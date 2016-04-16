//
//  LeaveView.h
//  JiaoBao
//
//  Created by Zqw on 16/3/12.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeaveNowModel.h"
#import "LeaveNowTableViewCell.h"
#import "dm.h"
#import "ChooseStudentViewController.h"
#import "ModelDialog.h"
#import "StuInfoModel.h"
#import "addDateCell.h"

@interface LeaveView : UIView<UITableViewDataSource,UITableViewDelegate,ChooseStudentViewCDelegate,ModelDialogDelegate,addDateCellDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UITableView *mTableV_leave;//
@property (nonatomic,assign) NSInteger mInt_flag;//判断身份，班主任代请0，普通老师、班主任自己请假1，家长代请2
@property (nonatomic,assign) NSInteger mInt_flagID;//区分身份，门卫0，班主任1，普通老师2，家长3
@property (nonatomic,strong) NSMutableArray *mArr_leave;//
@property (nonatomic,strong) MyStdInfo *mModel_student;//家长身份时，选择学生的信息
@property (nonatomic,strong) StuInfoModel *mModel_studentInfo;//班主任身份时，选择学生的信息
@property (nonatomic,assign) int mInt_select0;//是1否0选择学生
@property (nonatomic,assign) int mInt_select1;//是1否0选择请假理由
@property (nonatomic,strong) UITextField *mTextF_reason;//cell输入框中的理由

//初始化
- (id)initWithFrame1:(CGRect)frame flag:(int)flag flagID:(int)flagID;

//生成一条请假条记录
-(void)NewLeaveModel:(NSNotification *)noti;

@end
