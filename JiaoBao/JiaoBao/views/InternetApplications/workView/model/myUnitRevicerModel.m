//
//  myUnitRevicerModel.m
//  JiaoBao
//
//  Created by Zqw on 14-11-4.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "myUnitRevicerModel.h"

@implementation myUnitRevicerModel
@synthesize UnitName,TabIDStr,UserList;

-(id)init{
    self = [super init];
    self.UserList = [[NSMutableArray alloc] init];
    return self;
}

@end
