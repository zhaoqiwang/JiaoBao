//
//  TreeView_Level1_Model.h
//  JiaoBao
//
//  Created by Zqw on 14-10-23.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TreeView_Level1_Model : NSObject{
    NSString *mStr_name;//名称
    int mInt_number;//未读消息条数
    NSString *mStr_img_open_close;//打开关闭按钮图片
    NSString *mStr_img_detail;//详情按钮图片
}

@property (strong,nonatomic) NSString *mStr_name;//名称
@property (strong,nonatomic) NSString *mStr_img_open_close;//打开关闭按钮图片
@property (strong,nonatomic) NSString *mStr_img_detail;//详情按钮图片
@property (assign,nonatomic) int mInt_number;//未读消息条数

@end
