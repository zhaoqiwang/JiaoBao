//
//  UnitPeopleViewController.h
//  JiaoBao
//  单位人员列表
//  Created by Zqw on 14-12-14.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "dm.h"
#import "utils.h"
#import "TopArthListModel.h"
#import "ShareHttp.h"
#import "MBProgressHUD.h"
#import "TreeView_node.h"
#import "TreeView_Level0_Cell.h"
#import "TreeView_Level0_Model.h"
#import "TreeView_Level1_Cell.h"
#import "TreeView_Level1_Model.h"
#import "TreeView_Level2_Cell.h"
#import "TreeView_Level2_Model.h"
#import "MBProgressHUD.h"
#import "ChineseString.h"
#import "pinyin.h"

@interface UnitPeopleViewController : UIViewController<MyNavigationDelegate,UITableViewDataSource,UITableViewDelegate,TreeView_Level2_CellDelegate,MBProgressHUDDelegate>{
    MyNavigationBar *mNav_navgationBar;//导航条
    UITableView *mTableV_list;//
    UnitSectionMessageModel *mModel_unit;
    NSMutableArray *mArr_list;//
    int mInt_index;//当往数组中添加数据时，记录当前的readflag
    NSMutableArray *mArr_sum;//当重新获取人员时，存储
}

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) IBOutlet UITableView *mTableV_list;//
@property (nonatomic,strong) UnitSectionMessageModel *mModel_unit;
@property (nonatomic,strong) NSMutableArray *mArr_list;//
@property (nonatomic,assign) int mInt_index;//当往数组中添加数据时，记录当前的readflag
@property (nonatomic,strong) NSMutableArray *mArr_sum;//当重新获取人员时，存储

@end
