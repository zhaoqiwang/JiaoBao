//
//  TopArthListCell.h
//  JiaoBao
//
//  Created by Zqw on 14-11-18.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TopArthListCellDelegate;

@interface TopArthListCell : UITableViewCell{
    UIImageView *mImgV_headImg;//头像
    UILabel *mLab_title;//标题
    UILabel *mLab_name;//姓名
    UILabel *mLab_time;//时间
    UIImageView *mImgV_viewCount;//观看次数
    UILabel *mLab_viewCount;//
    UIImageView *mImgV_likeCount;//赞人数
    UILabel *mLab_likeCount;
    UILabel *mLab_line;//分割线
    id<TopArthListCellDelegate> delegate;
}

@property (nonatomic,strong) IBOutlet UIImageView *mImgV_headImg;//头像
@property (nonatomic,strong) IBOutlet UILabel *mLab_title;//标题
@property (nonatomic,strong) IBOutlet UILabel *mLab_name;//姓名
@property (nonatomic,strong) IBOutlet UILabel *mLab_time;//时间
@property (nonatomic,strong) IBOutlet UIImageView *mImgV_viewCount;//观看次数
@property (nonatomic,strong) IBOutlet UILabel *mLab_viewCount;//
@property (nonatomic,strong) IBOutlet UIImageView *mImgV_likeCount;//赞人数
@property (nonatomic,strong) IBOutlet UILabel *mLab_likeCount;
@property (nonatomic,strong) IBOutlet UILabel *mLab_line;//分割线
@property (strong,nonatomic) id<TopArthListCellDelegate> delegate;

-(void)init:(TopArthListCell *)cell;

//给头像添加点击事件
-(void)headImgClick;

@end

@protocol TopArthListCellDelegate <NSObject>
//向cell中添加长按手势
- (void) TopArthListCellLongPress:(TopArthListCell *) topArthListCell;

//向cell中添加头像点击手势
- (void) TopArthListCellTapPress:(TopArthListCell *) topArthListCell;

@end
