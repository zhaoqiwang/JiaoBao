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


@interface CommentViewController : UIViewController<MyNavigationDelegate,UITableViewDataSource,UITableViewDelegate,ButtonViewDelegate,UITextFieldDelegate,KnowledgeTableViewCellDelegate,UIWebViewDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)QuestionModel *questionModel;//
@property (nonatomic,strong) AnswerByIdModel *answerModel;
@property(nonatomic,strong) commentListModel *cellmodel;
@property(nonatomic,strong)AnswerDetailModel *AnswerDetailModel;
@property (strong, nonatomic)  UITableView *tableView;//评论列表
@property(nonatomic,strong)ButtonView *mBtnV_btn;//放举报 评论 反对按钮的view
@property (nonatomic,strong) UITextField *mTextF_text;//输入框
@property(nonatomic,strong)UIView *mView_text;
@property(nonatomic,assign)int btn_tag;//区别点击的是赞还是反对
@property (strong, nonatomic)  UIView *tableHeadView;
@property(nonatomic,assign)NSInteger topButtonTag;//区别是推荐还是精选
@property(nonatomic,assign)BOOL flag;//区别是否显示详情
@end
