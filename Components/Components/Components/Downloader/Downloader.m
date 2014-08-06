//
//  Downloader.m
//  Downloader
//
//  Created by Siva RamaKrishna Ravuri
//  Copyright (c) 2014 www.siva4u.com. All rights reserved.
//
// The MIT License (MIT)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

#import "Downloader.h"

@interface Downloader()
@property(nonatomic,retain) id              delegate;
@property(nonatomic,retain) DownloadClient  *dnDownloadClient;
@property(nonatomic,retain) DownloaderODM   *dnDataModel;
@property(nonatomic,retain) NSArray         *dnDownloadList;
@property(nonatomic,retain) NSData          *dnDataToSend;
@property(nonatomic,assign) NSUInteger      dnTotalDownloads;
@property(nonatomic,assign) int             dnDownloadIndex;
@property(nonatomic,assign) int             dnPacketCount;
@end

@implementation Downloader

@synthesize delegate;
@synthesize dnDownloadClient;
@synthesize dnDataModel;
@synthesize dnDownloadList;
@synthesize dnDataToSend;
@synthesize dnTotalDownloads;
@synthesize dnDownloadIndex;
@synthesize dnPacketCount;

#pragma mark - De-Allocs

-(void) releaseMem {
    RELEASE_MEM(dnDownloadClient);
    RELEASE_MEM(dnDataModel);
    RELEASE_MEM(dnDownloadList);
    RELEASE_MEM(dnDataToSend);
    dnTotalDownloads = 0;
    dnDownloadIndex  = 0;
    dnPacketCount    = 0;
}

-(void) dealloc {
    [self releaseMem];
#if !(__has_feature(objc_arc))
    [super dealloc];
#endif
}

#pragma mark - Local APIs

-(void) callDelegateFunction:(NSData *)dataValue {
    // Check whether Delete is initialized by caller
	if (self.delegate) {
        // Check whether Delete is implemented by caller
        if ([delegate respondsToSelector:@selector(Downloader: data: dataModel:)]) {
            // If implemented, call the delegate function
            [delegate Downloader:self data:dataValue dataModel:dnDataModel];
        }
    }
}

-(void) downloadSingleRequest {
    BOOL callNextFunc = NO;
    BOOL callDelegate = YES;
    EnumDownloaderStatus returnStatus = EnumDownloaderStatusFail;
    
    if (dnDownloadIndex < dnTotalDownloads) {
        DownloaderIDM *itemToDownload = [dnDownloadList objectAtIndex:dnDownloadIndex];
        dnDownloadIndex++;

        [dnDataModel setUrl:itemToDownload.url];
        [dnDataModel setType:itemToDownload.type];
        [dnDataModel setDownloadSpeed:0];
        [dnDataModel setCurrentDataTotalLength:0];
        [dnDataModel setCurrentDataLength:0];
        [dnDataModel setCurrentDownload:dnDownloadIndex];

        if ((itemToDownload.type == EnumDownloaderTypeStore) ||
            (itemToDownload.type == EnumDownloaderTypeStoreAndGet) ) {
            if (itemToDownload.path == nil) {
                AppLog(APP_LOG_ERR,@"Downloader:File Path is not Set");
                returnStatus = EnumDownloaderStatusFail;
                callNextFunc = YES;
            } else {
                [dnDataModel setPath:[NSString stringWithFormat:@"%@/%@",[DownloadConstants getFileSystemBasePath],itemToDownload.path]];
                NSFileManager *fileMgr = [NSFileManager defaultManager];
                NSDictionary *fileAttributes = [fileMgr attributesOfItemAtPath:dnDataModel.path error:nil];
                if (([fileMgr fileExistsAtPath:dnDataModel.path] == YES)&&([fileAttributes fileSize] > 0)) {
                    AppLog(APP_LOG_INFO,@"file %@ size is %llu",dnDataModel.path,[fileAttributes fileSize]);
                    RELEASE_MEM(dnDataToSend);
                    dnDataToSend = [[NSData alloc]initWithContentsOfFile:dnDataModel.path];
                    returnStatus = EnumDownloaderStatusCompleted;
                    callNextFunc = YES;
                } else {
                    [dnDownloadClient setFilePath:dnDataModel.path];
                }
            }
        } else {
            // Else means EnumDownloaderTypeGet
            // nothing to do
        }
        
        if (callNextFunc == NO) {
            dnPacketCount = 0;        
            [dnDownloadClient setDownloadType:itemToDownload.type];
            if(itemToDownload.headers) [dnDownloadClient setHeaderOptions:itemToDownload.headers];
            [dnDownloadClient startDownloadWithUrl:itemToDownload.url
                                        httpMethod:itemToDownload.connectionType
                                              data:itemToDownload.postData];
            callDelegate = NO;
        }
    } else {
        returnStatus = EnumDownloaderStatusCompletedAll;
    }
    
    if (callDelegate == YES) {
        [dnDataModel setStatus:returnStatus];
        [self callDelegateFunction:dnDataToSend];
    }

    if (callNextFunc == YES) {
        [self performSelector:@selector(downloadSingleRequest) withObject:nil afterDelay:0.001];
    }
}

-(EnumDownloaderStatus) getDownloadStatusFromDownloadClientStatus:(EnumDownloadClientStatus)inStatus {
    EnumDownloaderStatus returnStatus = EnumDownloaderStatusFail;
    switch (inStatus) {
        case EnumDownloadClientStatusStarted   : returnStatus = EnumDownloaderStatusStarted;break;
        case EnumDownloadClientStatusInProgress: returnStatus = EnumDownloaderStatusInProgress;break;
        case EnumDownloadClientStatusCompleted : returnStatus = EnumDownloaderStatusCompleted;break;
        case EnumDownloadClientStatusTimeOut   : returnStatus = EnumDownloaderStatusTimeOut;break;
        case EnumDownloadClientStatusNoNetwork : returnStatus = EnumDownloaderStatusNoNetwork;break;
        default: break;
    }
    return returnStatus;
}

-(void) logDownloaderStatus:(EnumDownloaderStatus)status {
    switch (status) {
        case EnumDownloaderStatusFail:          AppLog(APP_LOG_INFO,@"Downloader Status:Fail"); break;
        case EnumDownloaderStatusStarted:       AppLog(APP_LOG_INFO,@"Downloader Status:Started"); break;
        case EnumDownloaderStatusInProgress:    AppLog(APP_LOG_INFO,@"Downloader Status:InProgress"); break;
        case EnumDownloaderStatusCompleted:     AppLog(APP_LOG_INFO,@"Downloader Status:Completed"); break;
        case EnumDownloaderStatusTimeOut:       AppLog(APP_LOG_INFO,@"Downloader Status:TimeOut"); break;
        case EnumDownloaderStatusNoNetwork:     AppLog(APP_LOG_INFO,@"Downloader Status:NoNetwork"); break;
        case EnumDownloaderStatusCreationFail:  AppLog(APP_LOG_INFO,@"Downloader Status:CreationFail"); break;
        case EnumDownloaderStatusCompletedAll:  AppLog(APP_LOG_INFO,@"Downloader Status:CompletedAll"); break;
        default: AppLog(APP_LOG_ERR,@"Downloader Status:Invalid");break;
    }
}

#pragma mark - Delegate Implementations

-(void) downloadClient:(DownloadClient *)downloadClient data:(NSData *)data dataModel:(DownloadClientDM *)dataModel {
    BOOL callDelegate = NO;
    BOOL callNextFunc = NO;
    EnumDownloaderStatus downloadStatus = [self getDownloadStatusFromDownloadClientStatus:dataModel.status];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = ((downloadStatus == EnumDownloaderStatusInProgress)?(YES):(NO));
    
    if(downloadStatus == EnumDownloaderStatusInProgress) {
        dnPacketCount++;
        if(dnPacketCount > DN_PACKET_COUNT) {
            dnPacketCount = 0;
            callDelegate = YES;
        }
    } else if(downloadStatus == EnumDownloaderStatusCompleted) {
        
        // Once the file is downloaded Successfully send that file to FileSystem and start download the next one.
        if ((dnDataModel.path != nil) && 
            ([[NSFileManager defaultManager] fileExistsAtPath:dnDataModel.path] != YES)) {
            downloadStatus = EnumDownloaderStatusCreationFail;
        }
        callDelegate = YES;
        callNextFunc = YES;
        
    } else if((downloadStatus == EnumDownloaderStatusFail) ||
              (downloadStatus == EnumDownloaderStatusNoNetwork) ||
              (downloadStatus == EnumDownloaderStatusTimeOut) ) {
        callDelegate = YES;
        // If couldn't able to download skip the file and download the next file in the list;
        callNextFunc = YES;
        
        [self logDownloaderStatus:downloadStatus];
        
    } else if(downloadStatus == EnumDownloaderStatusStarted) {
        dnDataModel.downloadedDataLength += dataModel.totalDataLength;
        [dnDataModel setCurrentDataTotalLength:dataModel.totalDataLength];
        callDelegate = YES;
    }
    
    if (callDelegate == YES) {
        [dnDataModel setStatus:downloadStatus];
        [dnDataModel setDownloadSpeed:dataModel.downloadSpeed];
        [dnDataModel setCurrentDataLength:dataModel.currentDataLength];
        [self callDelegateFunction:data];
    }
    
    if (callNextFunc == YES) {
        [self performSelector:@selector(downloadSingleRequest) withObject:nil afterDelay:0.001];
    }
}

#pragma mark - Download Manager APIs

-(id)initWithDelegate:(id)dnDelegate {
    self = [super init];
    if (self) {
        // Custom initialization
        [self releaseMem];
        self.delegate = dnDelegate;
    }
    return self;
}

-(void) startDownloads:(NSArray *)downloadItems {
    RELEASE_MEM(dnDataModel);
    dnDataModel = [[DownloaderODM alloc]init];
    NSUInteger downloadsCount = [downloadItems count];
    if ( (downloadItems != nil) && ( downloadsCount > 0) ) {
        RELEASE_MEM(dnDownloadList);
        dnDownloadList = [[NSArray alloc]initWithArray:downloadItems];
        if(dnDownloadList) {
            dnDownloadIndex  = 0;
            dnTotalDownloads = downloadsCount;
            RELEASE_MEM(dnDownloadClient);
            dnDownloadClient = [[DownloadClient alloc]initWithDelegate:self];
            if(dnDownloadClient) {
                [dnDataModel setTotalDownloads:downloadsCount];
                [dnDataModel setDownloadedDataLength:0];
                [self downloadSingleRequest];
                return; // Success Scenario
            }
        }
        [dnDataModel setMessage:@"Unable to Create Download Client"];
    } else {
        [dnDataModel setMessage:@"Invalid Download Items"];
    }
    [dnDataModel setStatus:EnumDownloaderStatusFail];
    [self callDelegateFunction:nil];
}

@end
