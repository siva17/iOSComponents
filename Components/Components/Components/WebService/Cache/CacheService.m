//
//  CacheService.m
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

#import "CacheService.h"

@interface CacheService ()
@property(nonatomic,retain) WebServiceClient *chWebServiceClient;
@end

@implementation CacheService

@synthesize delegate;
@synthesize chWebServiceClient;

#pragma mark - De-Allocs

-(void) initialize {
    RELEASE_MEM(chWebServiceClient);
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
        if ([self.delegate respondsToSelector:@selector(cacheService: status: response:)]) {
            // If implemented, call the delegate function
            [self.delegate cacheService:self status:status response:response];
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

-(void) cancelCacheServiceRequest {
    [chWebServiceClient cancelWebServiceRequest];
    RELEASE_MEM(chWebServiceClient);
}

-(void) cahceServiceRequest:(NSDictionary *)params {
    // Cancel previous sessions before proceessing for new request
    [self cancelCacheServiceRequest];
    chWebServiceClient = [[WebServiceClient alloc]init];
    if (chWebServiceClient) {
        chWebServiceClient.delegate = self;
        [chWebServiceClient webServiceRequest:params];
    } else {
        [self callDelegateWithStatus:WSI_STATUS_FAIL response:nil];
    }
}

#pragma WebServiceClient Delegate Methods

-(void) webServiceClient:(WebServiceClient *)webServiceClient status:(WSI_STATUS)status response:(id)response {
    [self callDelegateWithStatus:status response:response];
}

@end
