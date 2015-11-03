//
//  ParentSearchViewController.h
//  JiaoBao
//  家长查询总界面
//  Created by Zqw on 15/11/2.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "dm.h"
#import "utils.h"
#import "define_constant.h"
#import "StudentHomework_TableViewCell.h"
#import "CompleteStatusModel.h"
#import "GenInfo.h"
#import "StuHWModel.h"


@interface ParentSearchViewController : UIViewController<MyNavigationDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) UIScrollView *mScrollV_all;//查询分类显示
@property (nonatomic,strong) IBOutlet UITableView *mTableV_list;//列表显示
@property (nonatomic,assign) int mInt_index;//查询选择的索引
@property (nonatomic,strong) NSMutableArray *mArr_nowHomework;//当前作业查询
@property (nonatomic,strong) NSMutableArray *mArr_overHomework;//完成情况查询
@property (nonatomic,strong) NSMutableArray *mArr_score;///学力查询
@property (nonatomic,strong) NSMutableArray *mArr_parent;//家长信息数组，其中包括学生id

@end
