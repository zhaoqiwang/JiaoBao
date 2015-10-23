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
#import "HomeworkModel.h"
#import "StuInfoModel.h"

@implementation ParserJson_OnlineJob
//解析年级
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
//解析科目
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
//解析教版
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
//解析章节
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
//解析自定义作业
+(NSMutableArray *)parserJsonHomeworkList:(NSString *)json
{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *arrList = [json objectFromJSONString];
    for (int i=0; i<arrList.count; i++) {
        HomeworkModel *model = [[HomeworkModel alloc] init];
        NSDictionary *dic = [arrList objectAtIndex:i];
        model.TabIDStr = [dic objectForKey:@"TabIDStr"];
        model.TabID = [dic objectForKey:@"TabID"];
        model.AccountID = [dic objectForKey:@"AccountID"];
        model.jiaobaohao = [dic objectForKey:@"jiaobaohao"];
        model.SubjectID = [dic objectForKey:@"SubjectID"];
        model.GradeID = [dic objectForKey:@"GradeID"];
        model.chapterID = [dic objectForKey:@"chapterID"];
        model.VersionID = [dic objectForKey:@"VersionID"];
        model.itemNumber = [dic objectForKey:@"itemNumber"];
        model.homeworkName = [dic objectForKey:@"homeworkName"];
        model.questionList = [dic objectForKey:@"questionList"];
        model.CreateTime = [dic objectForKey:@"CreateTime"];
                model.itemSelect = [dic objectForKey:@"itemSelect"];
        model.itemInput = [dic objectForKey:@"itemInput"];
        
        [array addObject:model];
    }
    return array;
}

+(NSDictionary *)parserJsonStuInfo:(NSString*)json//解析学生信息
{
        NSDictionary *dic = [json objectFromJSONString];
        StuInfoModel *model = [[StuInfoModel alloc] init];
        model.StudentID = [dic objectForKey:@"StudentID"];
        model.StdName = [dic objectForKey:@"StdName"];
        model.Sex = [dic objectForKey:@"Sex"];
        model.SchoolType = [dic objectForKey:@"SchoolType"];
        model.GradeYear = [dic objectForKey:@"GradeYear"];
        model.GradeName = [dic objectForKey:@"GradeName"];
        model.ClassNo = [dic objectForKey:@"ClassNo"];
        model.UnitClassID = [dic objectForKey:@"UnitClassID"];
        model.SchoolID = [dic objectForKey:@"SchoolID"];

        
    return dic;
    
}

@end
