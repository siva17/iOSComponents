//
//  DMDefinition.h
//  Components
//
//  Created by admin on 28/07/14.
//  Copyright (c) 2014 www.siva4u.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    // Should be first item
    DMTYPE_MIN = 0,
    
    DMTYPE_INT,
    DMTYPE_BOOL,
    DMTYPE_STRING,

    DMTYPE_ARRAY,
    DMTYPE_DICTIONARY,

    // Should be last item
    DMTYPE_MAX
} DMTYPE;

@interface DMDefinition : NSObject
@property(nonatomic,assign) int			type;
@property(nonatomic,assign) id			value;
@property(nonatomic,assign) id 			defaultValue;
@property(nonatomic,retain) NSString	*refName;
@property(nonatomic,assign) id			getAPI;

-(id)initWithType:(DMTYPE)type refName:(NSString *)refName;
-(id)initWithType:(DMTYPE)type refName:(NSString *)refName defaultValue:(id)defaultValue;
-(id)initWithType:(DMTYPE)type refName:(NSString *)refName defaultValue:(id)defaultValue getAPI:(id)getAPI;
-(id)initWithType:(DMTYPE)type refName:(NSString *)refName getAPI:(id)getAPI;

@end
