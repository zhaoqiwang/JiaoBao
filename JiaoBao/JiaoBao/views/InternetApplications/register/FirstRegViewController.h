//
//  FirstRegViewController.h
//  JiaoBao
//
//  Created by songyanming on 15/6/3.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"

@interface FirstRegViewController : UIViewController<UITextFieldDelegate,MyNavigationDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tel;//手机号码输入框
@property (weak, nonatomic) IBOutlet UITextField *urlNumTF;//图片验证码输入框
@property (weak, nonatomic) IBOutlet UITextField *tel_identi_codeTF;//手机验证码输入框 现已隐藏
@property (weak, nonatomic) IBOutlet UIImageView *urlImgV;//加载数据流url图片的imgV
@property(nonatomic,strong)NSString *telStr;//用于判断重复输入电话号码是是否已改变
@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property(nonatomic,assign)BOOL forgetPWSymbol;//区别忘记密码和注册的标志

@property(nonatomic,assign)BOOL telSymbol,urlSymbol ,identi_code_Symbol;//手机号码是否正确的标志、图片验证码是否正确的标志、手机验证码是否正确的标志
- (IBAction)getIdentiCodeAction:(id)sender;//点击获取验证码的方法
- (IBAction)nextStepAction:(id)sender;//点击下一步的方法 现已隐藏
- (IBAction)getUrlImageAction:(id)sender;//点击图片获取图片验证码
@property (weak, nonatomic) IBOutlet UIButton *get_identi_code_btn;//获取手机验证码的button

@end
