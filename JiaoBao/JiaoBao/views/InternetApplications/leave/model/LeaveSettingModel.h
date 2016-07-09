//
//  LeaveSettingModel.h
//  JiaoBao
//  指定单位的请假设置model
//  Created by SongYanming on 16/3/10.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LevelNoteModel.h"

@interface LeaveSettingModel : NSObject
@property(nonatomic,strong)NSString *StatusStd;//是否启用学生请假系统（如果为false,忽略ApproveLevelStd，LevelNoteStd，ApproveListStd ）
@property(nonatomic,strong)NSString *ApproveLevelStd;//学生请假审核级数（1-5级）

@property(nonatomic,strong)NSString *StatusTea;//是否启用老师（教职工）请假系统（如果为false,忽略

@property(nonatomic,strong)NSString *ApproveLevelTea;//老师请假审核级数（1-5级）
@property(nonatomic,strong)NSString *GateGuardList;//是否有门卫权限

@property(nonatomic,strong)LevelNoteModel *LevelNoteStd;//学生请假的各级审核流程的名称（例：{"A":"班主任","B":"年级主任","C":"德育主任","D":"","E":null}，A、B、C、D、E对应1-5级，如果对应的流程有名称，则在界面上显示名称，没有则显示一审，二审，三审，……）
@property(nonatomic,strong)LevelNoteModel *LevelNoteTea;//老师请假的各级审核流程的名称（例：{"A":"科室主任","B":"副校长","C":"","D":"","E":null}）
@property(nonatomic,strong)LevelNoteModel *ApproveListStd;// 当前帐户在学生请假各个审批流程中的权限，（例：{"A":"false","B":"true","C":"false","D":"","E":null}

@property(nonatomic,strong)LevelNoteModel *ApproveListTea;//当前帐户在老师请假各个审批流程中的权限，（例：{"A":"false","B":"true","C":"false","D":"","E":null}



@end
