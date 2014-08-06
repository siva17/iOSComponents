//
//  DMSignupReq.h
//  Components
//
//  Created by admin on 04/08/14.
//  Copyright (c) 2014 www.siva4u.com. All rights reserved.
//

#import "DMBase.h"
#import "DMSignupReqDetails.h"

@interface DMSignupReq : DMBase
@property(nonatomic,retain) NSString *email;
@property(nonatomic,retain) NSString *password;
@property(nonatomic,retain) NSString *firstName;
@property(nonatomic,retain) NSString *lastName;
@property(nonatomic,retain) DMSignupReqDetails *signupDetails;
@property(nonatomic,retain) NSArray *signupArray;
@end
