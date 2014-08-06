//
//  ComponentConstants.h
//  Components
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

#ifndef RELEASE_MEM
#if __has_feature(objc_arc)
#define RELEASE_MEM(ptr)    ptr=nil;
#else
#define RELEASE_MEM(ptr)    if(ptr){[ptr release];ptr=nil;}
#endif
#endif

typedef enum {
    APP_LOG_NONE    = 0x00,
    APP_LOG_EXCEP   = 0x01,
    APP_LOG_ERR     = 0x02,
    APP_LOG_WARN    = 0x04,
    APP_LOG_INFO    = 0x08,
    APP_LOG_FLOW    = 0x10
} APP_LOG;

#define BUILD_TYPE  1

#if(BUILD_TYPE == 1)

#define APP_LOG_LEVEL   (APP_LOG_EXCEP|APP_LOG_ERR|APP_LOG_WARN|APP_LOG_INFO|APP_LOG_FLOW)

#elif(BUILD_TYPE == 2)

#define APP_LOG_LEVEL   (APP_LOG_EXCEP|APP_LOG_ERR|APP_LOG_WARN|APP_LOG_INFO)

#elif(BUILD_TYPE == 3)

#define APP_LOG_LEVEL   (APP_LOG_EXCEP|APP_LOG_ERR|APP_LOG_WARN)

#elif(BUILD_TYPE == 4)

#define APP_LOG_LEVEL   (APP_LOG_EXCEP|APP_LOG_ERR)

#endif

#ifdef APP_LOG_LEVEL
#define AppLog(level,s, ...) if(APP_LOG_LEVEL & level) NSLog(@"\t<%p %@:(%d)>\t%@\n", self, [[NSString stringWithUTF8String:__FUNCTION__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ## __VA_ARGS__]);
#else
#define AppLog(level,s, ...)
#endif

#define IS_IPAD()	(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)		

#define DEFAULT_THEME_COLOR_ALPHA(x) [UIColor colorWithRed:(16.0/255.0) green:(131.0/255.0) blue:(225.0/255.0) alpha:x]

// Should be here at the bottom as it depends on above #defines
#import "WebServiceConstants.h"
#import "Utilities.h"
