//
//  ClassLeavesModel.h
//  JiaoBao
//
//  Created by SongYanming on 16/3/14.
//  Copyright © 2016年 JSY. All rights reserved.
//班主任或审核人员取得请假记录model或门卫取请假记录model

#import <Foundation/Foundation.h>

@interface ClassLeavesModel : NSObject
@property (nonatomic,strong) NSString *TabID;//假条记录ID
@property (nonatomic,strong) NSString *ManName;//请假人姓名
@property (nonatomic,strong) NSString *WriteDate;//发起日期
@property (nonatomic,strong) NSString *LeaveType;//请假类型
@property (nonatomic,strong) NSString *StatusStr;//状态
@property (nonatomic,strong) NSString *RowCount;// 记录数量


@property (nonatomic,strong) NSString *Sdate;//请假开始时间
@property (nonatomic,strong) NSString *Edate;//请假结束时间
@property (nonatomic,strong) NSString *LWriterName;//离校登记人（门卫）
@property (nonatomic,strong) NSString *LeaveTime;//离校时间
@property (nonatomic,strong) NSString *CWriterName;//返校登记人(门卫）
@property (nonatomic,strong) NSString *ComeTime;//返校时间



-(void)dicToModel:(NSDictionary*)dic;
-(void)dicToGateModel:(NSDictionary*)dic;


@end
