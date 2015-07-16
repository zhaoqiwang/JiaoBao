//
//  ArthLIstViewController.m
//  JiaoBao
//
//  Created by Zqw on 14-11-22.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "ArthLIstViewController.h"
#import "Reachability.h"
#import "MobClick.h"
@interface ArthLIstViewController ()

@end

@implementation ArthLIstViewController
@synthesize mNav_navgationBar,mTableV_list,mStr_classID,mStr_title,mArr_list,mInt_index,mInt_flag,mInt_section,mBtn_posting,mInt_class,mStr_local,mStr_flag;


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
    //通知shareview界面，将得到的值，传到界面,最新更新，推荐
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TopArthListIndex" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TopArthListIndex:) name:@"TopArthListIndex" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TopArthListIndexShow" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TopArthListIndex:) name:@"TopArthListIndexShow" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"exchangeGetFaceImg" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TopArthListIndexImg:) name:@"exchangeGetFaceImg" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.mArr_list = [NSMutableArray array];
    self.mInt_index = 1;
    //添加导航条
    if (self.mInt_section == 0) {
        self.mStr_title = [NSString stringWithFormat:@"%@",self.mStr_title];
    }else if (self.mInt_section == 1){
        self.mStr_title = [NSString stringWithFormat:@"%@",self.mStr_title];
    }
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:self.mStr_title];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    
    if (self.mInt_class == 1) {//能发布文章
        self.mTableV_list.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height-[dm getInstance].statusBar, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height+[dm getInstance].statusBar-51);
        self.mBtn_posting.hidden = NO;
    }else{//不能发布
        self.mTableV_list.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height-[dm getInstance].statusBar, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height+[dm getInstance].statusBar);
        self.mBtn_posting.hidden = YES;
    }
    //添加表格的下拉刷新
    [self.mTableV_list addHeaderWithTarget:self action:@selector(headerRereshing)];
    self.mTableV_list.headerPullToRefreshText = @"下拉刷新";
    self.mTableV_list.headerReleaseToRefreshText = @"松开后刷新";
    self.mTableV_list.headerRefreshingText = @"正在刷新...";
    
    //发表文章按钮，根据情况，是否隐藏
    self.mBtn_posting = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img_btn = [UIImage imageNamed:@"root_addBtn"];
    [self.mBtn_posting setBackgroundImage:img_btn forState:UIControlStateNormal];
    self.mBtn_posting.frame = CGRectMake(([dm getInstance].width-img_btn.size.width)/2, self.mTableV_list.frame.origin.y+self.mTableV_list.frame.size.height+(51-img_btn.size.height)/2, img_btn.size.width, img_btn.size.height);
    [self.mBtn_posting setTitle:@"发表文章" forState:UIControlStateNormal];
    [self.mBtn_posting setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.mBtn_posting addTarget:self action:@selector(clickPosting:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.mBtn_posting];
    
    //发送请求
    [self sendhttpRequest];
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

//发表文章按钮
-(void)clickPosting:(UIButton *)btn{
    SharePostingViewController *posting = [[SharePostingViewController alloc] init];
    UnitSectionMessageModel *model1 = [[UnitSectionMessageModel alloc] init];
    model1.UnitID = self.mStr_classID;
    if (self.mInt_flag == 0) {
        model1.UnitType = @"2";
    }else if (self.mInt_flag == 1){
        model1.UnitType = @"1";
    }
    posting.mInt_section = self.mInt_section;
    posting.mModel_unit = model1;
    [utils pushViewController:posting animated:YES];
}

//最新更新、推荐的通知
-(void)TopArthListIndex:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    [self.mTableV_list headerEndRefreshing];
    [self.mTableV_list footerEndRefreshing];
    NSMutableDictionary *dic = noti.object;
    NSString *flag = [dic objectForKey:@"flag"];
    if ([flag intValue]==0) {
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
        //检查当前网络是否可用
        if ([self checkNetWork]) {
            return;
        }
        self.mInt_index = (int)self.mArr_list.count/20+1;
        D("self.mint.page-====%lu %d",(unsigned long)self.mArr_list.count,self.mInt_index);
        [self sendhttpRequest];
        
        [MBProgressHUD showMessage:@"" toView:self.view];
    }
}

-(void)sendhttpRequest{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    if (self.mInt_flag == 0) {//判断是学校0还是单位1
        if (self.mInt_section == 0) {//分享
            [[ShareHttp getInstance] shareHttpGetUnitArthLIstIndexWith:@"1" UnitID:[NSString stringWithFormat:@"-%@",self.mStr_classID] Page:[NSString stringWithFormat:@"%d",self.mInt_index]];
        }else if (self.mInt_section == 1){//展示
            [[ShareHttp getInstance] shareHttpGetUnitArthLIstIndexWith:@"2" UnitID:[NSString stringWithFormat:@"-%@",self.mStr_classID] Page:[NSString stringWithFormat:@"%d",self.mInt_index]];
        }
    }else if (self.mInt_flag == 1){//单位1
        if (self.mInt_section == 0) {//分享
            [[ShareHttp getInstance] shareHttpGetUnitArthLIstIndexWith:@"1" UnitID:[NSString stringWithFormat:@"%@",self.mStr_classID] Page:[NSString stringWithFormat:@"%d",self.mInt_index]];
        }else if (self.mInt_section == 1){//展示
            [[ShareHttp getInstance] shareHttpGetUnitArthLIstIndexWith:@"2" UnitID:[NSString stringWithFormat:@"%@",self.mStr_classID] Page:[NSString stringWithFormat:@"%d",self.mInt_index]];
        }
    }else if (self.mInt_flag == 3){//showview中，请求文章
        [[ShowHttp getInstance] showHttpGetShowingUnitArthList:self.mStr_flag flag:self.mStr_local page:[NSString stringWithFormat:@"%d",self.mInt_index]];
    }else if (self.mInt_flag == 4){//shareNew中的最新文章和推荐文章
        [[ShowHttp getInstance] showHttpGetShareingArthList:self.mStr_flag page:[NSString stringWithFormat:@"%d",self.mInt_index]];
    }
    [MBProgressHUD showMessage:@"" toView:self.view];
}

//获取到头像后，更新界面
-(void)TopArthListIndexImg:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    //刷新，布局
    [self.mTableV_list reloadData];
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mArr_list.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellWithIdentifier = @"TopArthListCell";
    TopArthListCell *cell = (TopArthListCell *)[tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TopArthListCell" owner:self options:nil] lastObject];
        cell.frame = CGRectMake(0, 0, [dm getInstance].width, 70);
    }
    TopArthListModel *model = [self.mArr_list objectAtIndex:indexPath.row];

    [cell.mImgV_headImg sd_setImageWithURL:(NSURL *)[NSString stringWithFormat:@"%@%@",AccIDImg,model.JiaoBaoHao] placeholderImage:[UIImage  imageNamed:@"root_img"]];
    //添加头像点击事件
    [cell headImgClick];
    cell.delegate = self;
    cell.tag = indexPath.row;
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

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    return 70;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TopArthListModel *model = [self.mArr_list objectAtIndex:indexPath.row];
    ArthDetailViewController *arth = [[ArthDetailViewController alloc] init];
    arth.Arthmodel = model;
    [utils pushViewController:arth animated:YES];
}

//向cell中添加头像点击手势
- (void) TopArthListCellTapPress:(TopArthListCell *)topArthListCell{
    TopArthListModel *model = [self.mArr_list objectAtIndex:topArthListCell.tag];
    //生成个人信息
    UserInfoByUnitIDModel *userModel = [[UserInfoByUnitIDModel alloc] init];
    userModel.UserID = model.JiaoBaoHao;
    userModel.UserName = model.UserName;
    userModel.AccID = model.JiaoBaoHao;
    
    PersonalSpaceViewController *personal = [[PersonalSpaceViewController alloc] init];
    personal.mModel_personal = userModel;
    [utils pushViewController:personal animated:YES];
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
