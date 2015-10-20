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
#import "GradeModel.h"
#import "SubjectModel.h"
#import "VersionModel.h"
#import "ChapterModel.h"
#import "TreeJob_sigleSelect_TableViewCell.h"
#import "TreeJob_questionCount_TableViewCell.h"

@interface MakeJobViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MyNavigationDelegate,ModelSelectionCellDelegate,MessageSelectionCellDelegate,TreeJob_class_TableViewCellDelegate,TreeJob_sigleSelect_TableViewCellDelegate,UITextFieldDelegate,TreeJob_questionCount_TableViewCellDelegate>

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (strong,nonatomic) IBOutlet UITableView *mTableV_work;
@property(strong,nonatomic) NSMutableArray *mArr_sumData;//保存全部数据的数组
@property(strong,nonatomic) NSArray *mArr_display;//保存要显示在界面上的数据的数组
@property (nonatomic,strong) MBProgressHUD *mProgressV;//
@property (nonatomic,assign) int mInt_index;//每个节点在全局中的索引
@property (nonatomic,assign) int mInt_modeSelect;//当前选择的哪个模式，0个性 1统一 2自定义
@property (nonatomic,assign) int mInt_parent;//是否通知家长，0是没选中 1是选中
@property (nonatomic,assign) int mInt_feedback;//是否通知反馈，0是没选中 1是选中
@property (nonatomic,strong) TreeJob_node *sigleClassNode;//统一作业中，单独的难度node
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)cancelBtnAction:(id)sender;
- (IBAction)doneBtnAction:(id)sender;

@end
