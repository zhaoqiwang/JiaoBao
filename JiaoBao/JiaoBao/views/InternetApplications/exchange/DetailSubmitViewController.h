//
//  DetailSubmitViewController.h
//  JiaoBao
//
//  Created by songyanming on 15/3/5.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "utils.h"
#import "TableViewWithBlock.h"
#import "Identity_UserUnits_model.h"




@interface DetailSubmitViewController : UIViewController<MyNavigationDelegate,UITextViewDelegate,UITextFieldDelegate>
- (IBAction)pullBtnAction:(id)sender;
@property(nonatomic,assign) BOOL isOpen;
@property (weak, nonatomic) IBOutlet UITextField *unitTF;
@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextView *textView2;
@property (nonatomic,strong) TableViewWithBlock *mTableV_name;//下拉选择框
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *selectedDate;
@property (weak, nonatomic) IBOutlet UILabel *recordDate;
@property (weak, nonatomic) IBOutlet UITextField *startTime;
@property (weak, nonatomic) IBOutlet UITextField *endTime;
@property(nonatomic,strong)NSString *selectedStr;
@property(nonatomic,assign)NSUInteger dayInterval;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
- (IBAction)cancelAction:(id)sender;
- (IBAction)doneAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIToolbar *SecToolBar;
@property (strong, nonatomic) IBOutlet UIDatePicker *secDatePicker;
@property(strong,nonatomic)NSDictionary *groupDic;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property(strong,nonatomic)NSArray *unitArr;
@property(nonatomic,strong)Identity_UserUnits_model *UserUnits_model;

@end
