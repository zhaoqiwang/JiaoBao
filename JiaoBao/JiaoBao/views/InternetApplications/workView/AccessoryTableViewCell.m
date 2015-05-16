//
//  AccessoryTableViewCell.m
//  JiaoBao
//
//  Created by Zqw on 15-3-13.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "AccessoryTableViewCell.h"

@implementation AccessoryTableViewCell
@synthesize mImgV_select,mLab_name,delegate;

//- (void)awakeFromNib {
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

//给头像添加点击事件
-(void)headImgClick{
    self.mImgV_select.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImgClick:)];
    [self.mImgV_select addGestureRecognizer:tap];
}

-(void)tapImgClick:(UIGestureRecognizer *)gest{
    [delegate AccessoryTableViewCellTapPress:self];
}

@end
