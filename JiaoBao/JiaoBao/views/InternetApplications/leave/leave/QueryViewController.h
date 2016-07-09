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

@interface QueryViewController : UITableViewController<UITableViewDelegate,LeaveDetailViewCDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *sectionView;//班级查询列表section
@property (nonatomic,assign) int mInt_leaveID;//区分身份，门卫0，班主任1，普通老师2，家长3
@property (nonatomic,assign) int mInt_flag;//区分是个人查询还是家长查询

@property (strong, nonatomic) IBOutlet UIView *teaHeadView;//老师表头
@property (strong, nonatomic) IBOutlet UIView *ParentsHeadView;//家长表头
@property(nonatomic,assign)BOOL cellFlag;//1：有学生cell 0：没有学生cell
@property (strong, nonatomic) IBOutlet UIView *stuSection;//个人查询
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;//日期选择控件
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;//时间选择控件上的工具条
@property (weak, nonatomic) IBOutlet UITextField *dateTF;//家长选择时间输入框
@property (weak, nonatomic) IBOutlet UITextField *teaDateTF;//老师选择时间输入框
@property (weak, nonatomic) IBOutlet UIButton *dateBtn;//点击弹出日期选择控件
@property(strong,nonatomic)UITextField *dateTf;//当前选择的日期输入框
@property (nonatomic,strong) MyStdInfo *mModel_student;//家长身份时，选择学生的信息
@property (weak, nonatomic) IBOutlet UIButton *stuBtn;//选择学生按钮
@property (weak, nonatomic) IBOutlet UIButton *parentDateBtn;//家长日期选择按钮
@property (nonatomic,assign) int mInt_flagID;//区分是查询老师自己1，学生0

- (IBAction)cancelToolAction:(id)sender;//toolbar取消
- (IBAction)doneToolAction:(id)sender;//toolBar确定
- (IBAction)datePickAction:(id)sender;//时间选择方法

- (IBAction)Stu_SelectionAction:(id)sender;//家长身份选择学生
-(void)sendRequest;


@end
