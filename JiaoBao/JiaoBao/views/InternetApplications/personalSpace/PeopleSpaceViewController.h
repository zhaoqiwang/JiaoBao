//
//  PeopleSpaceViewController.h
//  JiaoBao
//
//  Created by Zqw on 15/6/4.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dm.h"
#import "utils.h"
#import "MWPhotoBrowser.h"
#import "MyNavigationBar.h"
#import "define_constant.h"
#import "LoginSendHttp.h"
#import "JSONKit.h"
#import "RegisterHttp.h"
#import "PersonalSpaceModel.h"
#import "PeopleSpaceTableViewCell.h"
#import "ReviseNameViewController.h"
#import "UnitTableViewCell.h"
#import "MBProgressHUD.h"
#import "Reachability.h"

@interface PeopleSpaceViewController : UIViewController<MyNavigationDelegate,MBProgressHUDDelegate,UITableViewDataSource,UITableViewDelegate,unitCellDelegate>{
    MyNavigationBar *mNav_navgationBar;//导航条
    MBProgressHUD *mProgressV;//
    UITableView *mTableV_personalS;//表格
    NSMutableArray *mArr_personalS;//个人信息数组
    
}

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) MBProgressHUD *mProgressV;//
@property (nonatomic,strong) IBOutlet UITableView *mTableV_personalS;
@property (nonatomic,strong) NSMutableArray *mArr_personalS;//个人信息数组
@property (weak, nonatomic) IBOutlet UITableView *unitTabelView;

@end
