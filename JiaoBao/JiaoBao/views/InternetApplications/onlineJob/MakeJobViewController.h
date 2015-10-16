//
//  MakeJobViewController.h
//  JiaoBao
//  布置作业---老师
//  Created by Zqw on 15/10/14.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dm.h"
#import "utils.h"
#import "MBProgressHUD.h"
#import "MyNavigationBar.h"
#import "TreeJob_node.h"
#import "TreeJob_level0_model.h"
#import "TreeJob_default_TableViewCell.h"
#import "TreeJob_class_model.h"
#import "TreeJob_class_TableViewCell.h"
#import "Mode_Selection_Cell.h"
#import "MessageSelectionCell.h"

@interface MakeJobViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MyNavigationDelegate,ModelSelectionCellDelegate,MessageSelectionCellDelegate>

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (strong,nonatomic) IBOutlet UITableView *mTableV_work;
@property(strong,nonatomic) NSMutableArray *mArr_sumData;//保存全部数据的数组
@property(strong,nonatomic) NSArray *mArr_display;//保存要显示在界面上的数据的数组
@property (nonatomic,strong) MBProgressHUD *mProgressV;//

@end
