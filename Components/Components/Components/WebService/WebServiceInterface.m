//
//  WebServiceInterface.m
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

#import "WebServiceInterface.h"
#import "Loading.h"

#import "WSSignup.h"
#import "WSLogin.h"
#import "WSHomeList.h"

#define REQUEST_TIMEOUT_INTERVAL        30.0
#define WSI_LOADING_TEXT                @"Loading"

@interface WebServiceInterface ()
@property(nonatomic,retain) Class               wsClass;
@property(nonatomic,retain) WebServiceBase      *wsObject;
@property(nonatomic,retain) UIViewController    *wsiParentVC;
@property(nonatomic,retain) Loading				*wsiLoadingIndicator;
@end

@implementation WebServiceInterface

@synthesize delegate;
@synthesize wsClass;
@synthesize wsObject;
@synthesize wsiParentVC;
@synthesize wsiLoadingIndicator;

#pragma mark - De-Allocs

-(void) initialize {
    wsClass = nil;
    RELEASE_MEM(wsObject);
    RELEASE_MEM(wsiParentVC);
    RELEASE_MEM(wsiLoadingIndicator);
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
        if ([self.delegate respondsToSelector:@selector(webServiceResponse: status: response:)]) {
            // If implemented, call the delegate function
            [delegate webServiceResponse:self status:status response:response];
        }
    }
}

#pragma WebServiceInterface Static Data

static NSMutableArray *wsdClassArray = nil;

+(void) registerWS:(Class)klass wsType:(WS_TYPE)wsType {
    [wsdClassArray insertObject:klass atIndex:wsType];
}

+(Class) getWebServiceClassFromType:(WS_TYPE)wsType {
    if ((wsType < WS_MIN)||(wsType >= WS_MAX)) return nil;
    return [wsdClassArray objectAtIndex:wsType];
}

#pragma mark - Public APIs

+(void) registerAllWebServices {
    @synchronized(self) {
        if (!wsdClassArray) {
            wsdClassArray = [[NSMutableArray alloc]initWithCapacity:WS_MAX];
        }
    }    
    // Register all Web Services
    [WebServiceInterface registerWS:[WSSignup class]			wsType:WS_SIGNUP];
    [WebServiceInterface registerWS:[WSLogin class]				wsType:WS_LOGIN];
    [WebServiceInterface registerWS:[WSHomeList class]			wsType:WS_HOME_LIST];
}

-(id) initWithVC: (UIViewController *)parentVC webServiceType:(WS_TYPE) webServiceType {
    self = [super init];
    if(self) {
        [self initialize];
        self.wsiParentVC = parentVC; // DO NOT allocate as we should point only
        self.delegate    = (id)parentVC; // DO NOT allocate as we should point only
        self.wsClass     = [WebServiceInterface getWebServiceClassFromType:webServiceType];
        self.wsiLoadingIndicator = [[Loading alloc] initWithParentView:parentVC.view];
    }
    return self;
}

-(BOOL) sendRequest:(id)requestDictionary {
    
    if (requestDictionary == nil) return NO;
    
    if (wsClass) {
        wsObject = [[wsClass alloc]init];
        if(wsObject) {
            [wsiLoadingIndicator showLoading];
            wsObject.delegate = self;
            [wsObject webServiceRequest:requestDictionary];
            return YES;
        }
    }
    return NO;
}

- (BOOL) cancelRequest {
    if (wsObject) {
        [wsObject webServiceCancel];
        return YES;
    }
    return NO;
}

-(id) getDataModel:(id)response {
    return [wsObject getDataModel:response];
}


#pragma WebService delegate methods

-(void) webService:(WebServiceBase *)webService status:(WSI_STATUS)status response:(id)response {
    [wsiLoadingIndicator hideLoading];
    [self callDelegateWithStatus:status response:response];
}

@end
