//
//  LeaveViewController.m
//  JiaoBao
//
//  Created by Zqw on 16/3/11.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "LeaveViewController.h"

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
    for (int i=0; i<3; i++) {
        ButtonViewModel *model = [[ButtonViewModel alloc] init];
        if (i==0) {
            model.mStr_title = @"请假";
        }else if (i==1){
            model.mStr_title = @"代请";
        }else if (i==2){
            model.mStr_title = @"查询";
        }
        
        [temp addObject:model];
    }
    self.mScrollV_all = [[LeaveTopScrollView alloc] initFrame:CGRectMake(0, self.mNav_navgationBar.frame.size.height, [dm getInstance].width, 48) Array:temp Flag:1 index:0];
    self.mScrollV_all.delegate = self;
    [self.view addSubview:self.mScrollV_all];
    
    //请假表格
    self.mView_root0 = [[LeaveView alloc] initWithFrame1:CGRectMake(0, self.mScrollV_all.frame.origin.y+self.mScrollV_all.frame.size.height, [dm getInstance].width, [dm getInstance].height-48-self.mNav_navgationBar.frame.size.height) flag:1 flagID:0];
    self.mView_root0.hidden = NO;
    
    self.mView_root1 = [[LeaveView alloc] initWithFrame1:CGRectMake(0, self.mScrollV_all.frame.origin.y+self.mScrollV_all.frame.size.height, [dm getInstance].width, [dm getInstance].height-48-self.mNav_navgationBar.frame.size.height) flag:0 flagID:2];
    self.mView_root1.hidden = NO;
    
    [self.view addSubview:self.mView_root0];
    [self.view addSubview:self.mView_root1];
}

-(void)LeaveViewCellTitleBtn:(LeaveViewCell *)view{
    self.mInt_flag = (int)view.tag -100;
    if (self.mInt_flag == 0) {
        self.mView_root0.hidden = NO;
        self.mView_root1.hidden = YES;
    }else if (self.mInt_flag == 1){
        self.mView_root0.hidden = YES;
        self.mView_root1.hidden = NO;
    }else if (self.mInt_flag == 2){
        self.mView_root0.hidden = YES;
        self.mView_root1.hidden = YES;
    }
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
