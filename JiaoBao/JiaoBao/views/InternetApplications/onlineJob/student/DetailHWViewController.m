//
//  DetailHWViewController.m
//  JiaoBao
//
//  Created by songyanming on 15/10/29.
//  Copyright © 2015年 JSY. All rights reserved.
//

#import "DetailHWViewController.h"
#import "utils.h"
#import "OnlineJobHttp.h"

@interface DetailHWViewController ()

@end

@implementation DetailHWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"做作业"];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    [[OnlineJobHttp getInstance] GetStuHWWithHwInfoId:self.TabID];
    //[[OnlineJobHttp getInstance]GetStuHWQsWithHwInfoId:<#(NSString *)#> QsId:<#(NSString *)#>]
    self.hwNameLabel.text = self.hwName;
    // Do any additional setup after loading the view from its nib.
}
//导航条返回按钮回调
-(void)myNavigationGoback{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

@end
