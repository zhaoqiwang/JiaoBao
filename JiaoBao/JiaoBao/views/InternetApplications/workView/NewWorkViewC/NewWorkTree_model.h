//
//  NewWorkTree_model.h
//  JiaoBao
//
//  Created by Zqw on 15/4/29.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommMsgRevicerUnitListModel.h"
#import "UserListModel.h"
#import "groupselit_selitModel.h"

@interface NewWorkTree_model : NSObject{
    NSString *mStr_name;//名称
    NSString *mStr_img_open_close;//打开关闭按钮图片
    NSString *mStr_classID;//学校班级ID，获取班级所有文章
    myUnit *mModel_unit;//单位信息
    UserListModel *mModel_group;//分组
    groupselit_selitModel *mModel_people;//分组中的人员
}
@property (strong,nonatomic) NSString *mStr_name;//名称
@property (strong,nonatomic) NSString *mStr_img_open_close;//打开关闭按钮图片
@property (nonatomic,strong) NSString *mStr_classID;//学校班级ID，获取班级所有文章
@property (nonatomic,strong) myUnit *mModel_unit;//单位信息
@property (nonatomic,strong) UserListModel *mModel_group;//分组
@property (nonatomic,strong) groupselit_selitModel *mModel_people;//分组中的人员

@end
