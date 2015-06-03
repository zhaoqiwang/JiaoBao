//
//  RegisterPassWViewController.h
//  JiaoBao
//
//  Created by Zqw on 15/6/3.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dm.h"
#import "utils.h"
#import "MWPhotoBrowser.h"
#import "MyNavigationBar.h"
#import "define_constant.h"
#import "LoginSendHttp.h"
#import "JSONKit.h"
#import "RegisterHttp.h"

@interface RegisterPassWViewController : UIViewController<MyNavigationDelegate,UITextFieldDelegate,MBProgressHUDDelegate>{
    MyNavigationBar *mNav_navgationBar;//导航条
    UILabel *mLab_passWord;//密码
    UITextField *mTextF_password;//密码
    UILabel *mLab_confirmPassWord;//确认密码
    UITextField *mTextF_confirmPassword;//确认密码
    UIButton *mBtn_register;//
    UILabel *mLab_tishi;//密码提示
    MBProgressHUD *mProgressV;//
    NSString *mStr_phoneNum;//从上个界面来的电话号码
}

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) IBOutlet UILabel *mLab_passWord;//
@property (nonatomic,strong) IBOutlet UITextField *mTextF_password;
@property (nonatomic,strong) IBOutlet UILabel *mLab_confirmPassWord;//
@property (nonatomic,strong) IBOutlet UITextField *mTextF_confirmPassword;
@property (nonatomic,strong) IBOutlet UIButton *mBtn_register;//
@property (nonatomic,strong) IBOutlet UILabel *mLab_tishi;
@property (nonatomic,strong) MBProgressHUD *mProgressV;//
@property (nonatomic,strong) NSString *mStr_phoneNum;//从上个界面来的电话号码

//点击注册按钮
-(IBAction)mBtn_register:(UIButton *)btn;

@end
