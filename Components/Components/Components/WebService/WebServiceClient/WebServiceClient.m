//
//  ASIWebServiceClient.m
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

#import "WebServiceClient.h"

@interface WebServiceClient ()
@property(nonatomic,retain) DownloadClient *dcRequest;
@end

@implementation WebServiceClient

@synthesize delegate;
@synthesize dcRequest;

#pragma mark - De-Allocs

-(void) initialize {
    RELEASE_MEM(dcRequest);
}

-(void) dealloc {
    [self initialize];
#if !(__has_feature(objc_arc))
    [super dealloc];
#endif
}

#pragma mark - Local APIs

-(void) callDelegateWithStatus:(WSI_STATUS)status response:(id)response {
    // Check whether Delete is initialized by caller
    if (self.delegate) {
        // Check whether Delete is implemented by caller
        if ([delegate respondsToSelector:@selector(webServiceClient: status: response:)]) {
            // If implemented, call the delegate function
            [delegate webServiceClient:self status:status response:response];
        }
    }
}

#pragma mark - Public APIs

-(id) init {
    self = [super init];
    if (self) {
        // Custom initialization
        [self initialize];
    }
    return self;
}

- (void) cancelWebServiceRequest {
    RELEASE_MEM(dcRequest);
    NSLog(@"Request cancelled!!");
}
/*
 * params can contain objects with following keys
 *
 * WSI_KEY_WSC_URL                 @"url"
 * WSI_KEY_WSC_HTTP_METHOD         @"httpMethod"
 * WSI_KEY_WSC_POST_DATA           @"postData"
 * WSI_KEY_WSC_HEADERS             @"headers"
 * WSI_KEY_REQUEST_AUTO_ALERT          @"autoAlert"
 *
 * WSI_KEY_WSC_RSP_ERROR            @"error"
 * WSI_KEY_WSC_RSP_HTTP_CODE        @"httpCode"
 * WSI_KEY_WSC_RSP_DATA             @"responseData"
 *
 */
-(void) webServiceRequest:(NSDictionary *)params {
    
    NSString *url = [params objectForKey:WSI_KEY_WSC_URL];
    if(url.length <= 0) {
        NSDictionary *response = [[NSDictionary alloc]initWithObjectsAndKeys:WSI_RSP_MSG_INVALID_URL,WSI_KEY_WSC_RSP_ERROR, nil];
        [self callDelegateWithStatus:WSI_STATUS_FAIL response:response];
        RELEASE_MEM(response);
        return;
    }
    
    dcRequest = [[DownloadClient alloc]init];
    if (dcRequest) {
        dcRequest.delegate = self;
        
        EnumDownloadClientHTTPMethod httpMethodType = EnumDownloadClientHTTPMethodGet;
        NSString *methodType = [params objectForKey:WSI_KEY_WSC_HTTP_METHOD];
        if (methodType) httpMethodType = (([methodType isEqualToString:HTTP_REQUEST_METHOD_POST])?
                                    (EnumDownloadClientHTTPMethodPost):
                                    (EnumDownloadClientHTTPMethodGet));
        
        NSDictionary *postDictionary = [params objectForKey:WSI_KEY_WSC_POST_DATA];
        NSData *postData = nil;
        if (postDictionary) {
            NSError *error;
            postData = [NSJSONSerialization dataWithJSONObject:postDictionary
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
        }
        
        [dcRequest setHeaderOptions:[params objectForKey:WSI_KEY_WSC_HEADERS]];
        [dcRequest startDownloadWithUrl:url httpMethod:httpMethodType data:postData];
    } else {
        NSDictionary *response = [[NSDictionary alloc]initWithObjectsAndKeys:WSI_RSP_MSG_CONNECTION_ERROR,WSI_KEY_WSC_RSP_ERROR, nil];
        [self callDelegateWithStatus:WSI_STATUS_FAIL response:response];
        RELEASE_MEM(response);
        return;
    }
}

#pragma - Download Client delegate methods

-(void)downloadClient:(DownloadClient *)downloadClient data:(NSData *)data dataModel:(DownloadClientDM *)dataModel {
    EnumDownloadClientStatus status = dataModel.status;
    if (status == EnumDownloadClientStatusCompleted) {
        NSString *httpCode = [NSString stringWithFormat:@"%lu",dataModel.statusCode];
        NSMutableDictionary *response = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                         httpCode,WSI_KEY_WSC_RSP_HTTP_CODE, nil];
        if (data) {
            AppLog(APP_LOG_INFO, @"Data:%@",[NSString stringWithUTF8String:[data bytes]]);
            NSError *error;
            id responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONWritingPrettyPrinted error:&error];
            if(responseDict) {
                [response setObject:responseDict forKey:WSI_KEY_WSC_RSP_DATA];
            }
        }
        [self callDelegateWithStatus:WSI_STATUS_SUCCESS response:response];
        RELEASE_MEM(response);
    } else if(status == EnumDownloadClientStatusFail) {
        [self callDelegateWithStatus:WSI_STATUS_FAIL response:nil];
    } else if(status == EnumDownloadClientStatusTimeOut) {
        [self callDelegateWithStatus:WSI_STATUS_TIMEOUT response:nil];
    } else if(status == EnumDownloadClientStatusNoNetwork) {
        [self callDelegateWithStatus:WSI_STATUS_NO_NETWORK response:nil];
    }
}

@end
