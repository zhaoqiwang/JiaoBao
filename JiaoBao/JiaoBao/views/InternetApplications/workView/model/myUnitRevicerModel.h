//
//  myUnitRevicerModel.h
//  JiaoBao
//
//  Created by Zqw on 14-11-4.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myUnitRevicerModel : NSObject{
    NSString *UnitName;//单位名称
    NSString *TabIDStr;
    NSMutableArray *UserList;//单位分组人员
}

@property (nonatomic,strong) NSString *UnitName;//单位名称
@property (nonatomic,strong) NSString *TabIDStr;
@property (nonatomic,strong) NSMutableArray *UserList;//单位分组人员

@end
//{"parentUnitRevicer":[{"UnitName":"测试单位","TabIDStr":"NDNEQUNCNTRFNDNBQkNFNA","UserList":[]
