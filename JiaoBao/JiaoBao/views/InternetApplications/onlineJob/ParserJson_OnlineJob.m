//
//  ParserJson_OnlineJob.m
//  JiaoBao
//
//  Created by songyanming on 15/10/16.
//  Copyright © 2015年 JSY. All rights reserved.
//

#import "ParserJson_OnlineJob.h"
#import "GradeModel.h"
#import "SubjectModel.h"
#import "VersionModel.h"
#import "ChapterModel.h"

@implementation ParserJson_OnlineJob
+(NSMutableArray *)parserJsonGradeList:(NSString *)json
{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *arrList = [json objectFromJSONString];
    for (int i=0; i<arrList.count; i++) {
        GradeModel *model = [[GradeModel alloc] init];
        NSDictionary *dic = [arrList objectAtIndex:i];
        model.TabIDStr = [dic objectForKey:@"TabIDStr"];
        model.TabID = [dic objectForKey:@"TabID"];
        model.GradeCode = [dic objectForKey:@"GradeCode"];
        model.GradeName = [dic objectForKey:@"GradeName"];
        model.isEnable = [dic objectForKey:@"isEnable"];
        model.orderby = [dic objectForKey:@"orderby"];
        [array addObject:model];
    }
    return array;
}
+(NSMutableArray *)parserJsonSubjectList:(NSString *)json
{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *arrList = [json objectFromJSONString];
    for (int i=0; i<arrList.count; i++) {
        SubjectModel *model = [[SubjectModel alloc] init];
        NSDictionary *dic = [arrList objectAtIndex:i];
        model.TabID = [dic objectForKey:@"TabID"];
        model.VersionCode = [dic objectForKey:@"VersionCode"];
        model.VersionName = [dic objectForKey:@"VersionName"];
        model.GradeCode = [dic objectForKey:@"GradeCode"];
        model.GradeName = [dic objectForKey:@"GradeName"];
        model.subjectCode = [dic objectForKey:@"subjectCode"];
        model.subjectName = [dic objectForKey:@"subjectName"];
        [array addObject:model];
    }
    return array;
}
+(NSMutableArray *)parserJsonVersionList:(NSString *)json
{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *arrList = [json objectFromJSONString];
    for (int i=0; i<arrList.count; i++) {
        VersionModel *model = [[VersionModel alloc] init];
        NSDictionary *dic = [arrList objectAtIndex:i];
        model.TabID = [dic objectForKey:@"TabID"];
        model.VersionCode = [dic objectForKey:@"VersionCode"];
        model.VersionName = [dic objectForKey:@"VersionName"];
        model.GradeCode = [dic objectForKey:@"GradeCode"];
        model.GradeName = [dic objectForKey:@"GradeName"];
        model.subjectCode = [dic objectForKey:@"subjectCode"];
        model.subjectName = [dic objectForKey:@"subjectName"];
        [array addObject:model];
    }
    return array;
    
}
+(NSMutableArray *)parserJsonChapterList:(NSString *)json
{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *arrList = [json objectFromJSONString];
    for (int i=0; i<arrList.count; i++) {
        ChapterModel *model = [[ChapterModel alloc] init];
        NSDictionary *dic = [arrList objectAtIndex:i];
        model.TabIDStr = [dic objectForKey:@"TabIDStr"];
        model.TabID = [dic objectForKey:@"TabID"];
        model.subjectID = [dic objectForKey:@"subjectID"];
        model.TVersionID = [dic objectForKey:@"TVersionID"];
        model.Unid = [dic objectForKey:@"Unid"];
        model.Pid = [dic objectForKey:@"Pid"];
        model.chapterCode = [dic objectForKey:@"chapterCode"];
        model.chapterName = [dic objectForKey:@"chapterName"];
        model.Remark = [dic objectForKey:@"Remark"];
        model.isEnable = [dic objectForKey:@"isEnable"];
        model.orderby = [dic objectForKey:@"orderby"];
        model.chapterCodePid = [dic objectForKey:@"chapterCodePid"];

        [array addObject:model];
    }
    return array;
    
}

@end
