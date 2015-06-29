//
//  UnitAlbumsViewController.h
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
#import "UnintAlbumsListViewController.h"
#import "UIImageView+WebCache.h"
#import "Identity_model.h"
#import "CreatAlbumsViewController.h"
#import "UpLoadPhotoViewController.h"

@interface UnitAlbumsViewController : UIViewController<MyNavigationDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MBProgressHUDDelegate,UIActionSheetDelegate,CreatAlbumsDelegate,UpLoadPhotoDelegate>{
    MyNavigationBar *mNav_navgationBar;//导航条
    UICollectionView *mCollectionV_albums;//放相册
    UnitSectionMessageModel *mModel_unit;//单位信息
    NSMutableArray *mArr_list;//
    UserInfoByUnitIDModel *mModel_personal;//个人信息
    NSString *mStr_flag;//判断是来自单位还是个人,1为个人
    NSMutableArray *mArr_myselfAlbums;//自己创建的相册
//    CreatAlbumsViewController *creatAlbums;
//    UpLoadPhotoViewController *uploadPhoto;
}

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) IBOutlet UICollectionView *mCollectionV_albums;//放相册
@property (nonatomic,strong) UnitSectionMessageModel *mModel_unit;
@property (nonatomic,strong) NSMutableArray *mArr_list;//
@property (nonatomic,strong) UserInfoByUnitIDModel *mModel_personal;//个人信息
@property (nonatomic,strong) NSString *mStr_flag;//判断是来自单位还是个人,1为个人
@property (nonatomic,strong) NSMutableArray *mArr_myselfAlbums;//自己创建的相册
//@property (nonatomic,strong) CreatAlbumsViewController *creatAlbums;
//@property (nonatomic,strong) UpLoadPhotoViewController *uploadPhoto;

@end
