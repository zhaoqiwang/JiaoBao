//
//  leaveRecordModel.h
//  JiaoBao
//
//  Created by SongYanming on 16/3/11.
//  Copyright © 2016年 JSY. All rights reserved.
//获得我提出申请的请假记录（请求参数model）

#import <Foundation/Foundation.h>

@interface leaveRecordModel : NSObject
@property(nonatomic,strong)NSString *numPerPage;//取回的记录数量，默认20
@property(nonatomic,strong)NSString *pageNum;//第几页，默认为1
@property(nonatomic,strong)NSString *RowCount;//pageNum=1为0，第二页起从前一页的返回结果中获得
@property(nonatomic,strong)NSString *accId;//用户教宝号
@property(nonatomic,strong)NSString *sDateTime;//按月查记录，月内任何一天都可以，这是申请日期，不是请假日期。
@property(nonatomic,strong)NSString *mName;//请假人姓名
@property(nonatomic,strong)NSString *manType;//人员类型，0学生1老师
- (NSMutableDictionary *)propertiesDic;



@end