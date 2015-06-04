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

@interface FirstRegViewController ()
{
    id  _observer1,_observer2,_observer3,_observer4;
    NSInteger timeNum;
}

@end

@implementation FirstRegViewController
-(void)doBack:(id)sender
{
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
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
    [self addNotification];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    timeNum = 120;
    self.navigationItem.title = @"注册";
    [dm getInstance].RegisterSymbol = YES;
    [[RegisterHttp getInstance]registerHttpGetValidateCode];
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        backBtn.frame = CGRectMake(0, 0,63,26);
        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
//        backBtn.backgroundColor = [UIColor colorWithRed:224/255.0 green:133/255.0 blue:30/255.0 alpha:1];
        [backBtn addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        self.navigationItem.leftBarButtonItem = backItem;

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
            [SVProgressHUD showInfoWithStatus:@"手机号码已经被注册"];
            self.telSymbol = NO;
        }
        
        
    }];
    _observer3 = [[NSNotificationCenter defaultCenter]addObserverForName:@"get_identi_code" object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        NSString *str =note.object;
        if([str integerValue ] == 0)
           {
               self.identi_code_Symbol = YES;
               NSLog(@"获取验证码成功");
               SecondRegViewController *sec = [[SecondRegViewController alloc]init];
               sec.tel = self.tel.text;
               [self.navigationController pushViewController:sec animated:YES];
               
           }
        else
        {
            [SVProgressHUD showInfoWithStatus:@"请获取手机验证码"];
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
            [SVProgressHUD showInfoWithStatus:@"验证失败"];
        }
        
        
        
    }];
    


    
    
        
    
    
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
        if(isTel)
        {
            if(self.tel.text != self.telStr)
            {
                [self.get_identi_code_btn setTitle:@"获取手机验证码" forState:UIControlStateNormal];
                self.get_identi_code_btn.enabled = YES;

                
            }
            [[RegisterHttp getInstance] registerHttpCheckmyMobileAcc:self.tel.text];
            
        }
        
    }
    self.telStr = self.tel.text;

}
#pragma -mark 正则表达式验证方法
- (BOOL)checkTel:(NSString *)str
{
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    if (!isMatch)
    {
        
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        return NO;
        
    }
    return YES;
    
}



- (IBAction)getIdentiCodeAction:(id)sender {
    if(!self.tel.text)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入手机号"];
        return;
    }
    if(!self.tel_identi_codeTF.text)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入验证码"];
        return;
 
    }
    if(self.telSymbol == YES)
    {
        [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timeAction:) userInfo:nil repeats:YES];
//        [dm getInstance].tel = self.tel.text;
//        [dm getInstance].urlNum = self.urlNumTF.text;
        [[LoginSendHttp getInstance] hands_login];

        [[RegisterHttp getInstance]registerHttpSendCheckCode:self.tel.text Code:self.urlNumTF.text];
    }
//        [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timeAction:) userInfo:nil repeats:YES];

}
-(void)timeAction:(id)sender
{
    if(timeNum>0)
    {
        [self.get_identi_code_btn setTitle:[NSString stringWithFormat:@"%ld重新获取验证码",timeNum] forState:UIControlStateNormal];
        timeNum--;
        self.get_identi_code_btn.enabled = NO;
        
    }
    else
    {
        [self.get_identi_code_btn setTitle:@"获取手机验证码" forState:UIControlStateNormal];
        self.get_identi_code_btn.enabled = YES;
    }


}

- (IBAction)nextStepAction:(id)sender {
//    SecondRegViewController *sec = [[SecondRegViewController alloc]init];
//    sec.tel = self.tel.text;
//    sec.urlNumStr = self.urlNumTF.text;
//    [self.navigationController pushViewController:sec animated:YES];
    
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
    [[RegisterHttp getInstance]registerHttpGetValidateCode];

}
@end
