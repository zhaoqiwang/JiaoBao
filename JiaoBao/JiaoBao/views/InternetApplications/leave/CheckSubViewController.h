//
//  CheckSubViewController.h
//  JiaoBao
//  审批界面
//  Created by SongYanming on 16/3/24.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "utils.h"
#import "LeaveHttp.h"
#import "LeaveDetailModel.h"
#import "IQKeyboardManager.h"


@interface CheckSubViewController : UIViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;//同意
@property (weak, nonatomic) IBOutlet UIButton *refuseBtn;//拒绝
@property(nonatomic,strong)CheckLeaveModel *model;//审批假条http请求model
@property(nonatomic,strong)LeaveDetailModel *mModel_LeaveDetail;//请假详情model

@property (weak, nonatomic) IBOutlet UITextView *textView;//批注
@property (weak, nonatomic) IBOutlet UITextField *TitleTF;//批注提示输入框
- (IBAction)agreeAction:(id)sender;//同意
- (IBAction)fefuseAction:(id)sender;//拒绝
- (IBAction)submitBtnAction:(id)sender;//提交

@end

