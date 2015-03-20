//
//  UpdateUnitListViewController.m
//  JiaoBao
//
//  Created by Zqw on 14-12-13.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "UpdateUnitListViewController.h"
#import "Reachability.h"

@interface UpdateUnitListViewController ()

@end

@implementation UpdateUnitListViewController
@synthesize mNav_navgationBar,mTableV_list,mProgressV,mStr_title,mArr_list,mInt_index,mStr_flag,mStr_local;

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
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
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
    
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
    
    self.mProgressV = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.mProgressV];
    self.mProgressV.delegate = self;
    
    //发送请求
    [self sendRequest];
}

//获取到单位头像后，刷新界面
-(void)refreshShowViewNew{
    [self.mTableV_list reloadData];
}

//将获得到的单位信息，通知到界面
-(void)UpdateUnitList:(NSNotification *)noti{
    [self.mProgressV hide:YES];
    [self.mTableV_list headerEndRefreshing];
    [self.mTableV_list footerEndRefreshing];
    NSMutableArray *array = noti.object;
    if (self.mInt_index > 1) {
        if (array.count>0) {
            [self.mArr_list addObjectsFromArray:array];
        }
    }else{
        if (array.count == 0) {
            self.mProgressV.mode = MBProgressHUDModeCustomView;
            self.mProgressV.labelText = @"没有更多了";
//            self.mProgressV.userInteractionEnabled = NO;
            [self.mProgressV show:YES];
            [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
            
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
        
        self.mProgressV.labelText = @"加载中...";
        self.mProgressV.mode = MBProgressHUDModeIndeterminate;
        [self.mProgressV show:YES];
        [self.mProgressV showWhileExecuting:@selector(Loading) onTarget:self withObject:nil animated:YES];
    }else {
        self.mProgressV.mode = MBProgressHUDModeCustomView;
        self.mProgressV.labelText = @"没有更多了";
        [self.mProgressV show:YES];
        [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
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
    self.mProgressV.labelText = @"加载中...";
    self.mProgressV.mode = MBProgressHUDModeIndeterminate;
    [self.mProgressV show:YES];
    [self.mProgressV showWhileExecuting:@selector(Loading) onTarget:self withObject:nil animated:YES];
}

- (void)Loading {
    sleep(TIMEOUT);
    self.mProgressV.mode = MBProgressHUDModeCustomView;
    [self.mTableV_list headerEndRefreshing];
    [self.mTableV_list footerEndRefreshing];
    self.mProgressV.labelText = @"加载超时";
//    self.mProgressV.userInteractionEnabled = NO;
    sleep(2);
}

-(void)noMore{
    sleep(1);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mArr_list.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellWithIdentifier = @"TopArthListCell";
    TopArthListCell *cell = (TopArthListCell *)[tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TopArthListCell" owner:self options:nil] lastObject];
        cell.frame = CGRectMake(0, 0, [dm getInstance].width, 70);
    }
    UpdateUnitListModel *model = [self.mArr_list objectAtIndex:indexPath.row];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    cell.mImgV_headImg.frame = CGRectMake(13, 5, 40, 40);
    //头像
    NSString *imgPath;
    NSString *tempUnit;
    if ([self.mStr_flag intValue] == 3) {
        imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",model.UnitClassID]];
        tempUnit = [NSString stringWithFormat:@"-%@",model.UnitClassID];
    }else{
        if ([model.UnitClassID intValue]>0) {
            imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",model.UnitClassID]];
            tempUnit = [NSString stringWithFormat:@"-%@",model.UnitClassID];
        }else{
            imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",model.UnitID]];
            tempUnit = model.UnitID;
        }
    }
    UIImage *img= [UIImage imageWithContentsOfFile:imgPath];
    if (img.size.width>0) {
        [cell.mImgV_headImg setImage:img];
    }else{
        [cell.mImgV_headImg setImage:[UIImage imageNamed:@"root_img"]];
        //获取单位logo
        [[ShowHttp getInstance] showHttpGetUnitLogo:tempUnit Size:@""];
    }
    
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
// 用于延时显示图片，以减少内存的使用
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    TopArthListCell *cell0 = (TopArthListCell *)cell;
//    UpdateUnitListModel *model = [self.mArr_list objectAtIndex:indexPath.row];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//    
//    //头像
//    NSString *imgPath;
//    if ([self.mStr_flag intValue] == 3) {
//        imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",model.UnitClassID]];
//    }else{
//        if ([model.UnitClassID intValue]>0) {
//            imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",model.UnitClassID]];
//        }else{
//            imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",model.UnitID]];
//        }
//    }
//    UIImage *img= [UIImage imageWithContentsOfFile:imgPath];
//    if (img.size.width>0) {
//        [cell0.mImgV_headImg setImage:img];
//    }else{
//        [cell0.mImgV_headImg setImage:[UIImage imageNamed:@"root_img"]];
//    }
//}
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
