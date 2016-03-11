//
//  ParserJson_leave.m
//  JiaoBao
//
//  Created by SongYanming on 16/3/10.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "ParserJson_leave.h"


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

        NSDictionary *ApproveListStdDic = [dic objectForKey:@"ApproveListStd"];

        model.ApproveListStd = [dic objectForKey:@"ApproveListStd"];
        NSDictionary *levelNoteStdDic = [dic objectForKey:@"LevelNoteStd"];
        [model.LevelNoteStd dicToModel:levelNoteStdDic];
        [model.ApproveListStd dicToModel:ApproveListStdDic];




    }
    else{
        
    }
    if([model.StatusTea integerValue]!=0){
        model.ApproveListTea = [dic objectForKey:@"ApproveList"];
        NSDictionary *levelNoteTeaDic = [dic objectForKey:@"LevelNote"];
        NSDictionary *ApproveListTeaDic = [dic objectForKey:@"ApproveList"];
        [model.LevelNoteTea dicToModel:levelNoteTeaDic];
        [model.LevelNoteTea dicToModel:ApproveListTeaDic];
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
        MyLeaveModel *model = [[MyLeaveModel alloc]init];
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

@end
