//
//  UnitSpaceViewController.m
//  JiaoBao
//
//  Created by Zqw on 14-12-14.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "UnitSpaceViewController.h"
#import "ShareCollectionViewCell.h"
#import "Reachability.h"
#import <UMAnalytics/MobClick.h>

static NSString *UnitSpaceCell = @"ShareCollectionViewCell";

@interface UnitSpaceViewController ()

@end

@implementation UnitSpaceViewController
@synthesize mArr_list,mStr_title,mNav_navgationBar,mCollectionV_unit,mScrollV_img,mModel_unit,mArr_newPhoto,mPageC_page;

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
    //单位最新前N张照片后，通知界面
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetUnitNewPhoto" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetUnitNewPhoto:) name:@"GetUnitNewPhoto" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mArr_list = [NSMutableArray array];
    self.mArr_list = [NSMutableArray arrayWithObjects:@"单位介绍",@"展示文章",@"分享文章",@"单位成员",@"下级单位",@"单位相册", nil];
    self.mArr_newPhoto = [NSMutableArray array];
    
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:self.mModel_unit.UnitName];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    
    self.mScrollV_img.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height-[dm getInstance].statusBar, [dm getInstance].width, 200);
    self.mScrollV_img.pagingEnabled = YES;
    self.mPageC_page.frame = CGRectMake(0, self.mScrollV_img.frame.origin.y+self.mScrollV_img.frame.size.height-self.mPageC_page.frame.size.height, [dm getInstance].width, self.mPageC_page.frame.size.height);
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mView_albumspress:)];
    [self.mScrollV_img addGestureRecognizer:singleTap1];
    
    //collectionview,单位列表
    self.mCollectionV_unit.frame = CGRectMake(0, self.mScrollV_img.frame.origin.y+self.mScrollV_img.frame.size.height, [dm getInstance].width, 400);
    self.mCollectionV_unit.backgroundColor = [UIColor whiteColor];
    [self.mCollectionV_unit registerClass:[ShareCollectionViewCell class] forCellWithReuseIdentifier:UnitSpaceCell];
    //设置本身大小和内容大小
    self.mCollectionV_unit.frame = CGRectMake(self.mCollectionV_unit.frame.origin.x, self.mCollectionV_unit.frame.origin.y, self.mCollectionV_unit.frame.size.width, self.mCollectionV_unit.collectionViewLayout.collectionViewContentSize.height);
    //设置照片展示
    [self setScrollViewImageShow];
    //获取当前单位的前N张照片
    [self sendRequst];
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

//点击图片后，实现跳转页面
-(void)mView_albumspress:(UIGestureRecognizer *)gest{
    UnitAlbumsViewController *Albums = [[UnitAlbumsViewController alloc] init];
    Albums.mModel_unit = self.mModel_unit;
    Albums.mStr_flag = @"2";
    [utils pushViewController:Albums animated:YES];
}

//单位最新前N张照片后，通知界面
-(void)GetUnitNewPhoto:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSDictionary *dic = noti.object;
//    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
//    NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
//    
//    if([ResultCode integerValue]!=0)
//    {
//        self.mProgressV.mode = MBProgressHUDModeCustomView;
//        self.mProgressV.labelText = ResultDesc;
//        [self.mProgressV show:YES];
//        [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
//        return;
//    }
    NSMutableArray *array = [dic objectForKey:@"array"];
    self.mArr_newPhoto = [NSMutableArray arrayWithArray:array];
    //设置照片展示
    [self setScrollViewImageShow];
}

//获取当前单位的前N张照片
-(void)sendRequst{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    if ([self.mModel_unit.UnitType intValue]==3) {
        [[ThemeHttp getInstance] themeHttpGetUnitNewPhoto:[NSString stringWithFormat:@"-%@",self.mModel_unit.UnitID] count:@"4"];
    }else {
        [[ThemeHttp getInstance] themeHttpGetUnitNewPhoto:self.mModel_unit.UnitID count:@"4"];
    }
    [MBProgressHUD showMessage:@"加载图片中..." toView:self.view];
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
            img.backgroundColor = [UIColor blackColor];
//            img.contentMode = UIViewContentModeScaleAspectFill;
            img.contentMode = UIViewContentModeScaleAspectFit;
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

#pragma mark - Collection View Data Source
//每一组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section{
    return self.mArr_list.count;
}
//定义并返回每个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ShareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:UnitSpaceCell forIndexPath:indexPath];
    if (!cell) {
        
    }
    NSString *name = [self.mArr_list objectAtIndex:indexPath.row];
    //文章个数
    cell.mImgV_red.hidden = YES;
    cell.mLab_count.hidden = YES;
    //图标
//    cell.mImgV_background.frame = CGRectMake(10, 0, 40, 40);
    cell.mImgV_background.frame = CGRectMake((([dm getInstance].width-50)/3-40)/2, 10, 40, 40);
    if (indexPath.row == 0) {
        cell.mImgV_background.image = [UIImage imageNamed:@"share_new0"];
    }else if (indexPath.row == 4){
        cell.mImgV_background.image = [UIImage imageNamed:@"share_next0"];
    }else {
        cell.mImgV_background.image = [UIImage imageNamed:@"share_new0"];
    }
    
    //标题
    cell.mLab_name.text = name;
    CGSize size = [name sizeWithFont:[UIFont systemFontOfSize:12]];
    cell.mLab_name.font = [UIFont systemFontOfSize:12];
    cell.mLab_name.frame = CGRectMake(0, 40, ([dm getInstance].width-50)/3, size.width);
    if (size.width>cell.mLab_name.frame.size.width) {
        cell.mLab_name.numberOfLines = 2;
    }
    return cell;
}

//设置每组的cell的边界
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {//单位介绍
        [MobClick event:@"UnitSpace_didSelectItem" label:@"单位介绍"];
        UnitDetailViewController *detail = [[UnitDetailViewController alloc] init];
        detail.mModel_unit = self.mModel_unit;
        [utils pushViewController:detail animated:YES];
    }else if (indexPath.row == 1){//展示文章
        [MobClick event:@"UnitSpace_didSelectItem" label:@"展示文章"];
        UnitSpaceArthListViewController *list = [[UnitSpaceArthListViewController alloc] init];
        list.mStr_flag = @"2";//1共享2展示
        list.mModel_unit = self.mModel_unit;
        [utils pushViewController:list animated:YES];
    }else if (indexPath.row == 2){//分享文章
        [MobClick event:@"UnitSpace_didSelectItem" label:@"分享文章"];
        UnitSpaceArthListViewController *list = [[UnitSpaceArthListViewController alloc] init];
        list.mStr_flag = @"1";//1共享2展示
        list.mModel_unit = self.mModel_unit;
        [utils pushViewController:list animated:YES];
    }else if (indexPath.row == 3){//单位成员
        [MobClick event:@"UnitSpace_didSelectItem" label:@"单位成员"];
        UnitPeopleViewController *people = [[UnitPeopleViewController alloc] init];
        people.mModel_unit = self.mModel_unit;
        [utils pushViewController:people animated:YES];
    }else if (indexPath.row == 4){//下级单位
        [MobClick event:@"UnitSpace_didSelectItem" label:@"下级单位"];
        if ([self.mModel_unit.UnitType intValue] == 3) {
            [MBProgressHUD showError:@"班级没有下级" toView:self.view];
        }else{
            SubUnitInfoViewController *subUnit = [[SubUnitInfoViewController alloc] init];
            subUnit.mModel_unit = self.mModel_unit;
            subUnit.mInt_section = 0;
            [utils pushViewController:subUnit animated:YES];
        }
    }else if (indexPath.row == 5){//单位相册
        [MobClick event:@"UnitSpace_didSelectItem" label:@"单位相册"];
        UnitAlbumsViewController *Albums = [[UnitAlbumsViewController alloc] init];
        Albums.mModel_unit = self.mModel_unit;
        Albums.mStr_flag = @"2";
        [utils pushViewController:Albums animated:YES];
    }
}
//每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(([dm getInstance].width-50)/3, 60);
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
//    [[SDImageCache sharedImageCache] clearDisk];
//    [[SDImageCache sharedImageCache] clearMemory];
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
