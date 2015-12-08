//
//  GetUnitInfoModel.h
//  JiaoBao
////单位信息获取接口
//  Created by Zqw on 15/12/4.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetUnitInfoModel : NSObject

@property (nonatomic,strong) NSString *UnitID;//单位ID,惟一标识
@property (nonatomic,strong) NSString *UnitType;//用户类型,1教育局2学校
@property (nonatomic,strong) NSString *UnitName;//单位名称
@property (nonatomic,strong) NSString *ShortName;//单位简称
@property (nonatomic,strong) NSString *Area;//区域代码
@property (nonatomic,strong) NSString *SchoolType;//学校类型
@property (nonatomic,strong) NSString *TownShip;//乡镇
@property (nonatomic,strong) NSString *TabIDStr;//

@end
//{"UnitID":1070,"UnitType":2,"UnitName":"支撑学校","ShortName":"支撑","Area":"370000","SchoolType":"小学","TownShip":null,"TabIDStr":null},