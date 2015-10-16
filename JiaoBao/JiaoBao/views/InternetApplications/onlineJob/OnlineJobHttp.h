//
//  OnlineJobHttp.h
//  JiaoBao
//
//  Created by songyanming on 15/10/15.
//  Copyright © 2015年 JSY. All rights reserved.
//在线作业接口

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
#import "ParserJson_share.h"
#import "ArthDetailModel.h"
#import "LoginSendHttp.h"
#import "VlorNetWorkAPI.h"
#import "ParserJson_knowledge.h"

@interface OnlineJobHttp : NSObject<ASIHTTPRequestDelegate>
//单
+(OnlineJobHttp *)getInstance;
//获取年纪列表
-(void)GetGradeList;
//获取联动列表
-(void)GetUnionChapterListWithgCode:(NSString*)gCode subCode:(NSString*)subCode uId:(NSString*)uId flag:(NSString*)flag;
//获取自定义作业列表
-(void)GetDesHWListWithChapterID:(NSString*)ChapterID teacherJiaobaohao:(NSString*)teacherJiaobaohao;
//
-(void)GetStuHWListWithStuId:(NSString*)StuId;
//获取单题，作业名称作业题量，作业开始时间，作业时长，作业上交时间
-(void)GetStuHWWithHwInfoId:(NSString*)HwInfoId;

@end
