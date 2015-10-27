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
#import "GenInfo.h"
#import "StuHWModel.h"
#import "StuHomeWorkModel.h"
#import "StuHWQsModel.h"
#import "utils.h"

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
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        model.TabID = [numberFormatter stringFromNumber:[dic objectForKey:@"TabID" ]];
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

+(StuInfoModel *)parserJsonStuInfo:(NSString*)json//解析学生信息
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

        
    return model;
    
}

+(GenInfo *)parserJsonGenInfo:(NSString*)json//解析家长信息
{
    NSDictionary *dic = [json objectFromJSONString];
    GenInfo *model = [[GenInfo alloc] init];
    model.AccID = [dic objectForKey:@"AccID"];
    model.ClassName = [dic objectForKey:@"ClassName"];
    model.GenID = [dic objectForKey:@"GenID"];
    model.SchoolID = [dic objectForKey:@"SchoolID"];
    model.SrvFlag = [dic objectForKey:@"SrvFlag"];
    model.StdName = [dic objectForKey:@"StdName"];
    model.StudentID = [dic objectForKey:@"StudentID"];
    model.UnitClassID = [dic objectForKey:@"UnitClassID"];
    
    
    return model;
    
}

+(NSMutableArray *)parserJsonStuHWList:(NSString*)json//解析学生当前作业列表
{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *arrList = [json objectFromJSONString];
    for (int i=0; i<arrList.count; i++) {
        StuHWModel *model = [[StuHWModel alloc] init];
        NSDictionary *dic = [arrList objectAtIndex:i];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        model.TabID = [numberFormatter stringFromNumber:[dic objectForKey:@"TabID" ]];
        model.homeworkName = [dic objectForKey:@"homeworkName"];
        model.distribution = [dic objectForKey:@"distribution"];
        model.itemNumber = [numberFormatter stringFromNumber:[dic objectForKey:@"itemNumber" ]] ;
        model.HWID = [numberFormatter stringFromNumber:[dic objectForKey:@"HWID"]];
        model.AccountID = [numberFormatter stringFromNumber:[dic objectForKey:@"AccountID"]];
        model.isHWFinish = [numberFormatter stringFromNumber:[dic objectForKey:@"isHWFinish"]];
        model.isAdFinish = [numberFormatter stringFromNumber:[dic objectForKey:@"isAdFinish"]];
        model.AddEndTime = [dic objectForKey:@"AddEndTime"];
        model.HWScore = [numberFormatter stringFromNumber:[dic objectForKey:@"HWScore"]];
        model.EduLevel = [numberFormatter stringFromNumber:[dic objectForKey:@"EduLevel"]];
        model.HWEndTime = [dic objectForKey:@"HWEndTime"];

//        model.TabIDStr = [dic objectForKey:@"TabIDStr"];
//        model.studentLevel = [dic objectForKey:@"studentLevel"];
//        model.jiaobaohao = [dic objectForKey:@"jiaobaohao"];
//        model.useLongtime = [dic objectForKey:@"useLongtime"];
//        model.AddStartTime = [dic objectForKey:@"AddStartTime"];
//        model.CheckNum = [dic objectForKey:@"CheckNum"];
//        model.CheckTeacher = [dic objectForKey:@"CheckTeacher"];
//        model.CheckResultJBH = [dic objectForKey:@"CheckResultJBH"];
//        model.SubjectID = [dic objectForKey:@"SubjectID"];

        
        [array addObject:model];
    }
    return array;
    
}

+(StuHomeWorkModel *)parserJsonStuHW:(NSString*)json//解析当前作业详细信息
{
    NSDictionary *dic = [json objectFromJSONString];
    StuHomeWorkModel *model = [[StuHomeWorkModel alloc] init];
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];

    model.hwid = [numberFormatter stringFromNumber:[dic objectForKey:@"hwid"]];
    model.hwinfoid = [numberFormatter stringFromNumber:[dic objectForKey:@"hwinfoid"]];
    model.homeworkname = [dic objectForKey:@"homeworkname"];
//    NSString *str = [utils getLocalTimeDate];
//    NSString *str2 = [dic objectForKey:@"HWStartTime"];
//    NSRange range = [str2 rangeOfString:str];
//    if (range.length>0) {
//        model.HWStartTime = [[[dic objectForKey:@"HWStartTime"] stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringFromIndex:10];
//    }else{
//        model.HWStartTime = [[[dic objectForKey:@"HWStartTime"] stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:10];
//    }
    model.HWStartTime = [dic objectForKey:@"HWStartTime"];
    model.LongTime = [numberFormatter stringFromNumber:[dic objectForKey:@"LongTime"]];
    model.Qsc = [numberFormatter stringFromNumber:[dic objectForKey:@"Qsc"]];
    model.QsIdQId = [dic objectForKey:@"QsIdQId"];
    
    
    return model;
}
+(StuHWQsModel *)parserJsonStuHWQs:(NSString*)json//解析某作业下某题的作业题及答案
{
    NSDictionary *dic = [json objectFromJSONString];
    StuHWQsModel *model = [[StuHWQsModel alloc] init];
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    
    model.hwid = [numberFormatter stringFromNumber:[dic objectForKey:@"hwid"]];
    model.hwinfoid = [numberFormatter stringFromNumber:[dic objectForKey:@"hwinfoid"]];
    model.QsCon = [dic objectForKey:@"QsCon"];
    model.QsAns = [dic objectForKey:@"QsAns"];
    model.QsId = [numberFormatter stringFromNumber:[dic objectForKey:@"QsId"]];
    model.QId = [numberFormatter stringFromNumber:[dic objectForKey:@"QId"]];
    model.QsT = [numberFormatter stringFromNumber:[dic objectForKey:@"QsT"]];
    return model;
    
    
}


@end
