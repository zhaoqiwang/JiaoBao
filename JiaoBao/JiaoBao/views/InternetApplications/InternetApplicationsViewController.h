//
//  InternetApplicationsViewController.h
//  JiaoBao
//
//  Created by Zqw on 14-10-21.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Nav_internetAppView.h"
#import "InternetAppTopScrollView.h"
#import "InternetAppRootScrollView.h"
#import "Identity_model.h"
#import "Identity_UserClasses_model.h"
#import "Identity_UserUnits_model.h"
#import "RegisterViewController.h"
#import "KxMenu.h"//右上角下拉
#import "ShowHttp.h"
#import "MyFriendsViewController.h"
#import "ThemeHttp.h"
#import "WorkView_new2.h"
#import "ClassView.h"
#import "NewWorkViewController.h"

@interface InternetApplicationsViewController : UIViewController<Nav_internetAppViewDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,MBProgressHUDDelegate>{
    Nav_internetAppView *nav_internetAppView;
    UIView *mView_all;//放表格，使点击界面时，能隐藏
    UITableView *mTableV_left;//单位
    UITableView *mTableV_right;//部门
    int mInt_defaultTV_index;//记录点击默认表格的索引
    MBProgressHUD *mProgressV;//
    int mInt_flag;//返回执行
}
@property (strong,nonatomic) Nav_internetAppView *nav_internetAppView;
@property (strong,nonatomic) UIView *mView_all;//放表格，使点击界面时，能隐藏
@property (strong,nonatomic) UITableView *mTableV_left;//单位
@property (strong,nonatomic) UITableView *mTableV_right;//部门
@property (nonatomic,assign) int mInt_defaultTV_index;//记录点击默认表格的索引
@property (nonatomic,strong) MBProgressHUD *mProgressV;//
@property (nonatomic,assign) int mInt_flag;//返回执行


@end
