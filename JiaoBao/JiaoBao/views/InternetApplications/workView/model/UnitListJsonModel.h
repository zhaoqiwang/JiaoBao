//
//  UnitListJsonModel.h
//  JiaoBao
//
//  Created by Zqw on 15-1-13.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
@class myUnitModel;
#import "UnitParentsModel.h"
#import "UnitClassModel.h"


@interface UnitListJsonModel : JSONModel

@property (nonatomic,assign) myUnitModel *myUnit;
@property (nonatomic,strong) NSArray<UnitParentsModel>* UnitParents;
@property (nonatomic,strong) NSArray<UnitParentsModel>* subUnits;
@property (nonatomic,strong) NSArray<UnitClassModel>* UnitClass;

@end

//{"myUnit":{"UintName":"测试教育局4","TabID":987,"TabIDStr":"MDQxNUM1MTI1OTE1NUM1OA","flag":1},"UnitParents":[{"UintName":"测试单位","TabID":1,"flag":2}],"subUnits":[{"UintName":"学校4","TabID":991,"flag":0}],"UnitClass":null}

//{"myUnit":{"UintName":"支撑学校","TabIDStr":"M0M5MzcyODA1NjQyQzg2Rg"},"UnitClass":[{"ClsName":"总部支撑","TabID":429,"flag":13}]}

@interface myUnitModel : JSONModel

@property (nonatomic,strong) NSString *UintName;
@property (nonatomic,assign) int TabID;
@property (nonatomic,strong) NSString *TabIDStr;
@property (nonatomic,assign) int flag;

@end
