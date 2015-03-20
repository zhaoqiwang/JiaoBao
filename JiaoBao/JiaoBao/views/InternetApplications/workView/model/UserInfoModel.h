//
//  UserInfoModel.h
//  JiaoBao
//
//  Created by Zqw on 14-11-13.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject{
    NSString *UserID;//用户id
    NSString *UserType;//用户类型
    NSString *UserName;//用户名
    NSString *UnitID;//用户所属单位id
    NSString *isAdmin;//是否管理员，0不是，1是单位管理员，2班主任，3单位管理员和班主任
}
@property (nonatomic,strong) NSString *UserID;//用户id
@property (nonatomic,strong) NSString *UserType;//用户类型
@property (nonatomic,strong) NSString *UserName;//用户名
@property (nonatomic,strong) NSString *UnitID;//用户所属单位id
@property (nonatomic,strong) NSString *isAdmin;//是否管理员

@end
//{"UserID":1511,"UserType":1,"UserName":"LM","UnitID":983,"isAdmin":0}