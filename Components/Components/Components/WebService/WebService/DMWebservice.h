//
//  DMWebservice.h
//  Components
//
//  Created by admin on 04/08/14.
//  Copyright (c) 2014 www.siva4u.com. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface DMWebservice : NSObject
@property(nonatomic,retain) NSString		*url;
@property(nonatomic,retain) NSString		*httpMethod;
@property(nonatomic,retain) NSDictionary	*httpHeaders;

@property(nonatomic,assign) WS_STATUS		status;
@property(nonatomic,assign) NSUInteger		responseCode;
@property(nonatomic,retain) NSString		*errorCodeMsg;
@property(nonatomic,retain) NSString		*errorMsg;

@property(nonatomic,retain) id				requestDM;
@property(nonatomic,retain) id				responseDM;

@property(nonatomic,assign) BOOL			backgroundRequestParsing;
@property(nonatomic,assign) BOOL			backgroundResponseParsing;
@end
