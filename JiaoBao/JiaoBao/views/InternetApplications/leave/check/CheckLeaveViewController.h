//
//  CheckLeaveViewController.h
//  JiaoBao
//  审核总界面
//  Created by Zqw on 16/3/16.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonViewModel.h"
#import "LeaveTopScrollView.h"
#import "MyNavigationBar.h"
#import "dm.h"
#import "utils.h"
#import "define_constant.h"
#import "leaveRecordModel.h"
#import "MBProgressHUD+AD.h"
#import "LeaveHttp.h"
#import "leaveRecordModel.h"
#import "QueryCell.h"
#import "CustomQueryCell.h"
#import "CheckSelectViewController.h"
#import "LeaveDetailViewController.h"

@interface CheckLeaveViewController : UIViewController<MyNavigationDelegate,LeaveViewCellDelegate,CheckSelectViewCDelegate,LeaveDetailViewCDelegate>

@property (strong, nonatomic)UITextField *dateTF;//门卫审核 点击日期按钮用到
@property (weak, nonatomic) IBOutlet UILabel *stuOrTeaLabel;//section中的学生或教职工
@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) LeaveTopScrollView *mScrollV_all;//查询分类显示
@property (nonatomic,strong) NSString *mStr_navName;//导航条名称
@property (nonatomic,assign) int mInt_flag;//区分当前选择的是第几个
@property (weak, nonatomic) IBOutlet UITableView *tableView;//审核列表
@property (strong, nonatomic) IBOutlet UIView *sectionView;//统计查询列表的section
@property (strong, nonatomic) IBOutlet UIView *stuSection;//审核查询列表的section
@property (strong, nonatomic) IBOutlet UIView *manSection;//门卫查询列表的section
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;//日期选择控件上面的工具条
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;//日期选择控件
@property (weak, nonatomic) IBOutlet UIButton *conditionBtn;//筛选条件按钮
@property (weak, nonatomic) IBOutlet UILabel *ManOrClassLabel;//section中教职工或班级
- (IBAction)conditionAction:(id)sender;//筛选条件方法
- (IBAction)cancelAction:(id)sender;//日期选择控件上面的工具条的取消按钮
- (IBAction)doneAction:(id)sender;//日期选择控件上面的工具条的确定按钮

@end
