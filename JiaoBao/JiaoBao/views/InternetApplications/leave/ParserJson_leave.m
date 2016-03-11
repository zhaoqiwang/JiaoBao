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
        NSString*ApproveListStd =[dic objectForKey:@"ApproveListStd"];
        NSString*levelNoteStd =[dic objectForKey:@"LevelNoteStd"];
        
        [model.LevelNoteStd dicToModel:ApproveListStd];
        [model.ApproveListStd dicToModel:levelNoteStd];




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
