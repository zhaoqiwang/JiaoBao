//
//  ShowHttp.h
//  JiaoBao
//
//  Created by Zqw on 14-12-13.
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
#import "LoginSendHttp.h"
#import "ParserJson_show.h"
#import "UpdateUnitListModel.h"


@interface ShowHttp : NSObject<ASIHTTPRequestDelegate>{
    
}

//单
+(ShowHttp *)getInstance;

//获取单位logo
-(void)showHttpGetUnitLogo:(NSString *)unitID Size:(NSString *)size;

//取同事、关注人、好友的分享文章
-(void)showHttpGetMyShareingArth:(NSString *)accid page:(NSString *)pageNum viewFlag:(NSString *)flag;

//取最新或推荐个人分享文章              1最新2推荐
-(void)showHttpGetShareingArthList:(NSString *)flag page:(NSString *)pageNum;

//取最新或推荐单位栏目文章                      1最新2推荐          是否本地
-(void)showHttpGetShowingUnitArthList:(NSString *)topFlags flag:(NSString *)flag page:(NSString *)pageNum;

//取最新更新文章单位信息                   1最新2推荐              是否本地
-(void)showHttpGetUpdateUnitList:(NSString *)topFlag local:(NSString *)local page:(NSString *)pageNum;

//取最新更新的主题                          1最新2推荐
-(void)showHttpGetUpdatedInterestList:(NSString *)topFlag page:(NSString *)pageNum;

//我的主题，取我关注的和我所参与主题
-(void)showHttpGetEnjoyInterestList:(NSString *)accid;

//获取我的关注单位
-(void)showHttpGetMyAttUnit:(NSString *)accid;

//获取本单位栏目文章                               1共享2展示                单位ID                第几页
-(void)showHttpGetUnitArthLIstIndexWith:(NSString *)sectionFlag UnitID:(NSString *)unitID Page:(NSString *)page;

//获取单位简介
-(void)showHttpGetintroduce:(NSString *)unitID uTyper:(NSString *)type;

//获取我的好友，提供用户jiaobaohao，获取该用户的所有好友
-(void)showHttpGetMyFriends:(NSString *)accid;

//获取好友分组，提供jiaobaohao，获取该用户的所有好友分组
-(void)showHttpGetMyGroups:(NSString *)accid;

//获取好友分组，提供jiaobaohao和组ID，获取该用户的这个组中所有好友
-(void)showHttpGetMyGroups:(NSString *)accid Group:(NSString *)groupID;

//获取我的关注,提供jiaobaohao，获取该用户关注人员
-(void)showHttpGetMyAttFriends:(NSString *)accid;

//获取单位头像
-(void)getUnitImg:(NSMutableArray *)array;

@end
