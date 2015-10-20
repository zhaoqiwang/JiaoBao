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

//老师发布作业接口
//接收参数：
//teacherJiaobaohao： 老师教宝号
//classID： 班级ID
//className：班级名称
//chapterID：章节ID
//DoLv：难度等级
//AllNum：总题量：
//SelNum：选择题量
//InpNum：填空题
//Distribution：1:10,2:20 试题分布
//LongTime：作业时长
//ExpTime：过期时间
//homeworkName：作业名称---  日期+科目+单元名称
//Additional：“”
//AdditionalDes：“”
//schoolName：学校名称
//HwType：作业类型  1为个性作业，2为AB卷，3为自定义作业，4统一作业（所有班级统一）
//IsAnSms：是否发送 答案 短信： T F
//IsQsSms： 是否发送 试题 通知：
//IsRep：是否发送 老师反馈 短信
//TecName：老师的名称
//DesId：自定义作业ID，如果是自定义作业则加上自定义的ID
//-(void)TecMakeHWWithteacherJiaobaohao:(NSString*)teacherJiaobaohao classID:(NSString*)classID className:(NSString*)className chapterID:(NSString*)chapterID DoLv:(NSString*)DoLv AllNum:(NSString*)AllNum SelNum:(NSString*)SelNum InpNum:(NSString*)InpNum Distribution:(NSString*)Distribution LongTime:(NSString*)LongTime ExpTime:(NSString*)ExpTime homeworkName:(NSString*)homeworkName Additional:(NSString*)Additional AdditionalDes:(NSString*)AdditionalDes schoolName:(NSString*)schoolName HwType:(NSString*)HwType IsAnSms:(NSString*)IsAnSms IsQsSms:(NSString*)IsQsSms IsRep:(NSString*)IsRep TecName:(NSString*)TecName DesId:(NSString*)DesId;

@end
