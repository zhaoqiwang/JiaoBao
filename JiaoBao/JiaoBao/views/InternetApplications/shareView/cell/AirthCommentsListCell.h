//
//  AirthCommentsListCell.h
//  JiaoBao
//
//  Created by Zqw on 15-1-16.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AirthCommentsListCellDelegate;
@protocol AirthCommentsListCellHeadDelegate;

@interface AirthCommentsListCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel *mLab_Number;
@property (nonatomic,strong) IBOutlet UIImageView *mImg_head;
@property (nonatomic,strong) IBOutlet UILabel *mLab_UnitShortname;
@property (nonatomic,strong) IBOutlet UILabel *mLab_time;
@property (nonatomic,strong) IBOutlet UILabel *mLab_Commnets;
@property (nonatomic,strong) IBOutlet UIButton *mBtn_reply;
@property (nonatomic,strong) IBOutlet UIButton *mBtn_LikeCount;
@property (nonatomic,strong) IBOutlet UIButton *mBtn_CaiCount;
@property (nonatomic,strong) IBOutlet UIView *mView_RefID;
@property (weak,nonatomic) id<AirthCommentsListCellDelegate> delegate;
@property (weak,nonatomic) id<AirthCommentsListCellHeadDelegate> headDelegate;

-(IBAction)mBtn_reply:(UIButton *)sender;
-(IBAction)mBtn_LikeCount:(UIButton *)sender;
-(IBAction)mBtn_CaiCount:(UIButton *)sender;

//给头像添加点击事件
-(void)headImgClick;

@end

@protocol AirthCommentsListCellDelegate <NSObject>
//向cell中添加按钮事件
- (void) mBtn_reply:(AirthCommentsListCell *) airthCommentsListCell;
- (void) mBtn_LikeCount:(AirthCommentsListCell *) airthCommentsListCell;
- (void) mBtn_CaiCount:(AirthCommentsListCell *) airthCommentsListCell;

@end

@protocol AirthCommentsListCellHeadDelegate <NSObject>

//向cell中添加头像点击手势
- (void) AirthCommentsListCellHeadTapHeadPress:(AirthCommentsListCell *) airthCommentsListCell;

@end
