//
//  DMTest.m
//  Components
//
//  Created by admin on 28/07/14.
//  Copyright (c) 2014 www.siva4u.com. All rights reserved.
//

#include <objc/runtime.h>
#import "DMTest.h"

typedef struct {
    int type;
    char *name;
    char *value;
} DMD;

@implementation DMTest

-(void)initDM {
    [self.dmDetails addObject:[[DMDefinition alloc] initWithType:DMTYPE_STRING refName:@"userid"]];
    [self.dmDetails addObject:[[DMDefinition alloc] initWithType:DMTYPE_STRING refName:@"username"]];
    class_addProperty([DMTest class], "userID", <#const objc_property_attribute_t *attributes#>, <#unsigned int attributeCount#>)
}
@end
