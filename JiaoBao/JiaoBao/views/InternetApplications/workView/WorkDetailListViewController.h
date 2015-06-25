//
//  WorkDetailListViewController.h
//  JiaoBao
//  详情列表页，可加载更多，刷新
//  Created by Zqw on 14-11-3.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "utils.h"
#import "TreeView_Level2_Cell.h"
#import "dm.h"
#import "UnReadMsg_model.h"
#import "LoginSendHttp.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"//上拉下拉刷新
#import "MsgDetailViewController.h"

@interface WorkDetailListViewController : UIViewController<MyNavigationDelegate,UITableViewDataSource,UITableViewDelegate>{
    MyNavigationBar *mNav_navgationBar;//导航条
    UITableView *mTableV_detailist;//信息列表表格
    NSMutableArray *mArr_detail;//详情数组
    int mInt_page;//当前加载的第几页
    int mInt_tag;//加载的哪项
    NSString *mStr_navName;//传递nav名字
    NSString *mStr_url;//需要申请的url
    int mInt_refresh;//判断是刷新还是加载更多，1是加载，2是刷新
}

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) IBOutlet UITableView *mTableV_detailist;//信息列表
@property (nonatomic,strong) NSMutableArray *mArr_detail;//详情数组
@property (nonatomic,assign) int mInt_page;//当前加载的第几页
@property (nonatomic,assign) int mInt_tag;//加载的哪项
@property (nonatomic,strong) NSString *mStr_navName;//传递nav名字
@property (nonatomic,strong) NSString *mStr_url;//需要申请的url
@property (nonatomic,assign) int mInt_refresh;//判断是刷新还是加载更多

@end
