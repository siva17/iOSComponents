//
//  DownloadClient.h
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

#import <Foundation/Foundation.h>
#import "DownloadClientDM.h"

#ifndef isOFFLINE
#import "Reachability.h"
#define isOFFLINE  ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)
#endif

@class DownloadClient;

@protocol DownloadClientDelegate<NSObject>
- (void) downloadClient:(DownloadClient *)downloadClient data:(NSData *)data dataModel:(DownloadClientDM *)dataModel;
@end

@interface DownloadClient : NSObject {    
    id<DownloadClientDelegate>  delegate;
}

@property(nonatomic,retain) id<DownloadClientDelegate>  delegate;

-(id)   init;
-(void) startDownloadWithUrl:(NSString *)url httpMethod:(EnumDownloadClientHTTPMethod)methodType data:(NSData *)dataToServer;
-(void) setDelegateAttributes:(EnumDownloadClientStatus)attributes;
-(void) setDownloadType:(EnumDownloaderType)type;
-(void) setFilePath:(NSString *)filePath;
-(void) resetHeader;
-(void) setHeaderOptions:(NSDictionary *)options;

@end
