//
//  TeacherSignInViewController.m
//  JiaoBao
//
//  Created by Zqw on 17/11/3.
//  Copyright © 2017年 JSY. All rights reserved.
//

#import "TeacherSignInViewController.h"
#import "Reachability.h"
#import <UMAnalytics/MobClick.h>
#import "UIImageView+WebCache.h"
#import "CheckSignInViewController.h"

@interface TeacherSignInViewController ()
@property(nonatomic,weak)UITextField *currTF;
@end

@implementation TeacherSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //签到回调
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UnitSignIn" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UnitSignIn:) name:@"UnitSignIn" object:nil];
    // Do any additional setup after loading the view from its nib.
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"签到"];
    [self.mNav_navgationBar setRightBtnTitle:@"查询"];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    if ([dm getInstance].statusBar>20) {
        self.mTableV_detailist.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height);
    } else {
        self.mTableV_detailist.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height-[dm getInstance].statusBar, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height+[dm getInstance].statusBar);
    }
    
    self.mTableV_detailist.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
//    self.automaticallyAdjustsScrollViewInsets = false;

    //添加表格的下拉刷新
//    [self.mTableV_detailist addHeaderWithTarget:self action:@selector(headerRereshing)];
//    self.mTableV_detailist.headerPullToRefreshText = @"下拉刷新";
//    self.mTableV_detailist.headerReleaseToRefreshText = @"松开后刷新";
//    self.mTableV_detailist.headerRefreshingText = @"正在刷新...";
    
    //合并教育局和老师身份的单数数组
    self.mArr_detail = [[NSMutableArray alloc] init];
    for (int i=0; i<[dm getInstance].identity.count; i++) {
        Identity_model *idenModel = [dm getInstance].identity[i];
        if ([idenModel.RoleIdentity intValue]==1||[idenModel.RoleIdentity intValue]==2) {
            for (int m = 0; m<idenModel.UserUnits.count; m++) {
                Identity_UserUnits_model *model = idenModel.UserUnits[m];
                model.flag = 0;
                [self.mArr_detail addObject:model];
            }
        }
    }
    
    //发送获取请求
//    [self firstSendHttp];
}

-(void)UnitSignIn:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSMutableDictionary *dic = noti.object;
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
    NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
    if ([ResultCode intValue] == 0 || [ResultDesc isEqualToString:@"该时段内用户已经签到成功，无需重复签到！"]) {
        [MBProgressHUD showError:ResultDesc toView:self.view];
        Identity_UserUnits_model *model = self.mArr_detail[self.mInt_tag];
        model.flag = 1;
        [self.mTableV_detailist reloadData];
    } else {
        [MBProgressHUD showError:ResultDesc toView:self.view];
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

//发送获取请求
-(void)firstSendHttp{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    [MBProgressHUD showMessage:@"" toView:self.view];
    self.mInt_page = 1;
    
}
//发送获取请求
//-(void)sendhttpRequest{
//    //检查当前网络是否可用
//    if ([self checkNetWork]) {
//        return;
//    }
//    if (self.mInt_refresh == 1) {//1是加载，2是刷新
//        [self firstSendHttp];
//    } else if (self.mInt_refresh == 2){//1是加载，2是刷新
//        if (self.mArr_detail.count>=20) {
//            self.mInt_page = (int)self.mArr_detail.count/20+1;
//            D("self.mint.page-====%lu %d",(unsigned long)self.mArr_detail.count,self.mInt_page);
//            
//            
//            [MBProgressHUD showMessage:@"" toView:self.view];
//        } else {
//            [self.mTableV_detailist footerEndRefreshing];
//            [MBProgressHUD showError:@"没有更多了" toView:self.view];
//        }
//    }
//}

//通知界面刷新消息cell头像
//-(void)UnReadMsgCellImg:(NSNotification *)noti{
//    [MBProgressHUD hideHUDForView:self.view];
//    [self.mTableV_detailist reloadData];
//}

//通知界面刷新消息cell
//-(void)UnReadMsgCell:(NSNotification *)noti{
//    [self.mTableV_detailist headerEndRefreshing];
//    [self.mTableV_detailist footerEndRefreshing];
//    [MBProgressHUD hideHUDForView:self.view];
//    NSMutableDictionary *dic = noti.object;
//    NSString *flag = [dic objectForKey:@"flag"];
//    if ([flag integerValue]==0) {
//        NSMutableArray *array = [dic valueForKey:@"array"];
//        if (self.mInt_page == 1) {
//            if (array.count>0) {
//                [self.mArr_detail removeAllObjects];
//                self.mArr_detail = [NSMutableArray arrayWithArray:array];
//            }
//            if (array.count==20) {
//                [self.mTableV_detailist addFooterWithTarget:self action:@selector(footerRereshing)];
//                self.mTableV_detailist.footerPullToRefreshText = @"上拉加载更多";
//                self.mTableV_detailist.footerReleaseToRefreshText = @"松开加载更多数据";
//                self.mTableV_detailist.footerRefreshingText = @"正在加载...";
//            }
//        }else{
//            if (array.count>0) {
//                for (int i=0; i<array.count; i++) {
//                    UnReadMsg_model *unReadMsgModel = [array objectAtIndex:i];
//                    [self.mArr_detail addObject:unReadMsgModel];
//                }
//            }
//            if (array.count<20) {
//                [self.mTableV_detailist removeFooter];
//            }
//        }
//        [self.mTableV_detailist reloadData];
//    }else{
//        [MBProgressHUD showError:@"获取失败" toView:self.view];
//    }
//}
//导航条返回按钮
-(void)myNavigationGoback{
    [utils popViewControllerAnimated:YES];
}

-(void)navigationRightAction:(UIButton *)sender{
    D("签到查询按钮");
    CheckSignInViewController *checkVC = [[CheckSignInViewController alloc]initWithNibName:@"CheckSignInViewController" bundle:nil];
    [self.navigationController pushViewController:checkVC animated:YES];
}

#pragma mark 开始进入刷新状态
//- (void)headerRereshing{
//    self.mInt_refresh = 1;
//    [self sendhttpRequest];
//}
//
//- (void)footerRereshing{
//    self.mInt_refresh = 2;
//    [self sendhttpRequest];
//}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mArr_detail.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"TeacherSignInTableViewCell";
    TeacherSignInTableViewCell *cell2 = (TeacherSignInTableViewCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell2 == nil) {
        cell2 = [[TeacherSignInTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TeacherSignInTableViewCell" owner:self options:nil];
        //这时myCell对象已经通过自定义xib文件生成了
        if ([nib count]>0) {
            cell2 = (TeacherSignInTableViewCell *)[nib objectAtIndex:0];
            //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
        }
        //添加图片点击事件
        //若是需要重用，需要写上以下两句代码
        UINib * n= [UINib nibWithNibName:@"TeacherSignInTableViewCell" bundle:[NSBundle mainBundle]];
        [self.mTableV_detailist registerNib:n forCellReuseIdentifier:indentifier];
    }
    Identity_UserUnits_model *unReadMsgModel = [self.mArr_detail objectAtIndex:indexPath.row];
    cell2.mLab_name.text = unReadMsgModel.UnitName;
    cell2.mBtn_signIn.layer.cornerRadius = 5;
    cell2.mBtn_signIn.tag = indexPath.row;
    if (unReadMsgModel.flag == 0) {
        [cell2.mBtn_signIn setTitle:@"未签到" forState:UIControlStateNormal];
        [cell2.mBtn_signIn setBackgroundColor:[UIColor orangeColor]];
    } else {
        [cell2.mBtn_signIn setTitle:@"已签到" forState:UIControlStateNormal];
         [cell2.mBtn_signIn setBackgroundColor:[UIColor brownColor]];
    }
    cell2.mBtn_signIn.frame = CGRectMake([dm getInstance].width-cell2.mBtn_signIn.frame.size.width-20, cell2.mBtn_signIn.frame.origin.y, cell2.mBtn_signIn.frame.size.width, cell2.mBtn_signIn.frame.size.height);
    [cell2.mBtn_signIn addTarget:self action:@selector(clickSignInBtn:) forControlEvents:UIControlEventTouchUpInside];
    //若是回复我的，显示回复内容
//    if (unReadMsgModel.MsgTabIDStr.length>0) {
//        cell2.mLab_detail.text = unReadMsgModel.FeeBackMsg;
//    }else{
//        cell2.mLab_detail.text = unReadMsgModel.MsgContent;
//    }
//    cell2.mLab_time.text = unReadMsgModel.RecDate;
//    cell2.mLab_time.frame = CGRectMake([dm getInstance].width-cell2.mLab_time.frame.size.width-20, cell2.mLab_time.frame.origin.y, cell2.mLab_time.frame.size.width, cell2.mLab_time.frame.size.height);
//    [cell2.mImgV_head sd_setImageWithURL:(NSURL *)[NSString stringWithFormat:@"%@%@",AccIDImg,unReadMsgModel.JiaoBaoHao] placeholderImage:[UIImage  imageNamed:@"root_img"]];
    
    return cell2;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    return 50;
}

-(void)clickSignInBtn:(UIButton *)sender{
    self.mInt_tag = (int)sender.tag;
    Identity_UserUnits_model *model = [self.mArr_detail objectAtIndex:self.mInt_tag];
    [[SignInHttp getInstance] setSign:model.UnitID];
    [MBProgressHUD showMessage:@"" toView:self.view];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    UnReadMsg_model *unReadMsgModel = [self.mArr_detail objectAtIndex:indexPath.row];
//    TreeView_Level2_Model *nodeData = [[TreeView_Level2_Model alloc] init];
//    nodeData.mStr_MsgTabIDStr = unReadMsgModel.MsgTabIDStr;
//    nodeData.mStr_TabIDStr = unReadMsgModel.TabIDStr;
//    MsgDetailViewController *msgDetailVC = [[MsgDetailViewController alloc] init];
//    msgDetailVC.mModel_tree2 = nodeData;
//    [utils pushViewController:msgDetailVC animated:YES];
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
