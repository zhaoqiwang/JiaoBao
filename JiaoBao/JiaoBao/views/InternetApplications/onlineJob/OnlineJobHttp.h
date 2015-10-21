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
#import "PublishJobModel.h"

@interface OnlineJobHttp : NSObject<ASIHTTPRequestDelegate>
//单
+(OnlineJobHttp *)getInstance;
//获取年纪列表
-(void)GetGradeList;
//获取联动列表 //（年级代码）- （科目代码）- （教版联动代码）- （0： 根据年级获取科目，1：根据科目获取教版，2： 根据教版获取章节）
-(void)GetUnionChapterListWithgCode:(NSString*)gCode subCode:(NSString*)subCode uId:(NSString*)uId flag:(NSString*)flag;
//获取老师的自定义作业列表
-(void)GetDesHWListWithChapterID:(NSString*)ChapterID teacherJiaobaohao:(NSString*)teacherJiaobaohao;



//老师发布作业接口
//发布作业的参数在PublishJobModel里
-(void)TecMakeHWWithPublishJobModel:(PublishJobModel*)publishJobModel;

//学生获取当前作业列表 参数：学生ID
-(void)GetStuHWListWithStuId:(NSString*)StuId;

@end
