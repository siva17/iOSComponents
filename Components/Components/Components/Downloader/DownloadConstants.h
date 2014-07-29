//
//  DownloadConstants.m
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

typedef enum {
    EnumDownloadClientHTTPMethodMin = 0,
    EnumDownloadClientHTTPMethodGet,
    EnumDownloadClientHTTPMethodPost,    
    EnumDownloadClientHTTPMethodInvalid
} EnumDownloadClientHTTPMethod;

typedef enum {
    EnumDownloaderTypeMin = 0,
    EnumDownloaderTypeGet,
    EnumDownloaderTypeStore,
    EnumDownloaderTypeStoreAndGet,
    EnumDownloaderTypeInvalid
} EnumDownloaderType;

typedef enum {
    // Bit Mask Enum Value
    EnumDownloadClientStatusFail                    = 1,
    EnumDownloadClientStatusStarted                 = 2,
    EnumDownloadClientStatusInProgress              = 4,
    EnumDownloadClientStatusCompleted               = 8,
    EnumDownloadClientStatusTimeOut                 = 16,
    EnumDownloadClientStatusNoNetwork               = 32,
    
    EnumDownloadClientStatusAll                     = (64-1)
} EnumDownloadClientStatus;

typedef enum {
    EnumDownloaderStatusMin = 0,
    
    EnumDownloaderStatusFail,
    EnumDownloaderStatusStarted,
    EnumDownloaderStatusInProgress,
    EnumDownloaderStatusCompleted,
    EnumDownloaderStatusTimeOut,
    EnumDownloaderStatusNoNetwork,
    EnumDownloaderStatusCreationFail,
    EnumDownloaderStatusCompletedAll,
    
    EnumDownloaderStatusMax
} EnumDownloaderStatus;

/*************************************************
 * Downloader Constants - Begin
 ************************************************/
#define DC_CONTENT_LENGTH_FIELD         @"Content-Length"
#define DC_TIMEOUT                      (30.0)
#define DC_FAIL_TIMEOUT                 @"The request timed out."
#define DC_MAX_PACKET_SIZE              (5*1024*1024)
#define DN_PACKET_COUNT                 10

#define CONN_REQUEST_STORE_TYPE_GET     @"GET"
#define CONN_REQUEST_STORE_TYPE_STORE   @"STORE"

#define HTTP_REQUEST_METHOD_POST        @"POST"
#define HTTP_REQUEST_METHOD_GET         @"GET"
/*************************************************
 * Downloader Constants - End
 ************************************************/
@interface DownloadConstants : NSObject

+(NSArray *)    getParentAndChildPathFromPath:(NSString *)fullPath;
+(NSString *)   getFileSystemBasePath;

@end
