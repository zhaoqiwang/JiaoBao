//
//  ExchangeUnitGroupsModel.h
//  JiaoBao
//  获取单位内所有分组
//  Created by Zqw on 14-12-2.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExchangeUnitGroupsModel : NSObject{
    NSString *GroupID;//唯一标示
    NSString *GroupName;//名称
    NSString *HideSign;//隐藏标识
    NSString *UnitID;//单位ID
}

@property (nonatomic,strong) NSString *GroupID;;
@property (nonatomic,strong) NSString *GroupName;
@property (nonatomic,strong) NSString *HideSign;
@property (nonatomic,strong) NSString *UnitID;

@end
//[{"GroupID":74,"GroupName":"总部支撑","HideSign":0,"UnitID":998},{"GroupID":0,"GroupName":"基本人员组","HideSign":0,"UnitID":998},{"GroupID":1,"GroupName":"单位领导组","HideSign":0,"UnitID":998}]