//
//  ModelDialog.h
//  JiaoBao
//
//  Created by SongYanming on 16/3/9.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeaveNowModel.h"
@protocol ModelDialogDelegate;
@interface ModelDialog : UIView<UITextFieldDelegate>
@property(nonatomic,strong)UITextField* selectedTF;//指向开始时间或者结束时间
@property (weak, nonatomic) IBOutlet UITextField *startDateTF;//开始时间输入框
@property (weak, nonatomic) IBOutlet UITextField *endDateTF;//结束时间输入框

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;//日期控件
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak,nonatomic) id<ModelDialogDelegate> delegate;
@property(nonatomic,assign)int flag;//0是修改 1是添加
@property(nonatomic,assign)NSUInteger row;
@property(nonatomic,strong)LeaveNowModel *model;
- (IBAction)cancelAction:(id)sender;//弹出框上的取消按钮
- (IBAction)doneAction:(id)sender;//弹出框上的完成按钮
- (IBAction)cancelToolAction:(id)sender;//toolbar上的取消按钮
- (IBAction)doneToolAction:(id)sender;//toolBar上的完成按钮
-(void )setUp;//初始化方法




@end
@protocol ModelDialogDelegate <NSObject>
@optional
-(void)LeaveNowModel:(LeaveNowModel*)model flag:(int)flag row:(NSInteger)row;

@end
