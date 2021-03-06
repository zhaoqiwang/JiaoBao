//
//  RegisterViewController.m
//  JiaoBao
//
//  Created by Zqw on 14-10-18.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "RegisterViewController.h"
#import "Reachability.h"
#import "FirstRegViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController
@synthesize mImgV_bg,mTextF_passwd,mTextF_userName,mImgV_select,mBtn_login,mView_view,mBtn_memberPassWD,mBtn_register,mBtn_forgetPW;


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
}

- (void)viewDidLoad {
    [LoginSendHttp getInstance].delegate = self;
    
    self.view.backgroundColor = [UIColor colorWithRed:3/255.0 green:76/255.0 blue:173/255.0 alpha:1];
    //背景图
    self.mImgV_bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Regiser_bg-568h"]];
    self.mImgV_bg.frame = CGRectMake(0, 0, [dm getInstance].width, [dm getInstance].height);
    self.mImgV_bg.userInteractionEnabled = YES;
    [self.view addSubview:self.mImgV_bg];
    
    //添加单击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressTap:)];
    tap.delegate = self;//设置代理，防止手势和按钮的点击事件冲突
    [self.mImgV_bg addGestureRecognizer:tap];
    
    self.mView_view = [[UIView alloc] initWithFrame:CGRectMake(0, 200, [dm getInstance].width, 300)];
    self.mView_view.backgroundColor = [UIColor clearColor];
    self.mView_view.userInteractionEnabled = YES;
    [self.view addSubview:self.mView_view];
    //添加单击手势
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressTap:)];
    tap2.delegate = self;//设置代理，防止手势和按钮的点击事件冲突
    [self.mView_view addGestureRecognizer:tap2];
    
    UIImage *image0 = [UIImage imageNamed:@"Regiser_jiaobao"];
    UIImageView *tempV_jiaobao = [[UIImageView alloc] initWithFrame:CGRectMake(([dm getInstance].width-image0.size.width)/2, 0, image0.size.width, image0.size.height)];
    tempV_jiaobao.backgroundColor = [UIColor clearColor];
    tempV_jiaobao.image = image0;
    [self.mView_view addSubview:tempV_jiaobao];
    
    UIImage *image1 = [UIImage imageNamed:@"Regiser_userName"];
    UIView *tempView1= [[UIView alloc] initWithFrame:CGRectMake(([dm getInstance].width-image1.size.width)/2, tempV_jiaobao.frame.size.height, image1.size.width, image1.size.height)];
    [tempView1 setBackgroundColor:[UIColor colorWithPatternImage:image1]];
    [self.mView_view addSubview:tempView1];
    //两个输入框
    self.mTextF_userName = [[UITextField alloc] initWithFrame:CGRectMake(30, 0, image1.size.width-30, image1.size.height)];
    self.mTextF_userName.delegate = self;
    self.mTextF_userName.font = [UIFont systemFontOfSize:12];
    self.mTextF_userName.textAlignment = NSTextAlignmentLeft;
    self.mTextF_userName.borderStyle=UITextBorderStyleNone;
    self.mTextF_userName.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"];
    self.mTextF_userName.delegate = self;
    self.mTextF_userName.returnKeyType = UIReturnKeyDone;//return键的类型
    [tempView1 addSubview:self.mTextF_userName];
    
    UIImage *image2 = [UIImage imageNamed:@"Regiser_passwd"];
    UIView *tempView2= [[UIView alloc] initWithFrame:CGRectMake(([dm getInstance].width-image2.size.width)/2, tempView1.frame.origin.y+tempView1.frame.size.height, image2.size.width, image2.size.height)];
    [self.mView_view addSubview:tempView2];
    [tempView2 setBackgroundColor:[UIColor colorWithPatternImage:image2]];
    [self.mView_view addSubview:tempView2];
    self.mTextF_passwd = [[UITextField alloc] initWithFrame:CGRectMake(30, 0, image2.size.width-30, image2.size.height)];
    self.mTextF_passwd.delegate = self;
    self.mTextF_passwd.font = [UIFont systemFontOfSize:12];
    self.mTextF_passwd.textAlignment = NSTextAlignmentLeft;
    [self.mTextF_passwd setSecureTextEntry:YES];
//    self.mTextF_passwd.keyboardType = UIKeyboardTypeNumberPad;
    self.mTextF_passwd.delegate = self;
    self.mTextF_passwd.returnKeyType = UIReturnKeyDone;//return键的类型
    self.mTextF_passwd.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"PassWD"];
    self.mTextF_passwd.borderStyle=UITextBorderStyleNone;
    [tempView2 addSubview:self.mTextF_passwd];
    
    //记住密码按钮
    NSString *memberPassWD = [[NSUserDefaults standardUserDefaults] valueForKey:@"rememberPassWD"];
    if (memberPassWD.length==0) {
        flag = 1;
    } else {
        flag = [memberPassWD intValue];
    }
    NSString *str_pic = [NSString stringWithFormat:@"Regiser_passwd_%d",flag];
    UIImage *image3 = [UIImage imageNamed:str_pic];
    self.mBtn_memberPassWD = [UIButton buttonWithType:UIButtonTypeCustom];
    self.mBtn_memberPassWD.frame = CGRectMake(tempView2.frame.origin.x, tempView2.frame.origin.y+tempView2.frame.size.height, image3.size.width, image3.size.height);
    [self.mBtn_memberPassWD setImage:image3 forState:UIControlStateNormal];
    [self.mBtn_memberPassWD addTarget:self action:@selector(memberPasswd:) forControlEvents:UIControlEventTouchDown];
//    [self.mView_view addSubview:self.mBtn_memberPassWD];
    
    //注册按钮
    self.mBtn_register = [UIButton buttonWithType:UIButtonTypeCustom];
    self.mBtn_register.frame = CGRectMake([dm getInstance].width-60, [dm getInstance].height-40, 50, 30);
    [self.mBtn_register setTitle:@"注册" forState:UIControlStateNormal];
    self.mBtn_register.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.mBtn_register addTarget:self action:@selector(registerPhoneNum:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.mBtn_register];
    
    //忘记密码按钮
    self.mBtn_forgetPW = [UIButton buttonWithType:UIButtonTypeCustom];
    self.mBtn_forgetPW.frame = CGRectMake(20, [dm getInstance].height-40, 50, 30);
    [self.mBtn_forgetPW setTitle:@"忘记密码" forState:UIControlStateNormal];
    self.mBtn_forgetPW.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.mBtn_forgetPW addTarget:self action:@selector(forgetPW:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.mBtn_forgetPW];
    
    //登陆按钮
    UIImage *image4 = [UIImage imageNamed:@"Regiser_login"];
    self.mBtn_login = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.mBtn_login setImage:image4 forState:UIControlStateNormal];
    self.mBtn_login.frame = CGRectMake(tempView2.frame.origin.x, self.mBtn_memberPassWD.frame.origin.y+self.mBtn_memberPassWD.frame.size.height, image4.size.width, image4.size.height);
    [self.mBtn_login addTarget:self action:@selector(clickLogin:) forControlEvents:UIControlEventTouchDown];
    [self.mView_view addSubview:self.mBtn_login];
    
    //键盘事件
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
    
    //通知界面，是否登录成功
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loginSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:@"loginSuccess" object:nil];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

//检查当前网络是否可用
-(BOOL)checkNetWork{
    if([Reachability isEnableNetwork]==NO){
        [MBProgressHUD showError:NETWORKENABLE toView:self.view];
        return YES;
    }else{
        return NO;
    }
}

//通知界面，是否登录成功
-(void)loginSuccess:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSString *str = noti.object;
    D("loginSuccess-== %@",str);
    [MBProgressHUD showSuccess:str toView:self.view];
}

-(void)myTask{
    sleep(1);
}

//点击记住密码按钮
-(void)memberPasswd:(id)sender{
    D("点击记住密码");
    if (flag == 1) {
        flag = 2;
    }else{
        flag = 1;
    }
    NSString *str_pic = [NSString stringWithFormat:@"Regiser_passwd_%d",flag];
    [self.mBtn_memberPassWD setImage:[UIImage imageNamed:str_pic] forState:UIControlStateNormal];
}

//注册
-(void)registerPhoneNum:(UIButton *)btn{
    FirstRegViewController *firstReg = [[FirstRegViewController alloc]init];
    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:firstReg];
    firstReg.forgetPWSymbol = NO;

    [self presentViewController:navC animated:YES completion:nil];
    D("点击注册按钮");
}

//忘记密码按钮
-(void)forgetPW:(UIButton *)btn{
    D("点击忘记密码按钮");
    FirstRegViewController *firstReg = [[FirstRegViewController alloc]init];
    firstReg.forgetPWSymbol = YES;
    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:firstReg];
    [self presentViewController:navC animated:YES completion:nil];
}

//点击登录按钮
-(void)clickLogin:(id)sender{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    D("点击登录按钮");
    if ([utils isBlankString:self.mTextF_passwd.text]||[utils isBlankString:self.mTextF_userName.text]) {
        [MBProgressHUD showError:@"请输入账号或密码" toView:self.view];
        return;
    }
    [[NSUserDefaults standardUserDefaults] setValue:self.mTextF_userName.text forKey:@"UserName"];
    [LoginSendHttp getInstance].mStr_userName = self.mTextF_userName.text;
    [LoginSendHttp getInstance].mStr_passwd = self.mTextF_passwd.text;
    //先获取时间,然后握手,登录
    [[LoginSendHttp getInstance] hands_login];
    [MBProgressHUD showMessage:@"登录中..." toView:self.view];
}
- (void) keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    self.mImgV_bg.frame = CGRectMake(0, 0, [dm getInstance].width, [dm getInstance].height-keyboardSize.height);
    self.mView_view.frame = CGRectMake(0, 80, [dm getInstance].width, 300);
}
- (void) keyboardWasHidden:(NSNotification *) notif
{
//    NSDictionary *info = [notif userInfo];
//    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
//    CGSize keyboardSize = [value CGRectValue].size;
    self.mImgV_bg.frame = CGRectMake(0, 0, [dm getInstance].width, [dm getInstance].height);
    self.mView_view.frame = CGRectMake(0, 200, [dm getInstance].width, 300);
}
-(void)pressTap:(UITapGestureRecognizer *)tap{
    [self.mTextF_userName resignFirstResponder];
    [self.mTextF_passwd resignFirstResponder];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    D("开始编辑");
}
//通知界面刷新
-(void)LoginSendHttpMember:(NSString *)str{
    D("str-===  %@",str);
    if (flag == 2&&[str isEqual:@"1"]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:@"rememberPassWD"];
        [[NSUserDefaults standardUserDefaults] setValue:self.mTextF_passwd.text forKey:@"PassWD"];
    } else {
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"rememberPassWD"];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"PassWD"];
    }
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
