//
//  LeaveDetailShowModel.h
//  JiaoBao
//  显示请假详情时，用到的model
//  Created by Zqw on 16/3/21.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LeaveDetailShowModel : NSObject

@property (nonatomic,assign) int mInt_flag;//区分是哪个cell，0请假人，1发起人，2发起时间，3理由，4开始结束时间，5，审核
@property (nonatomic,strong) NSString *mStr_name;//左边显示标题
@property (nonatomic,strong) NSString *mStr_value;//真实数据

@property (nonatomic,strong) NSString *mStr_startTime;//
@property (nonatomic,strong) NSString *mStr_startTimeValue;//
@property (nonatomic,strong) NSString *mStr_goTime;//
@property (nonatomic,strong) NSString *mStr_goTimeValue;//
@property (nonatomic,strong) NSString *mStr_door;//
@property (nonatomic,strong) NSString *mStr_doorValue;//
@property (nonatomic,strong) NSString *mStr_endTime;//
@property (nonatomic,strong) NSString *mStr_endTimeValue;//
@property (nonatomic,strong) NSString *mStr_comeTime;//
@property (nonatomic,strong) NSString *mStr_comeTimeValue;//
@property (nonatomic,strong) NSString *mStr_door2;//
@property (nonatomic,strong) NSString *mStr_door2Value;//

@property (nonatomic,strong) NSString *mStr_status;//审核状态,0等待中;//1通过;//2拒绝
@property (nonatomic,strong) NSString *mStr_node;//审核批注

@end
