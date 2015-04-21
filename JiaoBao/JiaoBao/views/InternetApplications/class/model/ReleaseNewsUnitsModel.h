//
//  ReleaseNewsUnitsModel.h
//  JiaoBao
//
//  Created by Zqw on 15-4-21.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReleaseNewsUnitsModel : NSObject{
    NSString *UnitId;
    NSString *UnitName;
    NSString *UnitType;//1=教育局，2学校，3班级
}

@property (nonatomic,strong) NSString *UnitId;
@property (nonatomic,strong) NSString *UnitName;
@property (nonatomic,strong) NSString *UnitType;

@end
//[{"UnitId":994,"UnitName":"战略发展部","UnitType":1},