//
//  DMSignupReqDetails.m
//  Components
//
//  Created by admin on 05/08/14.
//  Copyright (c) 2014 www.siva4u.com. All rights reserved.
//

#import "DMSignupReqDetails.h"

@implementation DMSignupReqDetails
@synthesize address;
@synthesize mobile;

@synthesize dmDefines = _dmDefines;

-(NSArray *)dmDefines {
    if (!_dmDefines) {
        _dmDefines = @[
                       @{
                           DM_DEFINE_MAPPING	: @"Address",
                           DM_DEFINE_DM_NAME	: @"address"
                           },
                       @{
                           DM_DEFINE_MAPPING	: @"MobileNumber",
                           DM_DEFINE_DM_NAME	: @"mobile"
                           }
                       ];
    }
    return _dmDefines;
}

@end
