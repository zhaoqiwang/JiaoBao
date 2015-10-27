//
//  ParserJson_OnlineJob.h
//  JiaoBao
//
//  Created by songyanming on 15/10/16.
//  Copyright © 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"
#import "StuInfoModel.h"
#import "GenInfo.h"
#import "StuHWModel.h"
#import "StuHomeWorkModel.h"
#import "StuHWQsModel.h"


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



@end
