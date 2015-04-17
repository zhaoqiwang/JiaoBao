//
//  ClassTopViewController.h
//  JiaoBao
//
//  Created by Zqw on 15-3-31.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopArthListModel.h"
#import "ClassTableViewCell.h"
#import "dm.h"
#import "utils.h"
#import "ClassModel.h"
#import "ExchangeHttp.h"
#import "ArthDetailViewController.h"
#import "MJRefresh.h"//上拉下拉刷新
#import "ClassHttp.h"
#import "UnitSpaceViewController.h"

@interface ClassTopViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MyNavigationDelegate,MBProgressHUDDelegate,ClassTableViewCellClassDelegate,ClassTableViewCellDelegate,ClassTableViewCellHeadImgDelegate>{
    MyNavigationBar *mNav_navgationBar;//导航条
    UITableView *mTableV_list;//列表显示
    NSMutableArray *mArr_list;//列表数组
    NSMutableArray *mArr_list_class;//列表数组,班级时用
    MBProgressHUD *mProgressV;//
    int mInt_flag;//判断是否在下拉刷新
    int mInt_unit_class;//判断的是要加载单位1还是班级2
    NSString *mStr_classID;//当显示班级时，班级ID
    NSString *mStr_navName;//当为班级时，加载班级名称
}
@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) IBOutlet UITableView *mTableV_list;//列表显示
@property (nonatomic,strong) NSMutableArray *mArr_list;//列表数组
@property (nonatomic,strong) NSMutableArray *mArr_list_class;//列表数组,班级时用
@property (nonatomic,strong) MBProgressHUD *mProgressV;//
@property (assign,nonatomic) int mInt_flag;//判断是否在下拉刷新
@property (assign,nonatomic) int mInt_unit_class;//判断的是要加载单位1还是班级2
@property (nonatomic,strong) NSString *mStr_classID;//当显示班级时，班级ID
@property (nonatomic,strong) NSString *mStr_navName;//当为班级时，加载班级名称

@end
