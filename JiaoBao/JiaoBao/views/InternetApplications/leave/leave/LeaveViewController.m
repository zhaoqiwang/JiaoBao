//
//  LeaveViewController.m
//  JiaoBao
//
//  Created by Zqw on 16/3/11.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "LeaveViewController.h"
#import "dm.h"

@interface LeaveViewController ()

@end

@implementation LeaveViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:self.mStr_navName];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    
    //三种状态
    NSMutableArray *temp = [NSMutableArray array];
    for (int i=0; i<2; i++) {
        ButtonViewModel *model = [[ButtonViewModel alloc] init];
        if (i==0) {
            model.mStr_title = @"请假";
        }else if (i==1){
            model.mStr_title = @"查询";
        }
        [temp addObject:model];
    }
    //添加班主任的代请
    if (self.mInt_leaveID == 1) {
        ButtonViewModel *model = [[ButtonViewModel alloc] init];
        model.mStr_title = @"代请";
        [temp insertObject:model atIndex:1];
    }
    self.mScrollV_all = [[LeaveTopScrollView alloc] initFrame:CGRectMake(0, self.mNav_navgationBar.frame.size.height, [dm getInstance].width, 48) Array:temp Flag:1 index:0];
    self.mScrollV_all.delegate = self;
    [self.view addSubview:self.mScrollV_all];
    
    //请假表格，门卫，班主任自己，普通老师
    self.mView_root0 = [[LeaveView alloc] initWithFrame1:CGRectMake(0, self.mScrollV_all.frame.origin.y+self.mScrollV_all.frame.size.height, [dm getInstance].width, [dm getInstance].height-48-self.mNav_navgationBar.frame.size.height) flag:1 flagID:self.mInt_leaveID];
    //代请，班主任，家长
    int a=0;
    if (self.mInt_leaveID==1) {
        a=0;
    }else if (self.mInt_leaveID ==3){
        a=2;
    }
    self.mView_root1 = [[LeaveView alloc] initWithFrame1:CGRectMake(0, self.mScrollV_all.frame.origin.y+self.mScrollV_all.frame.size.height, [dm getInstance].width, [dm getInstance].height-48-self.mNav_navgationBar.frame.size.height) flag:a flagID:self.mInt_leaveID];

    [self.view addSubview:self.mView_root0];
    [self.view addSubview:self.mView_root1];


    self.automaticallyAdjustsScrollViewInsets = NO;
    if (self.mInt_leaveID==3) {
        self.mView_root0.hidden = YES;
        self.mView_root1.hidden = NO;
    }else{
        self.mView_root0.hidden = NO;
        self.mView_root1.hidden = YES;
    }
    self.queryVC = [[QueryViewController alloc]initWithNibName:@"QueryViewController" bundle:nil];

}

-(void)LeaveViewCellTitleBtn:(LeaveViewCell *)view{
    self.mInt_flag = (int)view.tag -100;
    
    //先判断身份，班主任有3个，其他为两个
    if (self.mInt_leaveID == 1) {
        if (self.mInt_flag == 0) {
            self.mView_root0.hidden = NO;
            self.mView_root1.hidden = YES;
            self.queryVC.view.hidden = YES;
        }else if (self.mInt_flag == 1){
            self.mView_root0.hidden = YES;
            self.mView_root1.hidden = NO;
            self.queryVC.view.hidden = YES;
        }else if (self.mInt_flag == 2){
            self.mView_root0.hidden = YES;
            self.mView_root1.hidden = YES;
                self.queryVC.mInt_leaveID = self.mInt_leaveID;
                [self addChildViewController:self.queryVC];
                [self.queryVC didMoveToParentViewController:self];
                [self addChild:self.queryVC withChildToRemove:nil];
            self.queryVC.view.hidden = NO;
        }
    }else{
        //判断是不是家长
        if (self.mInt_leaveID == 3) {
            if (self.mInt_flag == 0) {
                self.mView_root0.hidden = YES;
                self.mView_root1.hidden = NO;
                self.queryVC.view.hidden = YES;
            }else if (self.mInt_flag == 1){
                self.mView_root0.hidden = YES;
                self.mView_root1.hidden = YES;

                    self.queryVC.mInt_leaveID = self.mInt_leaveID;
                    [self addChildViewController:self.queryVC];
                    [self.queryVC didMoveToParentViewController:self];
                    [self addChild:self.queryVC withChildToRemove:nil];
                self.queryVC.view.hidden = NO;
            }
        }else{
            if (self.mInt_flag == 0) {
                self.mView_root0.hidden = NO;
                self.mView_root1.hidden = YES;
                self.queryVC.view.hidden = YES;
            }else if (self.mInt_flag == 1){
                self.mView_root0.hidden = YES;
                self.mView_root1.hidden = YES;
                    self.queryVC.mInt_leaveID = self.mInt_leaveID;
                    [self addChildViewController:self.queryVC];
                    [self.queryVC didMoveToParentViewController:self];
                    [self addChild:self.queryVC withChildToRemove:nil];
                self.queryVC.view.hidden = NO;
            }
        }
    }
}
-(void)addChild:(UIViewController *)childToAdd withChildToRemove:(UIViewController *)childToRemove
{
    assert(childToAdd != nil);
    
    if (childToRemove != nil)
    {
        [childToRemove.view removeFromSuperview];
    }
    
    // match the child size to its parent
    CGRect frame = childToAdd.view.frame;
    frame.origin.y = CGRectGetMaxY(self.mScrollV_all.frame);
    frame.size.height = CGRectGetHeight(self.view.frame)-self.mScrollV_all.frame.origin.y-self.mScrollV_all.frame.size.height;
    frame.size.width = CGRectGetWidth(self.view.frame);
    childToAdd.view.frame = frame;
    [self.view addSubview:childToAdd.view];
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
