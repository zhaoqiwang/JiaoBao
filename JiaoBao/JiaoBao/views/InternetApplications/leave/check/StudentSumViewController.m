//
//  StudentSumViewController.m
//  JiaoBao
//
//  Created by SongYanming on 16/4/11.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "StudentSumViewController.h"
#import "CustomQueryCell.h"
#import "MBProgressHUD+AD.h"
#import "MJRefresh.h"//上拉下拉刷新
#import "LeaveHttp.h"


@interface StudentSumViewController ()
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,assign)int mInt_reloadData;
@property(nonatomic,strong)MyNavigationBar *mNav_navgationBar;

@end

@implementation StudentSumViewController
-(void)GetStudentSumLeaves:(NSNotification*)sender{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.dataSource = [sender object];
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:[NSString stringWithFormat:@"%@统计",self.ClassSumModel.ClassStr]];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    //学生统计查询后的通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"GetStudentSumLeaves" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetStudentSumLeaves:) name:@"GetStudentSumLeaves" object:nil];
    self.dataSource = [NSMutableArray array];
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self sendRequest];
//    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
//    self.tableView.headerPullToRefreshText = @"下拉刷新";
//    self.tableView.headerReleaseToRefreshText = @"松开后刷新";
//    self.tableView.headerRefreshingText = @"正在刷新...";
//    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
//    self.tableView.footerPullToRefreshText = @"上拉加载更多";
//    self.tableView.footerReleaseToRefreshText = @"松开加载更多数据";
//    self.tableView.footerRefreshingText = @"正在加载...";
//    [self.tableView headerEndRefreshing];
//    [self.tableView footerEndRefreshing];
    // Do any additional setup after loading the view from its nib.
}
-(void)sendRequest{

                        [[LeaveHttp getInstance]GetStudentSumLeavesWithUnitId: self.ClassSumModel.UnitClassId sDateTime:self.sDateTime];
}
//导航条返回按钮回调
-(void)myNavigationGoback{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 开始进入刷新状态
- (void)headerRereshing{
    self.mInt_reloadData = 0;
    [self sendRequest];
}

- (void)footerRereshing{
    self.mInt_reloadData = 1;
    [self sendRequest];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *indentifier = @"CustomQueryCell";
    CustomQueryCell *cell = (CustomQueryCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    
    if (cell == nil) {
        cell = [[CustomQueryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomQueryCell" owner:self options:nil];
        //这时myCell对象已经通过自定义xib文件生成了
        if ([nib count]>0) {
            cell = (CustomQueryCell *)[nib objectAtIndex:0];
            //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
        }
        //添加图片点击事件
        //若是需要重用，需要写上以下两句代码
        UINib * n= [UINib nibWithNibName:@"CustomQueryCell" bundle:[NSBundle mainBundle]];
        [self.tableView registerNib:n forCellReuseIdentifier:indentifier];
    }
    [cell setStatisticsData:[self.dataSource objectAtIndex:indexPath.row]];
    return cell;

}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
        return self.stuSection;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return 32;
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
