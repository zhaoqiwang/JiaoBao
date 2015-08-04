//
//  ParserJson_knowledge.h
//  JiaoBao
//
//  Created by Zqw on 15/8/3.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"
#import "ProviceModel.h"
#import "UserInformationModel.h"
#import "CategoryModel.h"

@interface ParserJson_knowledge : NSObject

//取系统中的省份信息
+(NSMutableArray *)parserJsonGetProvice:(NSString *)json;

//通过昵称取用户教宝号
+(NSMutableArray *)parserJsonGetJiaoBaoHao:(NSString *)json;

//取用户信息
+(UserInformationModel*)parserJsonGetUserInfo:(NSString *)json;

//取系统话题列表
+(NSMutableArray*)parserJsonGetCategory:(NSString *)json;

//获取单一话题
+(CategoryModel*)parserJsonGetCategoryById:(NSString*)json;
@end
