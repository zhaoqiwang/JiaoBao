//
//  ThemeSpaceViewController.h
//  JiaoBao
//
//  Created by Zqw on 14-12-17.
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
#import "ShareHttp.h"
#import "UnitAlbumsViewController.h"
#import "UnitSectionMessageModel.h"

@interface ThemeSpaceViewController : UIViewController<MyNavigationDelegate,UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>{
    MyNavigationBar *mNav_navgationBar;//导航条
    UIScrollView *mScrollV_all;//放所有控件
    UIImageView *mImgV_head;//头像
    UIButton *mBtn_att;//关注主题，tag=0未关注，tag=1已关注
    UILabel *mLab_detail;//主题简介
    UILabel *mLab_albums;//相册标签
    UIScrollView *mScrollV_img;
    UIPageControl *mPageC_page;
    UILabel *mLab_arth;//主题文章标签
    UITableView *mTableV_arth;//
    UIButton *mBtn_add;//加载更多文章按钮
    NSMutableArray *mArr_list;//文章数组
    int mInt_index;//加载的第几页文章
    MBProgressHUD *mProgressV;//
    NSString *mStr_title;//标题
    NSString *mStr_unitID;//id号
    NSMutableArray *mArr_newPhoto;//最新的N张照片
    NSString *mStr_tableID;//当前主题加密id
}

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) IBOutlet UIScrollView *mScrollV_all;//放所有控件
@property (nonatomic,strong) IBOutlet UIImageView *mImgV_head;//头像
@property (nonatomic,strong) IBOutlet UIButton *mBtn_att;//关注主题
@property (nonatomic,strong) IBOutlet UILabel *mLab_detail;//主题简介
@property (nonatomic,strong) IBOutlet UILabel *mLab_albums;//相册标签
@property (nonatomic,strong) IBOutlet UIScrollView *mScrollV_img;
@property (nonatomic,strong) IBOutlet UIPageControl *mPageC_page;
@property (nonatomic,strong) IBOutlet UILabel *mLab_arth;//主题文章标签
@property (nonatomic,strong) IBOutlet UITableView *mTableV_arth;//
@property (nonatomic,strong) IBOutlet UIButton *mBtn_add;//加载更多文章按钮
@property (nonatomic,strong) NSMutableArray *mArr_list;////文章数组
@property (nonatomic,assign) int mInt_index;//加载的第几页文章
@property (nonatomic,strong) MBProgressHUD *mProgressV;//
@property (nonatomic,strong) NSString *mStr_title;//标题
@property (nonatomic,strong) NSString *mStr_unitID;//id号
@property (nonatomic,strong) NSMutableArray *mArr_newPhoto;//最新的N张照片
@property (nonatomic,strong) NSString *mStr_tableID;//当前主题加密id

//关注主题按钮
-(IBAction)mBtn_att:(UIButton *)btn;

@end
