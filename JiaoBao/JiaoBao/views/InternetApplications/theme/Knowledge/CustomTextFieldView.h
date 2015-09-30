//
//  CustomTextFieldView.h
//  JiaoBao
//  自定义输入框
//  Created by Zqw on 15/9/8.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomTextFieldViewDelegate;

@interface CustomTextFieldView : UIView<UITextFieldDelegate>

@property (nonatomic,strong) UITextField *mTextF_input;//输入框
@property (nonatomic,strong) UIButton *mBtn_sure;//确定按钮
@property (weak,nonatomic) id<CustomTextFieldViewDelegate> delegate;


-(id)initFrame:(CGRect)rect;

@end

@protocol CustomTextFieldViewDelegate <NSObject>

@optional

//点击
-(void) CustomTextFieldViewSureBtn:(CustomTextFieldView *) view;

@end