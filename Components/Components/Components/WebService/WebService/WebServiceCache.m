//
//  WebServiceCache.m
//  WebService
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

#import "WebServiceCache.h"

@interface WebServiceCache ()
@property(nonatomic,retain) WebServiceClient *chWebServiceClient;
@end

@implementation WebServiceCache

@synthesize delegate;
@synthesize chWebServiceClient;

#pragma mark - De-Allocs

-(void) releaseMem {
    RELEASE_MEM(chWebServiceClient);
}

-(void) dealloc {
    [self releaseMem];
#if !(__has_feature(objc_arc))
    [super dealloc];
#endif
}

#pragma mark - Local APIs

-(void) callDelegateWithStatus:(WS_STATUS)status response:(DMWebservice *)response {
    if((self.delegate) && ([self.delegate respondsToSelector:@selector(webServiceCache: response:)])) {
		response.status = status;
		[self.delegate webServiceCache:self response:response];
	}
}

#pragma mark - Public APIs

-(id)initWithDelegate:(id)cacheDelegate {
    self = [super init];
    if (self) {
        // Custom initialization
        [self releaseMem];
        self.delegate = cacheDelegate;
    }
    return self;
}

-(void) cancelRequest {
    [chWebServiceClient cancelRequest];
    RELEASE_MEM(chWebServiceClient);
}

-(void)sendRequest:(DMWebservice *)dataModel {
    // Cancel previous sessions before proceessing for new request
    [self cancelRequest];
    chWebServiceClient = [[WebServiceClient alloc]initWithDelegate:self];
    if (chWebServiceClient) {
        [chWebServiceClient sendRequest:dataModel];
    } else {
        [self callDelegateWithStatus:WS_STATUS_FAIL response:dataModel];
    }
}

#pragma WebServiceClient Delegate Methods
-(void) webServiceClient:(WebServiceClient *)webServiceClient response:(DMWebservice *)response {
    [self callDelegateWithStatus:response.status response:response];
}

@end
