//
//  Identity_model.m
//  JiaoBao
//
//  Created by Zqw on 14-10-24.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "Identity_model.h"

@implementation Identity_model
@synthesize RoleIdentity,RoleIdName,UserUnits,UserClasses,DefaultUnitId;

-(id)init{
    self.UserUnits = [[NSMutableArray alloc] init];
    self.UserClasses = [[NSMutableArray alloc] init];
    return self;
}

@end
