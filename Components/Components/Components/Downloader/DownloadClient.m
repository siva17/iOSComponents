//
//  DownloadClient.m
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

#import "DownloadClient.h"

@interface DownloadClient()
@property(nonatomic,retain) id								delegate;
@property(nonatomic,retain) NSMutableURLRequest             *dcConnRequest;
@property(nonatomic,retain) NSURLConnection                 *dcConnection;
@property(nonatomic,retain) NSMutableData                   *dcWebData;
@property(nonatomic,retain) DownloadClientDM                *dcDataModel;
@property(nonatomic,retain) NSFileHandle                    *dcFileHandle;
@property(nonatomic,assign) EnumDownloaderType              dcDownloadType;
@property(nonatomic,assign) EnumDownloadClientStatus        dcDelegateAttributes;
@property(nonatomic,assign) EnumDownloadClientStatus        dcDelegateMaskAttributes;
@end

@implementation DownloadClient

@synthesize delegate;
@synthesize dcConnRequest;
@synthesize dcConnection;
@synthesize dcWebData;
@synthesize dcDataModel;
@synthesize dcFileHandle;
@synthesize dcDownloadType;
@synthesize dcDelegateAttributes;
@synthesize dcDelegateMaskAttributes;

#pragma mark - De-Allocs

-(void) releaseMem {
    RELEASE_MEM(dcConnRequest);
    RELEASE_MEM(dcConnection);
    RELEASE_MEM(dcWebData);
    RELEASE_MEM(dcDataModel);
    RELEASE_MEM(dcFileHandle);
    dcDownloadType       = EnumDownloaderTypeGet;
    dcDelegateAttributes = (EnumDownloadClientStatusFail|
                            EnumDownloadClientStatusStarted|
                            EnumDownloadClientStatusInProgress|
                            EnumDownloadClientStatusTimeOut|
                            EnumDownloadClientStatusCompleted);
    dcDelegateMaskAttributes = dcDelegateAttributes;
}

-(void) dealloc {
    [self releaseMem];
#if !(__has_feature(objc_arc))
    [super dealloc];
#endif
}

#pragma mark - Local APIs

-(void) callDelegateFunction:(EnumDownloadClientStatus)status {
    if (status & dcDelegateAttributes) {
        if (self.delegate) {
            if ([delegate respondsToSelector:@selector(downloadClient: data: dataModel:)]) {
                [dcDataModel setStatus:status];
                [delegate downloadClient:self data:dcWebData dataModel:dcDataModel];
                if(status == EnumDownloadClientStatusFail) {
                    dcDelegateMaskAttributes = dcDelegateAttributes;
                    dcDelegateAttributes = 0;
                }
            }
        }
    }
    // Cancel the Timer
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(downloadClientTimeOut) object:nil];
}

-(void) downloadClientTimeOut {
    AppLog(APP_LOG_INFO,@"downloadClient:Timeout\n");
    [self callDelegateFunction:EnumDownloadClientStatusTimeOut];
}

-(void) downloadClientNoNetwork {
    AppLog(APP_LOG_INFO,@"downloadClient:NoNetwork\n");
    [self callDelegateFunction:EnumDownloadClientStatusNoNetwork];
}

-(void) allocateMemoryForData {
    RELEASE_MEM(dcWebData);
    dcWebData = [[NSMutableData alloc]init];
}

-(void) appendDataToFile {
    if (dcFileHandle) {
        [dcFileHandle seekToEndOfFile];
        [dcFileHandle writeData:dcWebData];
    }
}

#pragma mark - DownloadClient APIs

-(id)initWithDelegate:(id)dcDelegate {
	if ((self = [super init])) {
        [self releaseMem];
        self.delegate = dcDelegate;
        dcDataModel   = [[DownloadClientDM alloc]init];
        dcConnRequest = [[NSMutableURLRequest alloc] init];
    }
    return self;
}
         
-(void) startDownloadWithUrl:(NSString *)url httpMethod:(NSString *)httpMethod data:(NSData *)dataToServer {
    
    /*
     * Check whether network is available for Web Connect
     * If not, return the object with NoNetwork Status
     */
    if (isOFFLINE) {
        /*
         * Start the Timer for No Network Condition
         * If we immediately call delegate function,
         * then parent Object may not initialize the delegate,
         * So will be calling with some delay 0.5 seconds
         */
        [self performSelector:@selector(downloadClientNoNetwork) withObject:nil afterDelay:0.5];
        return;
    }
    
    dcDelegateAttributes = dcDelegateMaskAttributes;

    if (dcConnRequest == nil) dcConnRequest = [[NSMutableURLRequest alloc] init];    
    
    [dcConnRequest setHTTPMethod:httpMethod];
    
    unsigned long postDataLength = [dataToServer length];
    if(postDataLength > 0) {
        [dcConnRequest setValue:[NSString stringWithFormat:@"%lu",postDataLength] forHTTPHeaderField:DC_CONTENT_LENGTH_FIELD];
        [dcConnRequest setHTTPBody:dataToServer];
    }
    
    // Allocate Memory for dcWebData which will store the data downloaded in packets
    [self allocateMemoryForData];

    NSString *escapedUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [dcConnRequest setURL:[NSURL URLWithString:escapedUrl]];
    RELEASE_MEM(dcConnection);
    dcConnection = [[NSURLConnection alloc] initWithRequest:dcConnRequest delegate:self];
    AppLog(APP_LOG_INFO,@"DownloadClient:Request for %@\n",escapedUrl);

    // Start the Timer for TimeOut Condition
    [self performSelector:@selector(downloadClientTimeOut) withObject:nil afterDelay:DC_TIMEOUT];
}

-(void) setDelegateAttributes:(EnumDownloadClientStatus)attributes {
    dcDelegateAttributes = dcDelegateAttributes | attributes;
    dcDelegateMaskAttributes = dcDelegateAttributes;
}

-(void) setDownloadType:(EnumDownloaderType)type {
    dcDownloadType = type;    
}

-(void) setFilePath:(NSString *)filePath {
    // If file Path is set then it should be Store type only.
    [dcDataModel setFilePath:filePath];
}

-(void) resetHeader {
    RELEASE_MEM(dcConnRequest);
}

-(void) setHeaderOptions:(NSDictionary *)options {

    if (dcConnRequest == nil) dcConnRequest = [[NSMutableURLRequest alloc] init];    
    
    NSArray *keys = [options allKeys];
    NSUInteger countOfOptions = [keys count];
    for (int index = 0; index < countOfOptions; index++) {
        NSString *headerKey = [keys objectAtIndex:index];
        [dcConnRequest setValue:[options objectForKey:headerKey] forHTTPHeaderField:headerKey];
    }
}

#pragma mark - NSURLConnection delegate 

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    [dcDataModel setStatusCode:[httpResponse statusCode]];
    AppLog(APP_LOG_INFO,@"DownloadClient:Header:Http Code:%lu\n",dcDataModel.statusCode);
    
    if(dcDataModel.statusCode == 200) {
        [dcDataModel setCurrentDataLength:0];
        [dcDataModel setTotalDataLength:[[[httpResponse allHeaderFields] objectForKey:DC_CONTENT_LENGTH_FIELD] intValue]];
        if((dcDownloadType == EnumDownloaderTypeStore) ||
           (dcDownloadType == EnumDownloaderTypeStoreAndGet)) {
            
            if (dcDataModel.filePath == nil) {
                AppLog(APP_LOG_ERR,@"DownloadClient:File Path is not Set");
                [self callDelegateFunction:EnumDownloadClientStatusFail];
                return;
            }
            
            NSFileManager *fileMgr = [NSFileManager defaultManager];
            NSArray *parentAndChildPath = [DownloadConstants getParentAndChildPathFromPath:dcDataModel.filePath];    
            if ([fileMgr createDirectoryAtPath:[parentAndChildPath objectAtIndex:0] withIntermediateDirectories:YES attributes:nil error:nil] == YES) {
                if ([fileMgr createFileAtPath:dcDataModel.filePath contents:nil attributes:nil] == YES) {
                    RELEASE_MEM(dcFileHandle);
                    dcFileHandle = [NSFileHandle fileHandleForWritingAtPath:dcDataModel.filePath];
                    AppLog(APP_LOG_INFO,@"DownloadClient:Created File at:%@\n",dcDataModel.filePath);
                    [self callDelegateFunction:EnumDownloadClientStatusStarted];
                    return;
                }
            }
        } else {
            [self callDelegateFunction:EnumDownloadClientStatusStarted];
            return;
        }
    }
    [self callDelegateFunction:EnumDownloadClientStatusFail];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
        
    [dcWebData appendData:data];
    dcDataModel.currentDataLength += [data length];
    
    double diff = 0;
//    ([[NSDate date] timeIntervalSinceNow] - [dcDataModel.startedDate timeIntervalSinceNow]);
    if(diff > 0) {
        [dcDataModel setDownloadSpeed:(dcDataModel.currentDataLength/diff)];
    }
    
    if ( (dcFileHandle) && ([dcWebData length] > DC_MAX_PACKET_SIZE)) {
        [self appendDataToFile];
        // Release earlier Memory and Allocate New Memory
        [self allocateMemoryForData];
    }
    
    [self callDelegateFunction:EnumDownloadClientStatusInProgress];
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection {
    if ( (dcFileHandle) && ([dcWebData length] > 0)) {
        [self appendDataToFile];
        [dcFileHandle closeFile];
        RELEASE_MEM(dcFileHandle);
    }
    // Don't release dcWebData as it needs to given to delegate and
    // actual release will happen when this object is released
    [self callDelegateFunction:EnumDownloadClientStatusCompleted];
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSString *errorMessage = [error localizedDescription];
    AppLog(APP_LOG_ERR,@"DownloadClient:Failed with Error:%@\n",errorMessage);
    if ([errorMessage isEqualToString:DC_FAIL_TIMEOUT] == NO) {
        // Don't send the failure message for Timeout as it is taken care
        [self callDelegateFunction:EnumDownloadClientStatusFail];
    }
}

@end
