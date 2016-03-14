//
//  ParserJson_OnlineJob.h
//  JiaoBao
//
//  Created by songyanming on 15/10/16.
//  Copyright © 2015年 JSY. All rights reserved.
//在线作业接口数据json解析

#import <Foundation/Foundation.h>
#import "JSONKit.h"
#import "StuInfoModel.h"
#import "GenInfo.h"
#import "StuHWModel.h"
#import "StuHomeWorkModel.h"
#import "StuHWQsModel.h"
#import "LevelModel.h"
#import "CompleteStatusModel.h"
#import "StuSubModel.h"
#import "TreeJob_node.h"
#import "GetUnitInfoModel.h"


@interface ParserJson_OnlineJob : NSObject
+(NSMutableArray *)parserJsonGradeList:(NSString *)json;//解析年级
+(NSMutableArray *)parserJsonSubjectList:(NSString *)json;//解析科目
+(NSMutableArray *)parserJsonVersionList:(NSString *)json;//解析教版
+(NSMutableArray *)parserJsonChapterList:(NSString *)json;//解析章节
+(NSMutableArray *)parserJsonHomeworkList:(NSString *)json;//解析自定义作业
+(StuInfoModel *)parserJsonStuInfo:(NSString*)json;//解析学生信息
+(GenInfo *)parserJsonGenInfo:(NSString*)json;//解析家长信息
+(NSMutableArray *)parserJsonStuHWList:(NSString*)json;//解析学生当前作业列表
+(StuHomeWorkModel *)parserJsonStuHW:(NSString*)json;//解析当前作业详细信息
+(StuHWQsModel *)parserJsonStuHWQs:(NSString*)json;//解析某作业下某题的作业题及答案
+(NSMutableArray *)parserJsonStuEduLevel:(NSString*)json;//解析学生学力
+(NSMutableArray *)parserJsonCompleteStatusHWWith:(NSString*)json;//解析学生作业完成情况
+(StuSubModel *)parserJsonStuSubModel:(NSString*)json;//解析提交答案model
+(GetUnitInfoModel *)parserJsonGetUnitInfoModel:(NSString *)json;//解析单位信息获取接口






@end
