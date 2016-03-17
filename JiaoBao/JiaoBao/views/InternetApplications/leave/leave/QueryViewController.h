//
//  QueryViewController.h
//  JiaoBao
//
//  Created by SongYanming on 16/3/15.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QueryViewController : UITableViewController<UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *tableHeadView;
@property (weak, nonatomic) IBOutlet UIButton *myBtn;//本人
@property (weak, nonatomic) IBOutlet UIButton *stdBtn;//学生

@property (strong, nonatomic) IBOutlet UIView *sectionView;
@property (nonatomic,assign) int mInt_leaveID;//区分身份，门卫0，班主任1，普通老师2，家长3
- (IBAction)selectionBtnAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *teaHeadView;
@property (strong, nonatomic) IBOutlet UIView *ParentsHeadView;
@property(nonatomic,assign)BOOL cellFlag;
@property (strong, nonatomic) IBOutlet UIView *stuSection;
- (IBAction)datePickAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
- (IBAction)cancelToolAction:(id)sender;
- (IBAction)doneToolAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *dateTF;
@property (weak, nonatomic) IBOutlet UIButton *dateBtn;

@end
