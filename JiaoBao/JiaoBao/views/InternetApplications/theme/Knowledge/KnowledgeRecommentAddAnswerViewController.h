//
//  KnowledgeRecommentAddAnswerViewController.h
//  JiaoBao
//  推荐中的单个明细
//  Created by Zqw on 15/8/14.
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
#import "ELCImagePickerController.h"
#import "ShareHttp.h"
#include<AssetsLibrary/AssetsLibrary.h>
#import "KnowledgeQuestionViewController.h"

@interface KnowledgeRecommentAddAnswerViewController : UIViewController<MyNavigationDelegate,UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,KnowledgeTableViewCellDelegate>

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) KnowledgeTableViewCell *mView_titlecell;//标题等
@property (nonatomic,strong) QuestionModel *mModel_question;//
@property (nonatomic,strong) RecommentAddAnswerModel *mModel_recomment;//
@property (nonatomic,strong) IBOutlet UIScrollView *mScrollV_view;//
@property (nonatomic,strong) IBOutlet UITableView *mTableV_answer;//推荐答案列表
@property (nonatomic,assign) int mInt_index;//当前加载的是第几个html，head中的，和tableview中的


@end
