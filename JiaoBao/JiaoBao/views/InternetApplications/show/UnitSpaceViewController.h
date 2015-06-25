//
//  UnitSpaceViewController.h
//  JiaoBao
//  单位空间
//  Created by Zqw on 14-12-14.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "dm.h"
#import "utils.h"
#import "MBProgressHUD.h"
#import "ShowHttp.h"
#import "UnitSpaceArthListViewController.h"
#import "UnitDetailViewController.h"
#import "UnitPeopleViewController.h"
#import "SubUnitInfoViewController.h"
#import "UnitAlbumsViewController.h"

@interface UnitSpaceViewController : UIViewController<MyNavigationDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MBProgressHUDDelegate>{
    MyNavigationBar *mNav_navgationBar;//导航条
    UIScrollView *mScrollV_img;
    UICollectionView *mCollectionV_unit;//放单位等
    NSString *mStr_title;//内务标题
    NSMutableArray *mArr_list;//需要显示数据
    UnitSectionMessageModel *mModel_unit;
    NSMutableArray *mArr_newPhoto;//最新的N张照片
    UIPageControl *mPageC_page;
}

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) IBOutlet UIScrollView *mScrollV_img;
@property (nonatomic,strong) IBOutlet UICollectionView *mCollectionV_unit;//放单位等
@property (nonatomic,strong) IBOutlet UIPageControl *mPageC_page;
@property (nonatomic,strong) NSString *mStr_title;//内务标题
@property (nonatomic,strong) NSMutableArray *mArr_list;//
@property (nonatomic,strong) UnitSectionMessageModel *mModel_unit;
@property (nonatomic,strong) NSMutableArray *mArr_newPhoto;//最新的N张照片

@end
