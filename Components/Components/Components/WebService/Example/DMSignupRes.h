//
//  DMSignup.h
//  Components
//
//  Created by admin on 04/08/14.
//  Copyright (c) 2014 www.siva4u.com. All rights reserved.
//

#import "DMBase.h"
#import "DMSignupReqDetails.h"

@interface DMSignupRes : DMBase
@property(nonatomic,retain) NSString *userID;
@property(nonatomic,retain) NSString *userName;
@property(nonatomic,assign) BOOL status;
@property(nonatomic,retain) DMSignupReqDetails *signupDetails;
@property(nonatomic,retain) NSArray *signupArray;
@end
