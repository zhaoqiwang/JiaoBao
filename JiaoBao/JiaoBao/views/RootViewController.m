//
//  RootViewController.m
//  JiaoBao
//  总界面
//  Created by Zqw on 14-10-18.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "RootViewController.h"
#import "TreeView_node.h"

#define SELECTED_VIEW_CONTROLLER_TAG 98456345

@interface RootViewController ()

@end

@implementation RootViewController
@synthesize mTabbar_view,mViewC_appcation,mViewC_center,mViewC_studentFile,mArr_views;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
//    [[RCIM sharedRCIM]setConnectionStatusDelegate:self];
    //将dm中的单位人员数组改为未展开、未选中
    for (TreeView_node *node1 in [dm getInstance].mArr_unit_member) {
        node1.isExpanded = FALSE;
        for(TreeView_node *node2 in node1.sonNodes){
            for(TreeView_node *node3 in node2.sonNodes){
                if (node3.mInt_select == 1) {
                    node3.mInt_select = 0;
                }
            }
        }
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [[RCIM sharedRCIM] setConnectionStatusDelegate:nil];
}

//-(void)responseConnectionStatus:(RCConnectionStatus)status{
//    if (ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT == status) {
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"" message:@"您已下线，重新连接？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"确定",nil];
//            alert.tag = 2000;
//            [alert show];
//        });
//    }
//}
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (2000 == alertView.tag) {
//        if (0 == buttonIndex) {
//            D("NO");
//        }
//        if (1 == buttonIndex) {
//            D("YES");
//            [RCIMClient reconnect:nil];
//        }
//    }
//}

- (void)viewDidLoad {
    //导航条
    
    self.mArr_views = [[NSMutableArray alloc] init];
    
    //添加自定义tabbar
    self.mTabbar_view = [[TabbarView alloc] init];
    self.mTabbar_view.tabbarView_Delegate = self;
    [self.view addSubview:self.mTabbar_view];
    
    [self createViewController];
    
    //通知界面，是否登录成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:@"loginSuccess" object:nil];
    
//    self.mProgressV.userInteractionEnabled = NO;
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

//通知界面，是否登录成功
-(void)loginSuccess:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSString *str = noti.object;
    D("loginSuccess-== %@",str);
    [MBProgressHUD showSuccess:str toView:self.view];
}

-(void)myTask{
    sleep(2);
}
-(void)createViewController{
    if (self.mViewC_appcation == nil) {
        self.mViewC_appcation = [[InternetApplicationsViewController alloc] init];
        [self.mArr_views addObject:self.mViewC_appcation];
    }
//    if (self.mViewC_studentFile == nil) {
//        self.mViewC_studentFile = [[StudentFileViewController alloc] init];
//        [self.mArr_views addObject:self.mViewC_studentFile];
//    }
//    if (self.mViewC_center == nil) {
//        self.mViewC_center = [[ApplicationCenterViewController alloc] init];
//        [self.mArr_views addObject:self.mViewC_center];
//    }
    
    self.mViewC_appcation.view.tag = SELECTED_VIEW_CONTROLLER_TAG;
    [self.view insertSubview:self.mViewC_appcation.view belowSubview:self.mTabbar_view];
}
#pragma mark 自定义tabbar 委托
-(void)tabbarView:(int)index{
    D("tabbarView----%d",index);
    if (index>=self.mArr_views.count) {
        return;
    }
    //
    UIView *vv = [self.view viewWithTag:SELECTED_VIEW_CONTROLLER_TAG];
    [vv removeFromSuperview];
    
    // 除了显示的VC，其它的VC中的view.tag都清零
    for (UIViewController* controler in self.mArr_views) {
        controler.view.tag = 0;
    }
    
    UIViewController *vc = [self.mArr_views objectAtIndex:index];
    vc.view.tag = SELECTED_VIEW_CONTROLLER_TAG;
    [self.view insertSubview:vc.view belowSubview:self.mTabbar_view];
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
