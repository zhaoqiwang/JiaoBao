//
//  ReviseNameViewController.m
//  JiaoBao
//
//  Created by 赵启旺 on 15/6/4.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "ReviseNameViewController.h"
#import "Reachability.h"

@interface ReviseNameViewController ()

@end

@implementation ReviseNameViewController
@synthesize mBtn_sure,mLab_nickName,mLab_trueName,mNav_navgationBar,mProgressV,mTextF_nickName,mTextF_trueName;


-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    //昵称是否重复
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"registerHttpCheckAccN" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerHttpCheckAccN:) name:@"registerHttpCheckAccN" object:nil];
    //修改昵称和姓名
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"registerHttpUpateRecAcc" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerHttpUpateRecAcc:) name:@"registerHttpUpateRecAcc" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"输入密码"];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    //昵称
    self.mLab_nickName.frame = CGRectMake(10, self.mNav_navgationBar.frame.size.height+20, self.mLab_nickName.frame.size.width, self.mLab_nickName.frame.size.height);
    self.mTextF_nickName.frame = CGRectMake(self.mLab_nickName.frame.origin.x+self.mLab_nickName.frame.size.width, self.mNav_navgationBar.frame.size.height+20, [dm getInstance].width-self.mLab_nickName.frame.origin.x-self.mLab_nickName.frame.size.width-30, self.mTextF_nickName.frame.size.height);
    //真实姓名
    self.mLab_trueName.frame = CGRectMake(10, self.mTextF_nickName.frame.origin.y+self.mTextF_nickName.frame.size.height+20, self.mLab_trueName.frame.size.width, self.mLab_trueName.frame.size.height);
    self.mTextF_trueName.frame = CGRectMake(self.mTextF_nickName.frame.origin.x, self.mLab_trueName.frame.origin.y, self.mTextF_nickName.frame.size.width, self.mTextF_nickName.frame.size.height);
    //确定按钮
    self.mBtn_sure.frame = CGRectMake(20, self.mTextF_trueName.frame.origin.y+self.mTextF_trueName.frame.size.height+20, [dm getInstance].width-40, self.mBtn_sure.frame.size.height);
    
    self.mProgressV = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:self.mProgressV];
    self.mProgressV.delegate = self;
}

//昵称是否重复
-(void)registerHttpCheckAccN:(NSNotification *)noti{
    NSString *flag = noti.object;
    if ([flag intValue] ==0) {//昵称可用
        //发送修改昵称和姓名协议
        [self ProgressViewLoad:@"修改昵称和姓名中"];
        [[RegisterHttp getInstance] registerHttpUpateRecAcc:[dm getInstance].jiaoBaoHao NickName:self.mTextF_nickName.text TrueName:self.mTextF_trueName.text];
    }else{//昵称重复
         [self progressViewTishi:@"昵称重复，请重新输入"];
    }
}

//修改昵称和姓名
-(void)registerHttpUpateRecAcc:(NSNotification *)noti{
    NSString *flag = noti.object;
    if ([flag intValue] ==0) {//修改成功
        //发送修改昵称和姓名协议
        [utils popViewControllerAnimated:YES];
    }else{//修改失败
        [self progressViewTishi:@"昵称重复，请重新输入"];
    }
}

-(void)mBtn_sure:(UIButton *)btn{
    D("点击确定按钮");
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    if (self.mTextF_nickName.text.length==0) {
        [self progressViewTishi:@"请输入昵称"];
        return;
    }else if (self.mTextF_trueName.text.length==0) {
        [self progressViewTishi:@"请输入真实姓名"];
        return;
    }else if (self.mTextF_trueName.text.length>20){
        [self progressViewTishi:@"真实姓名长度不能大于20个字符"];
    }
    
    //判断昵称格式是否正确
    if ([self isPureInt:self.mTextF_nickName.text]) {//纯数字
        [self progressViewTishi:@"昵称不能全部为数字"];
    }else{
        //判断是否包含@
        NSRange range = [self.mTextF_nickName.text rangeOfString:@"@"];
        if (range.length > 0){//包含
            [self progressViewTishi:@"昵称不能有“@“字符"];
        }else{
            //发送请求，判断昵称是否重复
            [self ProgressViewLoad:@"判断昵称是否可用"];
            [[RegisterHttp getInstance] registerHttpCheckAccN:self.mTextF_nickName.text];
        }
    }
}

//整形判断
- (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
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

-(void)myNavigationGoback{
    [utils popViewControllerAnimated:YES];
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