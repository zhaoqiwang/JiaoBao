//
//  UnitSpaceArthListViewController.m
//  JiaoBao
//
//  Created by Zqw on 14-12-14.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "UnitSpaceArthListViewController.h"
#import "Reachability.h"
#import "MBProgressHUD+AD.h"
#import <UMAnalytics/MobClick.h>

@interface UnitSpaceArthListViewController ()

@end

@implementation UnitSpaceArthListViewController
@synthesize mArr_list,mTableV_list,mNav_navgationBar,mInt_index,mStr_flag,mModel_unit;

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:UMMESSAGE];
    [MobClick endLogPageView:UMPAGE];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:UMMESSAGE];
    [MobClick beginLogPageView:UMPAGE];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
    //通知单位展示空间界面，将得到的值，传到界面
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UnitSpaceArthList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UnitSpaceArthList:) name:@"UnitSpaceArthList" object:nil];
    //获取到头像后，更新界面
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"exchangeGetFaceImg" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TopArthListIndexImg:) name:@"exchangeGetFaceImg" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mArr_list = [NSMutableArray array];
    self.mInt_index = 1;
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:self.mModel_unit.UnitName];
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
    [self sendRequest];
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

//获取到头像后，更新界面
-(void)TopArthListIndexImg:(NSNotification *)noti{
    //刷新，布局
    [MBProgressHUD hideHUDForView:self.view];
    [self.mTableV_list reloadData];
}

//将获得到的单位信息，通知到界面
-(void)UnitSpaceArthList:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    [self.mTableV_list headerEndRefreshing];
    [self.mTableV_list footerEndRefreshing];
    NSMutableDictionary *dic = noti.object;
    NSString *flag = [dic objectForKey:@"flag"];
    if ([flag integerValue]==0) {
        NSMutableArray *array = [dic objectForKey:@"array"];
        if (self.mInt_index > 1) {
            if (array.count>0) {
                [self.mArr_list addObjectsFromArray:array];
            }
            if (array.count<20) {
                [self.mTableV_list removeFooter];
            }
        }else{
            if (array.count == 0) {
                [MBProgressHUD showError:@"没有更多了" toView:self.view];
                return;
            }
            self.mArr_list = [NSMutableArray arrayWithArray:array];
            if (self.mInt_index == 1) {
                if (array.count==20) {
                    [self.mTableV_list addFooterWithTarget:self action:@selector(footerRereshing)];
                    self.mTableV_list.footerPullToRefreshText = @"上拉加载更多";
                    self.mTableV_list.footerReleaseToRefreshText = @"松开加载更多数据";
                    self.mTableV_list.footerRefreshingText = @"正在加载...";
                }
            }
        }
        //刷新，布局
        [self.mTableV_list reloadData];
    }else{
        [MBProgressHUD showError:@"" toView:self.view];
    }
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing{
    self.mInt_index = 1;
    [self sendRequest];
}

- (void)footerRereshing{
    if (self.mArr_list.count>=20) {
        //检查当前网络是否可用
        if ([self checkNetWork]) {
        return;
    }
        self.mInt_index = (int)self.mArr_list.count/20+1;
        [self sendRequest];
        
        [MBProgressHUD showMessage:@"" toView:self.view];
    }else {
        [MBProgressHUD showError:@"没有更多了" toView:self.view];
    }
}

//发送请求
-(void)sendRequest{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    if ([self.mModel_unit.UnitType intValue]==3) {
        [[ShowHttp getInstance] showHttpGetUnitArthLIstIndexWith:self.mStr_flag UnitID:[NSString stringWithFormat:@"-%@",self.mModel_unit.UnitID] Page:[NSString stringWithFormat:@"%d",self.mInt_index]];
    }else {
        [[ShowHttp getInstance] showHttpGetUnitArthLIstIndexWith:self.mStr_flag UnitID:self.mModel_unit.UnitID Page:[NSString stringWithFormat:@"%d",self.mInt_index]];
    }
    
    [MBProgressHUD showMessage:@"" toView:self.view];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mArr_list.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
    TopArthListModel *model = [self.mArr_list objectAtIndex:indexPath.row];
    [cell.mImgV_headImg sd_setImageWithURL:(NSURL *)[NSString stringWithFormat:@"%@%@",AccIDImg,model.JiaoBaoHao] placeholderImage:[UIImage  imageNamed:@"root_img"]];

    //标题
    CGSize numSize = [[NSString stringWithFormat:@"%@",model.Title] sizeWithFont:[UIFont systemFontOfSize:14]];
    cell.mLab_title.frame = CGRectMake(cell.mLab_title.frame.origin.x, cell.mLab_title.frame.origin.y, [dm getInstance].width-cell.mImgV_headImg.frame.size.width-23, numSize.height*2);
    cell.mLab_title.text = model.Title;
    if (numSize.width>cell.mLab_title.frame.size.width) {
        cell.mLab_title.numberOfLines = 2;
    }
    //姓名
    CGSize size = [@"金视野" sizeWithFont:[UIFont systemFontOfSize:10]];
    cell.mLab_name.text = model.UserName;
    cell.mLab_name.frame = CGRectMake(cell.mLab_name.frame.origin.x, 70-12-size.height, cell.mLab_name.frame.size.width, size.height);
    //时间
    cell.mLab_time.text = model.RecDate;
    cell.mLab_time.frame = CGRectMake(cell.mLab_time.frame.origin.x, 70-12-size.height, cell.mLab_time.frame.size.width, size.height);
    //赞个数
    CGSize likeSize = [[NSString stringWithFormat:@"%@",model.LikeCount] sizeWithFont:[UIFont systemFontOfSize:10]];
    cell.mLab_likeCount.frame = CGRectMake([dm getInstance].width-10-likeSize.width, 70-12-likeSize.height, likeSize.width, likeSize.height);
    cell.mLab_likeCount.text = model.LikeCount;
    //赞图标
    UIImage *likeImg = [UIImage imageNamed:@"share_like_1"];
    cell.mImgV_likeCount.frame = CGRectMake(cell.mLab_likeCount.frame.origin.x-likeImg.size.width-5, 70-12-likeImg.size.height, likeImg.size.width, likeImg.size.height);
    cell.mImgV_likeCount.image = likeImg;
    //阅读人数
    CGSize lookSize = [[NSString stringWithFormat:@"%@",model.ViewCount] sizeWithFont:[UIFont systemFontOfSize:10]];
    cell.mLab_viewCount.frame = CGRectMake(cell.mImgV_likeCount.frame.origin.x-lookSize.width-5, 70-12-lookSize.height, lookSize.width, lookSize.height);
    cell.mLab_viewCount.text = model.ViewCount;
    //阅读图标
    UIImage *lookImg = [UIImage imageNamed:@"share_look"];
    cell.mImgV_viewCount.frame = CGRectMake(cell.mLab_viewCount.frame.origin.x-lookImg.size.width-5, 70-12-lookImg.size.height, lookImg.size.width, lookImg.size.height);
    cell.mImgV_viewCount.image = lookImg;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TopArthListModel *model = [self.mArr_list objectAtIndex:indexPath.row];
    ArthDetailViewController *arth = [[ArthDetailViewController alloc] init];
    arth.Arthmodel = model;
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
