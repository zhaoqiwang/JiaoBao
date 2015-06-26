//
//  UnitSpaceArthListViewController.h
//  JiaoBao
//  单位空间文章列表
//  Created by Zqw on 14-12-14.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "dm.h"
#import "utils.h"
#import "MBProgressHUD.h"
#import "ShowHttp.h"
#import "MJRefresh.h"//上拉下拉刷新
#import "TopArthListCell.h"
#import "TopArthListModel.h"
#import "ArthDetailViewController.h"

@interface UnitSpaceArthListViewController : UIViewController<MyNavigationDelegate,UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>{
    MyNavigationBar *mNav_navgationBar;//导航条
    UITableView *mTableV_list;//
    NSString *mStr_flag;//1分享，2展示
    int mInt_index;//第几页
    NSMutableArray *mArr_list;//
    UnitSectionMessageModel *mModel_unit;
}

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) IBOutlet UITableView *mTableV_list;//
@property (nonatomic,strong) NSMutableArray *mArr_list;//
@property (nonatomic,strong) NSString *mStr_flag;//1分享，2展示
@property (nonatomic,assign) int mInt_index;//第几页
@property (nonatomic,strong) UnitSectionMessageModel *mModel_unit;

@end
