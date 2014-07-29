//
//  WebServiceInterface.h
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

#import <Foundation/Foundation.h>

#import "WebServiceBase.h"

#import "DMSignupReq.h"
#import "DMSignup.h"
#import "DMLoginReq.h"
#import "DMLogin.h"
#import "DMHomeListReq.h"
#import "DMHomeList.h"
#import "DMHomeListItem.h"

@class WebServiceInterface;

@protocol WebServiceInterfaceDelegate <NSObject>
-(void) webServiceResponse:(WebServiceInterface *)webServiceInterface status:(WSI_STATUS)status response:(id)response;
@end

@interface WebServiceInterface : NSObject <WebServiceBaseDelegate>

@property (nonatomic, retain) id <WebServiceInterfaceDelegate> delegate;

+(void) registerAllWebServices;
-(id)   initWithVC  : (UIViewController *)parentVC webServiceType:(WS_TYPE) webServiceType;
-(BOOL) sendRequest : (id)requestDictionary;
-(BOOL) cancelRequest;
-(id)   getDataModel:(id)response;

@end
