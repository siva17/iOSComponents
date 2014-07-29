//
//  WebService.m
//  Components
//
//  Created by admin on 28/07/14.
//  Copyright (c) 2014 www.siva4u.com. All rights reserved.
//

#import "WebService.h"

@implementation WebService

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
