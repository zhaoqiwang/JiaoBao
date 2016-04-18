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
    //生成一条请假条记录
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NewLeaveModel" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NewLeaveModel:) name:@"NewLeaveModel" object:nil];
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
            if (self.mInt_leaveID == 1) {//班主任
                model.mStr_title = @"个人查询";
            }else{
                model.mStr_title = @"查询";
            }
        }
        [temp addObject:model];
    }
    //添加班主任的代请
    if (self.mInt_leaveID == 1) {
        ButtonViewModel *model = [[ButtonViewModel alloc] init];
        model.mStr_title = @"代请";
        [temp insertObject:model atIndex:1];
    }
    //班主任时，添加班级查询
    if (self.mInt_leaveID == 1) {
        ButtonViewModel *model = [[ButtonViewModel alloc] init];
        model.mStr_title = @"班级查询";
        [temp addObject:model];
    }
    self.mScrollV_all = [[LeaveTopScrollView alloc] initFrame:CGRectMake(0, self.mNav_navgationBar.frame.size.height, [dm getInstance].width, 48) Array:temp Flag:1 index:0];
    self.mScrollV_all.delegate = self;
    [self.view addSubview:self.mScrollV_all];
    
    //请假表格，门卫，班主任自己，普通老师
    self.mView_root0 = [[LeaveView alloc] initWithFrame1:CGRectMake(0, self.mScrollV_all.frame.origin.y+self.mScrollV_all.frame.size.height, [dm getInstance].width, [dm getInstance].height-48-self.mNav_navgationBar.frame.size.height) flag:1 flagID:self.mInt_leaveID];
    //代请，班主任，家长
    int a=0;
    if (self.mInt_leaveID==1) {//班主任
        a=0;
    }else if (self.mInt_leaveID ==3){//家长
        a=2;
    }
    self.mView_root1 = [[LeaveView alloc] initWithFrame1:CGRectMake(0, self.mScrollV_all.frame.origin.y+self.mScrollV_all.frame.size.height, [dm getInstance].width, [dm getInstance].height-48-self.mNav_navgationBar.frame.size.height) flag:a flagID:self.mInt_leaveID];

    [self.view addSubview:self.mView_root0];
    [self.view addSubview:self.mView_root1];


    self.automaticallyAdjustsScrollViewInsets = NO;
    //家长或别的身份时，判断哪个该优先显示
    if (self.mInt_leaveID ==3){//家长
        self.mView_root0.hidden = YES;
        self.mView_root1.hidden = NO;
    }else{
        self.mView_root0.hidden = NO;
        self.mView_root1.hidden = YES;
    }
    self.myQueryVC = [[QueryViewController alloc]init];
    [self addChildViewController:self.myQueryVC];
    [self.myQueryVC didMoveToParentViewController:self];
    self.myQueryVC.cellFlag = YES;
    self.myQueryVC.mInt_flag = 2;
    self.myQueryVC.mInt_flagID = 1;
    self.myQueryVC.mInt_leaveID = self.mInt_leaveID;

    self.classQueryVC = [[QueryViewController alloc]init];
    [self addChildViewController:self.classQueryVC];
    self.classQueryVC.cellFlag = NO;
    self.classQueryVC.mInt_flag = 3;
    self.classQueryVC.mInt_flagID = 0;
    self.classQueryVC.mInt_leaveID = self.mInt_leaveID;

    [self.classQueryVC didMoveToParentViewController:self];
    [self addChildViewController:self.myQueryVC];
    [self addChild:self.myQueryVC ];
    [self addChild:self.classQueryVC];

}

//生成一条请假条记录
-(void)NewLeaveModel:(NSNotification *)noti{
    NSMutableDictionary *dic = noti.object;
    NSString *flag = [dic objectForKey:@"flag"];
    if ([flag intValue]==1) {//家长或老师代请
        [self.mView_root1 NewLeaveModel:noti];
    }else{
        [self.mView_root0 NewLeaveModel:noti];
    }
}

-(void)LeaveViewCellTitleBtn:(LeaveViewCell *)view{
    self.mInt_flag = (int)view.tag -100;
    [self.mView_root0.mTextF_reason resignFirstResponder];
    [self.mView_root1.mTextF_reason resignFirstResponder];
    //先判断身份，班主任有4个，其他为两个
    if (self.mInt_leaveID == 1) {
        if (self.mInt_flag == 0) {
            self.mView_root0.hidden = NO;
            self.mView_root1.hidden = YES;
            self.myQueryVC.view.hidden = YES;
            self.classQueryVC.view.hidden = YES;

        }else if (self.mInt_flag == 1){
            self.mView_root0.hidden = YES;
            self.mView_root1.hidden = NO;
            self.myQueryVC.view.hidden = YES;
            self.classQueryVC.view.hidden = YES;

        }else if (self.mInt_flag == 2){
            self.mView_root0.hidden = YES;
            self.mView_root1.hidden = YES;
            self.myQueryVC.view.hidden = NO;
            self.classQueryVC.view.hidden = YES;

        }else if (self.mInt_flag == 3){
            self.mView_root0.hidden = YES;
            self.mView_root1.hidden = YES;
            self.myQueryVC.view.hidden = YES;
            self.classQueryVC.view.hidden = NO;
        }
    }else{
        //判断是不是家长
        if (self.mInt_leaveID == 3) {
            if (self.mInt_flag == 0) {
                self.mView_root0.hidden = YES;
                self.mView_root1.hidden = NO;
                self.myQueryVC.view.hidden = YES;
                self.classQueryVC.view.hidden = YES;
            }else if (self.mInt_flag == 1){
                self.mView_root0.hidden = YES;
                self.mView_root1.hidden = YES;
                self.myQueryVC.view.hidden = YES;
                self.classQueryVC.view.hidden = NO;

            }
        }else{
            if (self.mInt_flag == 0) {
                self.mView_root0.hidden = NO;
                self.mView_root1.hidden = YES;
                self.myQueryVC.view.hidden = YES;
                self.classQueryVC.view.hidden = YES;
            }else if (self.mInt_flag == 1){
                self.mView_root0.hidden = YES;
                self.mView_root1.hidden = YES;
                self.myQueryVC.view.hidden = NO;
                self.classQueryVC.view.hidden = YES;
            }
        }
    }
}
-(void)addChild:(UIViewController *)childToAdd
{
    CGRect frame = childToAdd.view.frame;
    frame.origin.y = CGRectGetMaxY(self.mScrollV_all.frame);
    frame.size.height = CGRectGetHeight(self.view.frame)-self.mScrollV_all.frame.origin.y-self.mScrollV_all.frame.size.height;
    frame.size.width = CGRectGetWidth(self.view.frame);
    childToAdd.view.frame = frame;
    [self.view addSubview:childToAdd.view];
    childToAdd.view.hidden = YES;
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
-(void)dealloc{
    
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
