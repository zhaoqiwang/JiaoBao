//
//  ClassHttp.h
//  JiaoBao
//
//  Created by Zqw on 15-3-27.
//  Copyright (c) 2015年 JSY. All rights reserved.
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
#import "ParserJson_class.h"

@interface ClassHttp : NSObject<ASIHTTPRequestDelegate>{
    
}

//单
+(ClassHttp *)getInstance;

//客户端通过本接口获取本单位栏目文章。    默认第一页           默认20条           1个人发布文章，2单位发布文章     单位ID           0按最新排序，1按最热排序，默认为0  标题关键字搜索
-(void)classHttpUnitArthListIndex:(NSString *)page Num:(NSString *)num Flag:(NSString *)flag UnitID:(NSString *)UnitID order:(NSString *)order title:(NSString *)title RequestFlag:(NSString *)ReFlag;

//取单位空间发表的最新或推荐文章,
//（包含官方文章和非官方文章,即单位展示和单位分享） 默认第一页   默认20条               1最新                     local本地，默认为空，取所有记录      请求flag
-(void)classHttpShowingUnitArthList:(NSString *)page Num:(NSString *)num topFlags:(NSString *)topFlags flag:(NSString *)flag RequestFlag:(NSString *)ReFlag;

//取我关注的单位栏目文章                   默认第一页           默认20条           教宝号
-(void)classHttpMyAttUnitArthListIndex:(NSString *)page Num:(NSString *)num accid:(NSString *)accid;

//我的班级文章列表                          默认第一页           默认20条           1个人发布文章，2单位动态       1是总界面，3是单独列表界面
-(void)classHttpAllMyClassArthList:(NSString *)page Num:(NSString *)num sectionFlag:(NSString *)flag RequestFlag:(NSString *)ReFlag;

//获取当前用户可以发布动态的单位列表(含班级）
-(void)classHttpGetReleaseNewsUnits;

@end
