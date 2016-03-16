//
//  CheckLeaveViewController.m
//  JiaoBao
//
//  Created by Zqw on 16/3/16.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "CheckLeaveViewController.h"

@interface CheckLeaveViewController ()

@end

@implementation CheckLeaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:self.mStr_navName];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    
    //4种状态
    NSMutableArray *temp = [NSMutableArray array];
    for (int i=0; i<4; i++) {
        ButtonViewModel *model = [[ButtonViewModel alloc] init];
        if (i==0) {
            model.mStr_title = @"已提交";
        }else if (i==1){
            model.mStr_title = @"待审核";
        }else if (i==2){
            model.mStr_title = @"已审核";
        }else if (i==3){
            model.mStr_title = @"统计查询";
        }
        [temp addObject:model];
    }
    self.mScrollV_all = [[LeaveTopScrollView alloc] initFrame:CGRectMake(0, self.mNav_navgationBar.frame.size.height, [dm getInstance].width, 48) Array:temp Flag:1 index:0];
    self.mScrollV_all.delegate = self;
    [self.view addSubview:self.mScrollV_all];
}

//分类状态的回调
-(void)LeaveViewCellTitleBtn:(LeaveViewCell *)view{
    self.mInt_flag = (int)view.tag -100;
}

//导航条返回按钮回调
-(void)myNavigationGoback{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
