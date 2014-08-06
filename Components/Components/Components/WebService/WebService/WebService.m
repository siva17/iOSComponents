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

#import "WebService.h"
#import "Loading.h"

@interface WebService()
@property(nonatomic,retain) id						delegate;
@property(nonatomic,retain) UIViewController		*wsParentVC;
@property(nonatomic,retain) DMWebservice			*wsDataModel;

@property(nonatomic,retain) WebServiceCache			*wsCacheHandler;
@property(nonatomic,retain) Loading					*wsLoadingIndicator;
@end

@implementation WebService

@synthesize delegate;
@synthesize wsParentVC;
@synthesize wsDataModel;

@synthesize wsCacheHandler		= _wsCacheHandler;
@synthesize wsLoadingIndicator	= _wsLoadingIndicator;

#pragma mark - Lazy instantiation

-(Loading *)wsLoadingIndicator {
    if(!_wsLoadingIndicator) _wsLoadingIndicator = [[Loading alloc] initWithParentView:wsParentVC.view];
    return _wsLoadingIndicator;
}
-(WebServiceCache *)wsCacheHandler {
    if(!_wsCacheHandler) _wsCacheHandler = [[WebServiceCache alloc] initWithDelegate:self];
    return _wsCacheHandler;
}

#pragma mark - Local APIs

-(void) callDelegateWithStatus:(WS_STATUS)status response:(DMWebservice *)response {
    if((self.delegate) && ([delegate respondsToSelector:@selector(webService:response:)])) {
        response.status = status;
		[self.wsLoadingIndicator hideLoading];
		[delegate webService:self response:response];
    }
}

#pragma mark - De-Allocs

-(void) releaseMem {
    RELEASE_MEM(_wsCacheHandler);
    RELEASE_MEM(_wsLoadingIndicator);
}

-(void) dealloc {
    [self releaseMem];
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

+(id)getObjectFromObject:(id)object {
    if((object) && (object != [NSNull null])) {
        if([object isKindOfClass:[NSArray class]]) {
            return [NSArray arrayWithArray:object];
        } else if([object isKindOfClass:[NSDictionary class]]) {
            return [NSDictionary dictionaryWithDictionary:object];
        } else if([object isKindOfClass:[NSString class]]) {
            return [NSString stringWithString:object];
        }
    }
	return nil;
}
+(NSArray *)getArrayFromObject:(id)object {
    if((object) && (object != [NSNull null])) {
        if([object isKindOfClass:[NSArray class]]) {
            return [NSArray arrayWithArray:object];
        } else if([object isKindOfClass:[NSDictionary class]]) {
            return [NSArray arrayWithObject:object];
        } else if([object isKindOfClass:[NSString class]]) {
            return [NSArray arrayWithObject:object];
        }
    }
	return nil;
}
+(NSString *)getStringFromObject:(id)object {
    if((object) &&
       (object != [NSNull null]) &&
       ([object isKindOfClass:[NSString class]])) {
        return [NSString stringWithString:object];
    }
	return nil;
}
+(BOOL)getBoolFromObject:(id)object {
    if((object) &&
       (object != [NSNull null]) &&
       ([object isKindOfClass:[NSString class]])) {
        return [[NSString stringWithString:object] isEqualToString:@"1"];
    }
	return false;
}

#pragma mark - MUST BE OVER WRITE in CHILD CLASSES

-(id) decodeRequestResponse:(id)response status:(WS_STATUS)status {
    return response;
}

-(BOOL)validateRequestDataModel {
    if(wsDataModel.url.length <= 0) {
        wsDataModel.errorMsg = WS_RSP_MSG_INVALID_URL;
        [self callDelegateWithStatus:WS_STATUS_FAIL response:wsDataModel];
        return false;
    }
    
    NSDictionary *headersFromWS = wsDataModel.httpHeaders;
    NSMutableDictionary *headers;
    if (headersFromWS) {
        headers = [[NSMutableDictionary alloc]initWithDictionary:headersFromWS];
        RELEASE_MEM(wsDataModel.httpHeaders);
    } else {
        headers = [[NSMutableDictionary alloc]init];
    }
    if(headers) {
        // Add following headers if not supplied by corresponding Web Service
        if(![headers objectForKey:@"Content-Type"]) [headers setObject:@"application/json" forKey:@"Content-Type"];
        if(![headers objectForKey:@"Accept"]) [headers setObject:@"application/json" forKey:@"Accept"];
    }
    wsDataModel.httpHeaders = headers;
    
    return true;
}

#pragma mark - Public APIs

-(id)initWithVC:(UIViewController *)parentVC {
    self = [super init];
    if (self) {
        // Custom initialization
        [self releaseMem];
        self.wsParentVC = parentVC;
        self.delegate 	= parentVC;
    }
    return self;
}

-(void)sendRequest:(DMWebservice *)dataModel {
    if(dataModel) {
        wsDataModel = dataModel;
        [self.wsLoadingIndicator showLoading];
        if([self validateRequestDataModel]) {
            [self.wsCacheHandler sendRequest:wsDataModel];
        }
    } else {
        [self callDelegateWithStatus:WS_STATUS_LOW_MEMORY response:[[DMWebservice alloc]init]];
    }
}

-(void) cancelRequest {
    AppLog(APP_LOG_WARN, @"Cancelling the Request");
    [self.wsCacheHandler cancelRequest];
    [self releaseMem];
}

#pragma mark - Child Class can override this method

-(DMWebservice *)processForErrorCodes:(DMWebservice *)dataModel {
    
    if(dataModel.errorCodeMsg) return dataModel; // Child Class has over written and updated with error code Message
    
    NSUInteger code = dataModel.responseCode;
    AppLog(APP_LOG_INFO, @"httpCode:%lu",(unsigned long)code);
    
    // Default class says that 2xx as NO Error.
    if((code >= 200)&&(code <= 299)) return dataModel;
    
    NSString *errorMsg = @"";
    if((code == 4)||(code == 409)) {
        // Request cancelled ERROR
        // No need to show alert
        // Send Failure
    } else if (code == 403) {
        errorMsg = WS_RSP_MSG_INVALID_EMAIL_OR_PASSWORD;
    } else if (code == 2) {
        errorMsg = WS_RSP_MSG_TIMEOUT;
    } else if(code == 602) {
        errorMsg = WS_RSP_MSG_NO_MATCHED_ADDRESS;
    } else {
        errorMsg = WS_RSP_MSG_CONNECTION_ERROR;
    }
    
    dataModel.errorCodeMsg	= [NSString stringWithFormat:@"Parsed for Error Code: %lu",(unsigned long)code];
    dataModel.errorMsg		= errorMsg;
    return dataModel;
}

#pragma mark - Delegates

-(void)webServiceCache:(WebServiceCache *)webServiceCache response:(DMWebservice *)response {
    wsDataModel = [self processForErrorCodes:response];
    [self callDelegateWithStatus:((wsDataModel.errorCodeMsg)?(WS_STATUS_FAIL):(response.status)) response:response];
}

@end
