//
//  WebServiceClient.h
//  WebServiceInterface
//
//  Created by Siva RamaKrishna Ravuri on 8/17/12.
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
#import "DownloadClient.h"

// Web Service to Cache Service Keys in params dictionary passed
#define WSI_KEY_WSC_URL             @"url"
#define WSI_KEY_WSC_HTTP_METHOD     @"httpMethod"
#define WSI_KEY_WSC_POST_DATA       @"postData"
#define WSI_KEY_WSC_HEADERS         @"headers"

// To Web Service Interface Keys in response dictionary from WebService Client
#define WSI_KEY_WSC_RSP_ERROR       @"error"
#define WSI_KEY_WSC_RSP_HTTP_CODE   @"httpCode"
#define WSI_KEY_WSC_RSP_DATA        @"responseData"

@class WebServiceClient;

@protocol WebServiceClientDelegate <NSObject>
-(void) webServiceClient:(WebServiceClient *)webServiceClient status:(WSI_STATUS)status response:(id)response;
@end

@interface WebServiceClient : NSObject<DownloadClientDelegate>

@property (nonatomic, retain) id <WebServiceClientDelegate> delegate;
-(id)   init;
-(void) cancelWebServiceRequest;
-(void) webServiceRequest:(NSDictionary *)params;
@end
