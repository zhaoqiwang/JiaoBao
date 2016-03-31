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
-(void)CheckLeaveModel:(NSNotification*)sender{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSString *resultCode = [sender object];
    if([resultCode integerValue]==0){
        [MBProgressHUD showError:@"成功"];

        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateCheckCell" object:self.model];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }else{
        [MBProgressHUD showError:@"失败"];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"CheckLeaveModel" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(CheckLeaveModel:) name:@"CheckLeaveModel" object:nil];
    self.model = [[CheckLeaveModel alloc]init];
    self.model.checkFlag = @"1";

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

- (IBAction)submitBtnAction:(id)sender {
    self.model.tabid = self.mModel_LeaveDetail.TabID;
    self.model.level = self.mModel_LeaveDetail.level;
    self.model.userName = [dm getInstance].TrueName;
    self.model.note = self.textView.text;
    self.model.cellFlag = self.mModel_LeaveDetail.cellFlag;
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[LeaveHttp getInstance]CheckLeaveModel:self.model];
}
- (void)textViewDidChange:(UITextView *)textView
{
    
    if([textView isEqual:self.textView])
    {
        if([textView.text isEqualToString:@""])
        {
            self.TitleTF.hidden = NO;
        }
        else
        {
            self.TitleTF.hidden = YES;
            
        }
        
    }
}

@end
