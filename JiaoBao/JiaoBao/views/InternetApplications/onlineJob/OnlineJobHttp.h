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
#import "StuInfoModel.h"
#import "GenInfo.h"

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

/*学生接口*/
//学生个人信息数据接口 参数：用户账号ID - 班级ID
-(void)getStuInfoWithAccID:(NSString*)AccID UID:(NSString*)UID;

//家长数据接口 参数：用户账号ID - 班级ID
-(void)getGenInfoWithAccID:(NSString*)AccID UID:(NSString*)UID;

//学生获取当前作业列表 参数：学生ID                =0为作业，=1为练习
-(void)GetStuHWListWithStuId:(NSString*)StuId IsSelf:(NSString *)IsSelf;

//获取单题,作业名称,作业题量,作业开始时间,作业时长,作业上交时间 参数：作业ID
-(void)GetStuHWWithHwInfoId:(NSString*)HwInfoId;

//获取某作业下某题的作业题及答案 参数：作业ID - 试题ID
-(void)GetStuHWQsWithHwInfoId:(NSString*)HwInfoId QsId:(NSString*)QsId;

//学生递交作业 参数：作业ID - 试题ID - 学生作答该题的答案
-(void)StuSubQsWithHwInfoId:(NSString*)HwInfoId QsId:(NSString*)QsId Answer:(NSString*)Answer;



@end