//
//  NewLeaveModel.h
//  JiaoBao
//
//  Created by SongYanming on 16/3/10.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewLeaveModel : NSObject
//生成一条请假条记录
@property(nonatomic,strong)NSString *UnitId;//单位Id
@property(nonatomic,strong)NSString *manId;//请假人的人员Id，学生ID或老师Id,非教宝号
@property(nonatomic,strong)NSString *manName;//请假人姓名
@property(nonatomic,strong)NSString *writerId;//发起人教宝号
@property(nonatomic,strong)NSString *writer;//发起人姓名
@property(nonatomic,strong)NSString *gradeStr;//年级名称
@property(nonatomic,strong)NSString *classStr;//班级名称
@property(nonatomic,strong)NSString *unitClassId;//班级Id,学生请假须提供，老师请假可以为0
@property(nonatomic,strong)NSString *manType;//人员类型，0为学生，1为老师
@property(nonatomic,strong)NSString *leaveType;//请假类型，如：补课，病假
@property(nonatomic,strong)NSString *leaveReason;//请假理由
@property(nonatomic,strong)NSString *sDateTime;//第一个请假时间段开始时间
@property(nonatomic,strong)NSString *eDateTime;//第一个请假时间段结束时间
@property(nonatomic,strong)NSString *sDateTime1;//第二个请假时间段开始时间，如果没有该时间段，调用时不需要提供该参数
@property(nonatomic,strong)NSString *eDateTime1;//第二个请假时间段结束时间，如果没有该时间段，调用时不需要提供该参数
@property(nonatomic,strong)NSString *sDateTime2;//同上
@property(nonatomic,strong)NSString *eDateTime2;//同上
@property(nonatomic,strong)NSString *sDateTime3;//同上
@property(nonatomic,strong)NSString *eDateTime3;//同上
@property(nonatomic,strong)NSString *sDateTime4;//同上
@property(nonatomic,strong)NSString *eDateTime4;//同上

//更新一条请假条记录
@property(nonatomic,strong)NSString *tabId;//请假记录Id
//@property(nonatomic,strong)NSString *manId;//请假人的人员Id，学生ID或老师Id,非教宝号
//@property(nonatomic,strong)NSString *manName;//请假人姓名
//@property(nonatomic,strong)NSString *gradeStr;//年级名称
//@property(nonatomic,strong)NSString *classStr;//班级名称
//@property(nonatomic,strong)NSString *manType;//人员类型，0为学生，1为老师
//@property(nonatomic,strong)NSString *leaveType;//请假类型，如：补课，病假
//@property(nonatomic,strong)NSString *leaveReason;//请假理由

//给一个假条新增加一个时间段
//@property(nonatomic,strong)NSString *tabId;//请假记录Id
@property(nonatomic,strong)NSString *leaveId;//---添加时间
//@property(nonatomic,strong)NSString *UnitId;//单位Id
//@property(nonatomic,strong)NSString *sDateTime;//请假时间段开始时间
//@property(nonatomic,strong)NSString *eDateTime;//请假时间段结束时间

//更新假条的一个时间段
//@property(nonatomic,strong)NSString *tabId;//时间段记录Id
//@property(nonatomic,strong)NSString *sDateTime;//请假时间段开始时间
//@property(nonatomic,strong)NSString *eDateTime;//请假时间段结束时间


- (NSMutableDictionary *)propertiesDic;



@end
