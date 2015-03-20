//
//  WorkDetailListViewController.m
//  JiaoBao
//
//  Created by Zqw on 14-11-3.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "WorkDetailListViewController.h"
#import "Reachability.h"

@interface WorkDetailListViewController ()

@end

@implementation WorkDetailListViewController
@synthesize mTableV_detailist,mArr_detail,mInt_page,mInt_tag,mNav_navgationBar,mStr_navName,mStr_url,mProgressV,mInt_refresh;



-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
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
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
    
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
    
    self.mProgressV = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.mProgressV];
    //发送获取请求
    [self firstSendHttp];
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

//发送获取请求
-(void)firstSendHttp{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    self.mProgressV.labelText = @"加载中...";
//    self.mProgressV.dimBackground = YES;
    [self.mProgressV show:YES];
    self.mInt_page = 1;
//    self.mProgressV.userInteractionEnabled = NO;
    [self.mProgressV showWhileExecuting:@selector(Loading) onTarget:self withObject:nil animated:YES];
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
            
            self.mProgressV.labelText = @"加载中...";
//            self.mProgressV.dimBackground = NO;
            [self.mProgressV show:YES];
            [self.mProgressV showWhileExecuting:@selector(Loading) onTarget:self withObject:nil animated:YES];
        } else {
            self.mProgressV.mode = MBProgressHUDModeCustomView;
            self.mProgressV.labelText = @"没有更多了";
//            self.mProgressV.userInteractionEnabled = NO;
//            self.mProgressV.dimBackground = NO;
            [self.mProgressV show:YES];
            [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
            [self.mTableV_detailist footerEndRefreshing];
        }
    }
}

-(void)noMore{
    sleep(1);
}

- (void)Loading {
    sleep(TIMEOUT);
    self.mProgressV.mode = MBProgressHUDModeCustomView;
    self.mProgressV.labelText = @"加载超时";
//    self.mProgressV.userInteractionEnabled = NO;
    [self.mTableV_detailist headerEndRefreshing];
    [self.mTableV_detailist footerEndRefreshing];
    sleep(2);
}

//通知界面刷新消息cell头像
-(void)UnReadMsgCellImg:(NSNotification *)noti{
    [self.mTableV_detailist reloadData];
}

//通知界面刷新消息cell
-(void)UnReadMsgCell:(NSNotification *)noti{
    [self.mTableV_detailist headerEndRefreshing];
    [self.mTableV_detailist footerEndRefreshing];
    [self.mProgressV hide:YES];
    NSMutableDictionary *dic = noti.object;
    NSMutableArray *array = [dic valueForKey:@"array"];
//    if (self.mInt_refresh == 1) {
//        if (array.count>0) {
//            [self.mArr_detail removeAllObjects];
//            self.mArr_detail = [NSMutableArray arrayWithArray:array];
//        }
//        if (array.count==20) {
//            [self.mTableV_detailist addFooterWithTarget:self action:@selector(footerRereshing)];
//            self.mTableV_detailist.footerPullToRefreshText = @"上拉加载更多";
//            self.mTableV_detailist.footerReleaseToRefreshText = @"松开加载更多数据";
//            self.mTableV_detailist.footerRefreshingText = @"正在加载...";
//        }else{
//            [self.mTableV_detailist removeFooter];
//        }
//    }else{
//        if (array.count==20) {
//            [self.mTableV_detailist addFooterWithTarget:self action:@selector(footerRereshing)];
//            self.mTableV_detailist.footerPullToRefreshText = @"上拉加载更多";
//            self.mTableV_detailist.footerReleaseToRefreshText = @"松开加载更多数据";
//            self.mTableV_detailist.footerRefreshingText = @"正在加载...";
//        }else{
//            [self.mTableV_detailist removeFooter];
//        }
//        if (array.count==0) {
//            self.mProgressV.mode = MBProgressHUDModeCustomView;
//            self.mProgressV.labelText = @"没有更多了";
//            [self.mProgressV show:YES];
//            [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
//        }
//        for (int i=0; i<array.count; i++) {
//            UnReadMsg_model *unReadMsgModel = [array objectAtIndex:i];
//            [self.mArr_detail addObject:unReadMsgModel];
//        }
//    }
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
    static NSString *indentifier2 = @"TreeView_Level2_Cell";
    TreeView_Level2_Cell *cell2 = (TreeView_Level2_Cell *)[tableView dequeueReusableCellWithIdentifier:indentifier2];
    if(cell2 == nil){
        cell2 = [[[NSBundle mainBundle] loadNibNamed:@"TreeView_Level2_Cell" owner:self options:nil] lastObject];
        cell2.frame = CGRectMake(0, 0, [dm getInstance].width, 65);
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
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //文件名
    NSString *imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",unReadMsgModel.JiaoBaoHao]];
    UIImage *img= [UIImage imageWithContentsOfFile:imgPath];
    if (img.size.width>0) {
        [cell2.mImgV_head setImage:img];
    }else{
        [cell2.mImgV_head setImage:[UIImage imageNamed:@"root_img"]];
        //获取头像
        [[ExchangeHttp getInstance] getUserInfoFace:unReadMsgModel.JiaoBaoHao];
    }
    return cell2;
}
// 用于延时显示图片，以减少内存的使用
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    TreeView_Level2_Cell *cell2 = (TreeView_Level2_Cell *)cell;
    UnReadMsg_model *unReadMsgModel = [self.mArr_detail objectAtIndex:indexPath.row];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //文件名
    NSString *imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",unReadMsgModel.JiaoBaoHao]];
    UIImage *img= [UIImage imageWithContentsOfFile:imgPath];
    if (img.size.width>0) {
        [cell2.mImgV_head setImage:img];
    }else{
        [cell2.mImgV_head setImage:[UIImage imageNamed:@"root_img"]];
    }
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
