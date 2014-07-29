//
//  DownloaderIDM.m
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

#import "DownloaderIDM.h"

@implementation DownloaderIDM

@synthesize url;
@synthesize path;
@synthesize postData;
@synthesize headers;
@synthesize type;
@synthesize connectionType;

-(void) initialize {
    RELEASE_MEM(url);
    RELEASE_MEM(path);
    RELEASE_MEM(postData);
    RELEASE_MEM(headers);
    type            = EnumDownloaderTypeGet;
    connectionType  = EnumDownloadClientHTTPMethodGet;
}

-(void) dealloc {
    [self initialize];
#if !(__has_feature(objc_arc))
    [super dealloc];
#endif
}

-(id) init  {
	if ((self = [super init])) {
        [self initialize];
    }
    return self;
}

-(void) setUrl:(NSString *)urlValue {
    RELEASE_MEM(url);
    url = [[NSString alloc]initWithString:urlValue];
}

-(void) setPath:(NSString *)pathValue {
    RELEASE_MEM(path);
    path = [[NSString alloc]initWithString:pathValue];
}

-(void) setPostData:(NSData *)postDataValue {
    RELEASE_MEM(postData);
    postData = [[NSData alloc]initWithData:postDataValue];
}

-(void) setHeaders:(NSDictionary *)headersValue {
    RELEASE_MEM(headers);
    headers = [[NSDictionary alloc]initWithDictionary:headersValue];
}

@end
