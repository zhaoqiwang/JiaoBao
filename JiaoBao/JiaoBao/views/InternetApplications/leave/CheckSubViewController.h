//
//  CheckSubViewController.h
//  JiaoBao
//
//  Created by SongYanming on 16/3/24.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "utils.h"
#import "LeaveHttp.h"
#import "LeaveDetailModel.h"
@protocol CheckSubVCDelegate;

@interface CheckSubViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *refuseBtn;
@property(nonatomic,strong)CheckLeaveModel *model;//审批假条http请求model
@property(nonatomic,strong)LeaveDetailModel *mModel_LeaveDetail;//请假详情model
@property (weak,nonatomic) id<CheckSubVCDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *TitleTF;
- (IBAction)agreeAction:(id)sender;
- (IBAction)fefuseAction:(id)sender;
- (IBAction)submitBtnAction:(id)sender;

@end
@protocol CheckSubVCDelegate<NSObject>
-(void)changeCheckState:(NSString*)State;
@end
