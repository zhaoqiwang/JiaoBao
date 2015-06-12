//
//  ThemeSpaceViewController.m
//  JiaoBao
//
//  Created by Zqw on 14-12-17.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "ThemeSpaceViewController.h"
#import "Reachability.h"

@interface ThemeSpaceViewController ()

@end

@implementation ThemeSpaceViewController
@synthesize mImgV_head,mBtn_add,mInt_index,mArr_list,mScrollV_img,mLab_albums,mLab_arth,mLab_detail,mNav_navgationBar,mScrollV_all,mTableV_arth,mProgressV,mStr_title,mStr_unitID,mArr_newPhoto,mPageC_page,mStr_tableID,mBtn_att;

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //获取到得文章通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"themeSpace" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeSpace:) name:@"themeSpace" object:nil];
    //获取到头像
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"exchangeGetFaceImg" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TopArthListIndexImg:) name:@"exchangeGetFaceImg" object:nil];
    //单位最新前N张照片后，通知界面
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetUnitNewPhoto" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetUnitNewPhoto:) name:@"GetUnitNewPhoto" object:nil];
    //是否关注主题
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ExistAtt" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ExistAtt:) name:@"ExistAtt" object:nil];
    //添加关注
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AddAtt" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddAtt:) name:@"AddAtt" object:nil];
    //取消主题关注
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RemoveAtt" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RemoveAtt:) name:@"RemoveAtt" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    // Do any additional setup after loading the view from its nib.
    
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
    
    
    self.mArr_list = [NSMutableArray array];
    self.mArr_newPhoto = [NSMutableArray array];
    self.mInt_index = 1;
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:self.mStr_title];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    //总
    self.mScrollV_all.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height-[dm getInstance].statusBar, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height+[dm getInstance].statusBar);
    //个人头像
    self.mImgV_head.frame = CGRectMake(20, 10, 40, 40);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //关注按钮
    self.mBtn_att.hidden = YES;
    //边框
    [self.mBtn_att.layer setMasksToBounds:YES];
    [self.mBtn_att.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    [self.mBtn_att.layer setBorderWidth:1.0]; //边框宽度
    CGColorRef colorref = [UIColor blueColor].CGColor;
    [self.mBtn_att.layer setBorderColor:colorref];//边框颜色
    //文件名
    NSString *imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",self.mStr_unitID]];
    UIImage *img= [UIImage imageWithContentsOfFile:imgPath];
    if (img.size.width>0) {
        [self.mImgV_head setImage:img];
    }else{
        [self.mImgV_head setImage:[UIImage imageNamed:@"root_img"]];
    }
    //个人简介
    self.mLab_detail.frame = CGRectMake(70, 10, [dm getInstance].width-80, 40);
    //相册标签
    self.mLab_albums.frame = CGRectMake(0, self.mImgV_head.frame.origin.y+self.mImgV_head.frame.size.height+10, [dm getInstance].width, self.mLab_albums.frame.size.height);
    //相册图片
    self.mScrollV_img.frame = CGRectMake(0, self.mLab_albums.frame.origin.y+self.mLab_albums.frame.size.height, [dm getInstance].width, self.mScrollV_img.frame.size.height);
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mView_albumspress:)];
    [self.mScrollV_img addGestureRecognizer:singleTap1];
    self.mScrollV_img.pagingEnabled = YES;
    self.mPageC_page.frame = CGRectMake(0, self.mScrollV_img.frame.origin.y+self.mScrollV_img.frame.size.height-self.mPageC_page.frame.size.height, [dm getInstance].width, self.mPageC_page.frame.size.height);
    
    //文章标签
    self.mLab_arth.frame = CGRectMake(0, self.mScrollV_img.frame.origin.y+self.mScrollV_img.frame.size.height, [dm getInstance].width, self.mLab_arth.frame.size.height);
    //文章列表
    self.mTableV_arth.frame = CGRectMake(0, self.mLab_arth.frame.origin.y+self.mLab_arth.frame.size.height, [dm getInstance].width, 0);
    //加载更多按钮
    self.mBtn_add.frame = CGRectMake(0, self.mTableV_arth.frame.origin.y+self.mTableV_arth.frame.size.height, [dm getInstance].width, self.mBtn_add.frame.size.height);
    [self.mBtn_add addTarget:self action:@selector(mBtn_addArth:) forControlEvents:UIControlEventTouchUpInside];
    
    //设置照片展示
    [self setScrollViewImageShow];
    //发送请求
    [self sendRequest];
    
    self.mProgressV = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.mProgressV];
    self.mProgressV.delegate = self;
//    self.mProgressV.userInteractionEnabled = NO;
    
    
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

-(void)sendRequest{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    //发送获取文章请求
    [[ShareHttp getInstance] shareHttpGetUnitArthLIstIndexWith:@"99" UnitID:[NSString stringWithFormat:@"-%@",self.mStr_unitID] Page:[NSString stringWithFormat:@"%d",self.mInt_index]];
    //获取前N张照片
    [[ThemeHttp getInstance] themeHttpGetUnitNewPhoto:[NSString stringWithFormat:@"-%@",self.mStr_unitID] count:@"4"];
    //获取是否关注此主题
    [[ThemeHttp getInstance] themeHttpExistAtt:self.mStr_tableID];
    
    self.mProgressV.labelText = @"加载中...";
    self.mProgressV.mode = MBProgressHUDModeIndeterminate;
    [self.mProgressV show:YES];
    [self.mProgressV showWhileExecuting:@selector(Loading) onTarget:self withObject:nil animated:YES];
}

//点击图片后，实现跳转页面
-(void)mView_albumspress:(UIGestureRecognizer *)gest{
    UnitSectionMessageModel *model = [[UnitSectionMessageModel alloc] init];
    model.UnitID = [NSString stringWithFormat:@"-%@",self.mStr_unitID];
    model.UnitName = self.mStr_title;
    UnitAlbumsViewController *Albums = [[UnitAlbumsViewController alloc] init];
    Albums.mModel_unit = model;
    [utils pushViewController:Albums animated:YES];
}

//是否关注主题
-(void)ExistAtt:(NSNotification *)noti{
    NSString *str = noti.object;
    self.mBtn_att.hidden = NO;
    if ([str integerValue]==0) {//未关注
        [self.mBtn_att setTitle:@"添加关注" forState:UIControlStateNormal];
        self.mBtn_att.tag = 0;
    }else{//已关注
        [self.mBtn_att setTitle:@"已关注" forState:UIControlStateNormal];
        self.mBtn_att.tag = 1;
    }
}
//添加关注
-(void)AddAtt:(NSNotification *)noti{
    [self.mBtn_att setTitle:@"已关注" forState:UIControlStateNormal];
    self.mBtn_att.tag = 1;
    self.mProgressV.mode = MBProgressHUDModeCustomView;
    self.mProgressV.labelText = @"关注成功";
    [self.mProgressV show:YES];
    [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
    //刷新主题界面
    [[ThemeHttp getInstance] themeHttpEnjoyInterestList:[dm getInstance].jiaoBaoHao];
}

//取消主题关注
-(void)RemoveAtt:(NSNotification *)noti{
    [self.mBtn_att setTitle:@"添加关注" forState:UIControlStateNormal];
    self.mBtn_att.tag = 0;
    self.mProgressV.mode = MBProgressHUDModeCustomView;
    self.mProgressV.labelText = @"取消关注成功";
    [self.mProgressV show:YES];
    [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
    //刷新主题界面
    //检查当前网络是否可用
    if([Reachability isEnableNetwork]==NO){
        
    }else{
        [[ThemeHttp getInstance] themeHttpEnjoyInterestList:[dm getInstance].jiaoBaoHao];
    }
    
}

//关注主题按钮
-(IBAction)mBtn_att:(UIButton *)btn{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    if (btn.tag==0) {//未关注
        //添加关注
        [[ThemeHttp getInstance] themeHttpAddAtt:self.mStr_tableID];
    }else if (btn.tag ==1){//已关注
        //取消关注
        [[ThemeHttp getInstance] themeHttpRemoveAtt:self.mStr_tableID];
    }
    self.mProgressV.mode = MBProgressHUDModeIndeterminate;
    self.mProgressV.labelText = @"加载中...";
    [self.mProgressV show:YES];
    [self.mProgressV showWhileExecuting:@selector(Loading) onTarget:self withObject:nil animated:YES];
}

//个人最新前N张照片后，通知界面
-(void)GetUnitNewPhoto:(NSNotification *)noti{
    NSMutableArray *array = noti.object;
    self.mArr_newPhoto = [NSMutableArray arrayWithArray:array];
    //设置照片展示
    [self setScrollViewImageShow];
}

//设置照片展示
-(void)setScrollViewImageShow{
    if (self.mArr_newPhoto.count == 0) {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [dm getInstance].width, self.mScrollV_img.frame.size.height)];
        img.image = [UIImage imageNamed:@"noPhoto"];
        [self.mScrollV_img addSubview:img];
    }else{
        self.mPageC_page.numberOfPages = self.mArr_newPhoto.count;
        self.mPageC_page.currentPage = 0;
        for (UIImageView *img in self.mScrollV_img.subviews) {
            if ([img isKindOfClass:[UIImageView class]]) {
                [img removeFromSuperview];
            }
        }
        for (int i=0; i<self.mArr_newPhoto.count; i++) {
            UnitAlbumsListModel *model = [self.mArr_newPhoto objectAtIndex:i];
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake([dm getInstance].width*i, 0, [dm getInstance].width, self.mScrollV_img.frame.size.height)];
            [img sd_setImageWithURL:[NSURL  URLWithString:model.BIGPhotoPath] placeholderImage:[UIImage  imageNamed:@"photo_default"]];
            img.contentMode = UIViewContentModeScaleAspectFill;
            [self.mScrollV_img addSubview:img];
        }
        self.mScrollV_img.contentSize = CGSizeMake([dm getInstance].width*self.mArr_newPhoto.count, self.mScrollV_img.frame.size.height);
    }
}

//滑动结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int a = scrollView.contentOffset.x/[dm getInstance].width;
    self.mPageC_page.currentPage = a;
}

//获取到头像后，更新界面
-(void)TopArthListIndexImg:(NSNotification *)noti{
    [self.mTableV_arth reloadData];
}

//获取到文章的通知
-(void)themeSpace:(NSNotification *)noti{
    [self.mProgressV hide:YES];
    NSMutableArray *array = noti.object;
    if (self.mInt_index > 1) {
        if (array.count>0) {
            [self.mArr_list addObjectsFromArray:array];
        }
        [self tableviewReload:(int)array.count];
    }else{
        self.mArr_list = [NSMutableArray arrayWithArray:array];
        [self tableviewReload:(int)array.count];
    }
}

-(void)tableviewReload:(int)a{
    //刷新，布局
    self.mTableV_arth.frame = CGRectMake(0, self.mTableV_arth.frame.origin.y, self.mTableV_arth.frame.size.width, self.mArr_list.count*70);
    [self.mTableV_arth reloadData];
    if (a<20) {
        self.mBtn_add.frame = self.mTableV_arth.frame;
        self.mBtn_add.hidden = YES;
    }else{
        self.mBtn_add.frame = CGRectMake(0, self.mTableV_arth.frame.origin.y+self.mTableV_arth.frame.size.height, [dm getInstance].width, self.mBtn_add.frame.size.height);
        self.mBtn_add.hidden = NO;
    }
    self.mScrollV_all.contentSize = CGSizeMake([dm getInstance].width, self.mBtn_add.frame.origin.y+self.mBtn_add.frame.size.height);
}

//加载更多按钮
-(void)mBtn_addArth:(UIButton *)btn{
    if (self.mArr_list.count>=20) {
        //检查当前网络是否可用
        if ([self checkNetWork]) {
        return;
    }
        self.mInt_index = (int)self.mArr_list.count/20+1;
        //发送获取文章请求
        [[ShareHttp getInstance] shareHttpGetUnitArthLIstIndexWith:@"99" UnitID:[NSString stringWithFormat:@"-%@",self.mStr_unitID] Page:[NSString stringWithFormat:@"%d",self.mInt_index]];
        self.mProgressV.mode = MBProgressHUDModeIndeterminate;
        self.mProgressV.labelText = @"加载中...";
        [self.mProgressV show:YES];
        [self.mProgressV showWhileExecuting:@selector(Loading) onTarget:self withObject:nil animated:YES];
    } else {
        self.mProgressV.mode = MBProgressHUDModeCustomView;
        self.mProgressV.labelText = @"没有更多了";
//        self.mProgressV.userInteractionEnabled = NO;
        [self.mProgressV show:YES];
        [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
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
    sleep(2);
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
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //文件名
    NSString *imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",model.JiaoBaoHao]];
    UIImage *img= [UIImage imageWithContentsOfFile:imgPath];
    cell.mImgV_headImg.frame = CGRectMake(13, 10, 48, 48);
    if (img.size.width>0) {
        [cell.mImgV_headImg setImage:img];
    }else{
        [cell.mImgV_headImg setImage:[UIImage imageNamed:@"root_img"]];
        //获取头像
        [[ExchangeHttp getInstance] getUserInfoFace:model.JiaoBaoHao];
    }
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
// 用于延时显示图片，以减少内存的使用
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    TopArthListCell *cell0 = (TopArthListCell *)cell;
    TopArthListModel *model = [self.mArr_list objectAtIndex:indexPath.row];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //文件名
    NSString *imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",model.JiaoBaoHao]];
    UIImage *img= [UIImage imageWithContentsOfFile:imgPath];
    if (img.size.width>0) {
        [cell0.mImgV_headImg setImage:img];
    }else{
        [cell0.mImgV_headImg setImage:[UIImage imageNamed:@"root_img"]];
    }
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
