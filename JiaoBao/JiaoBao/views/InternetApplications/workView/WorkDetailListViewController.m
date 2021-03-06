//
//  WorkDetailListViewController.m
//  JiaoBao
//
//  Created by Zqw on 14-11-3.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "WorkDetailListViewController.h"
#import "Reachability.h"
#import "MobClick.h"
#import "UIImageView+WebCache.h"
@interface WorkDetailListViewController ()

@end

@implementation WorkDetailListViewController
@synthesize mTableV_detailist,mArr_detail,mInt_page,mInt_tag,mNav_navgationBar,mStr_navName,mStr_url,mInt_refresh;



-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [MobClick endLogPageView:UMMESSAGE];
    [MobClick endLogPageView:UMPAGE];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:UMMESSAGE];
    [MobClick beginLogPageView:UMPAGE];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
    //通知界面刷新消息cell
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UnReadMsgCell" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UnReadMsgCell:) name:@"UnReadMsgCell" object:nil];
    //通知界面刷新消息cell头像
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UnReadMsgCellImg" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UnReadMsgCellImg:) name:@"UnReadMsgCellImg" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:self.mStr_navName];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    
    self.mTableV_detailist.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height-[dm getInstance].statusBar, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height+[dm getInstance].statusBar);
    //添加表格的下拉刷新
    [self.mTableV_detailist addHeaderWithTarget:self action:@selector(headerRereshing)];
    self.mTableV_detailist.headerPullToRefreshText = @"下拉刷新";
    self.mTableV_detailist.headerReleaseToRefreshText = @"松开后刷新";
    self.mTableV_detailist.headerRefreshingText = @"正在刷新...";
    
    self.mArr_detail = [[NSMutableArray alloc] init];
    
    //发送获取请求
    [self firstSendHttp];
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
    if (self.mInt_tag == 6||self.mInt_tag == 7||self.mInt_tag == 8||self.mInt_tag == 9||self.mInt_tag == 4) {
        D("111111111");
        //获取发给我的待处理信息
        [[LoginSendHttp getInstance] wait_unReadMsgWithTag:self.mInt_tag page:[NSString stringWithFormat:@"%d",self.mInt_page]];
    }else if (self.mInt_tag == 2){//获取自己发出的信息
        [[LoginSendHttp getInstance] getMyselfSendMsgWithPage:[NSString stringWithFormat:@"%d",self.mInt_page]];
    }
}
//发送获取请求
-(void)sendhttpRequest{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    if (self.mInt_refresh == 1) {
        [self firstSendHttp];
    } else if (self.mInt_refresh == 2){
        if (self.mArr_detail.count>=20) {
            self.mInt_page = (int)self.mArr_detail.count/20+1;
            D("self.mint.page-====%lu %d",(unsigned long)self.mArr_detail.count,self.mInt_page);
            if (self.mInt_tag == 6||self.mInt_tag == 7||self.mInt_tag == 8||self.mInt_tag == 9||self.mInt_tag == 4) {
                D("111111111");
                //获取发给我的待处理信息
                [[LoginSendHttp getInstance] wait_unReadMsgWithTag:self.mInt_tag page:[NSString stringWithFormat:@"%d",self.mInt_page]];
            }else if (self.mInt_tag == 2){//获取自己发出的信息
                [[LoginSendHttp getInstance] getMyselfSendMsgWithPage:[NSString stringWithFormat:@"%d",self.mInt_page]];
            }
            
            [MBProgressHUD showMessage:@"" toView:self.view];
        } else {
            [self.mTableV_detailist footerEndRefreshing];
            [MBProgressHUD showError:@"没有更多了" toView:self.view];
        }
    }
}

//通知界面刷新消息cell头像
-(void)UnReadMsgCellImg:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    [self.mTableV_detailist reloadData];
}

//通知界面刷新消息cell
-(void)UnReadMsgCell:(NSNotification *)noti{
    [self.mTableV_detailist headerEndRefreshing];
    [self.mTableV_detailist footerEndRefreshing];
    [MBProgressHUD hideHUDForView:self.view];
    NSMutableDictionary *dic = noti.object;
    NSString *flag = [dic objectForKey:@"flag"];
    if ([flag integerValue]==0) {
        NSMutableArray *array = [dic valueForKey:@"array"];
        if (self.mInt_page == 1) {
            if (array.count>0) {
                [self.mArr_detail removeAllObjects];
                self.mArr_detail = [NSMutableArray arrayWithArray:array];
            }
            if (array.count==20) {
                [self.mTableV_detailist addFooterWithTarget:self action:@selector(footerRereshing)];
                self.mTableV_detailist.footerPullToRefreshText = @"上拉加载更多";
                self.mTableV_detailist.footerReleaseToRefreshText = @"松开加载更多数据";
                self.mTableV_detailist.footerRefreshingText = @"正在加载...";
            }
        }else{
            if (array.count>0) {
                for (int i=0; i<array.count; i++) {
                    UnReadMsg_model *unReadMsgModel = [array objectAtIndex:i];
                    [self.mArr_detail addObject:unReadMsgModel];
                }
            }
            if (array.count<20) {
                [self.mTableV_detailist removeFooter];
            }
        }
        [self.mTableV_detailist reloadData];
    }else{
        [MBProgressHUD showError:@"获取失败" toView:self.view];
    }
}
//导航条返回按钮
-(void)myNavigationGoback{
    [utils popViewControllerAnimated:YES];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing{
    self.mInt_refresh = 1;
    [self sendhttpRequest];
}

- (void)footerRereshing{
    self.mInt_refresh = 2;
    [self sendhttpRequest];
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mArr_detail.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"TreeView_Level2_Cell";
    TreeView_Level2_Cell *cell2 = (TreeView_Level2_Cell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell2 == nil) {
        cell2 = [[TreeView_Level2_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TreeView_Level2_Cell" owner:self options:nil];
        //这时myCell对象已经通过自定义xib文件生成了
        if ([nib count]>0) {
            cell2 = (TreeView_Level2_Cell *)[nib objectAtIndex:0];
            //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
        }
        //添加图片点击事件
        //若是需要重用，需要写上以下两句代码
        UINib * n= [UINib nibWithNibName:@"TreeView_Level2_Cell" bundle:[NSBundle mainBundle]];
        [self.mTableV_detailist registerNib:n forCellReuseIdentifier:indentifier];
    }
    UnReadMsg_model *unReadMsgModel = [self.mArr_detail objectAtIndex:indexPath.row];
    cell2.mLab_name.text = unReadMsgModel.UserName;
    //若是回复我的，显示回复内容
    if (unReadMsgModel.MsgTabIDStr.length>0) {
        cell2.mLab_detail.text = unReadMsgModel.FeeBackMsg;
    }else{
        cell2.mLab_detail.text = unReadMsgModel.MsgContent;
    }
    cell2.mLab_time.text = unReadMsgModel.RecDate;
    cell2.mLab_time.frame = CGRectMake([dm getInstance].width-cell2.mLab_time.frame.size.width-20, cell2.mLab_time.frame.origin.y, cell2.mLab_time.frame.size.width, cell2.mLab_time.frame.size.height);
    [cell2.mImgV_head sd_setImageWithURL:(NSURL *)[NSString stringWithFormat:@"%@%@",AccIDImg,unReadMsgModel.JiaoBaoHao] placeholderImage:[UIImage  imageNamed:@"root_img"]];

    return cell2;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    return 65;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UnReadMsg_model *unReadMsgModel = [self.mArr_detail objectAtIndex:indexPath.row];
    TreeView_Level2_Model *nodeData = [[TreeView_Level2_Model alloc] init];
    nodeData.mStr_MsgTabIDStr = unReadMsgModel.MsgTabIDStr;
    nodeData.mStr_TabIDStr = unReadMsgModel.TabIDStr;
    MsgDetailViewController *msgDetailVC = [[MsgDetailViewController alloc] init];
    msgDetailVC.mModel_tree2 = nodeData;
    [utils pushViewController:msgDetailVC animated:YES];
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
