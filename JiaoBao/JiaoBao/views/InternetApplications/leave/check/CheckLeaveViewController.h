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

@interface CheckLeaveViewController : UIViewController<MyNavigationDelegate,LeaveViewCellDelegate,CheckSelectViewCDelegate>

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) LeaveTopScrollView *mScrollV_all;//查询分类显示
@property (nonatomic,strong) NSString *mStr_navName;//导航条名称
@property (nonatomic,assign) int mInt_flag;//区分当前选择的是第几个
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *headView;
@property(nonatomic,strong)UIView *tableHeadView;
@property (strong, nonatomic) IBOutlet UIView *sectionView;
@property (strong, nonatomic) IBOutlet UIView *stuSection;
- (IBAction)conditionAction:(id)sender;

@end
