//
//  UserInfoByUnitIDModel.h
//  JiaoBao
//  获取单位内所有用户
//  Created by Zqw on 14-12-3.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoByUnitIDModel : NSObject{
    NSString *isAdmin;//是否管理员
    NSString *UserID;//用户ID
    NSString *UserName;//用户姓名
    NSString *AccID;//账户ID
    NSMutableArray *GroupFlag;//分组，多个以英文，分开
}

@property (nonatomic,strong) NSString *isAdmin;
@property (nonatomic,strong) NSString *UserID;
@property (nonatomic,strong) NSString *UserName;
@property (nonatomic,strong) NSString *AccID;
@property (nonatomic,strong) NSMutableArray *GroupFlag;

@end
//[{"isAdmin":1,"UserID":20,"UserName":"马文彬","AccID":5150028,"GroupFlag":"1"},{"isAdmin":0,"UserID":21,"UserName":"张叶青","AccID":5150030,"GroupFlag":"43"}