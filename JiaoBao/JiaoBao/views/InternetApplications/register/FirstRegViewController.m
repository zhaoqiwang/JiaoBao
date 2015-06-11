//
//  FirstRegViewController.m
//  JiaoBao
//
//  Created by songyanming on 15/6/3.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "FirstRegViewController.h"
#import "SVProgressHUD.h"
#import "RegisterHttp.h"
#import "SecondRegViewController.h"
#import "MBProgressHUD.h"
#import "Reachability.h"

@interface FirstRegViewController ()<MBProgressHUDDelegate>
{
    id  _observer1,_observer2,_observer3,_observer4;
    NSInteger timeNum;//倒计时计时器的时间参数
}
@property(nonatomic,strong)NSTimer *myTimer;//倒计时计时器
@property(nonatomic,strong)MBProgressHUD *mProgressV;

@end

@implementation FirstRegViewController

-(void)viewWillDisappear:(BOOL)animated{
    [dm getInstance].RegisterSymbol = NO;
    
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
    //加通知
    [self addNotification];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
    timeNum = 60;
    [dm getInstance].RegisterSymbol = YES;


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

        
    }
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    

    if ([self checkNetWork]) {
        return;
    }
    [[RegisterHttp getInstance]registerHttpGetValidateCode];


    // Do any additional setup after loading the view from its nib.
}
-(void)addNotification
{
    //获取图片验证码d的图片
    _observer1 = [[NSNotificationCenter defaultCenter]addObserverForName:@"urlImage" object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSData *imgData = note.object;
        UIImage *image = [UIImage imageWithData:imgData];
        self.urlImgV.image = image;
        
        
        
    }];
    //获取手机是否已经注册的参数
    _observer2 = [[NSNotificationCenter defaultCenter]addObserverForName:@"tel" object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *str =note.object;
        if([str isEqualToString:@"true"])//true表示手机号码没有注册
        {
            if(self.forgetPWSymbol == YES)//如果是忘记密码的VC 则提示手机号码没有注册 并清空手机号码输入框
            {
                [self progressViewTishi:@"手机号码没有注册"];
                self.tel.text = @"";

            }
            else//如果是注册界面vc 不用提示 手机号码是否正确的标志设置为yes
            {
                self.telSymbol = YES;

                
            }


        }
        else//false表示手机号码已经注册
        {
            if(self.forgetPWSymbol == YES)//如果是忘记密码vc 手机号码是否正确的标志设置为yes
            {
                self.telSymbol = YES;
                
            }
            else//如果是注册界面vc 则提示手机号码已经被注册 并清空手机号码输入框
            {
                [self progressViewTishi:@"手机号码已经被注册"];
                self.tel.text = @"";
                self.telSymbol = NO;



                
            }
        }
        
        
    }];
    //获取手机验证码
    _observer3 = [[NSNotificationCenter defaultCenter]addObserverForName:@"get_identi_code" object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        NSString *str =note.object;
        if([str integerValue ] == 0)//成功
           {
               self.identi_code_Symbol = YES;
               NSLog(@"获取验证码成功");
               //成功则跳转到第二个界面
               SecondRegViewController *sec = [[SecondRegViewController alloc]init];
               sec.tel = self.tel.text;
               sec.forgetPWSymbol = self.forgetPWSymbol;
               [self.navigationController pushViewController:sec animated:YES];
               
           }
        else
        {
            [self progressViewTishi:@"获取验证码失败"];

            //[SVProgressHUD showInfoWithStatus:@"请获取手机验证码"];
        }
        
        
        
    }];
    
    _observer4 = [[NSNotificationCenter defaultCenter]addObserverForName:@"RegCheckMobileVcode" object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *str =note.object;
        if([str integerValue ] == 0)
        {
            NSLog(@"验证成功");
            
            
            
        }
        else
        {
            [self progressViewTishi:@"验证失败"];

            //[SVProgressHUD showInfoWithStatus:@"验证失败"];
        }
        
        
        
    }];
    


    
    
        
    
    
}
-(void)myNavigationGoback{
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if([textField isEqual:self.tel])
    {


        BOOL isTel = [self checkTel:self.tel.text];
        //BOOL isTel = YES;
        if(isTel)
        {
            if(![self.tel.text isEqualToString: self.telStr])
            {
                [self.get_identi_code_btn setTitle:@"获取手机验证码" forState:UIControlStateNormal];
                self.get_identi_code_btn.enabled = YES;
                [self.myTimer invalidate];
                timeNum = 60;

                
            }
            if ([self checkNetWork])
            {
                return;
            }
            if(self.forgetPWSymbol ==NO)
            {
                [[RegisterHttp getInstance] registerHttpCheckmyMobileAcc:self.tel.text];

                
            }
            else
            {
                self.telSymbol = YES;
                [[RegisterHttp getInstance] registerHttpCheckmyMobileAcc:self.tel.text];
            }
            
        }
        
    }
    self.telStr = self.tel.text;

}
#pragma -mark 正则表达式验证方法
- (BOOL)checkTel:(NSString *)str
{
   // NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSString *regex = @"^[1][3-9]\\d{9}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    if (!isMatch)
    {
        [self progressViewTishi:@"请输入正确的手机号码"];
        //[SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        return NO;
        
    }
    return YES;
    
}



- (IBAction)getIdentiCodeAction:(id)sender {
    if([self.tel.text isEqualToString:@""])
    {
        [self progressViewTishi:@"请输入手机号"];
        //[SVProgressHUD showInfoWithStatus:@"请输入手机号"];
        return;
    }
    if([self.urlNumTF.text isEqualToString:@""])
    {
        [self progressViewTishi:@"请输入验证码"];

        //[SVProgressHUD showInfoWithStatus:@"请输入验证码"];
        return;
 
    }
    if(self.telSymbol == YES)
    {
        self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeAction:) userInfo:nil repeats:YES];
//        [dm getInstance].tel = self.tel.text;
//        [dm getInstance].urlNum = self.urlNumTF.text;
        if ([self checkNetWork]) {
            return;
        }
        if(self.forgetPWSymbol == YES)
        {
            if ([self checkNetWork]) {
                return;
            }

            [[LoginSendHttp getInstance] hands_login];
            [[RegisterHttp getInstance]registerHttpReSendCheckCode:self.tel.text vCode:self.urlNumTF.text];
            

            
        }
        else
        {
            if ([self checkNetWork]) {
                return;
            }
            [[LoginSendHttp getInstance] hands_login];
            
            [[RegisterHttp getInstance]registerHttpSendCheckCode:self.tel.text Code:self.urlNumTF.text];
            
        }

    }


}
-(void)timeAction:(id)sender
{
    if(timeNum>0)
    {
        [self.get_identi_code_btn setTitle:[NSString stringWithFormat:@"%ld秒后重新获取验证码",timeNum] forState:UIControlStateNormal];
        timeNum--;
        self.get_identi_code_btn.enabled = NO;
        
    }
    else
    {
        [self.get_identi_code_btn setTitle:@"获取手机验证码" forState:UIControlStateNormal];
        self.get_identi_code_btn.enabled = YES;
        [self.myTimer invalidate];
        timeNum = 60;
    }


}

- (IBAction)nextStepAction:(id)sender {
    SecondRegViewController *sec = [[SecondRegViewController alloc]init];
    sec.tel = self.tel.text;
    sec.forgetPWSymbol = YES;
    //sec.urlNumStr = self.urlNumTF.text;
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeAction:) userInfo:nil repeats:YES];
    [self.navigationController pushViewController:sec animated:YES];

    
//    if(!self.tel.text)
//    {
//        [SVProgressHUD showInfoWithStatus:@"请输入手机号"];
//        return;
//    }
//    if(!self.tel_identi_codeTF.text)
//    {
//        [SVProgressHUD showInfoWithStatus:@"请输入验证码"];
//        return;
//        
//    }
//    if(self.telSymbol== YES&&self.identi_code_Symbol == YES)
//    {
//        NSLog(@"first = %@ second = %@ third = %@",self.tel.text,self.tel_identi_codeTF.text,self.urlNumTF.text);
//        [[RegisterHttp getInstance]registerHttpRegCheckMobileVcode:self.tel.text cCode:self.tel_identi_codeTF.text vCode:self.urlNumTF.text];
//        
//    }


}

- (IBAction)getUrlImageAction:(id)sender {
    if ([self checkNetWork]) {
        return;
    }
    [[RegisterHttp getInstance]registerHttpGetValidateCode];

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
@end
