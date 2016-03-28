//
//  ParserJson_leave.m
//  JiaoBao
//
//  Created by SongYanming on 16/3/10.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "ParserJson_leave.h"
#import "MyStdInfo.h"
#import "MyAdminClass.h"
#import "ClassLeavesModel.h"
#import "UserClassInfo.h"
#import "StuInfoModel.h"
#import "dm.h"
#import "ClassSumLeaves.h"

@implementation ParserJson_leave
//取指定单位的请假设置
+(LeaveSettingModel *)parserJsonGetLeaveSetting:(NSString *)json{
    NSDictionary *dic = [json objectFromJSONString];
    LeaveSettingModel *model = [[LeaveSettingModel alloc ]init];
    model.StatusStd = [NSString stringWithFormat:@"%@",[dic objectForKey:@"StatusStd"]];
        model.StatusTea = [NSString stringWithFormat:@"%@",[dic objectForKey:@"Status"]];
    
    model.ApproveLevelStd = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ApproveLevelStd"]];
    model.ApproveLevelTea = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ApproveLevel"]];
    
        model.GateGuardList = [NSString stringWithFormat:@"%@",[dic objectForKey:@"GateGuardList"]];
    
    if([model.StatusStd integerValue]!=0){
        NSString*ApproveListStd =[dic objectForKey:@"ApproveListStd"];
        NSString*levelNoteStd =[dic objectForKey:@"LevelNoteStd"];
        
        //[model.LevelNoteStd dicToModel:levelNoteStd];
        [model.ApproveListStd dicToModel:ApproveListStd];




    }
    else{
        
    }
    if([model.StatusTea integerValue]!=0){
        NSString *levelNoteTea = [dic objectForKey:@"LevelNote"];
        NSString *ApproveListTea = [dic objectForKey:@"ApproveList"];
        
        [model.LevelNoteTea dicToModel:levelNoteTea];
        [model.ApproveListTea dicToModel:ApproveListTea];
    }else{
        
    }
    return model;
}
//获得我提出申请的请假记录
+(NSMutableArray*)parserJsonMyLeaves:(NSString*)json{
    NSMutableArray *arr = [json objectFromJSONString];
    NSMutableArray *mArr = [[NSMutableArray alloc]initWithCapacity:0];
    for(int i=0;i<arr.count;i++){
        NSDictionary *dic = [arr objectAtIndex:i];
        ClassLeavesModel *model = [[ClassLeavesModel alloc]init];
        [model dicToModel:dic];
        [mArr addObject:model];
        
    }
    return mArr;

}

//取一个假条的明细信息
+(LeaveDetailModel*)parserJsonleaveDetail:(NSString*)json{
    NSDictionary *dic = [json objectFromJSONString];
    LeaveDetailModel *model = [[LeaveDetailModel alloc ]init];
    [model dicToModel:dic];
    return model;
}
//取得我的教宝号所关联的学生列表(家长身份)
+(NSMutableArray*)parserJsonMyStdInfo:(NSString *)json{
    NSMutableArray *arr = [json objectFromJSONString];
    NSMutableArray *mArr = [[NSMutableArray alloc]initWithCapacity:0];
    for(int i=0;i<arr.count;i++){
        NSDictionary *dic = [arr objectAtIndex:i];
        MyStdInfo *model = [[MyStdInfo alloc]init];
        [model dicToModel:dic];
        [mArr addObject:model];
    }
    return mArr;
    
}
//作为班主任身份,取得我所管理的班级列表
+(NSMutableArray*)parserJsonMyAdminClass:(NSString *)json{
    NSMutableArray *arr = [json objectFromJSONString];
    NSMutableArray *mArr = [[NSMutableArray alloc]initWithCapacity:0];
    for(int i=0;i<arr.count;i++){
        NSDictionary *dic = [arr objectAtIndex:i];
        MyAdminClass *model = [[MyAdminClass alloc]init];
        [model dicToModel:dic];
        [mArr addObject:model];
        
    }
    return mArr;
    
}
//班主任身份获取本班学生请假的审批记录
+(NSMutableArray*)parserJsonClassLeaves:(NSString *)json{
    NSMutableArray *arr = [json objectFromJSONString];
    NSMutableArray *mArr = [[NSMutableArray alloc]initWithCapacity:0];
    for(int i=0;i<arr.count;i++){
        NSDictionary *dic = [arr objectAtIndex:i];
        ClassLeavesModel *model = [[ClassLeavesModel alloc]init];
        [model dicToModel:dic];
        [mArr addObject:model];
        
    }
    return mArr;
    
}
//门卫取请假记录
+(NSMutableArray*)parserJsonGateLeaves:(NSString *)json{
    NSMutableArray *arr = [json objectFromJSONString];
    NSMutableArray *mArr = [[NSMutableArray alloc]initWithCapacity:0];
    for(int i=0;i<arr.count;i++){
        NSDictionary *dic = [arr objectAtIndex:i];
        ClassLeavesModel *model = [[ClassLeavesModel alloc]init];
        [model dicToGateModel:dic];
        [mArr addObject:model];
        
    }
    return mArr;
    
}
+(NSMutableArray *)parserJsonStuInfoArr:(NSString*)json//解析学生信息
{
    NSMutableArray *arr = [json objectFromJSONString];
    NSMutableArray *mArr = [[NSMutableArray alloc]initWithCapacity:0];
    for(int i=0;i<arr.count;i++){
        NSDictionary *dic = [arr objectAtIndex:i];
        StuInfoModel *model = [[StuInfoModel alloc] init];
        model.StudentID = [dic objectForKey:@"StudentID"];
        model.StdName = [dic objectForKey:@"StdName"];
        model.Sex = [dic objectForKey:@"Sex"];
        model.SchoolType = [dic objectForKey:@"SchoolType"];
        model.GradeYear = [dic objectForKey:@"GradeYear"];
        model.GradeName = [dic objectForKey:@"GradeName"];
        model.ClassNo = [dic objectForKey:@"ClassNo"];
        model.ClassName = [dic objectForKey:@"ClassName"];
        model.UnitClassID = [dic objectForKey:@"UnitClassID"];
        model.SchoolID = [dic objectForKey:@"SchoolID"];
        [mArr addObject:model];
        
    }
    return mArr;
    
}
+(NSMutableArray *)parserJsonUserClassInfoArr:(NSString*)json//解析学校所有班级
{
    NSMutableArray *arr = [json objectFromJSONString];
    NSMutableArray *mArr = [[NSMutableArray alloc]initWithCapacity:0];
    for(int i=0;i<arr.count;i++){
        NSDictionary *dic = [arr objectAtIndex:i];
        UserClassInfo *model = [[UserClassInfo alloc] init];
        model.ClassID = [dic objectForKey:@"ClassID"];
        model.ClassNo = [dic objectForKey:@"ClassNo"];
        model.ClassName = [dic objectForKey:@"ClassName"];
        model.GradeYear = [dic objectForKey:@"GradeYear"];
        model.GradeName = [dic objectForKey:@"GradeName"];
        model.State = [dic objectForKey:@"State"];
        model.SchoolID = [dic objectForKey:@"SchoolID"];

        [mArr addObject:model];
        
    }
    
    //二级数组格式
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i<mArr.count; i++) {
        UserClassInfo *model = [mArr objectAtIndex:i];
        if (array.count==0) {
            [array addObject:model];
        }
        for (UserClassInfo *tempModel in array) {
            if ([model.GradeName isEqual:tempModel.GradeName]) {
                [tempModel.mArr_class addObject:model];
            }else{
                [array addObject:model];
            }
        }
    }
    for (int i=0; i<array.count; i++) {
        UserClassInfo *model = [array objectAtIndex:i];
        UserClassInfo *model1 = [[UserClassInfo alloc] init];
        model1.ClassName = @"全部";
        [model.mArr_class insertObject:model1 atIndex:0];
    }
    //插入默认的“全部”
    UserClassInfo *model = [[UserClassInfo alloc] init];
    model.GradeName = @"全部";
    model.mArr_class = mArr;
    UserClassInfo *model1 = [[UserClassInfo alloc] init];
    model1.ClassName = @"全部";
    [model.mArr_class insertObject:model1 atIndex:0];
    [array insertObject:model atIndex:0];
    
    [dm getInstance].mArr_listClass = array;
    [dm getInstance].mArr_allClass = mArr;
    
    return mArr;
}
+(NSMutableArray *)parserJsonGetClassSumLeaves:(NSString*)json//解析学校班级请假查询统计
{
    NSMutableArray *arr = [json objectFromJSONString];
    NSMutableArray *mArr = [[NSMutableArray alloc]initWithCapacity:0];
    for(int i=0;i<arr.count;i++){
        NSDictionary *dic = [arr objectAtIndex:i];
        ClassSumLeaves *model = [[ClassSumLeaves alloc] init];
        model.UnitClassId = [dic objectForKey:@"UnitClassId"];
        model.ClassStr = [dic objectForKey:@"ClassStr"];
        model.GradeStr = [dic objectForKey:@"GradeStr"];
        model.Amount = [dic objectForKey:@"Amount"];
        model.Amount2 = [dic objectForKey:@"Amount2"];
        [mArr addObject:model];
    }
    return mArr;
}



@end
