//
//  HomeClassWorkView.h
//  JiaoBao
//
//  Created by Zqw on 15-4-23.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dm.h"

@interface HomeClassWorkView : UIView{
    UIScrollView *mScrollV_all;//放所有控件
    UIView *mView_top;//放列表的上部分控件
    UITextView *mTextV_input;//输入内容
    UIButton *mBtn_accessory;//附件按钮
    UIButton *mBtn_photos;//拍照按钮
    UIButton *mBtn_sendMsg;//是否发送短信
    UIButton *mBtn_send;//发送按钮
    NSMutableArray *mArr_accessory;//附件数组
    UIView *mView_accessory;//显示附件用
    
}

@property (nonatomic,strong) UIScrollView *mScrollV_all;//放所有控件
@property (nonatomic,strong) UIView *mView_top;//放列表的上部分控件
@property (nonatomic,strong) UITextView *mTextV_input;//输入内容
@property (nonatomic,strong) UIButton *mBtn_accessory;//附件按钮
@property (nonatomic,strong) UIButton *mBtn_photos;//拍照按钮
@property (nonatomic,strong) UIButton *mBtn_sendMsg;//是否发送短信
@property (nonatomic,strong) UIButton *mBtn_send;//发送按钮
@property (nonatomic,strong) NSMutableArray *mArr_accessory;//附件数组
@property (nonatomic,strong) UIView *mView_accessory;//显示附件用

- (id)initWithFrame1:(CGRect)frame;

@end
