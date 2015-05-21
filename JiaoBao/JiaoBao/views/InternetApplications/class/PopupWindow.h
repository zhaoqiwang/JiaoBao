//
//  PopupWindow.h
//  JiaoBao
//  点赞和评论的弹出框
//  Created by Zqw on 15/5/20.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopupWindowDelegate;

@interface PopupWindow : UIView{
    UIButton *mBtn_like;//点赞按钮
    UIButton *mBtn_comment;//评论按钮
    id<PopupWindowDelegate> delegate;
}

@property (nonatomic,strong) UIButton *mBtn_like;//点赞按钮
@property (nonatomic,strong) UIButton *mBtn_comment;//评论按钮
@property (strong,nonatomic) id<PopupWindowDelegate> delegate;

@end

//点击按钮时的回调方法
@protocol PopupWindowDelegate <NSObject>

- (void) PopupWindowClickBtn:(PopupWindow *) PopupWindow Button:(UIButton *)btn;

@end