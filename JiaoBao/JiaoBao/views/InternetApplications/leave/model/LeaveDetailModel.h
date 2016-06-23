//
//  LeaveDetailModel.h
//  JiaoBao
//
//  Created by SongYanming on 16/3/11.
//  Copyright © 2016年 JSY. All rights reserved.
//假条详情model

#import <Foundation/Foundation.h>

@interface LeaveDetailModel : NSObject
@property(nonatomic,strong)NSString *TabID;// 记录ID
@property(nonatomic,strong)NSString *ManName;//请假人姓名
@property(nonatomic,strong)NSString *ManId;//请假人的人员Id，学生ID或老师Id,非教宝号
@property(nonatomic,strong)NSString *ManType;//人员类型，0学生1老师
@property(nonatomic,strong)NSString *UnitClassId;//班级Id,学生请假须提供，老师请假可以为0
@property(nonatomic,strong)NSString *ClassStr;//班级名称
@property(nonatomic,strong)NSString *GradeStr;//年级名称
@property(nonatomic,strong)NSString *UnitId;//单位Id
@property(nonatomic,strong)NSString *WriterId;//发起人教宝号

@property(nonatomic,strong)NSString *Writer;////发起人姓名
@property(nonatomic,strong)NSString *WriteDate;//发起日期
@property(nonatomic,strong)NSString *LeaveType;//请假类型
@property(nonatomic,strong)NSString *LeaveReason;//理由
@property(nonatomic,strong)NSString *StatusStr; //状态
@property(nonatomic,strong)NSString *ApproveStatus;//一审状态 0等待中;//1通过;//2拒绝
@property(nonatomic,strong)NSString *Approve;//一审人姓名
@property(nonatomic,strong)NSString *ApproveDate;//一审日期
@property(nonatomic,strong)NSString *ApproveNote;//一审批注
@property(nonatomic,strong)NSString *ApproveStatus1;//二审状态
@property(nonatomic,strong)NSString *Approve1;//二审人姓名
@property(nonatomic,strong)NSString *ApproveDate1;//二审日期
@property(nonatomic,strong)NSString *ApproveNote1;//二审批注
@property(nonatomic,strong)NSString *ApproveStatus2;//三审状态
@property(nonatomic,strong)NSString *Approve2;//三审人姓名
@property(nonatomic,strong)NSString *ApproveDate2;//三审日期
@property(nonatomic,strong)NSString *ApproveNote2;//三审批注
@property(nonatomic,strong)NSString *ApproveStatus3;//四审状态
@property(nonatomic,strong)NSString *Approve3;//四审人姓名
@property(nonatomic,strong)NSString *ApproveDate3;//四审日期
@property(nonatomic,strong)NSString *ApproveNote3;//四审批注
@property(nonatomic,strong)NSString *ApproveStatus4;//五审状态
@property(nonatomic,strong)NSString *Approve4;//五审人姓名
@property(nonatomic,strong)NSString *ApproveDate4;//五审日期
@property(nonatomic,strong)NSString *ApproveNote4;//五审批注
@property(nonatomic,strong)NSMutableArray *TimeList;

@property(nonatomic,assign) int cellFlag;//cell当前的索引
@property(nonatomic,strong) NSString *level;//审核级别

-(void)dicToModel:(NSDictionary*)dic;//解析假条详情

@end
@interface TimeListModel:NSObject//门卫
@property(nonatomic,strong)NSString *TabID;//时间段记录ID
@property(nonatomic,strong)NSString *Sdate;//开始时间
@property(nonatomic,strong)NSString *Edate;//结束时间
@property(nonatomic,strong)NSString *LeaveTime;//离校时间
@property(nonatomic,strong)NSString *LWriterName;//门卫
@property(nonatomic,strong)NSString *ComeTime;//到校时间
@property(nonatomic,strong)NSString *CWriterName ;//门卫
-(void)dicToModel:(NSDictionary*)dic;//解析门卫假条详情


@end
