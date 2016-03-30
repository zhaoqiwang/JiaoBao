//
//  LeaveDetailViewController.h
//  JiaoBao
//  请假详情
//  Created by Zqw on 16/3/21.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "dm.h"
#import "utils.h"
#import "define_constant.h"
#import "LeaveDetailModel.h"
#import "LeaveDetailShowModel.h"
#import "LeaveDetailTableViewCell.h"
#import "LeaveHttp.h"
#import "LeaveDetailModel.h"
#import "ClassLeavesModel.h"
#import "CheckSubViewController.h"

@protocol LeaveDetailViewCDelegate;

@interface LeaveDetailViewController : UIViewController<MyNavigationDelegate,UITableViewDataSource,UITableViewDelegate,LeaveDetailTableViewCellDelegate,UIActionSheetDelegate>

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) NSString *mStr_navName;//导航条名称
@property (nonatomic,strong) IBOutlet UITableView *mTableV_leave;//请假列表
@property (nonatomic,strong) NSMutableArray *mArr_list;//详情显示列表
@property (nonatomic,strong) LeaveDetailModel *mModel_detail;//请假详情
@property (nonatomic,assign) int mInt_falg;//0学生，1老师
@property(nonatomic,strong)ClassLeavesModel *mModel_classLeaves;//审核或请假查询列表中的model
@property (nonatomic,assign) int mInt_from;//从哪个界面来的，0请假查询，1待审核，2已审核
@property (nonatomic,assign) int mInt_index;//当前数据，在表格数组中的索引
@property (nonatomic,assign) int mInt_check;//当前为第几审的数据
@property (weak,nonatomic) id<LeaveDetailViewCDelegate> delegate;

@end

@protocol LeaveDetailViewCDelegate <NSObject>

@optional

//点击确定后，返回              表格数组中的索引    0撤回，1修改，2老师审核，3门卫审核
- (void) LeaveDetailViewCDeleteLeave:(int)index action:(int)action;

@end