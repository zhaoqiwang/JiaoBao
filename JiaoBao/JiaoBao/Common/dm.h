//
//  dm.h
//  JiaoBao
//
//  Created by Zqw on 14-10-18.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"
#import "RongYunTokenModel.h"

@interface dm : NSObject{
    int width;//界面宽度
    int height;//界面高度
    NSString *url;//系统应用的URL
    int statusBar;//状态栏
    NSString *jiaoBaoHao;//教宝号,accid
    NSString *name;//自己的名字`
    NSString *TrueName;
    NSMutableArray *identity;//个人的班级或者学校信息
    NSString *unReadMsg1;//未读交流信息数量
    NSString *unReadMsg2;//未读回复信息数量
    int UID;//单位ID
    int uType;//用户身份ID,用户账号ID
    NSString *mStr_unit;//当前登录单位的名字
    NSString *mStr_tableID;//当前所在单位的加密ID
    UserInfoModel *userInfo;//个人信息
    int mImt_shareUnRead;//分享未读数量
    int mImt_showUnRead;//展示未读数量
    RongYunTokenModel *rongYunModel;//融云网络用户token
    NSMutableArray *mArr_rongYunUser;//融云所有用户
    NSMutableArray *mArr_rongYunGroup;//融云所有群组
    NSMutableArray *mArr_unit_member;//所在的所有单位，和单位里面分组、人员
    NSMutableArray *mArr_myFriends;//自己所有的好友分组、好友
    NSString *uuid;//启动时设置，注册成功后，添加到key中
    BOOL tableSymbol;
    
}

@property (nonatomic,assign) int width;//界面宽度
@property (nonatomic,assign) int height;//界面高度
@property (nonatomic,strong) NSString *url;//系统应用的URL
@property (nonatomic,assign) int statusBar;//状态栏
@property (nonatomic,strong) NSString *jiaoBaoHao;//教宝号
@property (nonatomic,strong) NSString *name;//自己的名字
@property (nonatomic,strong) NSString *TrueName;
@property (nonatomic,strong) NSMutableArray *identity;//个人的班级或者学校信息
@property (nonatomic,strong) NSString *unReadMsg1;//未读交流信息数量
@property (nonatomic,strong) NSString *unReadMsg2;//未读回复信息数量
@property (nonatomic,assign) int UID;//单位ID
@property (nonatomic,assign) int uType;//用户身份ID
@property (nonatomic,strong) NSString *mStr_unit;//当前登录单位的名字
@property (nonatomic,strong) NSString *mStr_tableID;//当前所在单位的加密ID
@property (nonatomic,strong) UserInfoModel *userInfo;//个人信息
@property (nonatomic,assign) int mImt_shareUnRead;//分享未读数量
@property (nonatomic,assign) int mImt_showUnRead;//展示未读数量
@property (nonatomic,strong) RongYunTokenModel *rongYunModel;//融云网络用户token
@property (nonatomic,strong) NSMutableArray *mArr_rongYunUser;//融云所有用户
@property (nonatomic,strong) NSMutableArray *mArr_rongYunGroup;//融云所有群组
@property (nonatomic,strong) NSMutableArray *mArr_unit_member;//所在的所有单位，和单位里面分组、人员
@property (nonatomic,strong) NSMutableArray *mArr_myFriends;//自己所有的好友分组、好友
@property (nonatomic,strong) NSString *uuid;//启动时设置，注册成功后，添加到key中
@property(nonatomic,assign)BOOL tableSymbol;
@property(nonatomic,strong)NSMutableSet *sectionSet;
@property(nonatomic,assign)NSUInteger notificationSymbol;


+ (dm*) getInstance;

@end
