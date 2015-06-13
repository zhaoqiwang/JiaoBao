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

@interface SecondRegViewController ()<MBProgressHUDDelegate>
{
    id  _observer1,_observer2,_observer3,_observer4;

}
@property(nonatomic,strong)MBProgressHUD *mProgressV;


@end

@implementation SecondRegViewController
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
    self.mProgressV = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:self.mProgressV];
    self.mProgressV.delegate = self;
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
   // 获取图片验证码的数据
    _observer1 = [[NSNotificationCenter defaultCenter]addObserverForName:@"urlImage" object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSData *imgData = note.object;
        UIImage *image = [UIImage imageWithData:imgData];
        self.urlImgV.image = image;
        
        
        
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
        NSString *str =note.object;
        if([str integerValue ] == 0)//成功则跳转到第三个界面
        {
            NSLog(@"验证成功");
            [self progressViewTishi:@"验证成功"];
            RegisterPassWViewController *pass = [[RegisterPassWViewController alloc]init];
            pass.mStr_phoneNum = self.tel;
            if(self.forgetPWSymbol ==YES)
            {
                pass.mInt_flag = 2;//表示是忘记密码界面

                
            }
            else
            {
                pass.mInt_flag = 1;//表示是注册界面

                
            }
            [self.navigationController pushViewController:pass animated:YES];
            
            
            
            
        }
        else
        {
            [self progressViewTishi:@"验证失败"];
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
        [self progressViewTishi:@"正在加载"];
        
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
        self.mProgressV.mode = MBProgressHUDModeCustomView;
        self.mProgressV.labelText = NETWORKENABLE;
        [self.mProgressV show:YES];
        [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
        return YES;
    }else{
        return NO;
    }
}

-(void)noMore{
    sleep(1);
}

-(void)progressViewTishi:(NSString *)title{
    self.mProgressV.labelText = title;
    self.mProgressV.mode = MBProgressHUDModeCustomView;
    [self.mProgressV show:YES];
    [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
}

-(void)ProgressViewLoad:(NSString *)title{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    self.mProgressV.mode = MBProgressHUDModeIndeterminate;
    self.mProgressV.labelText = title;
    [self.mProgressV show:YES];
    [self.mProgressV showWhileExecuting:@selector(Loading) onTarget:self withObject:nil animated:YES];
}

- (void)Loading {
    sleep(TIMEOUT);
    self.mProgressV.mode = MBProgressHUDModeCustomView;
    self.mProgressV.labelText = @"加载超时";
    sleep(2);
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
