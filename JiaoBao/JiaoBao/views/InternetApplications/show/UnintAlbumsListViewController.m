//
//  UnintAlbumsListViewController.m
//  JiaoBao
//
//  Created by Zqw on 14-12-19.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "UnintAlbumsListViewController.h"
#import "ShareCollectionViewCell.h"
#import "Reachability.h"
#import <UMAnalytics/MobClick.h>

static NSString *UnitListAlbums = @"ShareCollectionViewCell";

@interface UnintAlbumsListViewController ()

@end

@implementation UnintAlbumsListViewController
@synthesize mArr_list,mCollectionV_albums,mNav_navgationBar,mModel_albums,mArr_bigPhoto,mModel_person,mStr_flag;

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
    //获取单位相册照片后，通知界面
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetUnitPhotoByGroupID" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetUnitPhotoByGroupID:) name:@"GetUnitPhotoByGroupID" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [[SDImageCache sharedImageCache] clearDisk];
//    [[SDImageCache sharedImageCache] clearMemory];
    
    self.mArr_list = [NSMutableArray array];
    self.mArr_bigPhoto = [NSMutableArray array];
    
    NSString *title;
    if ([self.mStr_flag intValue] == 1) {
        title = [NSString stringWithFormat:@"%@[照片]",self.mModel_person.GroupName];
    }else{
        title = [NSString stringWithFormat:@"%@[照片]",self.mModel_albums.nameStr];
    }
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:title];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    
    //collectionview,单位列表
    self.mCollectionV_albums.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height-[dm getInstance].statusBar, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height+[dm getInstance].statusBar);
    self.mCollectionV_albums.backgroundColor = [UIColor whiteColor];
    [self.mCollectionV_albums registerClass:[ShareCollectionViewCell class] forCellWithReuseIdentifier:UnitListAlbums];
    
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

//获取单位相册后，通知界面
-(void)GetUnitPhotoByGroupID:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSDictionary *dic = noti.object;
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
//    NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
    
    if([ResultCode integerValue]!=0)
    {
        [MBProgressHUD showError:@"数据错误或没有照片" toView:self.view];
        return;
    }
    NSMutableArray *array = [dic objectForKey:@"array"];    self.mArr_list = [NSMutableArray arrayWithArray:array];
    //将相册图片中的大图片路径，循环加入数组
    for (int i=0; i<self.mArr_list.count; i++) {
        UnitAlbumsListModel *model = [self.mArr_list objectAtIndex:i];
        [self.mArr_bigPhoto addObject:model.BIGPhotoPath];
    }
    [self.mCollectionV_albums reloadData];
}

//发送请求
-(void)sendRequest{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    if ([self.mStr_flag intValue] == 1) {
        [[ThemeHttp getInstance] themeHttpGetPhotoByGroup:self.mModel_person.accid GroupInfo:self.mModel_person.ID];
    }else{
        [[ThemeHttp getInstance] themeHttpGetUnitPhotoByGroupIDs:self.mModel_albums.UnitID GroupID:self.mModel_albums.TabID];
    }
    [MBProgressHUD showMessage:@"" toView:self.view];
}

#pragma mark - Collection View Data Source
//每一组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section{
    D("self.mArr_list.count-===%lu",(unsigned long)self.mArr_list.count);
    return self.mArr_list.count;
}
//定义并返回每个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ShareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:UnitListAlbums forIndexPath:indexPath];
    if (!cell) {
        
    }
    UnitAlbumsListModel *model = [self.mArr_list objectAtIndex:indexPath.row];
    //文章个数
    cell.mImgV_red.hidden = YES;
    cell.mLab_count.hidden = YES;
    //图标
    //    cell.mImgV_background.frame = CGRectMake(10, 0, 40, 40);
    cell.mImgV_background.frame = CGRectMake((([dm getInstance].width-50)/3-([dm getInstance].width-50)/3)/2, 0, ([dm getInstance].width-50)/3, 60);
    [cell.mImgV_background sd_setImageWithURL:[NSURL  URLWithString:model.SMPhotoPath] placeholderImage:[UIImage  imageNamed:@"photo_default"]];
    cell.mImgV_background.contentMode = UIViewContentModeScaleAspectFit;
    
    //标题
//    cell.mLab_name.text = model.nameStr;
//    CGSize size = [model.nameStr sizeWithFont:[UIFont systemFontOfSize:12]];
//    cell.mLab_name.font = [UIFont systemFontOfSize:12];
//    cell.mLab_name.textAlignment = NSTextAlignmentCenter;
//    cell.mLab_name.frame = CGRectMake(0, 40, ([dm getInstance].width-50)/3, size.height);
    return cell;
}

//设置每组的cell的边界
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [MobClick event:@"UnintAlbumsList_didSelectItem" label:@""];
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray array];
    
    for (int i = 0; i < [self.mArr_bigPhoto count]; i++) {
        // 替换为中等尺寸图片
        NSString * getImageStrUrl = [NSString stringWithFormat:@"%@", [self.mArr_bigPhoto objectAtIndex:i]];
        D("getImageStrUrl-====%@",getImageStrUrl);
        [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:getImageStrUrl]]];
    }
    self.photos = photos;
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;//分享按钮,默认是
    browser.displayNavArrows = NO;//左右分页切换,默认否
    browser.displaySelectionButtons = NO;//是否显示选择按钮在图片上,默认否
    browser.alwaysShowControls = NO;//控制条件控件 是否显示,默认否
    browser.zoomPhotosToFill = NO;//是否全屏,默认是
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    browser.wantsFullScreenLayout = YES;//是否全屏
#endif
    browser.enableGrid = NO;//是否允许用网格查看所有图片,默认是
    browser.startOnGrid = NO;//是否第一张,默认否
    browser.enableSwipeToDismiss = NO;
    [browser setCurrentPhotoIndex:indexPath.row];
    
    double delayInSeconds = 0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
    });
    
    self.navigationController.title = @"";
    [self.navigationController pushViewController:browser animated:YES];

}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    NSLog(@"Photo at index %lu selected %@", (unsigned long)index, selected ? @"YES" : @"NO");
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
    [self dismissViewControllerAnimated:YES completion:nil];
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
//    [[NSURLCache sharedURLCache] removeAllCachedResponses];
//    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    
//    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
//    [mgr cancelAll];
//    [mgr.imageCache clearMemory];
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
