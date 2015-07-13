//
//  SecondRegViewController.m
//  JiaoBao
//
//  Created by songyanming on 15/6/4.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "SecondRegViewController.h"
#import "LoginSendHttp.h"
#import "RegisterHttp.h"
#import "SVProgressHUD.h"
#import "RegisterPassWViewController.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "MobClick.h"

@interface SecondRegViewController ()<MBProgressHUDDelegate>
{
    id  _observer1,_observer2,_observer3,_observer4;

}


@end

@implementation SecondRegViewController
-(void)dealloc
{
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:UMMESSAGE];
    [MobClick endLogPageView:UMPAGE];

    //移除通知
    if(_observer1)
    {
        
        [[NSNotificationCenter defaultCenter] removeObserver:_observer1];
        
    }
    if(_observer2)
    {
        
        [[NSNotificationCenter defaultCenter] removeObserver:_observer2];
        
    }
    if(_observer3)
    {
        
        [[NSNotificationCenter defaultCenter] removeObserver:_observer3];
        
    }
    if(_observer4)
    {
        
        [[NSNotificationCenter defaultCenter] removeObserver:_observer4];
        
    }

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:UMMESSAGE];
    [MobClick beginLogPageView:UMPAGE];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBarHidden = YES;
    if(self.forgetPWSymbol == YES)
    {
        self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"忘记密码"];
        
        
    }
    else
    {
        self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"注册"];
        
        
    }    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];

    [self addNotification];
    if ([self checkNetWork]) {
        return;
    }
//获取图片验证码的请求
    [[RegisterHttp getInstance]registerHttpGetValidateCode];

    // Do any additional setup after loading the view from its nib.
}
-(void)addNotification
{
    __weak SecondRegViewController *weakSelf = self;

   // 获取图片验证码的数据
    _observer1 = [[NSNotificationCenter defaultCenter]addObserverForName:@"urlImage" object:nil queue:nil usingBlock:^(NSNotification *note) {
        if([note.object isKindOfClass:[NSString class]])
        {
            if([note.object isEqualToString:@"请求超时"])
            {
                [MBProgressHUD showText:@"请求超时" toView:self.view];
                return ;
            }
            
        }
        NSData *imgData = note.object;
        UIImage *image = [UIImage imageWithData:imgData];
        weakSelf.urlImgV.image = image;
        
        
        
    }];
//    //获取手机号码是否正确的数据
//    _observer2 = [[NSNotificationCenter defaultCenter]addObserverForName:@"tel" object:nil queue:nil usingBlock:^(NSNotification *note) {
//        NSString *str =note.object;
//        if([str isEqualToString:@"true"])//true表示手机号码已经被注册
//        {
//            self.telSymbol = YES;
//            
//            
//        }
//        else
//        {
//            [self progressViewTishi:@"手机号码已经被注册"];
//            self.telSymbol = NO;
//        }
//        
//        
//    }];
//    _observer3 = [[NSNotificationCenter defaultCenter]addObserverForName:@"get_identi_code" object:nil queue:nil usingBlock:^(NSNotification *note) {
//        
//        NSString *str =note.object;
//        if([str integerValue ] == 0)
//        {
//            self.identi_code_Symbol = YES;
//            NSLog(@"获取验证码成功");
//            
//        }
//        else
//        {
//            [self progressViewTishi:@"请获取手机验证码"];
//        }
//        
//        
//        
//    }];
    //获取验证验证码是否正确的数据
    _observer4 = [[NSNotificationCenter defaultCenter]addObserverForName:@"RegCheckMobileVcode" object:nil queue:nil usingBlock:^(NSNotification *note) {
        [MBProgressHUD hideHUDForView:self.view];

        NSDictionary *dic = note.object;
        NSArray *keyArr =[dic allKeys];
        NSString *str = [keyArr objectAtIndex:0];
        NSString *ResultDesc = [dic objectForKey:str];
        if([str integerValue ] == 0)//成功则跳转到第三个界面
        {
            [MBProgressHUD showSuccess:@"验证成功" toView:self.view];
            RegisterPassWViewController *pass = [[RegisterPassWViewController alloc]init];
            pass.mStr_phoneNum = weakSelf.tel;
            if(weakSelf.forgetPWSymbol ==YES)
            {
                pass.mInt_flag = 2;//表示是忘记密码界面

                
            }
            else
            {
                pass.mInt_flag = 1;//表示是注册界面

                
            }
            [weakSelf.navigationController pushViewController:pass animated:YES];
            
            
            
            
        }
        else
        {
            [MBProgressHUD showError:ResultDesc toView:self.view];

        }
        
        
        
    }];

    
}
//已经隐藏
- (IBAction)getIdentiCodeAction:(id)sender {
    
    if ([self checkNetWork]) {
        return;
    }


        [[LoginSendHttp getInstance] hands_login];
        
        [[RegisterHttp getInstance]registerHttpSendCheckCode:self.tel Code:self.urlNumStr];
    
    
}

- (IBAction)nextStepAction:(id)sender {
//    RegisterPassWViewController *pass = [[RegisterPassWViewController alloc]init];
//    pass.mStr_phoneNum = self.tel;
//    if(self.forgetPWSymbol ==YES)
//    {
//        pass.mInt_flag = 2;
//        
//        
//    }
//    else
//    {
//        pass.mInt_flag = 1;
//        
//        
//    }
//    [self.navigationController pushViewController:pass animated:YES];
    if([self.tel_identi_codeTF.text isEqualToString:@""])
    {
        [self progressViewTishi:@"请输入手机号码"];
        return;

        
    }
    if([self.urlNumTF.text isEqualToString:@""])
    {
        [self progressViewTishi:@"请输入图片验证码"];
        return;
        
    }
    if(self.forgetPWSymbol == YES)
    {
        if ([self checkNetWork]) {
            return;
        }
        //验证忘记密码的手机验证码及图片验证码和手机的请求

        [[RegisterHttp getInstance]registerHttpCheckMobileVcode:self.tel cCode:self.tel_identi_codeTF.text vCode:self.urlNumTF.text];
        
    }

    else

    {
        if ([self checkNetWork]) {
            return;
        }
        //验证注册的手机验证码及图片验证码和手机的请求
        [[RegisterHttp getInstance]registerHttpRegCheckMobileVcode:self.tel cCode:self.tel_identi_codeTF.text vCode:self.urlNumTF.text];
        [MBProgressHUD showMessage:@"正在加载" toView:self.view];
        
    }
    
}
//点击button获取图片验证码
- (IBAction)getUrlImageAction:(id)sender {
    if ([self checkNetWork]) {
        return;
    }
    //获取图片验证码的请求
    [[RegisterHttp getInstance]registerHttpGetValidateCode];
    
}


-(void)myNavigationGoback{
    [self.navigationController popToRootViewControllerAnimated:YES];
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

//键盘点击DO 回收键盘
#pragma mark - UITextView Delegate Methods
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        
        return NO;
    }
    return YES;
}
//点击view回收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
