//
//  StudentHomewrokViewController.h
//  JiaoBao
//  学生作业总界面
//  Created by Zqw on 15/10/23.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "dm.h"
#import "utils.h"
#import "MJRefresh.h"//上拉下拉刷新
#import "StudentHomework_TableViewCell.h"
#import "Identity_model.h"
#import "Identity_UserClasses_model.h"
#import "OnlineJobHttp.h"
#import "StuHWModel.h"

@interface StudentHomewrokViewController : UIViewController<MyNavigationDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) UIScrollView *mScrollV_all;//做作业、做练习显示
@property (nonatomic,strong) IBOutlet UITableView *mTableV_list;//列表显示
@property (nonatomic,assign) int mInt_index;//练习选择的索引
@property (nonatomic,strong) NSMutableArray *mArr_homework;//老师布置作业列表
@property (nonatomic,strong) NSMutableArray *mArr_practice;//做练习列表


@end
