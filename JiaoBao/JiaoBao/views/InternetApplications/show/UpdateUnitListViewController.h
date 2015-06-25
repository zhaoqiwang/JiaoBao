//
//  UpdateUnitListViewController.h
//  JiaoBao
//  最新单位列表
//  Created by Zqw on 14-12-13.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "dm.h"
#import "utils.h"
#import "MBProgressHUD.h"
#import "ShowHttp.h"
#import "MJRefresh.h"//上拉下拉刷新
#import "UpdateUnitListModel.h"
#import "TopArthListCell.h"
#import "UnitSpaceViewController.h"
#import "ThemeHttp.h"
#import "ThemeSpaceViewController.h"

@interface UpdateUnitListViewController : UIViewController<MyNavigationDelegate,UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>{
    MyNavigationBar *mNav_navgationBar;//导航条
    UITableView *mTableV_list;//
    NSString *mStr_title;//标题
    NSString *mStr_flag;//1最新，2推荐,3主题
    NSString *mStr_local;//true本地，默认false
    int mInt_index;//第几页
    NSMutableArray *mArr_list;//
    
}

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) IBOutlet UITableView *mTableV_list;//
@property (nonatomic,strong) NSString *mStr_title;//内务标题
@property (nonatomic,strong) NSMutableArray *mArr_list;//
@property (nonatomic,strong) NSString *mStr_flag;//1最新，2推荐
@property (nonatomic,strong) NSString *mStr_local;//true本地，默认false
@property (nonatomic,assign) int mInt_index;//第几页

@end
