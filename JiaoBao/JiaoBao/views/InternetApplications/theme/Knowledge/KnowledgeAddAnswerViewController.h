//
//  KnowledgeAddAnswerViewController.h
//  JiaoBao
//
//  Created by Zqw on 15/8/11.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "dm.h"
#import "utils.h"
#import "MBProgressHUD.h"
#import "KnowledgeTableViewCell.h"
#import "QuestionModel.h"
#import "KnowledgeHttp.h"
#import "UIImageView+WebCache.h"
#import "AnswerByIdModel.h"

@interface KnowledgeAddAnswerViewController : UIViewController<MyNavigationDelegate,UITextViewDelegate>

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) KnowledgeTableViewCell *mView_titlecell;//标题等
@property (nonatomic,strong) QuestionModel *mModel_question;//
@property (nonatomic,strong) QuestionDetailModel *mModel_questionDetail;
@property (nonatomic,weak) IBOutlet UITextView *mTextV_answer;//回答
@property (nonatomic,weak) IBOutlet UITextView *mTextV_content;//内容
@property (nonatomic,weak) IBOutlet UIButton *mBtn_submit;//提交
@property (nonatomic,weak) IBOutlet UIButton *mBtn_anSubmit;//匿名提交
@property (nonatomic,weak) IBOutlet UILabel *mLab_answer;//回答提示
@property (nonatomic,weak) IBOutlet UILabel *mLab_content;//内容提示

-(IBAction)mBtn_submit:(id)sender;
-(IBAction)mBtn_anSubmit:(id)sender;

@end
