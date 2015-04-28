//
//  CommMsgRevicerUnitListModel.h
//  JiaoBao
//
//  Created by Zqw on 15-1-10.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
@class myUnit;

@interface CommMsgRevicerUnitListModel : NSObject{
    myUnit *myUnit;
    NSMutableArray *UnitParents;
    NSMutableArray *subUnits;
    NSMutableArray *UnitClass;
}

@property (nonatomic,strong) myUnit *myUnit;
@property (nonatomic,strong) NSMutableArray *UnitParents;
@property (nonatomic,strong) NSMutableArray *subUnits;
@property (nonatomic,strong) NSMutableArray *UnitClass;

@end
//{"myUnit":{"UintName":"测试教育局4","TabID":987,"TabIDStr":"MDQxNUM1MTI1OTE1NUM1OA","flag":1},"UnitParents":[{"UintName":"测试单位","TabID":1,"flag":2}],"subUnits":[{"UintName":"学校4","TabID":991,"flag":0}],"UnitClass":null}

//{"myUnit":{"UintName":"支撑学校","TabIDStr":"M0M5MzcyODA1NjQyQzg2Rg"},"UnitClass":[{"ClsName":"总部支撑","TabID":429,"flag":13}]}

 //当前所在单位
@interface myUnit : NSObject{
    NSString *UintName; //当前用户所在单位名称
    NSString *TabID;//当前用户所在单位ID，取本单位接收人用到
    NSString *TabIDStr; //当前用户所在单位ID加密，提交信息时用到
    NSString *flag;  //取本单位接收人用到
    NSMutableArray *list;
}

@property (nonatomic,strong) NSString *UintName;
@property (nonatomic,strong) NSString *TabID;
@property (nonatomic,strong) NSString *TabIDStr;
@property (nonatomic,strong) NSString *flag;
@property (nonatomic,strong) NSMutableArray *list;
@property(nonatomic,assign)BOOL isSelected;


@end

//上级单位数组可能有多个
@interface UnitParents : NSObject{
    NSMutableArray *UnitParents_array;
}

@property (nonatomic,strong) NSMutableArray *UnitParents_array;

@end

 //下级单位数组可能有多个
@interface subUnits : NSObject{
    NSMutableArray *subUnits_array;
}

@property (nonatomic,strong) NSMutableArray *subUnits_array;

@end

//班级数组，我所执教的班级
@interface UnitClass : NSObject{ //[{"ClsName":"总部支撑","TabID":429,"flag":13}
    NSMutableArray *UnitClass_array;
}

@property (nonatomic,strong) NSMutableArray *UnitClass_array;

@end

