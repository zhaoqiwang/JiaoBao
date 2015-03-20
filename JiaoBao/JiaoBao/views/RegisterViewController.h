//
//  RegisterViewController.h
//  JiaoBao
//  登陆页面
//  Created by Zqw on 14-10-18.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dm.h"
#import "LoginSendHttp.h"
#import "MBProgressHUD.h"


@interface RegisterViewController : UIViewController<UITextFieldDelegate,UIGestureRecognizerDelegate,ASIHTTPRequestDelegate,LoginSendHttpDelegate,MBProgressHUDDelegate>{
    UIImageView *mImgV_bg;//填充背景
    UITextField *mTextF_userName;//用户名
    UITextField *mTextF_passwd;//密码
    UIImageView *mImgV_select;//判断是否选中记住密码
    UIButton *mBtn_login;//登陆按钮
    UIView *mView_view;//放需要变坐标的控件
    UIButton *mBtn_memberPassWD;//记住密码按钮
    int flag;//记住密码标记,1是未记住，2是记住
    MBProgressHUD *mProgressV;//
}

@property (strong,nonatomic) UIImageView *mImgV_bg;//填充背景
@property (strong,nonatomic) UITextField *mTextF_userName;//用户名
@property (strong,nonatomic) UITextField *mTextF_passwd;//密码
@property (strong,nonatomic) UIImageView *mImgV_select;//判断是否选中记住密码
@property (strong,nonatomic) UIButton *mBtn_login;//登陆按钮
@property (strong,nonatomic) UIView *mView_view;//放需要变坐标的控件
@property (strong,nonatomic) UIButton *mBtn_memberPassWD;//记住密码按钮
@property (nonatomic,strong) MBProgressHUD *mProgressV;//

@end
