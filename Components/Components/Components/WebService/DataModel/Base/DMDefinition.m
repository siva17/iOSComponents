//
//  DMDefinition.m
//  Components
//
//  Created by admin on 28/07/14.
//  Copyright (c) 2014 www.siva4u.com. All rights reserved.
//

#import "DMDefinition.h"

@implementation DMDefinition
@synthesize type			= _type;
@synthesize value			= _value;
@synthesize defaultValue	= _defaultValue;
@synthesize refName			= _refName;
@synthesize getAPI			= _getAPI;

-(id)initWithType:(DMTYPE)type refName:(NSString *)refName {
    self = [super init];
    if (self) {
        self.type		= type;
        self.refName	= refName;
    }
    return self;
}
-(id)initWithType:(DMTYPE)type refName:(NSString *)refName defaultValue:(id)defaultValue {
    self = [super init];
    if (self) {
        self.type			= type;
        self.refName		= refName;
        self.defaultValue	= defaultValue;
    }
    return self;
}
-(id)initWithType:(DMTYPE)type refName:(NSString *)refName defaultValue:(id)defaultValue getAPI:(id)getAPI {
    self = [super init];
    if (self) {
        self.type			= type;
        self.refName		= refName;
        self.defaultValue	= defaultValue;
        self.getAPI			= getAPI;
    }
    return self;
}
-(id)initWithType:(DMTYPE)type refName:(NSString *)refName getAPI:(id)getAPI {
    self = [super init];
    if (self) {
        self.type		= type;
        self.refName	= refName;
        self.getAPI		= getAPI;
    }
    return self;
}
@end
