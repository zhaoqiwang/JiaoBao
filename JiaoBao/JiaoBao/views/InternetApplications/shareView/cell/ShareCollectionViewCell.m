//
//  ShareCollectionViewCell.m
//  JiaoBao
//
//  Created by Zqw on 14-11-15.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "ShareCollectionViewCell.h"
#import "dm.h"

@implementation ShareCollectionViewCell
@synthesize mLab_name,mImgV_red,mLab_count,mImgV_pic,mImgV_background;

//- (void)awakeFromNib {
    // Initialization code
//}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectedBackgroundView.backgroundColor = [UIColor grayColor];
        // Initialization code
        //背景图
        self.mImgV_background = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, self.frame.size.width-4, self.frame.size.height-4)];
        self.mImgV_background.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.mImgV_background];
        //图标
        self.mImgV_pic = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, self.frame.size.width-4, self.frame.size.height-4)];
        [self addSubview:self.mImgV_pic];
        //显示数字的红点
        self.mImgV_red = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, self.frame.size.width-4, self.frame.size.height-4)];
        [self addSubview:self.mImgV_red];
        //数字个数
        self.mLab_count = [[UILabel alloc] initWithFrame:self.mImgV_red.frame];
        [self addSubview:self.mLab_count];
        self.mLab_count.font = [UIFont systemFontOfSize:14];
        self.mLab_count.textAlignment = NSTextAlignmentCenter;
        self.mLab_count.textColor = [UIColor whiteColor];
        //标题
        self.mLab_name = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height-22, self.frame.size.width, 36)];
        self.mLab_name.textAlignment = NSTextAlignmentCenter;
        self.mLab_name.font = [UIFont systemFontOfSize:10];
        self.mLab_name.backgroundColor = [UIColor clearColor];
        [self addSubview:self.mLab_name];
    }
    return self;
}

@end
