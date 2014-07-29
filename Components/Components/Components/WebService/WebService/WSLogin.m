//
//  WSLogin.m
//  WebServiceInterface
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

#import "WSLogin.h"
#import "DMLoginReq.h"
#import "DMLogin.h"

#define REQ_USERNAME	@"username"
#define REQ_PASSWORD	@"password"

#define RSP_USERNAME	@"username"
#define RSP_USER_ID		@"userid"
#define RSP_STATUS		@"status"
#define RSP_ERROR_MSG	@"error_msg"

@implementation WSLogin

#pragma mark - Override API

-(id) decodeRequestResponse:(id)response status:(WSI_STATUS)status {

    id successResponse = [self getResponseData:response];
    
    if(status == WSI_STATUS_SUCCESS) {
#if (__has_feature(objc_arc))
        DMLogin *loginResponse    = [[DMLogin alloc] init];
#else
        DMLogin *loginResponse    = [[[DMLogin alloc] init]autorelease];
#endif
        NSDictionary *rspDictionary = successResponse;
        NSString *tmp;
        
        tmp = [rspDictionary objectForKey:RSP_USERNAME];
        if((tmp) && (tmp != (NSString *)[NSNull null])) loginResponse.userName = [NSString stringWithString:tmp];
        
        tmp = [rspDictionary objectForKey:RSP_USER_ID];
        if((tmp) && (tmp != (NSString *)[NSNull null])) loginResponse.userID = [NSString stringWithString:tmp];
        
        loginResponse.status = [WebServiceBase getBooleanStatusFromResponse:[rspDictionary objectForKey:RSP_STATUS]];
        
        tmp = [rspDictionary objectForKey:RSP_ERROR_MSG];
        if((tmp) && (tmp != (NSString *)[NSNull null])) loginResponse.errorMsg = [NSString stringWithString:tmp];
        
        successResponse = loginResponse;
    }
    
    return [super decodeRequestResponse:successResponse status:status];
}

-(id) encodeRequestParams :(id)params {
    /*
     * All the parameters for belows can be set
     * 1. WSI_KEY_WSC_URL           @"url"          - Mandatory
     * 2. WSI_KEY_WSC_HTTP_METHOD   @"httpMethod"   - Optional, default is GET
     * 3. WSI_KEY_WSC_POST_DATA     @"postData"     - Optional, default is nil
     * 4. WSI_KEY_WSC_HEADERS       @"headers"      - Optional, default headers will be set
     */
#if (__has_feature(objc_arc))
    NSMutableDictionary *wsParams = [[NSMutableDictionary alloc]initWithDictionary:params];
#else
    NSMutableDictionary *wsParams = [[[NSMutableDictionary alloc]initWithDictionary:params]autorelease];
#endif
    
    // Step 1 - Setting of URL
    DMLoginReq *loginDetails = [params objectForKey:WSI_KEY_REQUEST_DATA_MODEL];
    NSString *url = [NSString stringWithFormat:@"%@%@/%@/%@/%@",
                     WS_URL_LOGIN,
                     REQ_USERNAME, loginDetails.username,
                     REQ_PASSWORD, loginDetails.password];
    AppLog(APP_LOG_INFO, @"FRAMED URL: %@",url);
	[wsParams setObject:WS_URL_LOGIN forKey:WSI_KEY_WSC_URL];
    
    // Step 2 - Not Required as it is defaulted to GET which is required here
    // Step 3 - Not Required as it should be nil.
    // Step 4 - Not required
    
    // Should be last statement
    return [super encodeRequestParams:wsParams];
}

@end
