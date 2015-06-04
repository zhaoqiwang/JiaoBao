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
-(void)viewDidDisappear:(BOOL)animated
{
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
    self.mProgressV = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:self.mProgressV];
    self.mProgressV.delegate = self;
    self.navigationController.navigationBarHidden = YES;
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"注册"];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];

    [self addNotification];

    [[RegisterHttp getInstance]registerHttpGetValidateCode];

    // Do any additional setup after loading the view from its nib.
}
-(void)addNotification
{
    _observer1 = [[NSNotificationCenter defaultCenter]addObserverForName:@"urlImage" object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSData *imgData = note.object;
        UIImage *image = [UIImage imageWithData:imgData];
        self.urlImgV.image = image;
        
        
        
    }];
    _observer2 = [[NSNotificationCenter defaultCenter]addObserverForName:@"tel" object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *str =note.object;
        if([str isEqualToString:@"true"])
        {
            self.telSymbol = YES;
            
            
        }
        else
        {
            [self progressViewTishi:@"手机号码已经被注册"];
            self.telSymbol = NO;
        }
        
        
    }];
    _observer3 = [[NSNotificationCenter defaultCenter]addObserverForName:@"get_identi_code" object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        NSString *str =note.object;
        if([str integerValue ] == 0)
        {
            self.identi_code_Symbol = YES;
            NSLog(@"获取验证码成功");
            
        }
        else
        {
            [self progressViewTishi:@"请获取手机验证码"];
        }
        
        
        
    }];
    
    _observer4 = [[NSNotificationCenter defaultCenter]addObserverForName:@"RegCheckMobileVcode" object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *str =note.object;
        if([str integerValue ] == 0)
        {
            NSLog(@"验证成功");
            [SVProgressHUD dismiss];
            RegisterPassWViewController *pass = [[RegisterPassWViewController alloc]init];
            pass.mStr_phoneNum = self.tel;
            [self.navigationController pushViewController:pass animated:YES];
            
            
            
            
        }
        else
        {
            [self progressViewTishi:@"验证失败"];
        }
        
        
        
    }];

    
}

- (IBAction)getIdentiCodeAction:(id)sender {


        [[LoginSendHttp getInstance] hands_login];
        
        [[RegisterHttp getInstance]registerHttpSendCheckCode:self.tel Code:self.urlNumStr];
    
    
}

- (IBAction)nextStepAction:(id)sender {
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

    
    [[RegisterHttp getInstance]registerHttpRegCheckMobileVcode:self.tel cCode:self.tel_identi_codeTF.text vCode:self.urlNumTF.text];
    [SVProgressHUD show];
        
    
    
    
}

- (IBAction)getUrlImageAction:(id)sender {
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

//键盘点击DO
#pragma mark - UITextView Delegate Methods
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        
        return NO;
    }
    return YES;
}
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
