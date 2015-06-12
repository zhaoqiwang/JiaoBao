//
//  ChineseString.m
//  ChineseSort
//
//  Created by Bill on 12-8-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ChineseString.h"

@implementation ChineseString

@synthesize string;
@synthesize pinYin,userModel,groupModel;

-(id)init{
    self = [super init];
    self.userModel = [[UserInfoByUnitIDModel alloc] init];
    self.groupModel = [[ExchangeUnitGroupsModel alloc] init];
    return self;
}

@end
