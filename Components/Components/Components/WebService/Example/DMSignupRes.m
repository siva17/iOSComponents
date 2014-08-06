//
//  DMSignup.m
//  Components
//
//  Created by admin on 04/08/14.
//  Copyright (c) 2014 www.siva4u.com. All rights reserved.
//

#import "DMSignupRes.h"

@implementation DMSignupRes
@synthesize userID;
@synthesize userName;
@synthesize status;
@synthesize signupDetails;
@synthesize signupArray;

@synthesize dmDefines = _dmDefines;

-(NSArray *)dmDefines {
    if (!_dmDefines) {
        _dmDefines = @[
                       @{
                           DM_DEFINE_MAPPING	: @"userid",
                           DM_DEFINE_DM_NAME	: @"userID"
                           },
                       @{
                           DM_DEFINE_MAPPING	: @"username",
                           DM_DEFINE_DM_NAME	: @"userName"
                           },
                       @{
                           DM_DEFINE_MAPPING	: @"status",
                           DM_DEFINE_DM_NAME	: @"status"
                           },
                       @{
                           DM_DEFINE_MAPPING	: @"details",
                           DM_DEFINE_DM_NAME	: @"signupDetails"
                           },
                       @{
                           DM_DEFINE_ARRAY_TYPE	: @"DMSignupReqDetails",
                           DM_DEFINE_MAPPING	: @"detailsArray",
                           DM_DEFINE_DM_NAME	: @"signupArray"
                           }
                       ];
    }
    return _dmDefines;
}

@end
