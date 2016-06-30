//
//  CommentViewController.h
//  JiaoBao
//
//  Created by songyanming on 15/8/10.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "QuestionModel.h"
#import "UIImageView+WebCache.h"
#import "KnowledgeHttp.h"
#import "ButtonView.h"
#import "KnowledgeTableViewCell.h"
#import "MJRefresh.h"//上拉下拉刷新
#import "KnowledgeQuestionViewController.h"
#import "AirthCommentsListCell.h"


@interface CommentViewController : UIViewController<MyNavigationDelegate,UITableViewDataSource,UITableViewDelegate,ButtonViewDelegate,UITextFieldDelegate,KnowledgeTableViewCellDelegate,UIWebViewDelegate,UIAlertViewDelegate,AirthCommentsListCellDelegate,UITextViewDelegate>
@property(nonatomic,strong)QuestionModel *questionModel;//问题列表model
@property (nonatomic,strong) AnswerByIdModel *answerModel;//答案列表model
@property(nonatomic,strong) commentListModel *cellmodel;//评论列表model
@property(nonatomic,strong)AnswerDetailModel *AnswerDetailModel;//答案详情model
@property (strong, nonatomic)  UITableView *tableView;//评论列表
@property(nonatomic,strong)ButtonView *mBtnV_btn;//放举报 评论 反对按钮的view
@property(nonatomic,strong)UILabel *rdateLabel;//日期
@property (nonatomic,strong)IBOutlet UITextView *mTextV_text;//输入框
- (IBAction)doneAction:(id)sender;//确定按钮方法
@property(nonatomic,strong)UIView *mView_text;//键盘上面的view
@property(nonatomic,assign)int btn_tag;//区别点击的是赞还是反对 赞：-1 反对：0
@property (strong, nonatomic)  UIView *tableHeadView;//表头
@property(nonatomic,assign)NSInteger topButtonTag;//区别是推荐答案界面还是评论列表界面
@property(nonatomic,assign)BOOL flag;//0：推荐界面 1：评论列表界面
@property(nonatomic,strong)UIButton *doneBtn;//确定按钮
@end
