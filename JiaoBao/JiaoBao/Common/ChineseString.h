//
//  ChineseString.h
//  ChineseSort
//
//  Created by Bill on 12-8-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoByUnitIDModel.h"
#import "ExchangeUnitGroupsModel.h"
#import "UserSumClassModel.h"
#import "UnitInfoModel.h"
#import "groupselit_selitModel.h"
#import "CommMsgRevicerUnitListModel.h"
#import "UserListModel.h"

@interface ChineseString : NSObject

@property(retain,nonatomic)NSString *string;
@property(retain,nonatomic)NSString *pinYin;
@property(retain,nonatomic)UserInfoByUnitIDModel *userModel;
@property(retain,nonatomic)ExchangeUnitGroupsModel *groupModel;
@property(retain,nonatomic)UserSumClassModel *userSumClassModel;
@property(retain,nonatomic)UnitInfoModel *unitInfoModel;
@property(retain,nonatomic)groupselit_selitModel *groupselit;
@property(retain,nonatomic)myUnit *myUnitModel;
@property(retain,nonatomic)UserListModel *userListModel;

@end
