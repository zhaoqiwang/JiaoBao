//
//  MyFriendsViewController.h
//  JiaoBao
//
//  Created by Zqw on 14-12-16.
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
#import "PersonalSpaceViewController.h"

@interface MyFriendsViewController : UIViewController<MyNavigationDelegate,UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>{
    MyNavigationBar *mNav_navgationBar;//导航条
    UITableView *mTableV_friends;//
    MBProgressHUD *mProgressV;//
    NSMutableArray *mArr_friends;//好友数组
    NSString *mStr_title;//标题
    int mInt_flag;//1好友，2关注
}

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) IBOutlet UITableView *mTableV_friends;//
@property (nonatomic,strong) NSMutableArray *mArr_friends;//好友数组
@property (nonatomic,strong) MBProgressHUD *mProgressV;//
@property (nonatomic,strong) NSString *mStr_title;//标题
@property (nonatomic,assign) int mInt_flag;//1好友，2关注

@end
