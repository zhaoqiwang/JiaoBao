//
//  TreeView_Level2_Model.h
//  JiaoBao
//
//  Created by Zqw on 14-10-23.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TreeView_Level2_Model : NSObject{
    NSString *mStr_name;//姓名
    NSString *mStr_headImg;//头像
    NSString *mStr_time;//时间
    NSString *mStr_img_detail;//详情
    NSString *mStr_TabIDStr;//当前行数据的ID
    NSString *mStr_JiaoBaoHao;//教宝号
    NSString *mStr_MsgTabIDStr;//点击回复我的信息时用
}

@property (strong,nonatomic) NSString *mStr_name;//姓名
@property (strong,nonatomic) NSString *mStr_headImg;//头像
@property (strong,nonatomic) NSString *mStr_time;//时间
@property (strong,nonatomic) NSString *mStr_img_detail;//详情
@property (strong,nonatomic) NSString *mStr_TabIDStr;//当前行数据的ID
@property (strong,nonatomic) NSString *mStr_JiaoBaoHao;//教宝号
@property (strong,nonatomic) NSString *mStr_MsgTabIDStr;//点击回复我的信息时用

@end
