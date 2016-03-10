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

@end
