//
//  TreeView_Level0_Model.h
//  JiaoBao
//
//  Created by Zqw on 14-10-23.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TreeView_Level0_Model : NSObject{
    NSString *mStr_name;//名称
    NSString *mStr_headImg;//头像
    int mInt_number;//未读消息条数
    NSString *mStr_img_open_close;//打开关闭按钮图片
    NSString *mStr_img_detail;//详情按钮图片
    int mInt_show;//是否显示详情按钮，1为显示
    NSString *mStr_classID;//学校班级ID，获取班级所有文章
}
@property (strong,nonatomic) NSString *mStr_name;//名称
@property (strong,nonatomic) NSString *mStr_headImg;//头像
@property (strong,nonatomic) NSString *mStr_img_open_close;//打开关闭按钮图片
@property (strong,nonatomic) NSString *mStr_img_detail;//详情按钮图片
@property (assign,nonatomic) int mInt_number;//未读消息条数
@property (assign,nonatomic) int mInt_show;//是否显示详情按钮，1为显示
@property (nonatomic,strong) NSString *mStr_classID;//学校班级ID，获取班级所有文章

@end
