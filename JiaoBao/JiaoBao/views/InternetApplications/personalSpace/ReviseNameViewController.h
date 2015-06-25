//
//  ReviseNameViewController.h
//  JiaoBao
//
//  Created by 赵启旺 on 15/6/4.
//  Copyright (c) 2015年 JSY. All rights reserved.
//修改昵称或修改密码的VC

#import <UIKit/UIKit.h>
#import "dm.h"
#import "utils.h"
#import "MWPhotoBrowser.h"
#import "MyNavigationBar.h"
#import "define_constant.h"
#import "LoginSendHttp.h"
#import "JSONKit.h"
#import "RegisterHttp.h"

@interface ReviseNameViewController : UIViewController<MyNavigationDelegate,UITextFieldDelegate,MBProgressHUDDelegate>{
    MyNavigationBar *mNav_navgationBar;//导航条
    UILabel *mLab_nickName;//昵称
    UITextField *mTextF_nickName;
    UILabel *mLab_trueName;//真实名字
    UITextField *mTextF_trueName;
    UIButton *mBtn_sure;//确定按钮
    int mInt_flag;//1是修改昵称，2是修改密码
}

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) IBOutlet UILabel *mLab_nickName;//
@property (nonatomic,strong) IBOutlet UITextField *mTextF_nickName;
@property (nonatomic,strong) IBOutlet UILabel *mLab_trueName;//
@property (nonatomic,strong) IBOutlet UITextField *mTextF_trueName;
@property (nonatomic,strong) IBOutlet UIButton *mBtn_sure;//
@property (nonatomic,assign) int mInt_flag;//1是修改昵称，2是修改密码

//确定按钮
-(IBAction)mBtn_sure:(UIButton *)btn;

@end
