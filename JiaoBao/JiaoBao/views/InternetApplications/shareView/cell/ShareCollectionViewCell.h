//
//  ShareCollectionViewCell.h
//  JiaoBao
//
//  Created by Zqw on 14-11-15.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareCollectionViewCell : UICollectionViewCell{
    UIImageView *mImgV_background;//背景图
    UIImageView *mImgV_pic;//图标
    UIImageView *mImgV_red;//写未读消息的背景红点
    UILabel *mLab_count;//未读个数
    UILabel *mLab_name;//名称
}

@property (nonatomic,strong) UIImageView *mImgV_background;//背景图
@property (nonatomic,strong) UIImageView *mImgV_pic;//图标
@property (nonatomic,strong) UIImageView *mImgV_red;//写未读消息的背景红点
@property (nonatomic,strong) UILabel *mLab_count;//未读个数
@property (nonatomic,strong) UILabel *mLab_name;//名称

@end
