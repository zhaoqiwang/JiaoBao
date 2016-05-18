//
//  NewWorkViewController.m
//  JiaoBao
//
//  Created by Zqw on 15-4-23.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "NewWorkViewController.h"
#import "ForwardViewController.h"
#import "RightModel.h"
#import "MobClick.h"
@interface NewWorkViewController ()

@property(nonatomic,strong)ForwardViewController *forward;

@end

@implementation NewWorkViewController
@synthesize mNav_navgationBar,rootView;
-(void)dealloc
{
    
}

-(void)changeCurUnit:(NSNotification *)noti{
    NSString *str = noti.object;
    if ([str intValue] ==0) {//成功
        [[LoginSendHttp getInstance]GetCommPerm];
    }else{
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:UMMESSAGE];
    [MobClick beginLogPageView:UMPAGE];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:UMMESSAGE];
    [MobClick endLogPageView:UMPAGE];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addMBPro:) name:@"addMBPro" object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetCommPerm" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetCommPerm:) name:@"GetCommPerm" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeCurUnit" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCurUnit:) name:@"changeCurUnit" object:nil];
    [[NSNotificationCenter defaultCenter]addObserverForName:@"" object:nil queue:nil usingBlock:^(NSNotification *note) {
        
    }];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CommMsgRevicerUnitList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CommMsgRevicerUnitList:) name:@"CommMsgRevicerUnitList" object:nil];
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"新建事务"];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];

    //top
    self.top = [[NewWorkTopScrollView alloc] initWithFrame];
    [self.view addSubview:self.top];
//    [self.view addSubview:[NewWorkTopScrollView shareInstance]];
    //root
    self.rootView = [[NewWorkRootScrollView alloc] initWithFrame];
    [self.view addSubview:self.rootView];
//    [self.view addSubview:[NewWorkRootScrollView shareInstance]];


    //[self.forward didMoveToParentViewController:self];

    [dm getInstance].secondFlag = @"0";
    [dm getInstance].notificationSymbol = 1;
    [[LoginSendHttp getInstance]changeCurUnit];
    //[[LoginSendHttp getInstance] login_CommMsgRevicerUnitList];D
    
    [MBProgressHUD showMessage:@"" toView:self.view];
}

//通知界面更新，获取事务信息接收单位列表
-(void)CommMsgRevicerUnitList:(NSNotification *)noti
{
    [MBProgressHUD hideHUDForView:self.view];
    NSMutableDictionary *dic = noti.object;
    NSString *flag = [dic objectForKey:@"flag"];
    if ([flag integerValue]==0) {
        if([dm getInstance].notificationSymbol ==1)
        {
            [dm getInstance].mModel_unitList = [dic objectForKey:@"model"];
            //CommMsgRevicerUnitListModel *model = noti.object;
            
            // NSLog(@"TabId =%@ %@",[dm getInstance].mModel_unitList,model);
            [[LoginSendHttp getInstance] login_GetUnitRevicer:[dm getInstance].mModel_unitList.myUnit.TabID Flag:[dm getInstance].mModel_unitList.myUnit.flag];
        }
    }else{
        [MBProgressHUD showError:@"" toView:self.view];
    }
}


//导航条返回按钮回调
-(void)myNavigationGoback{
    [HomeClassTopScrollView shareInstance].requestSymbol0 =YES;
    [HomeClassTopScrollView shareInstance].requestSymbol1 =YES;
    [HomeClassTopScrollView shareInstance].requestSymbol2 =YES;
    [HomeClassTopScrollView shareInstance].requestSymbol3 =YES;
    [HomeClassTopScrollView shareInstance].dataArr = [[NSMutableArray alloc]initWithCapacity:0];
    [[HomeClassRootScrollView shareInstance].characterView removeNotification];
    [[HomeClassRootScrollView shareInstance].schoolMessage removeNotification];
    [[HomeClassRootScrollView shareInstance].patriarchView removeNotification];
    [[HomeClassRootScrollView shareInstance].classMessageView removeNotification];

    [HomeClassTopScrollView destroyDealloc];
    [HomeClassRootScrollView destroyDealloc];
    self.top.firstSel = 0;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.rootView.moreUnitView dealloc1];
    [self.rootView.homeClassView dealloc1];
    [self.top dealloc1];
    [self.rootView dealloc1];
    [self.forward removeNotification];
    [dm getInstance].firstFlag = @"0";
    [dm getInstance].thirdFlag = @"0";
    [dm getInstance].secondFlag = @"0";
    [utils popViewControllerAnimated:YES];


}
-(void)GetCommPerm:(id)sender
{
    [MBProgressHUD hideHUDForView:self.view];
    NSMutableDictionary *dic = [sender object];
    NSString *flag = [dic objectForKey:@"flag"];
    if ([flag intValue] ==0) {//成功
        RightModel *rightModel = [dic objectForKey:@"model"];
        
        //BOOL unitCommright= [dic objectForKey:@"UnitCommRight"];
        if([rightModel.UnitCommRight integerValue]==1)
        {
            self.forward = [[ForwardViewController alloc]initWithNibName:@"ForwardViewController" bundle:nil];
            //forward.mStr_navName = @"新建事务";
            //forward.mInt_forwardFlag = 1;
            [LoginSendHttp getInstance].mInt_forwardFlag = 1;
            self.forward.mInt_forwardAll = 2;
            self.forward.mInt_flag = 1;
            self.forward.mInt_all = 2;
            //forward.mInt_where = 0;
            [self addChildViewController:self.forward];
            [self.forward didMoveToParentViewController:self];
            [self.rootView addSubview:self.forward.view];
            [[LoginSendHttp getInstance] login_CommMsgRevicerUnitList];
            
        }
        else
        {
            [[LoginSendHttp getInstance] login_CommMsgRevicerUnitList];
            [dm getInstance].firstFlag = @"1";
            [MBProgressHUD showError:@"没有权限" toView:self.view];
            
        }
    }else{
        [MBProgressHUD showError:@"获取权限失败" toView:self.view];
    }
}
-(void)addMBPro:(id)sender
{
    NSNotification *note = sender;
    if([note.object isEqualToString:@"0"])
    {
        [MBProgressHUD showMessage:@"" toView:self.view];
    }
    else
    {
        [MBProgressHUD hideHUDForView:self.view];

        
    }

        
        
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
