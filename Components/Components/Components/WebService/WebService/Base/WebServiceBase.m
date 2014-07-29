//
//  WebServiceBase.m
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

#import "WebServiceBase.h"

#define WSI_VAL_ALERT_TITLE         @"Alert"
#define WSI_VAL_ALERT_BUTTON        @"OK"

#define WS_KEY_WS_DICTIONARY        @"wsBaseDictionary"
#define WS_KEY_WS_RSP_DATA_MODEL    @"responseDataModel"

@interface WebServiceBase()
@property(nonatomic,retain) CacheService        *wsCacheServiceHandler;
@property(nonatomic,retain) NSMutableDictionary *wsData;
@property(nonatomic)        BOOL                wsShowAlert;
@end

@implementation WebServiceBase

@synthesize delegate;
@synthesize wsAlertView;

@synthesize wsCacheServiceHandler;
@synthesize wsData;
@synthesize wsShowAlert;

#pragma mark - Local APIs

-(void) callDelegateWithStatus:(WSI_STATUS)status response:(id)response {
    // Check whether Delete is initialized by caller
    if (self.delegate) {
        // Check whether Delete is implemented by caller
        if ([delegate respondsToSelector:@selector(webService:status:response:)]) {
            // If implemented, call the delegate function
            [delegate webService:self
                          status:status
                        response:((response)?([NSDictionary dictionaryWithObjectsAndKeys:response,WS_KEY_WS_RSP_DATA_MODEL, nil]):(nil))];
        }
    }
}

-(void) releaseAlert {
    if (wsAlertView) [wsAlertView dismissWithClickedButtonIndex:0 animated:YES];
    RELEASE_MEM(wsAlertView);
}

#pragma mark - De-Allocs

-(void) initialize {
    delegate = nil;
    [self releaseAlert];
    
    RELEASE_MEM(wsCacheServiceHandler);
    RELEASE_MEM(wsData);
    wsShowAlert = NO;
}

-(void) dealloc {
    [self initialize];
#if !(__has_feature(objc_arc))
    [super dealloc];
#endif
}

#pragma mark - Public APIs
+(BOOL)getBooleanStatusFromResponse:(id)status {
    if(status) {
        if(([status isKindOfClass:[NSString class]]) && (status != (NSString *)[NSNull null])) {
            return [[NSString stringWithString:status] isEqualToString:@"true"];
        } else {
            return (BOOL)status;
        }
    }
    return false;
}

-(id) init {
    self = [super init];
    if (self) {
        // Custom initialization
        [self initialize];
        wsData = [[NSMutableDictionary alloc]init];
    }
    return self;
}

-(id) getResponseData:(id)response {
    NSDictionary *data = [NSDictionary dictionaryWithDictionary:response];
    return [data objectForKey:WSI_KEY_WSC_RSP_DATA];
}

-(id) getDataModel:(id)response {
    NSDictionary *data = [NSDictionary dictionaryWithDictionary:response];
    return [data objectForKey:WS_KEY_WS_RSP_DATA_MODEL];
}

#pragma mark - MUST BE OVER WRITE in CHILD CLASSES

-(id) decodeRequestResponse:(id)response status:(WSI_STATUS)status {
    return response;
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
    
    // Step 1 Nothing to update here    - Must be updated by corresponsing Web Service
    // Step 2 Nothing to update here    - Can be updated by corresponsing Web Service, if not defaulted to GET
    // Step 3 Nothing to update here    - Can be updated by corresponsing Web Service, if not defaulted as No Post Data
    // Step 4 Appending default headers - Can be appending by corresponding Web Service.
    NSDictionary *headersFromWS = [wsParams objectForKey:WSI_KEY_WSC_HEADERS];
    NSMutableDictionary *headers;
    if (headersFromWS) {
        headers = [[NSMutableDictionary alloc]initWithDictionary:headersFromWS];
    } else {
        headers = [[NSMutableDictionary alloc]init];
    }
    if(headers) {
        // Add following headers if not supplied by corresponding Web Service
        if(![headers objectForKey:@"Content-Type"]) [headers setObject:@"application/json" forKey:@"Content-Type"];
        if(![headers objectForKey:@"Accept"]) [headers setObject:@"application/json" forKey:@"Accept"];
        [wsParams setObject:headers forKey:WSI_KEY_WSC_HEADERS];
    }
    RELEASE_MEM(headers);
    return wsParams;
}


#pragma mark - Optionally OVER WRITE in CHILD CLASSES

-(PARSED_FOR_ERROR) didParsedForErrorCodes:(PARSED_FOR_ERROR)parseForError
                         processedForError:(PROCESSED_FOR_ERROR)processedForError
                                    status:(WSI_STATUS)status
                                  response:(id)response {
    
    /*
     * !!!WARNING!!! this should be first execution statement
     * Storing the failResponse for refering the failure through alert
     */
    if(response) [wsData setObject:response forKey:WS_KEY_WS_DICTIONARY];
    
    // If already processed by child object, then return with child error status.
    AppLog(APP_LOG_INFO, @"Did Processed by Child object:%d", processedForError);
    if (processedForError == PROCESSED_FOR_ERROR_YES) return parseForError;
    
    /*
     * Already confirmed that it is already parsed for Error and
     * so returning immediately with error.
     * This will happen when derived class has processed for errors
     */
    AppLog(APP_LOG_INFO, @"Did Parsed as Error by Child object:%d", parseForError);
    if(parseForError == PARSED_FOR_ERROR_YES) return PARSED_FOR_ERROR_YES;
    
    unsigned long code = ((response)?([[response objectForKey:WSI_KEY_WSC_RSP_HTTP_CODE] integerValue]):(0));
    AppLog(APP_LOG_INFO, @"httpCode:%lu", code);
    
    // Default class says that 2xx as NO Error.
    if((code >= 200)&&(code <= 299)) return PARSED_FOR_ERROR_NO;
    
    NSString *alertMsg = @"";
    BOOL canIShowAlert = NO;
    if(wsShowAlert) {
        if((code == 4)||(code == 409)) {
            // Request cancelled ERROR
            // No need to show alert
            // Send Failure
        } else if (code == 403) {
            canIShowAlert = YES;
            alertMsg = WSI_RSP_MSG_INVALID_EMAIL_OR_PASSWORD;
        } else if (code == 2) {
            canIShowAlert = YES;
            alertMsg = WSI_RSP_MSG_TIMEOUT;
        } else if(code == 602) {
            canIShowAlert = YES;
            alertMsg = WSI_RSP_MSG_NO_MATCHED_ADDRESS;
        } else {
            canIShowAlert = YES;
            alertMsg = WSI_RSP_MSG_CONNECTION_ERROR;
        }
    }
    
    // Removing if any earlier data
    [wsData removeObjectForKey:WS_KEY_WS_DICTIONARY];
    
    // Creating Fail Data Model
#if (__has_feature(objc_arc))
    DMFail *failResponse = [[DMFail alloc]init];
#else
    DMFail *failResponse = [[[DMFail alloc]init]autorelease];
#endif
    if (failResponse) {
        failResponse.failCode    = code;
        failResponse.failType    = @"Fail";
        failResponse.failMessage = @"Failed";
        /*
         * Updating latest Details
         * Storing the failResponse for refering the failure through alert
         */
        [wsData setObject:failResponse forKey:WS_KEY_WS_DICTIONARY];
    }
    
    if(canIShowAlert == YES) {
        /*
         * Response to Web Service will be sent once user confirms to the alert
         * So delegate will be call in following method
         * -(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
         */
        AppLog(APP_LOG_INFO, @"Showing Alert for error");
        [self releaseAlert];
        wsAlertView = [[UIAlertView alloc] initWithTitle:WSI_VAL_ALERT_TITLE
                                                 message:alertMsg
                                                delegate:self
                                       cancelButtonTitle:WSI_VAL_ALERT_BUTTON
                                       otherButtonTitles:nil, nil];
        [wsAlertView show];
    } else {
        /*
         * This is an error use case and no alert so,
         * inform the Web Service by calling delegate method.
         */
        AppLog(APP_LOG_INFO, @"No Alert shown for error");
        [self callDelegateWithStatus:WSI_STATUS_FAIL
                            response:[wsData objectForKey:WS_KEY_WS_DICTIONARY]];
    }
    /*
     * When the control comes here, it was defined that the response
     * falls into error use case and so sending it as PARSED FOR ERROR as YES
     */
    AppLog(APP_LOG_INFO, @"Declaring the response as Error");
    return PARSED_FOR_ERROR_YES;
}


-(void) webServiceRequest:(NSDictionary *)params {
    wsCacheServiceHandler = [[CacheService alloc]init];
    if (wsCacheServiceHandler) {
        
        NSString *doWeNeedToShowAlert = [params objectForKey:WSI_KEY_REQUEST_AUTO_ALERT];
        wsShowAlert = ((doWeNeedToShowAlert && ([doWeNeedToShowAlert isEqualToString:WSI_VAL_REQUEST_AUTO_ALERT_SHOW]))?(YES):(NO));
        
        wsCacheServiceHandler.delegate = self;
        [wsCacheServiceHandler cahceServiceRequest:[self encodeRequestParams:params]];
        
    } else {
        AppLog(APP_LOG_EXCEP, @"Exception of Low Memory");
        [self callDelegateWithStatus:WSI_STATUS_LOW_MEMORY response:nil];
    }
}

-(void) webServiceCancel {
    AppLog(APP_LOG_WARN, @"Cancelling the Request");
    [wsCacheServiceHandler cancelCacheServiceRequest];
    [self initialize];
}

#pragma mark - Delegates

-(void) cacheService:(CacheService *)cacheService status:(WSI_STATUS)status response:(id)response {
    if ([self didParsedForErrorCodes:PARSED_FOR_ERROR_NO
                   processedForError:PROCESSED_FOR_ERROR_NO
                              status:status
                            response:response] == PARSED_FOR_ERROR_NO) {
        
        [self callDelegateWithStatus:status
                            response:[self decodeRequestResponse:response status:status]];
    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    AppLog(APP_LOG_INFO, @"User answered the error response");
    [self callDelegateWithStatus:WSI_STATUS_FAIL
                        response:[wsData objectForKey:WS_KEY_WS_DICTIONARY]];
    
    // Removing the object as it is not necessary.
    [wsData removeObjectForKey:WS_KEY_WS_DICTIONARY];
}

@end
