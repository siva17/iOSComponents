//
//  WebServiceBase.h
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
#import "CacheService.h"
#import "DMFail.h"

typedef enum {
    PARSED_FOR_ERROR_NO  = 0,
    PARSED_FOR_ERROR_YES = 1
} PARSED_FOR_ERROR;

typedef enum {
    PROCESSED_FOR_ERROR_NO  = 0,
    PROCESSED_FOR_ERROR_YES = 1
} PROCESSED_FOR_ERROR;

@class WebServiceBase;

@protocol WebServiceBaseDelegate <NSObject>
-(void) webService:(WebServiceBase *)webService status:(WSI_STATUS)status response:(id)response;
@end

@interface WebServiceBase : NSObject <CacheServiceDelegate,UIAlertViewDelegate> {
    
@public
    id <WebServiceBaseDelegate> delegate;
    UIAlertView                 *wsAlertView;
}

@property(nonatomic,retain) id <WebServiceBaseDelegate> delegate;
@property(nonatomic,retain) UIAlertView                 *wsAlertView;

+(BOOL)getBooleanStatusFromResponse:(id)status;

-(id) init;
-(id) getResponseData:(id)response;
-(id) getDataModel:(id)response;

-(id)   decodeRequestResponse :(id)response status:(WSI_STATUS)status;
-(id)   encodeRequestParams   :(id)params;
-(PARSED_FOR_ERROR) didParsedForErrorCodes:(PARSED_FOR_ERROR)parseForError
                         processedForError:(PROCESSED_FOR_ERROR)processedForError
                                    status:(WSI_STATUS)status
                                  response:(id)response;

-(void) webServiceRequest :(NSDictionary *)params;
-(void) webServiceCancel;

@end
