//
//  WebServiceConstants.h
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

#ifndef HTTP_REQUEST_METHOD_POST
#define HTTP_REQUEST_METHOD_POST        @"POST"
#endif
#ifndef HTTP_REQUEST_METHOD_GET
#define HTTP_REQUEST_METHOD_GET         @"GET"
#endif

typedef enum {
    WSI_STATUS_MIN = 0,
    
	WSI_STATUS_FAIL,
	WSI_STATUS_TIMEOUT,
	WSI_STATUS_NO_NETWORK,
	WSI_STATUS_SUCCESS,
	WSI_STATUS_LOW_MEMORY,
    
	WSI_STATUS_MAX,
    WSI_STATUS_INVALID = WSI_STATUS_MAX
} WSI_STATUS;

typedef enum {
    WS_MIN = 0,
    
	WS_SIGNUP = WS_MIN,
	WS_LOGIN,
    
	WS_HOME_LIST,

    WS_MAX,
    WS_INVALID = WS_MAX
} WS_TYPE;

//Generic Web Service Response messages
#define WSI_RSP_MSG_INVALID_URL                 @"Invalid URL"
#define WSI_RSP_MSG_TIMEOUT                     @"Request timed out. Please try again later."
#define WSI_RSP_MSG_NO_MATCHED_ADDRESS          @"No matched address found"
#define WSI_RSP_MSG_CONNECTION_ERROR            @"Connection Error."
#define WSI_RSP_MSG_INVALID_EMAIL_OR_PASSWORD   @"Invalid Email or Password, Please check"

// Application to Web Service Interface Keys in params dictionary passed
#define WSI_KEY_REQUEST_DATA_MODEL			@"wsDataModel"
#define WSI_KEY_REQUEST_AUTO_ALERT			@"autoAlert"
#define WSI_VAL_REQUEST_AUTO_ALERT_SHOW		@"show"

#undef WS_BASE_URL
#define WS_BASE_URL                 @"http://www.siva4u.com/public/"

#define WS_URL_SIGNUP				[NSString stringWithFormat:@"%@signup.json",WS_BASE_URL]
#define WS_URL_LOGIN				[NSString stringWithFormat:@"%@login.json",WS_BASE_URL]
#define WS_URL_HOMELIST				[NSString stringWithFormat:@"%@homelist.json",WS_BASE_URL]
#define WS_URL_HOMELIST_SEARCH		[NSString stringWithFormat:@"%@homelistSearch.json",WS_BASE_URL]





