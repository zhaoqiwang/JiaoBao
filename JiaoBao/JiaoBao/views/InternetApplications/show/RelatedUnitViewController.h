//
//  RelatedUnitViewController.h
//  JiaoBao
//  相关单位列表
//  Created by Zqw on 14-12-14.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "dm.h"
#import "utils.h"
#import "ShowHttp.h"
#import "TopArthListCell.h"
#import "ShareHttp.h"
#import "MBProgressHUD.h"
#import "UnitSpaceViewController.h"

@interface RelatedUnitViewController : UIViewController<MyNavigationDelegate,UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>{
    MyNavigationBar *mNav_navgationBar;//导航条
    UIScrollView *mScrollV_all;
    UILabel *mLab_up;//上级单位标签
    UITableView *mTableV_list;//
    UILabel *mLab_down;//下级单位标签
    UITableView *mTableV_down;//下级单位
    NSString *mStr_title;//标题
    NSMutableArray *mArr_list;//上级单位数组
    NSMutableArray *mArr_down;//下级单位数组
    UnitSectionMessageModel *mModel_unit;
    MBProgressHUD *mProgressV;//
    NSString *mStr_UID;//单位id
}

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) IBOutlet UIScrollView *mScrollV_all;
@property (nonatomic,strong) IBOutlet UILabel *mLab_up;//上级单位标签
@property (nonatomic,strong) IBOutlet UITableView *mTableV_list;//
@property (nonatomic,strong) IBOutlet UILabel *mLab_down;//下级单位标签
@property (nonatomic,strong) IBOutlet UITableView *mTableV_down;//下级单位
@property (nonatomic,strong) NSString *mStr_title;//内务标题
@property (nonatomic,strong) NSMutableArray *mArr_list;//
@property (nonatomic,strong) NSMutableArray *mArr_down;//下级单位数组
@property (nonatomic,strong) UnitSectionMessageModel *mModel_unit;
@property (nonatomic,strong) MBProgressHUD *mProgressV;//
@property (nonatomic,strong) NSString *mStr_UID;//单位id

@end
