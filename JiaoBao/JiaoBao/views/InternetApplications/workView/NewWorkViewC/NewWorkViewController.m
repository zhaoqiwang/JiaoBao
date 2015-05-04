//
//  NewWorkViewController.m
//  JiaoBao
//
//  Created by Zqw on 15-4-23.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "NewWorkViewController.h"
#import "ForwardViewController.h"

@interface NewWorkViewController ()

@end

@implementation NewWorkViewController
@synthesize mNav_navgationBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"新建事务"];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    //top
    [self.view addSubview:[NewWorkTopScrollView shareInstance]];
    //root
    [self.view addSubview:[NewWorkRootScrollView shareInstance]];
    
    ForwardViewController *forward = [[ForwardViewController alloc]initWithNibName:@"ForwardViewController" bundle:nil];
    forward.mStr_navName = @"新建事务";
    forward.mInt_forwardFlag = 1;
    forward.mInt_forwardAll = 2;
    forward.mInt_flag = 1;
    forward.mInt_all = 2;
    forward.mInt_where = 0;
    [self addChildViewController:forward];
    [forward didMoveToParentViewController:self];
    //[self addChild:leftTableVC withChildToRemove:nil];
    [[NewWorkRootScrollView shareInstance] addSubview:forward.view];
    
//    ForwardViewController *forward2 = [[ForwardViewController alloc]initWithNibName:@"ForwardViewController" bundle:nil];
//    forward2.mStr_navName = @"新建事务";
//    forward2.mInt_forwardFlag = 1;
//    forward2.mInt_forwardAll = 2;
//    forward2.mInt_flag = 1;
//    forward2.mInt_all = 2;
//    forward2.mInt_where = 0;
//    forward2.showTopView = NO;
//    [self addChildViewController:forward2];
//    [forward2 didMoveToParentViewController:self];
//
//    //[self addChild:leftTableVC withChildToRemove:nil];
//    [[NewWorkRootScrollView shareInstance].homeClassView.bottomView addSubview:forward2.view];

    

    
}


//导航条返回按钮回调
-(void)myNavigationGoback{
    [[NewWorkTopScrollView shareInstance]removeFromSuperview];
    [[NewWorkRootScrollView shareInstance]removeFromSuperview];
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
