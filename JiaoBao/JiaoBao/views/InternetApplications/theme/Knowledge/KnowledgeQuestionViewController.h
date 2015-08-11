//
//  KnowledgeQuestionViewController.h
//  JiaoBao
//
//  Created by Zqw on 15/8/10.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "dm.h"
#import "utils.h"
#import "MBProgressHUD.h"
#import "ButtonView.h"
#import "KnowledgeTableViewCell.h"
#import "QuestionModel.h"
#import "KnowledgeHttp.h"
#import "UIImageView+WebCache.h"
#import "AnswerByIdModel.h"
#import "MJRefresh.h"//上拉下拉刷新

@interface KnowledgeQuestionViewController : UIViewController<MyNavigationDelegate,ButtonViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) ButtonView *mBtnV_btn;//三个按钮
@property (nonatomic,strong) KnowledgeTableViewCell *mView_titlecell;//标题等
@property (nonatomic,strong) QuestionModel *mModel_question;//
@property (nonatomic,strong) UITableView *mTableV_answers;//答案列表
@property (nonatomic,strong) NSMutableArray *mArr_answers;//
@property (nonatomic,assign) int mInt_reloadData;//记录是刷新0还是加载更多1



@end
