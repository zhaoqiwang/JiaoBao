//
//  UnitInfoModel.h
//  JiaoBao
//
//  Created by Zqw on 14-11-22.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnitInfoModel : NSObject{
    NSString *AccountID;//管理员账户ID
    NSString *ArtCount;//文章总数
    NSString *ArtUpdate;//今日更新
    NSString *CityCode;//区域代码
    NSString *EduParentID;//教育系统隶属ID
    NSString *ParentID;//上级单位ID
    NSString *ShortName;//单位简称
    NSString *State;//0禁用，1正常
    NSString *TabID;//加密ID
    NSString *TownShip;//乡镇
    NSString *UintName;//单位名称
    NSString *UnitCode;//单位系统代码
    NSString *UnitNo;//单位代码
    NSString *UnitType;//教育局1，学校2，班级
}

@property (nonatomic,strong) NSString *AccountID;
@property (nonatomic,strong) NSString *ArtCount;
@property (nonatomic,strong) NSString *ArtUpdate;
@property (nonatomic,strong) NSString *CityCode;
@property (nonatomic,strong) NSString *EduParentID;
@property (nonatomic,strong) NSString *ParentID;
@property (nonatomic,strong) NSString *ShortName;
@property (nonatomic,strong) NSString *State;
@property (nonatomic,strong) NSString *TabID;
@property (nonatomic,strong) NSString *TownShip;
@property (nonatomic,strong) NSString *UintName;
@property (nonatomic,strong) NSString *UnitCode;
@property (nonatomic,strong) NSString *UnitNo;
@property (nonatomic,strong) NSString *UnitType;

@end
//[{"AccountID":0,"ArtCount":513,"ArtUpdate":556,"CityCode":"370103","EduParentID":-1,"ParentID":"997","ShortName":null,"State":1,"TabID":998,"TownShip":null,"UintName":"金视野山东大区","UnitCode":null,"UnitNo":0,"UnitType":1}