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
#import "ParentSearchHeadView.h"
#import "TreeJob_node.h"
#import "LevelModel.h"
#import "TableViewWithBlock.h"
#import "MJRefresh.h"//上拉下拉刷新
#import "ButtonViewModel.h"
#import "ButtonView.h"

@interface ParentSearchViewController : UIViewController<MyNavigationDelegate,UITableViewDataSource,UITableViewDelegate,ButtonViewDelegate>
@property (strong, nonatomic) UIView *containerView;

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) ButtonView *mScrollV_all;//查询分类显示
@property (nonatomic,strong) IBOutlet UITableView *mTableV_list;//列表显示
@property (nonatomic,assign) int mInt_index;//查询选择的索引
@property (nonatomic,strong) NSMutableArray *mArr_nowHomework;//当前作业查询
@property (nonatomic,strong) NSMutableArray *mArr_overHomework;//完成情况查询
@property (nonatomic,strong) NSMutableArray *mArr_score;///学力查询
@property (nonatomic,strong) NSMutableArray *mArr_practice;//练习列表查询
@property (nonatomic,strong) NSArray *mArr_disScore;///学力查询,显示数据
@property (nonatomic,strong) NSMutableArray *mArr_parent;//家长信息数组，其中包括学生id
@property (nonatomic,strong) ParentSearchHeadView *mView_head;//表头
@property (nonatomic,strong) IBOutlet UILabel *mLab_select;//学生选择文字
@property (nonatomic,strong) IBOutlet UIButton *mBtn_select;//学生选择下拉按钮
@property (nonatomic,strong) TableViewWithBlock *mTableV_name;//下拉列表
@property (nonatomic,strong) GenInfo *mModel_gen;//当前选择的学生
@property (nonatomic,assign) int mInt_parctice;//练习查询的页码

//点击学生下拉选择
- (IBAction)selectStuBtnAction:(id)sender;

@end
