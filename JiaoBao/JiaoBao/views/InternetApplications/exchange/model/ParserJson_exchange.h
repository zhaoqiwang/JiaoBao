//
//  ParserJson_exchange.h
//  JiaoBao
//
//  Created by Zqw on 14-12-2.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"
#import "ExchangeUnitGroupsModel.h"
#import "UserInfoByUnitIDModel.h"
#import "RongYunTokenModel.h"
#import "MyFriendsGroupsModel.h"

@interface ParserJson_exchange : NSObject

//获取单位所有分组
+(NSMutableArray *)parserJsonUnitGroupsWith:(NSString *)json;

//单位内所有用户
+(NSMutableArray *)parserJsonUserInfoByUnitIDWith:(NSString *)json;

//解析融云网络用户token
+(RongYunTokenModel *)parserJsonGetRongYunTokenWith:(NSString *)json;

//获取自己的好友分组
+(NSMutableArray *)parserJsonMyFriendsGroups:(NSString *)json;

@end
