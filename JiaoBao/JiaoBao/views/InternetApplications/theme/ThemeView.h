//
//  ThemeView.h
//  JiaoBao
//  主题
//  Created by Zqw on 14-12-16.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "dm.h"
#import "utils.h"
#import "MJRefresh.h"//上拉下拉刷新
#import "KnowledgeHttp.h"
#import "QuestionModel.h"
#import "KnowledgeTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "AllCategoryModel.h"
#import "KnowledgeQuestionViewController.h"
#import "KnowledgeAddAnswerViewController.h"
#import "KnowledgeRecommentAddAnswerViewController.h"
#import "HtmlString.h"
#import "CustomTextFieldView.h"
#import "OldChoiceViewController.h"
#import "AdView.h"

@interface ThemeView : UIView<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,KnowledgeTableViewCellDelegate,UIScrollViewDelegate>{
    
}

@property (nonatomic,strong) UIScrollView *mScrollV_all;//首页精选等
@property (nonatomic,strong) UITableView *mTableV_knowledge;//
@property (nonatomic,assign) int mInt_index;//首页等选择的索引
@property(nonatomic,strong)ItemModel *ItemModel;//选择的话题model
@property (nonatomic,assign) int mInt_reloadData;//记录是刷新0还是加载更多1
@property (nonatomic,strong) NSMutableArray *mArr_AllCategory;//首页精选等一级主题数组
@property (nonatomic,strong) UIButton *mBtn_down;//下拉选择按钮
@property(nonatomic,strong)NSMutableArray *mArr_selectCategory;//被选择的分类 数组
@property (nonatomic,strong) GetPickedByIdModel *mModel_getPickdById;//精选model
@property (nonatomic,strong) UILabel *mLab_warn;//提醒有几条数据被隐藏或删除，有证据列表


- (id)initWithFrame1:(CGRect)frame;
-(void)ProgressViewLoad;

@end
