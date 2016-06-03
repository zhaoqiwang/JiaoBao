//
//  UpdateLeaveViewController.h
//  JiaoBao
//  修改假条
//  Created by Zqw on 16/3/30.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "dm.h"
#import "utils.h"
#import "define_constant.h"
#import "MyStdInfo.h"
#import "MyAdminClass.h"
#import "LeaveHttp.h"
#import "StuInfoModel.h"
#import "UserClassInfo.h"
#import "ChooseStudentViewController.h"
#import "ModelDialog.h"
#import "addDateCell.h"
#import "LeaveNowTableViewCell.h"
#import "LeaveDetailModel.h"
#import "LeaveHttp.h"

@interface UpdateLeaveViewController : UIViewController<MyNavigationDelegate,UITableViewDataSource,UITableViewDelegate,ChooseStudentViewCDelegate,addDateCellDelegate,ModelDialogDelegate,UIActionSheetDelegate,UITextFieldDelegate>

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) NSString *mStr_navName;//导航条名称
@property (nonatomic,strong) IBOutlet UITableView *mTableV_leave;//
@property (nonatomic,strong) NSMutableArray *mArr_leave;//
@property (nonatomic,strong) LeaveDetailModel *mModel_detail;//请假详情
@property (nonatomic,assign) int mInt_flag;//班主任、家长代请0，老师请假1
@property (nonatomic,strong) UITextField *mTextF_reason;//cell输入框中的理由
@property (nonatomic,assign) int mInt_return;//=0返回，=1不返回
@property (nonatomic,strong) NSMutableArray *mArr_time;//记录原先的时间，提交时，和现在页面中的做对比

@end
