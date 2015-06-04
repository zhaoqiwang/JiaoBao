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

@interface SecondRegViewController ()

@end

@implementation SecondRegViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNotification];

    [[RegisterHttp getInstance]registerHttpGetValidateCode];

    // Do any additional setup after loading the view from its nib.
}
-(void)addNotification
{
    [[NSNotificationCenter defaultCenter]addObserverForName:@"urlImage" object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSData *imgData = note.object;
        UIImage *image = [UIImage imageWithData:imgData];
        self.urlImgV.image = image;
        
        
        
    }];
    [[NSNotificationCenter defaultCenter]addObserverForName:@"tel" object:nil queue:nil usingBlock:^(NSNotification *note) {
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
    [[NSNotificationCenter defaultCenter]addObserverForName:@"get_identi_code" object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        NSString *str =note.object;
        if([str integerValue ] == 0)
        {
            self.identi_code_Symbol = YES;
            NSLog(@"获取验证码成功");
            
        }
        else
        {
            [SVProgressHUD showInfoWithStatus:@"请获取手机验证码"];
        }
        
        
        
    }];
    
    [[NSNotificationCenter defaultCenter]addObserverForName:@"RegCheckMobileVcode" object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *str =note.object;
        if([str integerValue ] == 0)
        {
            NSLog(@"验证成功");
            [SVProgressHUD dismiss];
            
            
            
            
        }
        else
        {
            [SVProgressHUD showInfoWithStatus:@"验证失败"];
        }
        
        
        
    }];

    
}

- (IBAction)getIdentiCodeAction:(id)sender {


        [[LoginSendHttp getInstance] hands_login];
        
        [[RegisterHttp getInstance]registerHttpSendCheckCode:self.tel Code:self.urlNumStr];
    
    
}

- (IBAction)nextStepAction:(id)sender {
    if(!self.tel_identi_codeTF.text)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入手机号码"];
        return;

        
    }
    if(!self.urlNumTF.text)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入图片验证码"];
        return;
        
    }

    
    [[RegisterHttp getInstance]registerHttpRegCheckMobileVcode:self.tel cCode:self.tel_identi_codeTF.text vCode:self.urlNumTF.text];
    [SVProgressHUD show];
        
    
    
    
}

- (IBAction)getUrlImageAction:(id)sender {
    [[RegisterHttp getInstance]registerHttpGetValidateCode];
    
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
