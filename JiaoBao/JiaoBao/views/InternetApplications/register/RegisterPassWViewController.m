//
//  RegisterPassWViewController.m
//  JiaoBao
//
//  Created by Zqw on 15/6/3.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "RegisterPassWViewController.h"
#import "Reachability.h"
#import "MobClick.h"

@interface RegisterPassWViewController ()

@end

@implementation RegisterPassWViewController
@synthesize mBtn_register,mLab_confirmPassWord,mLab_passWord,mTextF_confirmPassword,mTextF_password,mNav_navgationBar,mLab_tishi,mStr_phoneNum,mInt_flag;

-(void)dealloc
{
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:UMMESSAGE];
    [MobClick endLogPageView:UMPAGE];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
     [MobClick beginLogPageView:UMMESSAGE];
    [MobClick beginLogPageView:UMPAGE];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
    //发送注册请求
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"registerGetTime" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerGetTime:) name:@"registerGetTime" object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"registerPW" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(registerPW:) name:@"registerPW" object:nil];
}
-(void)registerPW:(id)sender
{
    [MBProgressHUD hideHUDForView:self.view];
    NSNotification *note = (NSNotification*)sender;
    NSDictionary *dic = note.object;
    NSArray *keyArr =[dic allKeys];
    NSString *str = [keyArr objectAtIndex:0];
    NSString *ResultDesc = [dic objectForKey:str];
    if(self.mInt_flag == 1)
    {
        if([str integerValue ] == 0)
        {
            NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
                [MBProgressHUD showText:@"注册成功" toView:self.view];
                [dm getInstance].RegisterSymbol = NO;
                sleep(2);
                
                
            }];
            
            NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
                [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
                
                
                
            }];
            [op2 addDependency:op1];
            NSOperationQueue *queue = [[NSOperationQueue alloc]init];
            [queue addOperation:op1];
            [queue addOperation:op2];
            
            
        }
        else
        {
            [MBProgressHUD showText:ResultDesc toView:self.view];

        }
        
    }
    
    else
    {
        if([str integerValue ] == 0)
        {
            NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
                [self progressViewTishi:@"重置密码成功"];
                [dm getInstance].RegisterSymbol = NO;
                
                sleep(2);
                
                
            }];
            
            NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
                [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
                
                
                
            }];
            [op2 addDependency:op1];
            [op2 addDependency:op1];
            NSOperationQueue *queue = [[NSOperationQueue alloc]init];
            [queue addOperation:op1];
            [queue addOperation:op2];
//            [self progressViewTishi:@"重置密码成功"];
//            [dm getInstance].RegisterSymbol = NO;
//            [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
            
            
        }
        else
        {
            [self progressViewTishi:@"重置密码失败"];
        }
        
    }

    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"输入密码"];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    //密码
    self.mLab_passWord.frame = CGRectMake(10, self.mNav_navgationBar.frame.size.height+20, self.mLab_passWord.frame.size.width, self.mLab_passWord.frame.size.height);
    self.mTextF_password.frame = CGRectMake(self.mLab_passWord.frame.origin.x+self.mLab_passWord.frame.size.width, self.mNav_navgationBar.frame.size.height+20, [dm getInstance].width-self.mLab_passWord.frame.origin.x-self.mLab_passWord.frame.size.width-30, self.mTextF_password.frame.size.height);
    //提示
    self.mLab_tishi.frame = CGRectMake(self.mTextF_password.frame.origin.x, self.mTextF_password.frame.origin.y+self.mTextF_password.frame.size.height, self.mLab_tishi.frame.size.width, self.mLab_tishi.frame.size.height);
    //确认密码
    self.mLab_confirmPassWord.frame = CGRectMake(10, self.mTextF_password.frame.origin.y+self.mTextF_password.frame.size.height+20, self.mLab_confirmPassWord.frame.size.width, self.mLab_confirmPassWord.frame.size.height);
    self.mTextF_confirmPassword.frame = CGRectMake(self.mTextF_password.frame.origin.x, self.mLab_confirmPassWord.frame.origin.y, self.mTextF_password.frame.size.width, self.mTextF_password.frame.size.height);
    //注册按钮
    self.mBtn_register.frame = CGRectMake(20, self.mTextF_confirmPassword.frame.origin.y+self.mTextF_confirmPassword.frame.size.height+20, [dm getInstance].width-40, self.mBtn_register.frame.size.height);
}

-(void)mBtn_register:(UIButton *)btn
{
        //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    if ([utils isBlankString:self.mTextF_password.text]||[utils isBlankString:self.mTextF_confirmPassword.text]) {
        [self progressViewTishi:@"请输入密码"];
        return;
    }
    if (self.mTextF_password.text.length<6||self.mTextF_password.text.length>18) {
        [self progressViewTishi:@"密码长度不正确"];
        return;
    }
    if (self.mTextF_confirmPassword.text.length<6||self.mTextF_confirmPassword.text.length>18) {
        [self progressViewTishi:@"确认密码长度不正确"];
        return;
    }
    //判断两次密码输入是否一致，一致，则发送注册协议
    if ([self.mTextF_confirmPassword.text isEqual:self.mTextF_password.text]) {
        D("哦了");
        if (self.mInt_flag == 1) {//注册时设置密码
            //获取当前时间
            [[LoginSendHttp getInstance] getTime:@"2"];
        }else if (self.mInt_flag == 2){//重置密码
            //生成登录的json字符串
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:self.mStr_phoneNum forKey:@"mobilenum"];
            [dic setValue:self.mTextF_password.text forKey:@"npw"];
            NSString *json = [dic JSONString];
            [[RegisterHttp getInstance] registerHttpResetAccPw:json iOS:@"true"];
        }
    }else{
        [self progressViewTishi:@"两次密码输入不一致"];
    }
}

//发送注册请求
-(void)registerGetTime:(NSNotification *)noti{
    NSString *time = noti.object;
        D("time-====%@",time);
    //生成登录的json字符串
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.mStr_phoneNum forKey:@"MobileNum"];
    [dic setValue:self.mTextF_password.text forKey:@"UserPW"];
    [dic setValue:time forKey:@"TimeStamp"];
    NSString *json = [dic JSONString];
    [[RegisterHttp getInstance] registerHttpRegAccId:CLIVER IAMSCID:[[NSUserDefaults standardUserDefaults]objectForKey:@"UUID"] regAccIdStr:json TimeStamp:time Sign:@"" ios:@"true"];
}

//用户注册                      客户端版本号              客户端ID               加密后的登录JSON对象字符串             当前时间（如：2013-12-09 00:37:09        数字签名，base64(MD5(Ver+regAccIdStr+ClientKey+TimeStamp))        true,ios应用
//-(void)registerHttpRegAccId:(NSString *)CliVer IAMSCID:(NSString *)IAMSCID regAccIdStr:(NSString *)regAccIdStr TimeStamp:(NSString *)TimeStamp Sign:(NSString *)Sign ios:(NSString *)ios

//检查当前网络是否可用
-(BOOL)checkNetWork{
    if([Reachability isEnableNetwork]==NO){
        [MBProgressHUD showError:NETWORKENABLE toView:self.view];
        return YES;
    }else{
        return NO;
    }
}

-(void)progressViewTishi:(NSString *)title{
    [MBProgressHUD showError:title toView:self.view];
}

-(void)ProgressViewLoad:(NSString *)title{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    [MBProgressHUD showMessage:title toView:self.view];
}

-(void)myNavigationGoback{
    [self.navigationController popViewControllerAnimated:YES];
}

//键盘点击DO
#pragma mark - UITextView Delegate Methods
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
