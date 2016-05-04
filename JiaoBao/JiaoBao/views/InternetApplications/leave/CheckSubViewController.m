//
//  CheckSubViewController.m
//  JiaoBao
//
//  Created by SongYanming on 16/3/24.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "CheckSubViewController.h"
#import "NSString+Extension.h"


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
- (void)textChanged:(NSNotification*)notification {
        UITextView *textField = (UITextView *)notification.object;
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage]; // 键盘输入模式
    
    if([toBeString isContainsEmoji])
    {
        if (textField.text.length>50) {
            NSString *a = [textField.text substringFromIndex:textField.text.length-1];
            NSString *b = [textField.text substringFromIndex:textField.text.length-2];
            NSString *c = [textField.text substringFromIndex:textField.text.length-3];
            NSString *d = [textField.text substringFromIndex:textField.text.length-4];
            NSString *e = [textField.text substringFromIndex:textField.text.length-5];
            if([a isContainsEmoji]) {
                textField.text = [toBeString substringToIndex:textField.text.length - 1];
            }else if ([b isContainsEmoji]){
                textField.text = [toBeString substringToIndex:textField.text.length - 2];
            }else if ([c isContainsEmoji]){
                textField.text = [toBeString substringToIndex:textField.text.length - 3];
            }else if ([d isContainsEmoji]){
                textField.text = [toBeString substringToIndex:textField.text.length - 4];
            }else if ([e isContainsEmoji]){
                textField.text = [toBeString substringToIndex:textField.text.length - 5];
            }
            toBeString = textField.text;
        }
    }
    for (int i=1; i<5; i++) {
        if (textField.text.length>50) {
            NSString *b = [textField.text substringFromIndex:textField.text.length-i];
            D("88888888888888-======%@",b);
        }
    }
    
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            
            if (toBeString.length > 50) {
                
                textField.text = [toBeString substringToIndex:50];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        
        if (toBeString.length > 50) {
            textField.text = [toBeString substringToIndex:50];
        }
    }
    
        if(textField.text.length>49)
        {
            textField.text = [textField.text substringToIndex:50];

        }
}
- (void)viewDidLoad {
    [super viewDidLoad];
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
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

//同意
- (IBAction)agreeAction:(id)sender {
    UIButton *currentBtn = sender;
    currentBtn.selected = YES;
    
    UIButton *anotherBtn = (UIButton*)[self.view viewWithTag:2];
    anotherBtn.selected = NO;
    self.model.checkFlag = @"1";
    
}
//拒绝
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
//提交
- (IBAction)submitBtnAction:(id)sender {
    //    if([utils isBlankString:self.textView.text]){
    //        [MBProgressHUD showError:@"批注不能为空"];
    //        return;
    //    }
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
    }else {
        self.TitleTF.hidden = YES;
        
    }
    if(textView.text.length>50)
    {
        textView.text = [textView.text substringToIndex:50];
    }
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{


    //输入删除时
    if ([text isEqualToString:@""]) {
        return YES;
    }
    if (textView.text.length+text.length>50) {
        return NO;
    }
    NSInteger existedLength = textView.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = text.length;
    if (existedLength - selectedLength + replaceLength > 50) {
        return NO;
    }
    
//    //系统九宫格限制字数
//    if(range.location==49&&text.length==1)
//    {
//        
//        if([text isEqualToString:@"➋"])
//        {
//            text = @"a";
//        }else if([text isEqualToString:@"➌"]){
//            text = @"d";
//        }else if([text isEqualToString:@"➍"]){
//            text = @"g";
//        }else if([text isEqualToString:@"➎"]){
//            text = @"j";
//        }else if([text isEqualToString:@"➏"]){
//            text = @"m";
//        }else if([text isEqualToString:@"➐"]){
//            text = @"p";
//        }else if([text isEqualToString:@"➑"]){
//            text = @"t";
//        }else if([text isEqualToString:@"➒"]){
//            text = @"w";
//        }else if([text isEqualToString:@"☻"]){
//            text = @"^";
//        }else {
//            
//        }
//    }
//    NSString *Sumstr = [NSString stringWithFormat:@"%@%@",textView.text,text];
////    //限制为50字
//    if(Sumstr.length>49)
//    {
//        textView.text = [Sumstr substringToIndex:50];
//        self.TitleTF.hidden = YES;
//        return NO;
//    }
//    if ([text isEqualToString:@"\n"]) {
//        
//    }
    return YES;
}
@end
