//
//  SubUnitInfoViewController.h
//  JiaoBao
//
//  Created by Zqw on 14-11-22.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "dm.h"
#import "utils.h"
#import "ShareHttp.h"
#import "MBProgressHUD.h"
#import "TreeView_Level0_Cell.h"
#import "ArthLIstViewController.h"
#import "UnitSpaceViewController.h"

@interface SubUnitInfoViewController : UIViewController<MyNavigationDelegate,MBProgressHUDDelegate>{
    MyNavigationBar *mNav_navgationBar;//导航条
    UITableView *mTableV_unit;//单位列表
//    NSString *mStr_UID;//班级ID
    NSMutableArray *mArr_unit;//获取到的文章数组
//    NSString *mStr_title;//标题
    MBProgressHUD *mProgressV;//
    int mInt_section;//判断是来自分享0还是展示1
    UnitSectionMessageModel *mModel_unit;//
}

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) IBOutlet UITableView *mTableV_unit;//单位列表
//@property (nonatomic,strong) NSString *mStr_UID;//班级ID
@property (nonatomic,strong) NSMutableArray *mArr_unit;//获取到的文章数组
//@property (nonatomic,strong) NSString *mStr_title;//标题
@property (nonatomic,strong) MBProgressHUD *mProgressV;//
@property (nonatomic,assign) int mInt_section;//判断是来自分享0还是展示1
@property (nonatomic,strong) UnitSectionMessageModel *mModel_unit;//

@end
