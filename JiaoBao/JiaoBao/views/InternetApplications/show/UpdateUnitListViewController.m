//
//  UpdateUnitListViewController.m
//  JiaoBao
//
//  Created by Zqw on 14-12-13.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "UpdateUnitListViewController.h"
#import "Reachability.h"
#import "MobClick.h"

@interface UpdateUnitListViewController ()

@end

@implementation UpdateUnitListViewController
@synthesize mNav_navgationBar,mTableV_list,mStr_title,mArr_list,mInt_index,mStr_flag,mStr_local;

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
    //将获得到的单位信息，通知到界面
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UpdateUnitList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateUnitList:) name:@"UpdateUnitList" object:nil];
    //获取到单位头像后，刷新界面
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshShowViewNew" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshShowViewNew) name:@"refreshShowViewNew" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mArr_list = [[NSMutableArray alloc] init];
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:self.mStr_title];
    //添加导航条
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

//获取到单位头像后，刷新界面
-(void)refreshShowViewNew{
    [self.mTableV_list reloadData];
}

//将获得到的单位信息，通知到界面
-(void)UpdateUnitList:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    [self.mTableV_list headerEndRefreshing];
    [self.mTableV_list footerEndRefreshing];
    NSDictionary *dic = noti.object;
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
    NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];

    if([ResultCode integerValue]!=0){
        [MBProgressHUD showError:ResultDesc toView:self.view];
        return;
    }
    NSMutableArray *array = [dic objectForKey:@"array"];
    if (self.mInt_index > 1) {
        if (array.count>0) {
            [self.mArr_list addObjectsFromArray:array];
        }
    }else{
        if (array.count == 0) {
            [MBProgressHUD showError:@"没有更多了" toView:self.view];
            return;
        }
        self.mArr_list = [NSMutableArray arrayWithArray:array];
        if (array.count>=20) {
            [self.mTableV_list addFooterWithTarget:self action:@selector(footerRereshing)];
            self.mTableV_list.footerPullToRefreshText = @"上拉加载更多";
            self.mTableV_list.footerReleaseToRefreshText = @"松开加载更多数据";
            self.mTableV_list.footerRefreshingText = @"正在加载...";
        }
    }
    //刷新，布局
    [self.mTableV_list reloadData];
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

//检查当前网络是否可用
-(BOOL)checkNetWork{
    if([Reachability isEnableNetwork]==NO){
        [MBProgressHUD showError:NETWORKENABLE toView:self.view];
        return YES;
    }else{
        return NO;
    }
}
//发送请求
-(void)sendRequest{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    if ([self.mStr_flag intValue] ==3) {
        [[ThemeHttp getInstance] themeHttpUpdatedInterestList:@"1" Page:[NSString stringWithFormat:@"%d",self.mInt_index]];
    }else{
        [[ShowHttp getInstance] showHttpGetUpdateUnitList:self.mStr_flag local:self.mStr_local page:[NSString stringWithFormat:@"%d",self.mInt_index]];
    }
    [MBProgressHUD showMessage:@"" toView:self.view];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mArr_list.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
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
    UpdateUnitListModel *model = [self.mArr_list objectAtIndex:indexPath.row];
    
    cell.mImgV_headImg.frame = CGRectMake(13, 5, 40, 40);
    
    NSString *tempUnit;
    if ([self.mStr_flag intValue] == 3) {
        //imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",model.UnitClassID]];
        tempUnit = [NSString stringWithFormat:@"-%@",model.UnitClassID];
    }else{
        if ([model.UnitClassID intValue]>0) {
            //imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",model.UnitClassID]];
            tempUnit = [NSString stringWithFormat:@"-%@",model.UnitClassID];
        }else{
            //imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",model.UnitID]];
            tempUnit = model.UnitID;
        }
    }
    [cell.mImgV_headImg sd_setImageWithURL:(NSURL *)[NSString stringWithFormat:@"%@%@",UnitIDImg,tempUnit] placeholderImage:[UIImage  imageNamed:@"root_img"]];

    
    //标题
    NSString *name;
    if ([self.mStr_flag intValue] ==3) {
        name = [NSString stringWithFormat:@"%@",model.UintName];
    }else{
        name = [NSString stringWithFormat:@"%@%@",model.UintName,model.ClsName];
    }
    CGSize numSize = [name sizeWithFont:[UIFont systemFontOfSize:14]];
    cell.mLab_title.frame = CGRectMake(cell.mLab_title.frame.origin.x, cell.mLab_title.frame.origin.y, [dm getInstance].width-cell.mImgV_headImg.frame.size.width-43, numSize.height);
    cell.mLab_title.text = name;
    //时间
    cell.mLab_time.frame = CGRectMake([dm getInstance].width-75, cell.mLab_title.frame.origin.y+cell.mLab_title.frame.size.height +5, 65, cell.mLab_time.frame.size.height);
    cell.mLab_time.text = model.pubDate;
    cell.mLab_time.textAlignment = NSTextAlignmentRight;
    //姓名,Title,详情
    cell.mLab_name.frame = CGRectMake(cell.mLab_name.frame.origin.x, cell.mLab_title.frame.origin.y+cell.mLab_title.frame.size.height +5, [dm getInstance].width-cell.mImgV_headImg.frame.size.width-cell.mLab_time.frame.size.width-43, cell.mLab_name.frame.size.height);
    cell.mLab_name.text = model.Title;
    
    //赞个数
    cell.mLab_likeCount.hidden = YES;
    //赞图标
    cell.mImgV_likeCount.hidden = YES;
    //阅读人数
    cell.mLab_viewCount.hidden = YES;
    //阅读图标
    cell.mImgV_viewCount.hidden = YES;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.mStr_flag intValue] ==3) {
        UpdateUnitListModel *model = [self.mArr_list objectAtIndex:indexPath.row];
        ThemeSpaceViewController *themeSpace = [[ThemeSpaceViewController alloc] init];
        themeSpace.mStr_title = model.UintName;
        themeSpace.mStr_unitID = model.UnitID;
        if (model.ClassIDStr.length>0) {
            themeSpace.mStr_tableID = model.ClassIDStr;
        }else{
            themeSpace.mStr_tableID = model.TabIDStr;
        }
        
        [utils pushViewController:themeSpace animated:YES];
    }else{
        UpdateUnitListModel *model = [self.mArr_list objectAtIndex:indexPath.row];
        UnitSectionMessageModel *unitModel = [[UnitSectionMessageModel alloc] init];
        unitModel.UnitID = model.UnitID;
        unitModel.UnitName = model.UintName;
        unitModel.UnitType = model.unitType;
        UnitSpaceViewController *space = [[UnitSpaceViewController alloc] init];
        space.mModel_unit = unitModel;
        [utils pushViewController:space animated:YES];
    }
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
