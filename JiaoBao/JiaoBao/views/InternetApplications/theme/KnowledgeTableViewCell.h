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

@protocol KnowledgeTableViewCellDelegate;

@interface KnowledgeTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) IBOutlet UILabel *mLab_title;//标题
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
@property (nonatomic,strong) QuestionModel *model;
@property (weak,nonatomic) id<KnowledgeTableViewCellDelegate> delegate;

//给标题和答案添加点击事件
-(void)addTapClick;

@end

//向cell中添加点击事件
@protocol KnowledgeTableViewCellDelegate <NSObject>

@optional

//点击标题
-(void) KnowledgeTableViewCellTitleBtn:(KnowledgeTableViewCell *) knowledgeTableViewCell;

//点击答案、依据
-(void)KnowledgeTableViewCellAnswers:(KnowledgeTableViewCell *) knowledgeTableViewCell;

@end