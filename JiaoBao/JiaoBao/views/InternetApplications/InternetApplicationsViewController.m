//
//  InternetApplicationsViewController.m
//  JiaoBao
//
//  Created by Zqw on 14-10-21.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "InternetApplicationsViewController.h"
#import "Reachability.h"
#import "SignInViewController.h"
#import "CheckingInViewController.h"
#import "MBProgressHUD+AD.h"
#import "MobClick.h"
#import "AddQuestionViewController.h"
#import "MakeJobViewController.h"
#import "TeacherViewController.h"
#import "LeaveViewController.h"
#import "LeaveHttp.h"
#import "CheckLeaveViewController.h"

@interface InternetApplicationsViewController ()

@end

@implementation InternetApplicationsViewController
@synthesize nav_internetAppView,mTableV_left,mTableV_right,mView_all,mInt_defaultTV_index,mInt_flag;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [dm getInstance].sectionSet = nil;
    [dm getInstance].tableSymbol =NO;
    if (self.mInt_flag == 0) {
        self.mInt_flag = 1;
    }else{
        [[LoginSendHttp getInstance] getUnreadMessages1];
        [[LoginSendHttp getInstance] getUnreadMessages2];
    }
    //添加通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getIdentity" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getIdentity:) name:@"getIdentity" object:nil];
    //通知internetApp界面，获取成功
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"internetAppGetUserInfo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(internetAppGetUserInfo:) name:@"internetAppGetUserInfo" object:nil];
    //向exchangeView页面发送通知，
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getTotalUnreadCount" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTotalUnreadCount) name:@"getTotalUnreadCount" object:nil];
    //通知界面，是否登录成功
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loginSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:@"loginSuccess" object:nil];
    //是否有更新
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"itunesUpdataCheck" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itunesUpdataCheck:) name:@"itunesUpdataCheck" object:nil];
    //获取当前用户可以发布动态的单位列表(含班级）
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetReleaseNewsUnits" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetReleaseNewsUnits:) name:@"GetReleaseNewsUnits" object:nil];
    //通知学校界面，切换成功身份成功，清空数组
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeCurUnit" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCurUnit:) name:@"changeCurUnit" object:nil];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
    //取指定单位的请假设置
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetLeaveSettingWithUnitId" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetLeaveSettingWithUnitId:) name:@"GetLeaveSettingWithUnitId" object:nil];
    
     [MobClick beginLogPageView:UMMESSAGE];
    [MobClick beginLogPageView:UMPAGE];
}

//取指定单位的请假设置
-(void)GetLeaveSettingWithUnitId:(NSNotification *)noti{
    D("请假系统的权限问题:%@，%@",[dm getInstance].leaveModel.StatusStd,[dm getInstance].leaveModel.StatusTea);
    //判断是否开启了学生请假系统
    if ([[dm getInstance].leaveModel.StatusStd intValue]==1) {
        //获取家长关联的学生
        [[LeaveHttp getInstance] GetMyStdInfo:[dm getInstance].jiaoBaoHao];
    }
    //判断是否开启了老师请假系统
    if ([[dm getInstance].leaveModel.StatusTea intValue]==1) {
        //获取班主任管理的班级
        [[LeaveHttp getInstance] GetMyAdminClass:[dm getInstance].jiaoBaoHao];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:UMMESSAGE];
    [MobClick endLogPageView:UMPAGE];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
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
    //导航条
    self.nav_internetAppView = [[Nav_internetAppView getInstance] initWithName:@"                                            "];
    self.nav_internetAppView.delegate = self;
    [self.view addSubview:self.nav_internetAppView];
    //top
    [self.view addSubview:[InternetAppTopScrollView shareInstance]];
    //root
    [self.view addSubview:[InternetAppRootScrollView shareInstance]];
    
    //放表格的view
    self.mView_all = [[UIView alloc] initWithFrame:CGRectMake(0, self.nav_internetAppView.frame.size.height, [dm getInstance].width, [dm getInstance].height-49-self.nav_internetAppView.frame.size.height)];
    self.mView_all.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.mView_all];
    self.mView_all.hidden = YES;
    //给弹出的uiview添加手势，点击隐藏
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressTap:)];
    tap2.delegate = self;
    [self.mView_all addGestureRecognizer:tap2];
    
    //左表格，单位
    self.mTableV_left = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [dm getInstance].width/2, 4*44)];
    self.mTableV_left.dataSource = self;
    self.mTableV_left.delegate = self;
    self.mTableV_left.tag = 100;
    self.mTableV_left.layer.borderWidth = 1;
    self.mTableV_left.layer.borderColor = [[UIColor colorWithRed:185/255.0 green:185/255.0 blue:185/255.0 alpha:1] CGColor];
    [self.mView_all addSubview:self.mTableV_left];
    self.mTableV_left.hidden = YES;
    
    //右表格，部门
    self.mTableV_right = [[UITableView alloc] initWithFrame:CGRectMake([dm getInstance].width/2, 0, [dm getInstance].width/2, 4*44)];
    self.mTableV_right.dataSource = self;
    self.mTableV_right.delegate = self;
    self.mTableV_right.tag = 101;
    self.mTableV_right.layer.borderWidth = 1;
    self.mTableV_right.layer.borderColor = [[UIColor colorWithRed:185/255.0 green:185/255.0 blue:185/255.0 alpha:1] CGColor];
    [self.mView_all addSubview:self.mTableV_right];
    self.mTableV_right.hidden = YES;
}

//是否有更新
-(void)itunesUpdataCheck:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
//    UIAlertView *createUserResponseAlert = [[UIAlertView alloc] initWithTitle:@"新版本被发现" message: @"发现新版本，如果不更新，可能会出现未知问题，是否下载最新？" delegate:self cancelButtonTitle:@"哦，不" otherButtonTitles: @"下载", nil];
//    createUserResponseAlert.delegate = self;
//    [createUserResponseAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSString *strUrl = @"https://itunes.apple.com/us/app/jiao-bao/id958950234?l=zh&ls=1&mt=8";
        NSURL *url = [NSURL URLWithString:strUrl];
        [[UIApplication sharedApplication] openURL:url];
    }
}

//检查当前网络是否可用
-(BOOL)checkNetWork{
    if([Reachability isEnableNetwork]==NO){
        [MBProgressHUD showError:NETWORKENABLE toView:self.view];
        return YES;
    }else{
        return NO;
    }
}

//通知界面，是否登录成功
-(void)loginSuccess:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSString *str = noti.object;
    D("loginSuccess-== %@",str);
    [MBProgressHUD showSuccess:str toView:self.view];
    if ([str isEqual:@"用户名或密码错误！"]) {
        [self pushMenuItem3:nil];
    }
}

//通知学校界面，切换成功身份成功，清空数组
-(void)changeCurUnit:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSString *str = noti.object;
    if ([str intValue] ==0) {//成功
        [MBProgressHUD showSuccess:@"切换成功" toView:self.view];
        [dm getInstance].leaveModel = nil;
        if ([dm getInstance].uType==2||[dm getInstance].uType==3) {//老师或家长身份时，判断有没有开启请假系统
            [[LeaveHttp getInstance] GetLeaveSettingWithUnitId:[NSString stringWithFormat:@"%d",[dm getInstance].UID]];
        }
        //应用系统通过单位ID，获取学校所有班级
        [[LeaveHttp getInstance] getunitclassWithUID:[NSString stringWithFormat:@"%d",[dm getInstance].UID]];
    }else{
        [MBProgressHUD showError:@"切换失败" toView:self.view];
    }
}

-(void)internetAppGetUserInfo:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSString *flag = noti.object;
    if ([flag integerValue]==0) {
        //检查当前网络是否可用
        if ([self checkNetWork]) {
            return;
        }
        [[InternetAppTopScrollView shareInstance] sendRequest];
        //是否隐藏加号
//        if ([dm getInstance].uType==1||[dm getInstance].uType==2) {
        [Nav_internetAppView getInstance].mBtn_add.hidden = NO;
//        }else{
//            [Nav_internetAppView getInstance].mBtn_add.hidden = YES;
//        }
    }else{
        [MBProgressHUD showError:@"获取个人信息超时" toView:self.view];
    }
}

//获取到个人信息的通知
-(void)getIdentity:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    NSMutableArray *tempArr = noti.object;
    NSString *name = @"";
    for (int i=0; i<tempArr.count; i++) {
        Identity_model *idenModel = [tempArr objectAtIndex:i];
        NSString *str_default = idenModel.DefaultUnitId;
        
        if ([idenModel.RoleIdentity intValue]==1||[idenModel.RoleIdentity intValue]==2) {
            NSMutableArray *array ;
            array = [NSMutableArray arrayWithArray:idenModel.UserUnits];
            for (int m=0; m<array.count; m++) {
                Identity_UserUnits_model *userUnitsModel = [array objectAtIndex:m];
                D("Identity_UserUnits_mode.ljl-====%@,%@",userUnitsModel.UnitID,str_default);
                if ([userUnitsModel.UnitID intValue] == [str_default intValue]) {
                    name = [NSString stringWithFormat:@"%@:%@",userUnitsModel.UnitName,[dm getInstance].name];
                    [dm getInstance].UID = [userUnitsModel.UnitID intValue];
                    [dm getInstance].uType = [idenModel.RoleIdentity intValue];
                    [dm getInstance].mStr_unit = userUnitsModel.UnitName;
                    [dm getInstance].mStr_tableID = userUnitsModel.TabIDStr;
                    break;
                }
            }
        }else if([idenModel.RoleIdentity intValue]==3||[idenModel.RoleIdentity intValue]==4){
            NSMutableArray *array ;
            array = [NSMutableArray arrayWithArray:idenModel.UserClasses];
            for (int m=0; m<array.count; m++) {
                Identity_UserClasses_model *userUnitsModel = [array objectAtIndex:m];
                if ([userUnitsModel.ClassID intValue]==[str_default intValue]) {
                    name = [NSString stringWithFormat:@"%@:%@",userUnitsModel.ClassName,[dm getInstance].name];
                    [dm getInstance].UID = [userUnitsModel.SchoolID intValue];
                    [dm getInstance].uType = [idenModel.RoleIdentity intValue];
                    [dm getInstance].mStr_unit = userUnitsModel.ClassName;
                    [dm getInstance].mStr_tableID = userUnitsModel.TabIDStr;
                    break;
                }
            }
        }else{
            [dm getInstance].uType = [idenModel.RoleIdentity intValue];
        }
        if (name.length>0)
        {
            CGSize newSize = [name sizeWithFont:[UIFont systemFontOfSize:16]];
            [Nav_internetAppView getInstance].mLab_name.text = name;
            [Nav_internetAppView getInstance].mScrollV_name.contentSize = CGSizeMake(newSize.width, 49);
            break;
        }
    }
    if (name.length==0) {
        for (int i=0; i<tempArr.count; i++) {
            Identity_model *idenModel ;
            idenModel = [tempArr objectAtIndex:i];
            NSString *name = @"";
           if ([idenModel.RoleIdentity intValue]==1||[idenModel.RoleIdentity intValue]==2) {
               NSMutableArray *array ;
                array = [NSMutableArray arrayWithArray:idenModel.UserUnits];
                if (array.count>0) {
                    Identity_UserUnits_model *userUnitsModel = [array objectAtIndex:0];
                    name = [NSString stringWithFormat:@"%@:%@",userUnitsModel.UnitName,[dm getInstance].name];
                    [dm getInstance].UID = [userUnitsModel.UnitID intValue];
                    [dm getInstance].uType = [idenModel.RoleIdentity intValue];
                    [dm getInstance].mStr_unit = userUnitsModel.UnitName;
                    [dm getInstance].mStr_tableID = userUnitsModel.TabIDStr;
                }
            }else if([idenModel.RoleIdentity intValue]==3||[idenModel.RoleIdentity intValue]==4){
                NSMutableArray *array ;
                array = [NSMutableArray arrayWithArray:idenModel.UserClasses];
                if (array.count>0) {
                    Identity_UserClasses_model *userUnitsModel = [array objectAtIndex:0];
                    name = [NSString stringWithFormat:@"%@:%@",userUnitsModel.ClassName,[dm getInstance].name];
                    [dm getInstance].UID = [userUnitsModel.SchoolID intValue];
                    [dm getInstance].uType = [idenModel.RoleIdentity intValue];
                    [dm getInstance].mStr_unit = userUnitsModel.ClassName;
                    [dm getInstance].mStr_tableID = userUnitsModel.TabIDStr;
                }
            }else{
                [dm getInstance].uType = [idenModel.RoleIdentity intValue];
            }
            if (name.length>0) {
                CGSize newSize = [name sizeWithFont:[UIFont systemFontOfSize:16]];
                [Nav_internetAppView getInstance].mLab_name.text = name;
                [Nav_internetAppView getInstance].mScrollV_name.contentSize = CGSizeMake(newSize.width, 49);
                break;
            }
        }
    }
    [[LoginSendHttp getInstance] getUserInfoWith:[dm getInstance].jiaoBaoHao UID:[NSString stringWithFormat:@"%d",[dm getInstance].UID]];
    //检查更新
    [[LoginSendHttp getInstance] login_itunesUpdataCheck];
    //获取求知中的个人信息
    [[KnowledgeHttp getInstance] GetUserInfo];
    //老师或家长身份时，判断有没有开启请假系统
    if ([dm getInstance].uType==2||[dm getInstance].uType==3) {
        [[LeaveHttp getInstance] GetLeaveSettingWithUnitId:[NSString stringWithFormat:@"%d",[dm getInstance].UID]];
    }
    //应用系统通过单位ID，获取学校所有班级
    [[LeaveHttp getInstance] getunitclassWithUID:[NSString stringWithFormat:@"%d",[dm getInstance].UID]];
}

//获取求知中的个人信息


//点击事件，点击隐藏
-(void)pressTap:(UITapGestureRecognizer *)tap{
    self.mView_all.hidden = YES;
    self.mTableV_right.hidden = YES;
    self.mTableV_left.hidden = YES;
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

//导航条按钮回调事件
-(void)Nav_internetAppViewClickBtnWith:(UIButton *)btn{
    if ([[dm getInstance].jiaoBaoHao intValue]>0) {
        if (btn.tag == 1) {//点击设置按钮
            NSArray *menuItems ;
            if ([dm getInstance].uType==3||[dm getInstance].uType==4) {
                menuItems =
                @[ [KxMenuItem menuItem:@"添加问题"
                                  image:[UIImage imageNamed:@"appNav_dongtai"]
                                 target:self
                                 action:@selector(pushMenuItem9:)],
                   [KxMenuItem menuItem:@"发布单位动态"
                                  image:[UIImage imageNamed:@"appNav_dongtai"]
                                 target:self
                                 action:@selector(pushMenuItem4:)],
                   [KxMenuItem menuItem:@"发表分享"
                                  image:[UIImage imageNamed:@"appNav_share"]
                                 target:self
                                 action:@selector(pushMenuItem5:)],
                   
                   [KxMenuItem menuItem:@"下载的附件"
                                  image:[UIImage imageNamed:@"appNav_access"]
                                 target:self
                                 action:@selector(pushMenuItem7:)],
                   
                   [KxMenuItem menuItem:@"个人中心"
                                  image:[UIImage imageNamed:@"appNav_changeUser"]
                                 target:self
                                 action:@selector(pushMenuItem8:)],
                   
                   [KxMenuItem menuItem:@"切换单位"
                                  image:[UIImage imageNamed:@"appNav_changeUnit"]
                                 target:self
                                 action:@selector(pushMenuItem2:)],
                   
                   [KxMenuItem menuItem:@"切换账号"
                                  image:[UIImage imageNamed:@"appNav_changeUser"]
                                 target:self
                                 action:@selector(pushMenuItem3:)],
                   
                   ];
            }else if ([dm getInstance].uType==1||[dm getInstance].uType==2) {
                menuItems =
                @[[KxMenuItem menuItem:@"添加问题"
                                 image:[UIImage imageNamed:@"appNav_dongtai"]
                                target:self
                                action:@selector(pushMenuItem9:)],
                  [KxMenuItem menuItem:@"新建事务"
                                 image:[UIImage imageNamed:@"appNav_work"]
                                target:self
                                action:@selector(pushMenuItem6:)],
                  
                  [KxMenuItem menuItem:@"发布单位动态"
                                 image:[UIImage imageNamed:@"appNav_dongtai"]
                                target:self
                                action:@selector(pushMenuItem4:)],
                  [KxMenuItem menuItem:@"发表分享"
                                 image:[UIImage imageNamed:@"appNav_share"]
                                target:self
                                action:@selector(pushMenuItem5:)],
                  
                  [KxMenuItem menuItem:@"下载的附件"
                                 image:[UIImage imageNamed:@"appNav_access"]
                                target:self
                                action:@selector(pushMenuItem7:)],
                  
                  [KxMenuItem menuItem:@"个人中心"
                                 image:[UIImage imageNamed:@"appNav_changeUser"]
                                target:self
                                action:@selector(pushMenuItem8:)],
                  
                  [KxMenuItem menuItem:@"切换单位"
                                 image:[UIImage imageNamed:@"appNav_changeUnit"]
                                target:self
                                action:@selector(pushMenuItem2:)],
                  
                  [KxMenuItem menuItem:@"切换账号"
                                 image:[UIImage imageNamed:@"appNav_changeUser"]
                                target:self
                                action:@selector(pushMenuItem3:)],
                  
                  ];
            }else{
                menuItems =
                @[
                  
                  [KxMenuItem menuItem:@"个人中心"
                                 image:[UIImage imageNamed:@"appNav_changeUser"]
                                target:self
                                action:@selector(pushMenuItem8:)],
                  
                  [KxMenuItem menuItem:@"切换账号"
                                 image:[UIImage imageNamed:@"appNav_changeUser"]
                                target:self
                                action:@selector(pushMenuItem3:)],
                  
                  ];
            }
            
            
            [KxMenu showMenuInView:self.view
                          fromRect:btn.frame
                         menuItems:menuItems];
        }else if (btn.tag == 2) {//点击添加按钮,让显示不同的界面时，点击出现不同的功能
            [self showMenu:btn];
        }
    }else{
        [MBProgressHUD showSuccess:@"登录成功后方可操作" toView:self.view];
    }
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 1) {
        return 2;
    }
    if ([dm getInstance].identity.count==0) {
        return 0;
    }
    if (tableView.tag == 100) {
        if([dm getInstance].tableSymbol == YES)
        {
            return 2;
        }
        return [dm getInstance].identity.count;
    }else if (tableView.tag == 101){
        Identity_model *idenModel = [[dm getInstance].identity objectAtIndex:self.mInt_defaultTV_index];
        if ([idenModel.RoleIdentity intValue]==1||[idenModel.RoleIdentity intValue]==2) {
            return idenModel.UserUnits.count;
        }else if ([idenModel.RoleIdentity intValue]==3||[idenModel.RoleIdentity intValue]==4) {
            return idenModel.UserClasses.count;
        }
    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellWithIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellWithIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    if (tableView.tag == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"切换单位";
        } else {
            cell.textLabel.text = @"切换账号";
        }
        cell.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        return cell;
    }
    if ([dm getInstance].identity.count==0) {
        return cell;
    }
    if (tableView.tag == 100) {
        Identity_model *idenModel = [[dm getInstance].identity objectAtIndex:row];
        cell.textLabel.text = idenModel.RoleIdName;
        if (self.mInt_defaultTV_index == 0&&row == 0) {
            //让自动设置为选中状态
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    } else {
        cell.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        Identity_model *idenModel = [[dm getInstance].identity objectAtIndex:self.mInt_defaultTV_index];
        if ([idenModel.RoleIdentity intValue]==1||[idenModel.RoleIdentity intValue]==2) {
            Identity_UserUnits_model *userUnitsModel = [idenModel.UserUnits objectAtIndex:row];
            cell.textLabel.text = userUnitsModel.UnitName;
        }else if ([idenModel.RoleIdentity intValue]==3||[idenModel.RoleIdentity intValue]==4) {
            Identity_UserClasses_model *userUnitsModel = [idenModel.UserClasses objectAtIndex:row];
            cell.textLabel.text = userUnitsModel.ClassName;
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    return 44;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 1) {
        if (indexPath.row== 0) {
            
        } else if(indexPath.row == 1){
            
        }
    }else if (tableView.tag == 100) {
        self.mInt_defaultTV_index = (int)indexPath.row;
        [self.mTableV_right reloadData];
        [dm getInstance].uType = (int)indexPath.row+1;
    } else if (tableView.tag == 101){
        //检查当前网络是否可用
        if ([self checkNetWork]) {
            return;
        }
        //记录当前为主动切换单位请求
        [InternetAppRootScrollView shareInstance].classView.mInt_changeUnit =1;
        Identity_model *idenModel = [[dm getInstance].identity objectAtIndex:self.mInt_defaultTV_index];
        if ([idenModel.RoleIdentity intValue]==1||[idenModel.RoleIdentity intValue]==2) {
            Identity_UserUnits_model *userUnitsModel = [idenModel.UserUnits objectAtIndex:indexPath.row];
            [dm getInstance].UID = [userUnitsModel.UnitID intValue];
            [dm getInstance].mStr_unit = userUnitsModel.UnitName;
            [dm getInstance].mStr_tableID = userUnitsModel.TabIDStr;
        }else if ([idenModel.RoleIdentity intValue]==3||[idenModel.RoleIdentity intValue]==4) {
            Identity_UserClasses_model *userUnitsModel = [idenModel.UserClasses objectAtIndex:indexPath.row];
            [dm getInstance].UID = [userUnitsModel.SchoolID intValue];
            [dm getInstance].mStr_unit = userUnitsModel.ClassName;
            [dm getInstance].mStr_tableID = userUnitsModel.TabIDStr;
        }
        [dm getInstance].uType = [idenModel.RoleIdentity intValue];
        //发送获取列表请求
        [[LoginSendHttp getInstance] changeCurUnit];
        [LoginSendHttp getInstance].mInt_forwardFlag =2;
//        [[LoginSendHttp getInstance] getUserInfoWith:[dm getInstance].jiaoBaoHao UID:[NSString stringWithFormat:@"%d",[dm getInstance].UID]];
        [MBProgressHUD showMessage:@"加载中..." toView:self.view];
        self.mView_all.hidden = YES;
        self.mTableV_right.hidden = YES;
        self.mTableV_left.hidden = YES;
        [[dm getInstance].mArr_leaveClass removeAllObjects];
        [[dm getInstance].mArr_leaveStudent removeAllObjects];
    }
}

//右上角“+”方法
- (void)showMenu:(UIButton *)sender{
    if ([[dm getInstance].jiaoBaoHao intValue]>0) {
        NSArray *menuItems0 =
        @[
          
          [KxMenuItem menuItem:@"签到考勤"
                         image:[UIImage imageNamed:@"appNav_contact"]
                        target:self
                        action:@selector(pushMenuItemSignIn:)],
          [KxMenuItem menuItem:@"日程记录"
                         image:[UIImage imageNamed:@"appNav_contact"]
                        target:self
                        action:@selector(pushMenuItemSchedule:)],
          
          ];
        //在线作业
        NSMutableArray *array = [NSMutableArray arrayWithArray:menuItems0];
        if ([dm getInstance].uType==2||[dm getInstance].uType==3||[dm getInstance].uType==4) {
            [array addObject:[self addOnLineJob]];
        }
        //请假
        if ([[dm getInstance].leaveModel.StatusStd intValue]==1||[[dm getInstance].leaveModel.StatusTea intValue]==1) {
            if ([dm getInstance].mArr_leaveStudent.count>0||[dm getInstance].uType==2) {
                [array addObject:[KxMenuItem menuItem:@"请假"
                                                image:[UIImage imageNamed:@"appNav_contact"]
                                               target:self
                                               action:@selector(pushMenuItemLeave:)]];
            }
        }
        //审核
        if ([[dm getInstance].leaveModel.ApproveListStd.A isEqual:@"True"]||[[dm getInstance].leaveModel.ApproveListStd.B isEqual:@"True"]||[[dm getInstance].leaveModel.ApproveListStd.C isEqual:@"True"]||[[dm getInstance].leaveModel.ApproveListStd.D isEqual:@"True"]||[[dm getInstance].leaveModel.ApproveListStd.E isEqual:@"True"]||[[dm getInstance].leaveModel.ApproveListTea.A isEqual:@"True"]||[[dm getInstance].leaveModel.ApproveListTea.B isEqual:@"True"]||[[dm getInstance].leaveModel.ApproveListTea.C isEqual:@"True"]||[[dm getInstance].leaveModel.ApproveListTea.D isEqual:@"True"]||[[dm getInstance].leaveModel.ApproveListTea.E isEqual:@"True"]||[[dm getInstance].leaveModel.GateGuardList intValue]==1||[[dm getInstance].userInfo.isAdmin intValue]==2||[[dm getInstance].userInfo.isAdmin intValue]==3) {
            [array addObject:[KxMenuItem menuItem:@"审核"
                                            image:[UIImage imageNamed:@"appNav_contact"]
                                           target:self
                                           action:@selector(pushMenuItemCheckLeave:)]];
        }
        
        NSArray *menuItems = array;
        D("iudhfgjhjh-==========%d",[dm getInstance].uType);
        [KxMenu showMenuInView:self.view
                      fromRect:sender.frame
                     menuItems:menuItems];
    }else{
        [MBProgressHUD showSuccess:@"登录成功后方可操作" toView:self.view];
    }
}
-(void)leaveAction{
    TeacherViewController *detail = [[TeacherViewController alloc] init];
    [utils pushViewController:detail animated:YES];
}
-(KxMenuItem *)addOnLineJob{
    if ([dm getInstance].uType==2) {
        return [KxMenuItem menuItem:@"作业布置"
                       image:[UIImage imageNamed:@"appNav_contact"]
                      target:self
                      action:@selector(makeJob:)];
    }else if ([dm getInstance].uType==3){
        return [KxMenuItem menuItem:@"家长查询"
                       image:[UIImage imageNamed:@"appNav_contact"]
                      target:self
                      action:@selector(parentSearch:)];
    }else if ([dm getInstance].uType==4){
        return [KxMenuItem menuItem:@"我的作业"
                       image:[UIImage imageNamed:@"appNav_contact"]
                      target:self
                      action:@selector(myJob:)];
    }
    return nil;
}
- (void) pushMenuItemSignIn:(id)sender{
    [MobClick event:@"InternetApplications_add" label:@"签到考勤"];
    CheckingInViewController *check = [[CheckingInViewController alloc]init];
    check.mView_all = self.mView_all;
    check.mTableV_left = self.mTableV_left;
    check.mTableV_right = self.mTableV_right;
    [utils pushViewController:check animated:YES];
}

- (void) pushMenuItemSchedule:(id)sender{
    [MobClick event:@"InternetApplications_add" label:@"日程记录"];

    SignInViewController *signIn = [[SignInViewController alloc] init];
    [utils pushViewController:signIn animated:YES];
}

//请假
- (void) pushMenuItemLeave:(id)sender{
//    TeacherViewController *detail = [[TeacherViewController alloc] init];
//    [utils pushViewController:detail animated:YES];
    LeaveViewController *leave = [[LeaveViewController alloc] init];
    if ([dm getInstance].uType==3) {
        leave.mStr_navName = @"家长";
        leave.mInt_leaveID = 3;
    }else if ([[dm getInstance].leaveModel.GateGuardList intValue]==1) {
        leave.mStr_navName = @"门卫";
        leave.mInt_leaveID = 0;
    }else if ([[dm getInstance].userInfo.isAdmin intValue]==2||[[dm getInstance].userInfo.isAdmin intValue]==3){
        leave.mStr_navName = @"班主任";
        leave.mInt_leaveID = 1;
    }else{
        leave.mStr_navName = @"老师";
        leave.mInt_leaveID = 2;
    }
    [utils pushViewController:leave animated:YES];
}

//审核
-(void) pushMenuItemCheckLeave:(id)sender{
    CheckLeaveViewController *checkLeave = [[CheckLeaveViewController alloc] init];
    checkLeave.mStr_navName = @"审核";
    [utils pushViewController:checkLeave animated:YES];
}

//我的作业
-(void)myJob:(id)sender{
    StudentHomewrokViewController *view = [[StudentHomewrokViewController alloc] init];
    [utils pushViewController:view animated:YES];
}

-(void)parentSearch:(id)sender{
    ParentSearchViewController *view = [[ParentSearchViewController alloc] init];
    [utils pushViewController:view animated:YES];
}

//作业布置
-(void)makeJob:(id)sender{
    MakeJobViewController *makeJob = [[MakeJobViewController alloc] init];
    [utils pushViewController:makeJob animated:YES];
}

//附件
- (void) pushMenuItem7:(id)sender{
    [MobClick event:@"InternetApplications_more" label:@"下载的附件"];
    AccessoryViewController *access = [[AccessoryViewController alloc] init];
    access.mInt_flag = 1;
//    access.delegate = self;
    [utils pushViewController:access animated:YES];
}

//切换单位
- (void) pushMenuItem2:(id)sender{
    [MobClick event:@"InternetApplications_more" label:@"切换单位"];
    self.mView_all.hidden = NO;
    self.mTableV_left.hidden = NO;
    self.mTableV_right.hidden = NO;
    [dm getInstance].leaveModel = nil;
    //self.mView_all.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.mView_all];
    [self.mTableV_left reloadData];
    [self.mTableV_right reloadData];
}
//切换账号
- (void) pushMenuItem3:(id)sender{
    
    [MobClick event:@"InternetApplications_more" label:@"切换账号"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //发送注销登录请求
    [[LoginSendHttp getInstance] loginHttpLogout];
    RegisterViewController *mRegister_view = [[RegisterViewController alloc]init];
    [LoginSendHttp getInstance].flag_skip = 1;
    //将InternetAppTopScrollView中的请求数据时的标志归零
    [InternetAppTopScrollView shareInstance].mInt_share = 0;
    [InternetAppTopScrollView shareInstance].mInt_show = 0;
    [InternetAppTopScrollView shareInstance].mInt_show2 = 0;
    [InternetAppTopScrollView shareInstance].mInt_theme = 0;
    [InternetAppTopScrollView shareInstance].mInt_work_sendToMe = 0;
    [InternetAppTopScrollView shareInstance].mInt_work_mysend = 0;
    [dm getInstance].mStr_unit = @"暂无";
    [dm getInstance].name = @"新用户";
    [dm getInstance].url = @"";
    [dm getInstance].UID = 0;
    [[dm getInstance].identity removeAllObjects];
    [dm getInstance].jiaoBaoHao = @"";
    [dm getInstance].leaveModel = nil;
    
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"PassWD"];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"Register"];
    //通知界面，更新数据
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RegisterView" object:nil];
    [Nav_internetAppView getInstance].mLab_name.text = @"";
    [utils pushViewController:mRegister_view animated:NO];
}

//发表文章动态
- (void) pushMenuItem4:(id)sender{
    [MobClick event:@"InternetApplications_more" label:@"发布单位动态"];
    self.mView_all.hidden = YES;
    self.mTableV_left.hidden = YES;
    self.mTableV_right.hidden = YES;
    //self.mView_all.backgroundColor = [UIColor redColor];
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    [[ClassHttp getInstance] classHttpGetReleaseNewsUnits];
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
}

//发表文章分享
- (void) pushMenuItem5:(id)sender{
    [MobClick event:@"InternetApplications_more" label:@"发布分享"];
    self.mView_all.hidden = YES;
    self.mTableV_left.hidden = YES;
    self.mTableV_right.hidden = YES;
    //self.mView_all.backgroundColor = [UIColor redColor];
    
    UnitSectionMessageModel *model = [[UnitSectionMessageModel alloc] init];
    model.UnitID = [NSString stringWithFormat:@"%d",[dm getInstance].UID];
    model.UnitType = [NSString stringWithFormat:@"%d",[dm getInstance].uType];
    SharePostingViewController *posting = [[SharePostingViewController alloc] init];
    posting.mModel_unit = model;
    posting.mInt_section = 0;
//    posting.mStr_uType = [NSString stringWithFormat:@"%d",[dm getInstance].uType];
//    posting.mStr_unitID = [NSString stringWithFormat:@"%d",[dm getInstance].UID];
    [utils pushViewController:posting animated:YES];
}

//新建事务
- (void) pushMenuItem6:(id)sender{
    [MobClick event:@"InternetApplications_more" label:@"新建事务"];
    //记录当前为被动切换单位请求
    [InternetAppRootScrollView shareInstance].classView.mInt_changeUnit =0;
    self.mView_all.hidden = YES;
    self.mTableV_left.hidden = YES;
    self.mTableV_right.hidden = YES;
    
    
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    D("点击新建事务、发布通知按钮");

    NewWorkViewController *newWork = [[NewWorkViewController alloc] init];
    [utils pushViewController:newWork animated:YES];
}

//个人中心
-(void)pushMenuItem8:(id)sender{
    [MobClick event:@"InternetApplications_more" label:@"个人中心"];
    self.mView_all.hidden = YES;
    self.mTableV_left.hidden = YES;
    self.mTableV_right.hidden = YES;
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    PeopleSpaceViewController *view = [[PeopleSpaceViewController alloc] init];
    [utils pushViewController:view animated:YES];
}
-(void)pushMenuItem9:(id)sender
{
    JoinUnit
    NoNickName
    AddQuestionViewController *addQuestionVC = [[AddQuestionViewController alloc]init];
    [utils pushViewController:addQuestionVC animated:YES];
}

//获取当前用户可以发布动态的单位列表(含班级）
-(void)GetReleaseNewsUnits:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSDictionary *dic = noti.object;
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
    NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
    [MBProgressHUD hideHUDForView:self.view];
    if([ResultCode integerValue]!=0)
    {
        [MBProgressHUD showSuccess:ResultDesc toView:self.view];
        return;
    }
    NSMutableArray *array = [dic objectForKey:@"array"];
    if (array.count==0) {
        [MBProgressHUD showSuccess:@"没有权限" toView:self.view];
    }else{
//        UnitSectionMessageModel *model = [[UnitSectionMessageModel alloc] init];
//        model.UnitID = [NSString stringWithFormat:@"%d",[dm getInstance].UID];
//        model.UnitType = [NSString stringWithFormat:@"%d",[dm getInstance].uType];
        SharePostingViewController *posting = [[SharePostingViewController alloc] init];
//        posting.mModel_unit = model;
        posting.mInt_section = 1;
        posting.mArr_dynamic = array;//*
//        posting.mStr_uType = [NSString stringWithFormat:@"%d",[dm getInstance].uType];
//        posting.mStr_unitID = [NSString stringWithFormat:@"%d",[dm getInstance].UID];
        [utils pushViewController:posting animated:YES];
    }
}

//右上角+，分享
-(void)shareAddMenu:(UIButton *)sender{
    NSArray *array = @[[KxMenuItem menuItem:@"好友空间" image:nil target:self action:@selector(shareAdd2:)],
                       [KxMenuItem menuItem:@"关注空间" image:nil target:self action:@selector(shareAdd3:)],];
    [KxMenu showMenuInView:self.view
                  fromRect:sender.frame
                 menuItems:array];
}

-(void)shareAdd2:(id)sender{
    //进入好友列表
    MyFriendsViewController *friends = [[MyFriendsViewController alloc] init];
    friends.mStr_title = @"好友空间";
    friends.mInt_flag = 1;
    [utils pushViewController:friends animated:YES];
}
-(void)shareAdd3:(id)sender{//进入关注好友空间列表
    MyFriendsViewController *friends = [[MyFriendsViewController alloc] init];
    friends.mStr_title = @"关注空间";
    friends.mInt_flag = 2;
    [utils pushViewController:friends animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // 清除内存中的图片缓存
//    [[SDImageCache sharedImageCache] clearMemory];
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
