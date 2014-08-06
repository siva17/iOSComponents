//
//  DownloaderODM.m
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

#import "DownloaderODM.h"

@implementation DownloaderODM

@synthesize downloadedDataLength;
@synthesize currentDataTotalLength;
@synthesize currentDataLength;

@synthesize currentDownload;
@synthesize totalDownloads;

@synthesize downloadSpeed;
@synthesize status;
@synthesize type;
@synthesize path;
@synthesize url;

@synthesize message;

-(void) releaseMem {
    downloadedDataLength    = 0;
    currentDataTotalLength  = 0;
    currentDataLength       = 0;
    currentDownload         = 0;
    totalDownloads          = 0;
    downloadSpeed           = 0;
    status                  = EnumDownloaderStatusFail;
    type                    = EnumDownloaderTypeGet;
    RELEASE_MEM(path);
    RELEASE_MEM(url);
    RELEASE_MEM(message);
}

-(void) dealloc {
    [self releaseMem];
#if !(__has_feature(objc_arc))
    [super dealloc];
#endif
}

-(id) init  {
	if ((self = [super init])) {
        [self releaseMem];
    }
    return self;
}

-(void) setPath:(NSString *)pathValue {
    RELEASE_MEM(path);
    path = [[NSString alloc]initWithString:pathValue];
}

-(void) setUrl:(NSString *)urlValue {
    RELEASE_MEM(url);
    url = [[NSString alloc]initWithString:urlValue];
}

-(void) setMessage:(NSString *)msg {
    RELEASE_MEM(message);
    message = [[NSString alloc]initWithString:msg];
}

@end
