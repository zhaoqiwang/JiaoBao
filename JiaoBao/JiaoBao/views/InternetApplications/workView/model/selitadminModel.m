//
//  selitadminModel.m
//  JiaoBao
//
//  Created by Zqw on 14-11-11.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "selitadminModel.h"

@implementation selitadminModel
@synthesize groupName,UnitType,UserList,SendFlag;

-(id)init{
    self = [super init];
    self.UserList = [[NSMutableArray alloc] init];
    return self;
}

@end
