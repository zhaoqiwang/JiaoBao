//
//  NoticeListViewController.h
//  JiaoBao
//
//  Created by Zqw on 14-11-29.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "dm.h"
#import "utils.h"
#import "ShareHttp.h"
#import "TopArthListCell.h"
#import "ArthDetailViewController.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"//上拉下拉刷新

@interface NoticeListViewController : UIViewController<MyNavigationDelegate,MBProgressHUDDelegate>{
    MyNavigationBar *mNav_navgationBar;//导航条
    UITableView *mTableV_list;//文章列表
    NSString *mStr_title;//班级名称
    NSString *mStr_classID;//班级ID
    NSMutableArray *mArr_list;//获取到的文章数组
    MBProgressHUD *mProgressV;//
    int mInt_index;//当前应该加载的第几页
    UnitNoticeModel *mModel_notice;//获取到的单位信息列表
}

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) IBOutlet UITableView *mTableV_list;//文章列表
@property (nonatomic,strong) NSString *mStr_title;//班级名称
@property (nonatomic,strong) NSString *mStr_classID;//班级ID
@property (nonatomic,strong) NSMutableArray *mArr_list;//获取到的文章数组
@property (nonatomic,strong) MBProgressHUD *mProgressV;//
@property (nonatomic,assign) int mInt_index;//当前应该加载的第几页
@property (nonatomic,strong) UnitNoticeModel *mModel_notice;//获取到的单位信息列表

@end
