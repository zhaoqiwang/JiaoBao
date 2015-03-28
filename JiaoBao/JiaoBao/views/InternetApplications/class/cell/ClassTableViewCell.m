//
//  ClassTableViewCell.m
//  JiaoBao
//
//  Created by Zqw on 15-3-26.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "ClassTableViewCell.h"

@implementation ClassTableViewCell
@synthesize mImgV_head,mLab_name,mLab_class,mLab_assessContent,mView_background,mImgV_airPhoto,mLab_content,mLab_time,mLab_click,mLab_clickCount,mLab_assess,mLab_assessCount,mLab_like,mLab_likeCount;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
