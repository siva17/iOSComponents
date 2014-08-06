//
//  WebServiceConstants.h
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

#import <Foundation/Foundation.h>

#define DM_DEFINE_ARRAY_TYPE		@"dmDefineArrayType"
#define DM_DEFINE_MAPPING			@"dmDefineMapping"
#define DM_DEFINE_DM_NAME			@"dmDefineDMName"

#ifndef HTTP_REQUEST_METHOD_GET
#define HTTP_REQUEST_METHOD_GET		@"GET"
#endif
#ifndef HTTP_REQUEST_METHOD_POST
#define HTTP_REQUEST_METHOD_POST	@"POST"
#endif
#ifndef HTTP_REQUEST_METHOD_PUT
#define HTTP_REQUEST_METHOD_PUT		@"PUT"
#endif
#ifndef HTTP_REQUEST_METHOD_DELETE
#define HTTP_REQUEST_METHOD_DELETE	@"DELETE"
#endif

typedef enum {
    WS_STATUS_MIN = 0,
    
	WS_STATUS_FAIL,
	WS_STATUS_TIMEOUT,
	WS_STATUS_NO_NETWORK,
	WS_STATUS_SUCCESS,
	WS_STATUS_LOW_MEMORY,
    
	WS_STATUS_MAX,
    WS_STATUS_INVALID = WS_STATUS_MAX
} WS_STATUS;


//Generic Web Service Response messages
#define WS_RSP_MSG_INVALID_URL                 @"Invalid URL"
#define WS_RSP_MSG_TIMEOUT                     @"Request timed out. Please try again later."
#define WS_RSP_MSG_NO_MATCHED_ADDRESS          @"No matched address found"
#define WS_RSP_MSG_CONNECTION_ERROR            @"Connection Error."
#define WS_RSP_MSG_INVALID_EMAIL_OR_PASSWORD   @"Invalid Email or Password, Please check"

#undef WS_BASE_URL
#define WS_BASE_URL                 @"http://www.siva4u.com/public/"

#define WS_URL_SIGNUP				[NSString stringWithFormat:@"%@signup.json",WS_BASE_URL]
#define WS_URL_LOGIN				[NSString stringWithFormat:@"%@login.json",WS_BASE_URL]
#define WS_URL_HOMELIST				[NSString stringWithFormat:@"%@homelist.json",WS_BASE_URL]
#define WS_URL_HOMELIST_SEARCH		[NSString stringWithFormat:@"%@homelistSearch.json",WS_BASE_URL]
