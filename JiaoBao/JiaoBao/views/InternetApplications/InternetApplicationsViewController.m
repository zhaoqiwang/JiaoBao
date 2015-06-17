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


@interface InternetApplicationsViewController ()

@end

@implementation InternetApplicationsViewController
@synthesize nav_internetAppView,mTableV_left,mTableV_right,mView_all,mInt_defaultTV_index,mProgressV,mInt_flag;

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(internetAppGetUserInfo) name:@"internetAppGetUserInfo" object:nil];
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
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
    
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
    
    self.mProgressV = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.mProgressV];
    self.mProgressV.delegate = self;
}

//是否有更新
-(void)itunesUpdataCheck:(NSNotification *)noti{
    UIAlertView *createUserResponseAlert = [[UIAlertView alloc] initWithTitle:@"新版本被发现" message: @"发现新版本，如果不更新，可能会出现未知问题，是否下载最新？" delegate:self cancelButtonTitle:@"哦，不" otherButtonTitles: @"下载", nil];
    createUserResponseAlert.delegate = self;
    [createUserResponseAlert show];
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
        self.mProgressV.mode = MBProgressHUDModeCustomView;
        self.mProgressV.labelText = NETWORKENABLE;
        [self.mProgressV show:YES];
        [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
        return YES;
    }else{
        return NO;
    }
}

//通知界面，是否登录成功
-(void)loginSuccess:(NSNotification *)noti{
    NSString *str = noti.object;
    D("loginSuccess-== %@",str);
    self.mProgressV.labelText = str;
    self.mProgressV.mode = MBProgressHUDModeCustomView;
    [self.mProgressV show:YES];
    [self.mProgressV showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    if ([str isEqual:@"用户名或密码错误！"]) {
        [self pushMenuItem3:nil];
    }
}

-(void)myTask{
    sleep(2);
}

-(void)internetAppGetUserInfo{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    [self.mProgressV hide:YES];
    [[InternetAppTopScrollView shareInstance] sendRequest];
    //是否隐藏加号
    if ([dm getInstance].uType==1||[dm getInstance].uType==2) {
        [Nav_internetAppView getInstance].mBtn_add.hidden = NO;
    }else{
        [Nav_internetAppView getInstance].mBtn_add.hidden = YES;
    }
}

//获取到个人信息的通知
-(void)getIdentity:(NSNotification *)noti{
    [self.mProgressV hide:YES];
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
}

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
    D("点击的button是  %ld",(long)btn.tag);
    if (btn.tag == 1) {//点击设置按钮
        NSArray *menuItems ;
        if ([dm getInstance].uType==3||[dm getInstance].uType==4) {
            menuItems =
            @[
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
        }
        
        
        [KxMenu showMenuInView:self.view
                      fromRect:btn.frame
                     menuItems:menuItems];
    }else if (btn.tag == 2) {//点击添加按钮,让显示不同的界面时，点击出现不同的功能
//        if ([InternetAppRootScrollView shareInstance].mInt == 0) {//交流
            [self showMenu:btn];
//        }else if ([InternetAppRootScrollView shareInstance].mInt == 1) {//分享
//            [self shareAddMenu:btn];
//        }
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
        }else if ([idenModel.RoleIdentity intValue]==3) {
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
        }else if ([idenModel.RoleIdentity intValue]==3) {
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
        }else if ([idenModel.RoleIdentity intValue]==3) {
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
        self.mProgressV.labelText = @"加载中...";
        self.mProgressV.mode = MBProgressHUDModeIndeterminate;
//        self.mProgressV.userInteractionEnabled = NO;
        [self.mProgressV show:YES];
        [self.mProgressV showWhileExecuting:@selector(Loading) onTarget:self withObject:nil animated:YES];
        self.mView_all.hidden = YES;
        self.mTableV_right.hidden = YES;
        self.mTableV_left.hidden = YES;
    }
}
- (void)Loading{
    sleep(TIMEOUT);
    self.mProgressV.mode = MBProgressHUDModeCustomView;
    self.mProgressV.labelText = @"加载超时";
    self.mProgressV.userInteractionEnabled = NO;
    sleep(2);
}

-(void)noMore{
    sleep(1);
}
//右上角“+”方法
- (void)showMenu:(UIButton *)sender{
    NSArray *menuItems =
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
    
//    KxMenuItem *first = menuItems[0];
//    first.foreColor = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
//    first.alignment = NSTextAlignmentCenter;
    
    [KxMenu showMenuInView:self.view
                  fromRect:sender.frame
                 menuItems:menuItems];
}
- (void) pushMenuItemSignIn:(id)sender{
    CheckingInViewController *check = [[CheckingInViewController alloc]init];
    check.mView_all = self.mView_all;
    check.mTableV_left = self.mTableV_left;
    check.mTableV_right = self.mTableV_right;
    [utils pushViewController:check animated:YES];
}

- (void) pushMenuItemSchedule:(id)sender{
    SignInViewController *signIn = [[SignInViewController alloc] init];
    [utils pushViewController:signIn animated:YES];
}

//附件
- (void) pushMenuItem7:(id)sender{
    AccessoryViewController *access = [[AccessoryViewController alloc] init];
    access.mInt_flag = 1;
//    access.delegate = self;
    [utils pushViewController:access animated:YES];
}

//切换单位
- (void) pushMenuItem2:(id)sender{
    self.mView_all.hidden = NO;
    self.mTableV_left.hidden = NO;
    self.mTableV_right.hidden = NO;
    //self.mView_all.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.mView_all];
    [self.mTableV_left reloadData];
    [self.mTableV_right reloadData];
}
//切换账号
- (void) pushMenuItem3:(id)sender{
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
    [dm getInstance].mStr_unit = @"";
    [dm getInstance].name = @"";
    [dm getInstance].url = @"";
    [dm getInstance].UID = 0;
    
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"PassWD"];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"Register"];
    //通知界面，更新数据
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RegisterView" object:nil];
    [Nav_internetAppView getInstance].mLab_name.text = @"";
    [utils pushViewController:mRegister_view animated:NO];
}

//发表文章动态
- (void) pushMenuItem4:(id)sender{
    self.mView_all.hidden = YES;
    self.mTableV_left.hidden = YES;
    self.mTableV_right.hidden = YES;
    //self.mView_all.backgroundColor = [UIColor redColor];
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    [[ClassHttp getInstance] classHttpGetReleaseNewsUnits];
    self.mProgressV.labelText = @"加载中...";
    self.mProgressV.mode = MBProgressHUDModeIndeterminate;
    [self.mProgressV show:YES];
    [self.mProgressV showWhileExecuting:@selector(Loading) onTarget:self withObject:nil animated:YES];
}

//发表文章分享
- (void) pushMenuItem5:(id)sender{
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

//获取当前用户可以发布动态的单位列表(含班级）
-(void)GetReleaseNewsUnits:(NSNotification *)noti{
    [self.mProgressV hide:YES];
    NSDictionary *dic = noti.object;
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
    NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
    
    if([ResultCode integerValue]!=0)
    {
        self.mProgressV.mode = MBProgressHUDModeCustomView;
        self.mProgressV.labelText = ResultDesc;
        [self.mProgressV show:YES];
        [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
        return;
    }
    NSMutableArray *array = [dic objectForKey:@"array"];
    if (array.count==0) {
        self.mProgressV.labelText = @"没有权限";
        self.mProgressV.mode = MBProgressHUDModeCustomView;
        [self.mProgressV show:YES];
        [self.mProgressV showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
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

-(void)shareAdd2:(id)sender{//进入好友列表
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
