//
//  ParserJson_OnlineJob.h
//  JiaoBao
//
//  Created by songyanming on 15/10/16.
//  Copyright © 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"


@interface ParserJson_OnlineJob : NSObject
+(NSMutableArray *)parserJsonGradeList:(NSString *)json;//解析年级
+(NSMutableArray *)parserJsonSubjectList:(NSString *)json;//解析科目
+(NSMutableArray *)parserJsonVersionList:(NSString *)json;//解析教版
+(NSMutableArray *)parserJsonChapterList:(NSString *)json;//解析章节
+(NSMutableArray *)parserJsonHomeworkList:(NSString *)json;//解析自定义作业
+(NSDictionary *)parserJsonStuInfo:(NSString*)json;//解析学生信息



@end
