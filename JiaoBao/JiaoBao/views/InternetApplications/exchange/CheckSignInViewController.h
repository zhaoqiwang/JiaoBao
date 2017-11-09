//
//  CheckSignInViewController.h
//  JiaoBao
//
//  Created by SongYanming on 2017/11/7.
//  Copyright © 2017年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyNavigationBar.h"
#import "utils.h"
#import "dm.h"
#import "SignInHttp.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"//上拉下拉刷新
#import "TeacherSignInTableViewCell.h"
#import "Identity_UserUnits_model.h"
#import "CheckSignInCell.h"

@interface CheckSignInViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MyNavigationDelegate>

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) IBOutlet UITableView *mTableV_detailist;//信息列表
@property (nonatomic,strong) NSMutableArray *mArr_detail;//详情数组
@property (nonatomic,assign) int mInt_page;//当前加载的第几页
@property (nonatomic,assign) int mInt_tag;//加载的哪项
@property (nonatomic,strong) NSString *mStr_navName;//传递nav名字
@property (nonatomic,strong) NSString *mStr_url;//需要申请的url
@property (nonatomic,assign) int mInt_refresh;//判断是刷新还是加载更多
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UITextField *beginDate;
@property (weak, nonatomic) IBOutlet UITextField *endDate;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
- (IBAction)checkAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)cancelAction:(id)sender;
- (IBAction)doneAction:(id)sender;

@end
