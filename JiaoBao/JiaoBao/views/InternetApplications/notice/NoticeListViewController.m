//
//  NoticeListViewController.m
//  JiaoBao
//
//  Created by Zqw on 14-11-29.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "NoticeListViewController.h"
#import "MobClick.h"
#import "OnlineJobHttp.h"

@interface NoticeListViewController ()

@end

@implementation NoticeListViewController
@synthesize mArr_list,mInt_index,mNav_navgationBar,mStr_classID,mStr_title,mTableV_list,mModel_notice;

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
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //切换账号时，更新数据
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RegisterView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RegisterView:) name:@"RegisterView" object:nil];
    //向转发界面传递得到的人员单位列表，在获取通知前，切换单位用到
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CMRevicer" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CMRevicer) name:@"CMRevicer" object:nil];
    //通知到内务获取到的单位通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetUnitNotices" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetUnitNotices:) name:@"GetUnitNotices" object:nil];
    //通知内务界面，切换成功
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeCurUnit" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCurUnit:) name:@"changeCurUnit" object:nil];
    
    self.mArr_list = [NSMutableArray array];
    self.mInt_index = 1;
    //添加导航条
    self.mStr_title = [NSString stringWithFormat:@"%@:内务",self.mStr_title];
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:self.mStr_title];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    
        self.mTableV_list.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height-[dm getInstance].statusBar, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height+[dm getInstance].statusBar);
    //添加表格的下拉刷新
    [self.mTableV_list addHeaderWithTarget:self action:@selector(headerRereshing)];
    self.mTableV_list.headerPullToRefreshText = @"下拉刷新";
    self.mTableV_list.headerReleaseToRefreshText = @"松开后刷新";
    self.mTableV_list.headerRefreshingText = @"正在刷新...";
    
    //发送请求
    [self sendhttpRequest];
}
//切换账号时，更新数据
-(void)RegisterView:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    [self.mArr_list removeAllObjects];
    self.mInt_index = 1;
    
    [self.mModel_notice.noticeInfoArray removeAllObjects];
}
//向转发界面传递得到的人员单位列表，在获取通知前，切换单位用到
-(void)CMRevicer{
//    for (int i=0; i<self.mArr_list.count; i++) {
//        if ([dm getInstance].UID == [mStr_classID intValue]) {
            self.mInt_index = 1;
            //发送获取当前单位通知请求
//            UnitSectionMessageModel *model = [self.mArr_unit objectAtIndex:self.mInt_flag];
//            D("NoticeHttpGetUnitNoticesWith-===%@,%@,%d",model.UnitType,model.UnitID,self.mInt_index);
            [[ShareHttp getInstance] NoticeHttpGetUnitNoticesWith:@"3" UnitID:mStr_classID pageNum:[NSString stringWithFormat:@"%d",self.mInt_index]];
//            [self.mTableV_list reloadData];
//        }
//    }
}
//通知到内务获取到的单位通知
-(void)GetUnitNotices:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    [self.mTableV_list headerEndRefreshing];
    [self.mTableV_list footerEndRefreshing];
    NSMutableDictionary *dic = noti.object;
    NSString *flag = [dic objectForKey:@"flag"];
    if ([flag integerValue]==0) {
        UnitNoticeModel *model = [dic objectForKey:@"model"];
        if (self.mInt_index > 1) {
            if (model.noticeInfoArray.count>0) {
                [self.mModel_notice.noticeInfoArray addObjectsFromArray:model.noticeInfoArray];
            }
        }else{
            if (model.noticeInfoArray.count == 0) {
                [MBProgressHUD showError:@"没有更多了" toView:self.view];
                return;
            }
            self.mModel_notice = noti.object;
            if (model.noticeInfoArray.count>=20) {
                [self.mTableV_list addFooterWithTarget:self action:@selector(footerRereshing)];
                self.mTableV_list.footerPullToRefreshText = @"上拉加载更多";
                self.mTableV_list.footerReleaseToRefreshText = @"松开加载更多数据";
                self.mTableV_list.footerRefreshingText = @"正在加载...";
            }
        }
        //刷新，布局
        [self.mTableV_list reloadData];
    }else{
        [MBProgressHUD showError:@"超时" toView:self.view];
    }
}
#pragma mark 开始进入刷新状态
- (void)headerRereshing{
    self.mInt_index = 1;
    [self sendhttpRequest];
}
- (void)footerRereshing{
    if (self.mArr_list.count>=20) {
        self.mInt_index = (int)self.mArr_list.count/20+1;
        D("self.mint.page-====%lu %d",(unsigned long)self.mArr_list.count,self.mInt_index);
        [[ShareHttp getInstance] NoticeHttpGetUnitNoticesWith:@"3" UnitID:mStr_classID pageNum:[NSString stringWithFormat:@"%d",self.mInt_index]];
        
        [MBProgressHUD showMessage:@"" toView:self.view];
    }
}

//发送获取切换单位和个人信息请求
-(void)sendhttpRequest{
    [LoginSendHttp getInstance].mInt_forwardFlag = 1;
    [[LoginSendHttp getInstance] changeCurUnit:0];
}
//切换成功
-(void)changeCurUnit:(NSNotification *)noti{
    NSString *str = noti.object;
    if ([str intValue] ==0) {//成功
        if ([dm getInstance].uType==3) {//家长
            [[OnlineJobHttp getInstance] getGenInfoWithAccID:[dm getInstance].jiaoBaoHao UID:[dm getInstance].ClassID];
        }else if ([dm getInstance].uType == 4){//学生
            [[OnlineJobHttp getInstance] getStuInfoWithAccID:[dm getInstance].jiaoBaoHao UID:[dm getInstance].ClassID];
        }else{//教育局、老师
            [[LoginSendHttp getInstance] getUserInfoWith:[dm getInstance].jiaoBaoHao UID:[NSString stringWithFormat:@"%d",[dm getInstance].UID]];
        }
    }else{
    }
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mModel_notice.noticeInfoArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"TopArthListCell";
    TopArthListCell *cell = (TopArthListCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[TopArthListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TopArthListCell" owner:self options:nil];
        //这时myCell对象已经通过自定义xib文件生成了
        if ([nib count]>0) {
            cell = (TopArthListCell *)[nib objectAtIndex:0];
            //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
        }
        //添加图片点击事件
        //若是需要重用，需要写上以下两句代码
        UINib * n= [UINib nibWithNibName:@"TopArthListCell" bundle:[NSBundle mainBundle]];
        [self.mTableV_list registerNib:n forCellReuseIdentifier:indentifier];
    }
    NoticeInfoModel *model = [self.mModel_notice.noticeInfoArray objectAtIndex:indexPath.row];
    cell.mImgV_headImg.frame = CGRectMake(13, 10, 48, 48);
    [cell.mImgV_headImg sd_setImageWithURL:(NSURL *)[NSString stringWithFormat:@"%@%@",AccIDImg,model.JiaoBaoHao] placeholderImage:[UIImage  imageNamed:@"root_img"]];
    //标题
    CGSize numSize = [[NSString stringWithFormat:@"%@",model.Subject] sizeWithFont:[UIFont systemFontOfSize:14]];
    cell.mLab_title.frame = CGRectMake(cell.mLab_title.frame.origin.x, cell.mLab_title.frame.origin.y, [dm getInstance].width-cell.mImgV_headImg.frame.size.width-23, numSize.height*2);
    cell.mLab_title.text = model.Subject;
    if (numSize.width>cell.mLab_title.frame.size.width) {
        cell.mLab_title.numberOfLines = 2;
    }
    //姓名
    CGSize size = [model.UserName sizeWithFont:[UIFont systemFontOfSize:10]];
    cell.mLab_name.text = model.UserName;
    cell.mLab_name.frame = CGRectMake(cell.mLab_name.frame.origin.x, 70-12-size.height, cell.mLab_name.frame.size.width, size.height);
    //时间
    CGSize timeSize = [[NSString stringWithFormat:@"%@",model.Recdate] sizeWithFont:[UIFont systemFontOfSize:10]];
    cell.mLab_time.text = model.Recdate;
    cell.mLab_time.frame = CGRectMake([dm getInstance].width-10-timeSize.width, 70-12-size.height, timeSize.width, size.height);
    
    cell.mLab_likeCount.hidden = YES;
    cell.mLab_viewCount.hidden = YES;
    cell.mImgV_likeCount.hidden = YES;
    cell.mImgV_viewCount.hidden = YES;
    return cell;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    return 70;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NoticeInfoModel *model = [self.mModel_notice.noticeInfoArray objectAtIndex:indexPath.row];
    ArthDetailViewController *arth = [[ArthDetailViewController alloc] init];
    arth.mInt_from = 2;
    arth.mStr_title = model.Subject;
    arth.mStr_tableID = model.TabIDStr;
    [utils pushViewController:arth animated:YES];
    
}

//导航条返回按钮回调
-(void)myNavigationGoback{
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
