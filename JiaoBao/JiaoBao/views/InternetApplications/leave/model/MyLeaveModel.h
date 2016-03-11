//
//  MyLeaveModel.h
//  JiaoBao
//
//  Created by SongYanming on 16/3/11.
//  Copyright © 2016年 JSY. All rights reserved.
//获得我提出申请的请假记录model

#import <Foundation/Foundation.h>

@interface MyLeaveModel : NSObject
@property(nonatomic,strong)NSString *TabID;//记录ID
@property(nonatomic,strong)NSString *WriteDate;//申请日期
@property(nonatomic,strong)NSString *LeaveType;//请假类型
@property(nonatomic,strong)NSString *StatusStr;//理由
@property(nonatomic,strong)NSString *RowCount;//记录总数
-(void)dicToModel:(NSDictionary*)dic;


@end
