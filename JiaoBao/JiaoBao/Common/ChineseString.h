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

@interface ChineseString : NSObject

@property(retain,nonatomic)NSString *string;
@property(retain,nonatomic)NSString *pinYin;
@property(retain,nonatomic)UserInfoByUnitIDModel *userModel;
@property(retain,nonatomic)ExchangeUnitGroupsModel *groupModel;

@end
