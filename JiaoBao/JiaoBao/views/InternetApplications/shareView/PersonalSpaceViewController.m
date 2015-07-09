//
//  PersonalSpaceViewController.m
//  JiaoBao
//
//  Created by Zqw on 14-12-15.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "PersonalSpaceViewController.h"
#import "ShareCollectionViewCell.h"
#import "UnitAlbumsViewController.h"
#import "Reachability.h"
#import "MobClick.h"
static NSString *PersonSpaceAlbums = @"ShareCollectionViewCell";

@interface PersonalSpaceViewController ()

@end

@implementation PersonalSpaceViewController
@synthesize mImgV_head,mBtn_add,mInt_index,mArr_list,mCollectionV_albums,mLab_albums,mLab_arth,mLab_detail,mNav_navgationBar,mScrollV_all,mTableV_arth,mModel_personal,mArr_NewPhoto,mLab_jiaobaohao;

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:UMMESSAGE];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:UMMESSAGE];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
    //获取到得文章通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TopArthListIndex" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TopArthListIndex:) name:@"TopArthListIndex" object:nil];
    //获得到头像通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"exchangeGetFaceImg" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TopArthListIndexImg:) name:@"exchangeGetFaceImg" object:nil];
    //个人最新前N张照片后，通知界面
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetNewPhoto" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetNewPhoto:) name:@"GetNewPhoto" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    self.mArr_list = [NSMutableArray array];
    self.mArr_NewPhoto = [NSMutableArray array];
    self.mInt_index = 1;
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:self.mModel_personal.UserName];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    //总
    self.mScrollV_all.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height-[dm getInstance].statusBar, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height+[dm getInstance].statusBar);
    //个人头像
    self.mImgV_head.frame = CGRectMake(18, 15, 57, 57);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //文件名
    NSString *imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",self.mModel_personal.AccID]];
    UIImage *img= [UIImage imageWithContentsOfFile:imgPath];
    if (img.size.width>0) {
        [self.mImgV_head setImage:img];
    }else{
        [self.mImgV_head setImage:[UIImage imageNamed:@"root_img"]];
    }
    //个人简介
    self.mLab_detail.frame = CGRectMake(93, 20, [dm getInstance].width-100, 20);
    self.mLab_detail.text = @"暂无简介";
    //个人简介
    self.mLab_jiaobaohao.frame = CGRectMake(93, 40, [dm getInstance].width-100, 20);
    self.mLab_jiaobaohao.text = [NSString stringWithFormat:@"教宝号:%@",self.mModel_personal.AccID];
    //相册标签
    self.mLab_albums.frame = CGRectMake(0, self.mImgV_head.frame.origin.y+self.mImgV_head.frame.size.height+15, [dm getInstance].width, 30);
    //相册图片
    //collectionview,单位列表
    self.mCollectionV_albums.frame = CGRectMake(0, self.mLab_albums.frame.origin.y+self.mLab_albums.frame.size.height, [dm getInstance].width, 80);
    self.mCollectionV_albums.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [self.mCollectionV_albums registerClass:[ShareCollectionViewCell class] forCellWithReuseIdentifier:PersonSpaceAlbums];
    
    //文章标签
    self.mLab_arth.frame = CGRectMake(0, self.mCollectionV_albums.frame.origin.y+self.mCollectionV_albums.frame.size.height, [dm getInstance].width, self.mLab_arth.frame.size.height);
    //文章列表
    self.mTableV_arth.frame = CGRectMake(0, self.mLab_arth.frame.origin.y+self.mLab_arth.frame.size.height, [dm getInstance].width, 0);
    //加载更多按钮
    self.mBtn_add.frame = CGRectMake(0, self.mTableV_arth.frame.origin.y+self.mTableV_arth.frame.size.height, [dm getInstance].width, self.mBtn_add.frame.size.height);
    [self.mBtn_add addTarget:self action:@selector(mBtn_addArth:) forControlEvents:UIControlEventTouchUpInside];
    
    [self sendRequest];
}

-(void)sendRequest{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    //发送获取文章请求
    [[ShowHttp getInstance] showHttpGetUnitArthLIstIndexWith:@"99" UnitID:self.mModel_personal.AccID Page:[NSString stringWithFormat:@"%d",self.mInt_index]];
    //获取前N张照片
    [[ThemeHttp getInstance] themeHttpGetNewPhoto:self.mModel_personal.AccID Count:@"3"];
    
    [MBProgressHUD showMessage:@"" toView:self.view];
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

//个人最新前N张照片后，通知界面
-(void)GetNewPhoto:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSDictionary *dic = noti.object;
    NSMutableArray *array = [dic objectForKey:@"array"];
    if (array.count>0) {
        self.mArr_NewPhoto = [NSMutableArray arrayWithArray:array];
        [self.mCollectionV_albums reloadData];
    }else{
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.mCollectionV_albums.frame.origin.y, [dm getInstance].width, self.mCollectionV_albums.frame.size.height)];
        img.image = [UIImage imageNamed:@"noPhoto"];
        [self.mScrollV_all addSubview:img];
    }
}
//获取到头像后，更新界面
-(void)TopArthListIndexImg:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    [self.mTableV_arth reloadData];
}

//获取到文章的通知
-(void)TopArthListIndex:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSMutableDictionary *dic = noti.object;
    NSString *flag = [dic objectForKey:@"flag"];
    if ([flag intValue] ==0) {
        NSMutableArray *array = [dic objectForKey:@"array"];
        if (self.mInt_index > 1) {
            if (array.count>0) {
                [self.mArr_list addObjectsFromArray:array];
            }
        }else{
            self.mArr_list = [NSMutableArray arrayWithArray:array];
        }
        //刷新，布局
        [self.mTableV_arth reloadData];
        self.mTableV_arth.frame = CGRectMake(0, self.mTableV_arth.frame.origin.y, self.mTableV_arth.frame.size.width, self.mArr_list.count*70);
        self.mBtn_add.frame = CGRectMake(0, self.mTableV_arth.frame.origin.y+self.mTableV_arth.frame.size.height, [dm getInstance].width, self.mBtn_add.frame.size.height);
        self.mScrollV_all.contentSize = CGSizeMake([dm getInstance].width, self.mBtn_add.frame.origin.y+self.mBtn_add.frame.size.height);
    }else{
        [MBProgressHUD showError:@"超时" toView:self.view];
    }
    
}

//加载更多按钮
-(void)mBtn_addArth:(UIButton *)btn{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    if (self.mArr_list.count>=20) {
        self.mInt_index = (int)self.mArr_list.count/20+1;
        //发送获取文章请求
        [[ShowHttp getInstance] showHttpGetUnitArthLIstIndexWith:@"99" UnitID:self.mModel_personal.AccID Page:[NSString stringWithFormat:@"%d",self.mInt_index]];
        [MBProgressHUD showMessage:@"" toView:self.view];
    } else {
        [MBProgressHUD showError:@"没有更多了" toView:self.view];
    }
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
    cell.mLab_name.hidden = YES;
    //时间
    cell.mLab_time.text = model.RecDate;
    cell.mLab_time.frame = CGRectMake(cell.mLab_name.frame.origin.x, 70-12-size.height, cell.mLab_time.frame.size.width, size.height);
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

#pragma mark - Collection View Data Source
//每一组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section{
    return self.mArr_NewPhoto.count;
}
//定义并返回每个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ShareCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:PersonSpaceAlbums forIndexPath:indexPath];
    if (!cell) {
        
    }
    UnitAlbumsListModel *model = [self.mArr_NewPhoto objectAtIndex:indexPath.row];
    //文章个数
    cell.mImgV_red.hidden = YES;
    cell.mLab_count.hidden = YES;
    //图标
    //    cell.mImgV_background.frame = CGRectMake(10, 0, 40, 40);
    cell.mImgV_background.frame = CGRectMake((([dm getInstance].width-50)/3-([dm getInstance].width-50)/3)/2, 0, ([dm getInstance].width-50)/3, 60);
    [cell.mImgV_background sd_setImageWithURL:[NSURL  URLWithString:model.SMPhotoPath] placeholderImage:[UIImage  imageNamed:@"photo_default"]];
    return cell;
}

//设置每组的cell的边界
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UnitAlbumsViewController *Albums = [[UnitAlbumsViewController alloc] init];
    Albums.mStr_flag = @"1";//来自个人
    Albums.mModel_personal = self.mModel_personal;
    [utils pushViewController:Albums animated:YES];
}
//每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(([dm getInstance].width-50)/3, 80);
}

//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
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
