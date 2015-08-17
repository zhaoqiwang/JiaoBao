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


@interface CommentViewController : UIViewController<MyNavigationDelegate,UITableViewDataSource,UITableViewDelegate,ButtonViewDelegate,UITextFieldDelegate,KnowledgeTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property(nonatomic,strong)QuestionModel *questionModel;
@property(nonatomic,strong)AnswerDetailModel *AnswerDetailModel;
@property (strong, nonatomic)  UITableView *tableView;
@property(nonatomic,assign)float cellHeight;
@property(nonatomic,strong)ButtonView *mBtnV_btn;
@property (nonatomic,strong) UITextField *mTextF_text;//输入框
@property(nonatomic,strong)UIView *mView_text;
@property(nonatomic,assign)int btn_tag;
@end
