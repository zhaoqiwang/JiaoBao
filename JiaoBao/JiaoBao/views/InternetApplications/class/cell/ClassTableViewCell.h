//
//  ClassTableViewCell.h
//  JiaoBao
//
//  Created by Zqw on 15-3-26.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassTableViewCell : UITableViewCell{
    UIImageView *mImgV_head;//单位logo
    UILabel *mLab_name;//姓名
    UILabel *mLab_class;//班级
    UILabel *mLab_assessContent;//评价
    UIView *mView_background;//背景色
    UIImageView *mImgV_airPhoto;//文章logo
    UILabel *mLab_content;//内容
    UILabel *mLab_time;//时间
    UILabel *mLab_click;//点击量
    UILabel *mLab_clickCount;//点击量个数
    UILabel *mLab_assess;//评论
    UILabel *mLab_assessCount;//评论条数
    UILabel *mLab_like;//赞
    UILabel *mLab_likeCount;//赞个数
}

@property (nonatomic,strong) IBOutlet UIImageView *mImgV_head;//单位logo
@property (nonatomic,strong) IBOutlet UILabel *mLab_name;//姓名
@property (nonatomic,strong) IBOutlet UILabel *mLab_class;//班级
@property (nonatomic,strong) IBOutlet UILabel *mLab_assessContent;//评价
@property (nonatomic,strong) IBOutlet UIView *mView_background;//背景色
@property (nonatomic,strong) IBOutlet UIImageView *mImgV_airPhoto;//文章logo
@property (nonatomic,strong) IBOutlet UILabel *mLab_content;//内容
@property (nonatomic,strong) IBOutlet UILabel *mLab_time;//时间
@property (nonatomic,strong) IBOutlet UILabel *mLab_click;//点击量
@property (nonatomic,strong) IBOutlet UILabel *mLab_clickCount;//点击量个数
@property (nonatomic,strong) IBOutlet UILabel *mLab_assess;//评论
@property (nonatomic,strong) IBOutlet UILabel *mLab_assessCount;//评论条数
@property (nonatomic,strong) IBOutlet UILabel *mLab_like;//赞
@property (nonatomic,strong) IBOutlet UILabel *mLab_likeCount;//赞个数

@end
