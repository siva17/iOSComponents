//
//  DMSignupReq.m
//  Components
//
//  Created by admin on 04/08/14.
//  Copyright (c) 2014 www.siva4u.com. All rights reserved.
//

#import "DMSignupReq.h"

@implementation DMSignupReq
@synthesize email;
@synthesize password;
@synthesize firstName;
@synthesize lastName;
@synthesize signupDetails;
@synthesize signupArray;

@synthesize dmDefines = _dmDefines;

-(NSArray *)dmDefines {
    if (!_dmDefines) {
        _dmDefines = @[
                       @{
                           DM_DEFINE_MAPPING	: @"email",
                           DM_DEFINE_DM_NAME	: @"email"
                           },
                       @{
                           DM_DEFINE_MAPPING	: @"pwd",
                           DM_DEFINE_DM_NAME	: @"password"
                           },
                       @{
                           DM_DEFINE_MAPPING	: @"firstname",
                           DM_DEFINE_DM_NAME	: @"firstName"
                           },
                       @{
                           DM_DEFINE_MAPPING	: @"lastname",
                           DM_DEFINE_DM_NAME	: @"lastName"
                           },
                       @{
                           DM_DEFINE_MAPPING	: @"Details",
                           DM_DEFINE_DM_NAME	: @"signupDetails"
                           },
                       @{
                           DM_DEFINE_MAPPING	: @"MyArray",
                           DM_DEFINE_DM_NAME	: @"signupArray"
                           }
                       ];
    }
    return _dmDefines;
}

@end
