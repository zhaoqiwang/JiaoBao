//
//  CheckSubViewController.m
//  JiaoBao
//
//  Created by SongYanming on 16/3/24.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "CheckSubViewController.h"


@interface CheckSubViewController ()<MyNavigationDelegate>
@property(nonatomic,strong)MyNavigationBar *mNav_navgationBar;
@end

@implementation CheckSubViewController
//审核假条通知回调
-(void)CheckLeaveModel:(NSNotification*)sender{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSString *resultCode = [sender object];
    if([resultCode integerValue]==0){
        if([self.model.checkFlag integerValue]==1){
            [MBProgressHUD showError:@"审核成功"];

        }
        else{
            [MBProgressHUD showError:@"拒绝成功"];
        }

        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateCheckCell" object:self.model];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }else{
        if([self.model.checkFlag integerValue]==1){
            [MBProgressHUD showError:@"审核失败"];
            
        }
        else{
            [MBProgressHUD showError:@"拒绝失败"];
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //审核假条通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"CheckLeaveModel" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(CheckLeaveModel:) name:@"CheckLeaveModel" object:nil];
    self.model = [[CheckLeaveModel alloc]init];
    self.model.checkFlag = @"1";//1通过，2拒绝

    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView.layer.borderWidth = 1;
    self.textView.layer.cornerRadius = 5;
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"审核"];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    //输入框弹出键盘问题
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;//控制整个功能是否启用
    manager.shouldResignOnTouchOutside = YES;//控制点击背景是否收起键盘
    manager.shouldToolbarUsesTextFieldTintColor = YES;//控制键盘上的工具条文字颜色是否用户自定义
    manager.enableAutoToolbar = YES;//控制是否显示键盘上的工具条
    
    // Do any additional setup after loading the view from its nib.
}
//导航条返回按钮回调
-(void)myNavigationGoback{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    //输入框弹出键盘问题
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;//控制整个功能是否启用
    manager.shouldResignOnTouchOutside = NO;//控制点击背景是否收起键盘
    manager.shouldToolbarUsesTextFieldTintColor = NO;//控制键盘上的工具条文字颜色是否用户自定义
    manager.enableAutoToolbar = NO;//控制是否显示键盘上的工具条
    [utils popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)agreeAction:(id)sender {
    UIButton *currentBtn = sender;
    currentBtn.selected = YES;
    
    UIButton *anotherBtn = (UIButton*)[self.view viewWithTag:2];
    anotherBtn.selected = NO;
    self.model.checkFlag = @"1";
    
}

- (IBAction)fefuseAction:(id)sender {
    UIButton *currentBtn = sender;
    currentBtn.selected = YES;
    UIButton *anotherBtn = (UIButton*)[self.view viewWithTag:1];
    anotherBtn.selected = NO;
    self.model.checkFlag = @"2";
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1){
        self.model.tabid = self.mModel_LeaveDetail.TabID;
        self.model.level = self.mModel_LeaveDetail.level;
        self.model.userName = [dm getInstance].TrueName;
        self.model.note = self.textView.text;
        self.model.cellFlag = self.mModel_LeaveDetail.cellFlag;
        [MBProgressHUD showMessage:@"" toView:self.view];
        [[LeaveHttp getInstance]CheckLeaveModel:self.model];
    }
}
- (IBAction)submitBtnAction:(id)sender {
    if([utils isBlankString:self.textView.text]){
        [MBProgressHUD showError:@"批注不能为空"];
        return;
    }
    if([self.model.checkFlag integerValue]==1){
        NSString *message = [NSString stringWithFormat:@"您确定要‘同意’%@的请假申请吗？",self.mModel_LeaveDetail.ManName];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }else{
        NSString *message = [NSString stringWithFormat:@"您确定要‘拒绝’%@的请假申请吗？",self.mModel_LeaveDetail.ManName];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }


}
- (void)textViewDidChange:(UITextView *)textView
{
    
        if([textView.text isEqualToString:@""])
        {
            self.TitleTF.hidden = NO;
        }
        else
        {
            self.TitleTF.hidden = YES;
            
        }
        if(textView.text.length>50)
        {
            textView.text = [textView.text substringToIndex:50];
        }
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //系统九宫格限制字数
    if(range.location==49&&text.length==1)
    {
        
        if([text isEqualToString:@"➋"])
        {
            text = @"a";
        }else if([text isEqualToString:@"➌"]){
            text = @"d";
        }else if([text isEqualToString:@"➍"]){
            text = @"g";
        }else if([text isEqualToString:@"➎"]){
            text = @"j";
        }else if([text isEqualToString:@"➏"]){
            text = @"m";
        }else if([text isEqualToString:@"➐"]){
            text = @"p";
        }else if([text isEqualToString:@"➑"]){
            text = @"t";
        }else if([text isEqualToString:@"➒"]){
            text = @"w";
        }else if([text isEqualToString:@"☻"]){
            text = @"^";
        }else {
        }
    }
    NSString *Sumstr = [NSString stringWithFormat:@"%@%@",textView.text,text];
    //限制为50字
    if(Sumstr.length>49)
    {
        textView.text = [Sumstr substringToIndex:50];
        self.TitleTF.hidden = YES;
        return NO;
    }
    if ([text isEqualToString:@"\n"]) {

}
    return YES;
}
@end
