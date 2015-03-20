//
//  ExchangeHttp.h
//  JiaoBao
//
//  Created by Zqw on 14-12-2.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "dm.h"
#import "ASIFormDataRequest.h"
#import "RSATool.h"
#import "NSString+Base64.h"
#import "NSData+Base64.h"
#import "NSData+CommonCrypto.h"
#import "DESTool.h"
#import "JSONKit.h"
#import "define_constant.h"
#import "LoginSendHttp.h"
#import "ParserJson_exchange.h"
#import "UnitSectionMessageModel.h"
#import "ParserJson_share.h"

@interface ExchangeHttp : NSObject<ASIHTTPRequestDelegate>

+(ExchangeHttp *)getInstance;

//获取单位所有分组,                         单位ID            来自哪个界面请求
-(void)exchangeHttpGetUnitGroupsWith:(NSString *)UID from:(NSString *)from;

//获取单位内所有用户                             单位ID               0全部，1账户ID>0            来自哪个界面请求
-(void)exchangeHttpGetUserUnfoByUnitIDWith:(NSString *)UID filter:(NSString *)filter from:(NSString *)from;;

//获取融云网络用户token
-(void)exchangeHttpRongYunGetToken:(NSString *)accid TrueName:(NSString *)name;

//获取好友分组
-(void)exchangeHttpGetGetMyFriendsGroups:(NSString *)accID;

//获取该用户的这个组中所有好友
-(void)exchangeHttpGetMyFriendsByGroups:(NSString *)accID GroupID:(NSString *)groupID;

//通过用户的accid，获取头像
-(void)getUserInfoFace:(NSString *)accid;

@end
