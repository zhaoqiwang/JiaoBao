//
//  QueryViewController.h
//  JiaoBao
//  请假查询界面
//  Created by SongYanming on 16/3/15.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyStdInfo.h"
#import "LeaveDetailViewController.h"

@interface QueryViewController : UITableViewController<UITableViewDelegate,LeaveDetailViewCDelegate>

@property (strong, nonatomic) IBOutlet UIView *sectionView;//班级查询列表section
@property (nonatomic,assign) int mInt_leaveID;//区分身份，门卫0，班主任1，普通老师2，家长3
@property (nonatomic,assign) int mInt_flag;//区分是个人查询还是家长查询

@property (strong, nonatomic) IBOutlet UIView *teaHeadView;//老师表头
@property (strong, nonatomic) IBOutlet UIView *ParentsHeadView;//家长表头
@property(nonatomic,assign)BOOL cellFlag;//1：有学生cell 0：没有学生cell
@property (strong, nonatomic) IBOutlet UIView *stuSection;//个人查询
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UITextField *dateTF;//家长选择时间输入框
@property (weak, nonatomic) IBOutlet UITextField *teaDateTF;//老师选择时间输入框
@property (weak, nonatomic) IBOutlet UIButton *dateBtn;
@property(strong,nonatomic)UITextField *dateTf;
@property (nonatomic,strong) MyStdInfo *mModel_student;//家长身份时，选择学生的信息
@property (weak, nonatomic) IBOutlet UIButton *stuBtn;
@property (weak, nonatomic) IBOutlet UIButton *parentDateBtn;
@property (nonatomic,assign) int mInt_flagID;//区分是查询老师自己1，学生0

- (IBAction)cancelToolAction:(id)sender;
- (IBAction)doneToolAction:(id)sender;
- (IBAction)datePickAction:(id)sender;

- (IBAction)Stu_SelectionAction:(id)sender;//家长身份选择学生
-(void)sendRequest;


@end
