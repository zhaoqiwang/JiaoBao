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
+(NSMutableArray *)parserJsonGradeList:(NSString *)json;
+(NSMutableArray *)parserJsonSubjectList:(NSString *)json;
+(NSMutableArray *)parserJsonVersionList:(NSString *)json;
+(NSMutableArray *)parserJsonChapterList:(NSString *)json;
+(NSMutableArray *)parserJsonHomeworkList:(NSString *)json;//解析自定义作业


@end
