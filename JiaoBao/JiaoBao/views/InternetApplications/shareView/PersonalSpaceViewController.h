//
//  PersonalSpaceViewController.h
//  JiaoBao
//  个人空间
//  Created by Zqw on 14-12-15.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "dm.h"
#import "utils.h"
#import "TopArthListModel.h"
#import "ShareHttp.h"
#import "MBProgressHUD.h"
#import "TopArthListCell.h"
#import "ArthDetailViewController.h"
#import "ThemeHttp.h"
#import "UIImageView+WebCache.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@interface PersonalSpaceViewController : UIViewController<MyNavigationDelegate,UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    MyNavigationBar *mNav_navgationBar;//导航条
    UIScrollView *mScrollV_all;//放所有控件
    UIImageView *mImgV_head;//头像
    UILabel *mLab_detail;//个人简介
    UILabel *mLab_jiaobaohao;//
    UILabel *mLab_albums;//相册标签
    UICollectionView *mCollectionV_albums;//放相册中前N张照片
    
    UILabel *mLab_arth;//个人文章标签
    UITableView *mTableV_arth;//
    UIButton *mBtn_add;//加载更多文章按钮
    NSMutableArray *mArr_list;//文章数组
    int mInt_index;//加载的第几页文章
    UserInfoByUnitIDModel *mModel_personal;//个人信息
    MBProgressHUD *mProgressV;//
    NSMutableArray *mArr_NewPhoto;//获取到最新照片的数组
}

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) IBOutlet UIScrollView *mScrollV_all;//放所有控件
@property (nonatomic,strong) IBOutlet UIImageView *mImgV_head;//头像
@property (nonatomic,strong) IBOutlet UILabel *mLab_detail;//个人简介
@property (nonatomic,strong) IBOutlet UILabel *mLab_jiaobaohao;//
@property (nonatomic,strong) IBOutlet UILabel *mLab_albums;//相册标签
@property (nonatomic,strong) IBOutlet UICollectionView *mCollectionV_albums;//放相册中前N张照片
@property (nonatomic,strong) IBOutlet UILabel *mLab_arth;//个人文章标签
@property (nonatomic,strong) IBOutlet UITableView *mTableV_arth;//
@property (nonatomic,strong) IBOutlet UIButton *mBtn_add;//加载更多文章按钮
@property (nonatomic,strong) NSMutableArray *mArr_list;////文章数组
@property (nonatomic,assign) int mInt_index;//加载的第几页文章
@property (nonatomic,strong) UserInfoByUnitIDModel *mModel_personal;//个人信息
@property (nonatomic,strong) MBProgressHUD *mProgressV;//
@property (nonatomic,strong) NSMutableArray *mArr_NewPhoto;//获取到最新照片的数组

@end
