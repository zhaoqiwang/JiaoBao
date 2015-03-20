//
//  UnintAlbumsListViewController.h
//  JiaoBao
//
//  Created by Zqw on 14-12-19.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "dm.h"
#import "utils.h"
#import "TopArthListModel.h"
#import "ShareHttp.h"
#import "MBProgressHUD.h"
#import "ThemeHttp.h"
#import "UIImageView+WebCache.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "MWPhotoBrowser.h"
#import <AssetsLibrary/AssetsLibrary.h>


@interface UnintAlbumsListViewController : UIViewController<MyNavigationDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MBProgressHUDDelegate,MWPhotoBrowserDelegate>{
    MyNavigationBar *mNav_navgationBar;//导航条
    UICollectionView *mCollectionV_albums;//放相册
    MBProgressHUD *mProgressV;//
    UnitAlbumsModel *mModel_albums;
    NSMutableArray *mArr_list;//
    NSMutableArray *mArr_bigPhoto;//存放大图片路径
    NSString *mStr_flag;//判断是来自单位还是个人,1为个人
    PersonPhotoModel *mModel_person;
}

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) IBOutlet UICollectionView *mCollectionV_albums;//放相册
@property (nonatomic,strong) MBProgressHUD *mProgressV;//
@property (nonatomic,strong) UnitAlbumsModel *mModel_albums;
@property (nonatomic,strong) NSMutableArray *mArr_list;//
@property (nonatomic,strong) NSMutableArray *mArr_bigPhoto;//存放大图片路径
@property (nonatomic,strong) NSString *mStr_flag;//判断是来自单位还是个人,1为个人
@property (nonatomic,strong) PersonPhotoModel *mModel_person;
@property (nonatomic, strong) NSMutableArray *photos;

@end

