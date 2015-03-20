//
//  Identity_UserUnits_model.h
//  JiaoBao
//
//  Created by Zqw on 14-10-24.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Identity_UserUnits_model : NSObject{
    NSString *UnitID;//单位ID
    NSString *UnitType;//单位类型
    NSString *UnitName;//单位名称
    NSString *ShortName;//
    NSString *Area;//
    NSString *SchoolType;//
    NSString *TownShip;//
    NSString *TabIDStr;//单位加密ID
}
@property (strong,nonatomic) NSString *UnitID;
@property (strong,nonatomic) NSString *UnitType;
@property (strong,nonatomic) NSString *UnitName;
@property (strong,nonatomic) NSString *ShortName;
@property (strong,nonatomic) NSString *Area;
@property (strong,nonatomic) NSString *SchoolType;
@property (strong,nonatomic) NSString *TownShip;
@property (strong,nonatomic) NSString *TabIDStr;

@end
