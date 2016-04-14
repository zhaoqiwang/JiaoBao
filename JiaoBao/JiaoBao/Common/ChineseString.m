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
@synthesize pinYin,userModel,groupModel,userSumClassModel,unitInfoModel,groupselit,myUnitModel,userListModel;

-(id)init{
    self = [super init];
    self.userModel = [[UserInfoByUnitIDModel alloc] init];
    self.groupModel = [[ExchangeUnitGroupsModel alloc] init];
    self.userSumClassModel = [[UserSumClassModel alloc] init];
    self.unitInfoModel = [[UnitInfoModel alloc] init];
    self.groupselit = [[groupselit_selitModel alloc] init];
    self.myUnitModel = [[myUnit alloc] init];
    self.userListModel = [[UserListModel alloc] init];
    self.stuInfoModel = [[StuInfoModel alloc] init];
    return self;
}

@end
