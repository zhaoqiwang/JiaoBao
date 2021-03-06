//
//  CheckSelectViewController.h
//  JiaoBao
//  审核的筛选条件界面
//  Created by Zqw on 16/3/24.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "dm.h"
#import "utils.h"
#import "define_constant.h"
#import "CheckSelectModel.h"
#import "CheckSelectTableViewCell.h"
#import "ChooseStudentViewController.h"

@protocol CheckSelectViewCDelegate;

@interface CheckSelectViewController : UIViewController<MyNavigationDelegate,UITableViewDataSource,UITableViewDelegate,CheckSelectTableViewCellDelegate,ChooseStudentViewCDelegate>

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) IBOutlet UITableView *mTableV_select;//筛选列表
@property (nonatomic,strong) NSMutableArray *mArr_list;//全部列表
@property (nonatomic,strong) NSMutableArray *mArr_dispaly;//显示列表
@property (nonatomic,assign) int mInt_flag;//0待审、已审，1统计查询
@property (weak,nonatomic) id<CheckSelectViewCDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *dateTF;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic,strong) NSString *mStr_checkName;//选择的几审


- (IBAction)cancelToolAction:(id)sender;
- (IBAction)doneToolAction:(id)sender;

@end

@protocol CheckSelectViewCDelegate <NSObject>

@optional

//点击确定后，返回model
- (void) CheckSelectViewCSelect:(leaveRecordModel *)model flag:(int)flag CheckName:(NSString *)name;

@end