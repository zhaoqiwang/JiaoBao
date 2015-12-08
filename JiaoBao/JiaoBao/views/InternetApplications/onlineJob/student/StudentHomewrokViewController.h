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
#import "TreeJob_node.h"
#import "TreeJob_level0_model.h"
#import "GradeModel.h"
#import "SubjectModel.h"
#import "VersionModel.h"
#import "ChapterModel.h"
#import "TreeJob_default_TableViewCell.h"
#import "TreeJob_sigleSelect_TableViewCell.h"
#import "TreeView_node.h"
#import "PublishJobCellTableViewCell.h"
#import "OtherItemsCell.h"
#import "IQKeyboardManager.h"
#import "GetUnitInfoModel.h"

@interface StudentHomewrokViewController : UIViewController<MyNavigationDelegate,UITableViewDataSource,UITableViewDelegate,TreeJob_sigleSelect_TableViewCellDelegate,PublishJobDelegate,UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) UIScrollView *mScrollV_all;//做作业、做练习显示
@property (nonatomic,strong) IBOutlet UITableView *mTableV_list;//列表显示
@property (nonatomic,assign) int mInt_index;//练习选择的索引
@property (nonatomic,strong) NSMutableArray *mArr_homework;//老师布置作业列表
@property (nonatomic,strong) NSMutableArray *mArr_practice;//做练习列表
@property (nonatomic,strong) StuInfoModel *mModel_stuInf;//学生信息，包含id
@property (strong,nonatomic) NSMutableArray *mArr_sumData;//保存全部数据的数组--发布练习
@property (strong,nonatomic) NSArray *mArr_display;//保存要显示在界面上的数据的数组--发布练习
@property (strong,nonatomic) NSString *mStr_textName;//练习名称
@property (strong,nonatomic) GetUnitInfoModel *mModel_unitInfo;//获取到的单位信息

@end
