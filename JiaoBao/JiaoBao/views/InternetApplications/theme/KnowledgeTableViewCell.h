//
//  KnowledgeTableViewCell.h
//  JiaoBao
//
//  Created by Zqw on 15/8/5.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCLabel.h"
#import "QuestionModel.h"
#import "MWPhotoBrowser.h"
#import "AnswerByIdModel.h"
#import "AnswerDetailModel.h"
#import "PickContentModel.h"
#import "ShowPickedModel.h"
#import "AdView.h"

@protocol KnowledgeTableViewCellDelegate;

@interface KnowledgeTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MWPhotoBrowserDelegate>



@property (weak, nonatomic) IBOutlet UIButton *LikeBtn;
@property (nonatomic,strong) IBOutlet RCLabel *mLab_title;//标题
@property (nonatomic,strong) IBOutlet UILabel *mLab_Category0;//话题
@property (nonatomic,strong) IBOutlet UILabel *mLab_Category1;//话题
@property (nonatomic,strong) IBOutlet UILabel *mLab_Att;//关注
@property (nonatomic,strong) IBOutlet UILabel *mLab_AttCount ;//关注数量
@property (nonatomic,strong) IBOutlet UILabel *mLab_Answers;//回答
@property (nonatomic,strong) IBOutlet UILabel *mLab_AnswersCount;//回答数量
@property (nonatomic,strong) IBOutlet UILabel *mLab_View;//访问
@property (nonatomic,strong) IBOutlet UILabel *mLab_ViewCount;//访问数量
@property (nonatomic,strong) IBOutlet UILabel *mLab_LikeCount;//点赞
@property (nonatomic,strong) IBOutlet RCLabel *mLab_ATitle;//答案标题
@property (nonatomic,strong) IBOutlet RCLabel *mLab_Abstracts;//答案内容
@property (nonatomic,strong) IBOutlet UILabel *mLab_IdFlag;//回答者姓名
@property (nonatomic,strong) IBOutlet UILabel *mLab_RecDate;//时间
@property (nonatomic,strong) IBOutlet UILabel *mLab_comment;//评论
@property (nonatomic,strong) IBOutlet UILabel *mLab_commentCount;//评论数量
@property (nonatomic,strong) IBOutlet UILabel *mLab_line;//区分线
@property (nonatomic,strong) IBOutlet UIView *mView_background;//回答内容背景色
@property (nonatomic,strong) IBOutlet UIImageView *mImgV_head;//头像
@property (nonatomic,strong) IBOutlet UICollectionView *mCollectionV_pic;//图片显示
@property (nonatomic,strong) IBOutlet UILabel *mLab_line2;//区分线
@property (nonatomic,strong) IBOutlet UIButton *mBtn_detail;//详情按钮
@property (nonatomic,strong) IBOutlet UIWebView *mWebV_comment;//内容
@property (nonatomic,strong) IBOutlet UIButton *mBtn_all;//全部
@property (nonatomic,strong) IBOutlet UIButton *mBtn_evidence;//有证据
@property (nonatomic,strong) IBOutlet UIButton *mBtn_discuss;//在讨论--有内容
@property (nonatomic,strong) IBOutlet UIButton *mBtn_nodiscuss;//在讨论--无内容
@property (nonatomic,strong) IBOutlet UILabel *mLab_selectCategory;//选择话题
@property (nonatomic,strong) IBOutlet UILabel *mLab_selectCategory1;//选择话题
@property (nonatomic,strong) IBOutlet AdView *mScrollV_pic;//精选图片
@property (nonatomic,strong) IBOutlet UIImageView *mImgV_top;//是否置顶

@property (nonatomic,strong) QuestionModel *model;
@property(nonatomic,strong)NSMutableArray *photos;
@property (nonatomic,strong) AnswerModel *RecommentAnswerModel;

@property (nonatomic,strong) AnswerByIdModel *answerModel;
@property(nonatomic,strong)AnswerDetailModel *AnswerDetailModel;
@property (weak,nonatomic) id<KnowledgeTableViewCellDelegate> delegate;
@property (nonatomic,assign) int mInt_flag;//0是首页model、1是回答列表answerModel，3是精选pickContentModel
@property (nonatomic,strong) PickContentModel *pickContentModel;//精选
@property(nonatomic,strong)ShowPickedModel *ShowPickedModel;
@property (weak, nonatomic) IBOutlet UIImageView *answerImgV;
@property (weak, nonatomic) IBOutlet UIImageView *basisImagV;
@property (weak, nonatomic) IBOutlet UIImageView *askImgV;
@property (weak, nonatomic) IBOutlet UIPageControl *pagControl;//分页


//给标题和答案添加点击事件,赞
-(void)addTapClick;

-(IBAction)detailBtn:(id)sender;

//全部、有证据、在讨论按钮、无内容
-(IBAction)mBtn_all:(id)sender;
-(IBAction)mBtn_evidence:(id)sender;
-(IBAction)mBtn_discuss:(id)sender;
-(IBAction)mBtn_nodiscuss:(id)sender;

@end

//向cell中添加点击事件
@protocol KnowledgeTableViewCellDelegate <NSObject>

@optional

//点击标题
-(void) KnowledgeTableViewCellTitleBtn:(KnowledgeTableViewCell *) knowledgeTableViewCell;

//点击答案、依据
-(void)KnowledgeTableViewCellAnswers:(KnowledgeTableViewCell *) knowledgeTableViewCell;

//点赞
-(void)KnowledgeTableVIewCellLike:(KnowledgeTableViewCell *) knowledgeTableViewCell;

//详情按钮
-(void)KnowledgeTableVIewCellDetailBtn:(KnowledgeTableViewCell *) knowledgeTableViewCell;

//全部、有依据、在讨论按钮
-(void)KnowledgeTableVIewCellAllBtn:(KnowledgeTableViewCell *) knowledgeTableViewCell;
-(void)KnowledgeTableVIewCellEvidenceBtn:(KnowledgeTableViewCell *) knowledgeTableViewCell;
-(void)KnowledgeTableVIewCellDiscussBtn:(KnowledgeTableViewCell *) knowledgeTableViewCell;
-(void)KnowledgeTableVIewCellNoDiscuss:(KnowledgeTableViewCell *) knowledgeTableViewCell;

@end