//
//  SumLeavesModel.h
//  JiaoBao
//
//  Created by SongYanming on 16/3/28.
//  Copyright © 2016年 JSY. All rights reserved.
//学校班级 班级学生 教职工请假查询统计

#import <Foundation/Foundation.h>

@interface SumLeavesModel : NSObject
//共用参数
@property (nonatomic,strong) NSString *Amount;//补课假次数（教职工没有此参数）
@property (nonatomic,strong) NSString *Amount2;// 其他假次数
//学校班级
@property (nonatomic,strong) NSString *UnitClassId;//班级ID用来做为取该班学生的请假统计的输入参数。
@property (nonatomic,strong) NSString *ClassStr;//班级名称
@property (nonatomic,strong) NSString *GradeStr;//年级名称

//班级学生 或教职工
@property (nonatomic,strong) NSString *ManName;//姓名


@end
