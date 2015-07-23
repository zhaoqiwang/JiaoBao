//
//  AirthCommentsListCell.m
//  JiaoBao
//
//  Created by Zqw on 15-1-16.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "AirthCommentsListCell.h"

@implementation AirthCommentsListCell

- (void)awakeFromNib {
    // Initialization code
    [self.mBtn_reply.layer setMasksToBounds:YES];
    [self.mBtn_reply.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    [self.mBtn_reply.layer setBorderWidth:1.0]; //边框宽度
    CGColorRef colorref = [UIColor blueColor].CGColor;
    [self.mBtn_reply.layer setBorderColor:colorref];//边框颜色
    
    [self.mBtn_LikeCount.layer setMasksToBounds:YES];
    [self.mBtn_LikeCount.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    [self.mBtn_LikeCount.layer setBorderWidth:1.0]; //边框宽度
    [self.mBtn_LikeCount.layer setBorderColor:colorref];//边框颜色
    
    [self.mBtn_CaiCount.layer setMasksToBounds:YES];
    [self.mBtn_CaiCount.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    [self.mBtn_CaiCount.layer setBorderWidth:1.0]; //边框宽度
    [self.mBtn_CaiCount.layer setBorderColor:colorref];//边框颜色
}

//给头像添加点击事件
-(void)headImgClick{
    self.mImg_head.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImgClick:)];
    [self.mImg_head addGestureRecognizer:tap];
}

-(void)tapImgClick:(UIGestureRecognizer *)gest{
//    [self.headDelegate AirthCommentsListCellHeadTapHeadPress:self];
    [self.delegate AirthCommentsListCellHeadTapHeadPress:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)mBtn_reply:(UIButton *)sender{
    [self.delegate mBtn_reply:self];
}
-(IBAction)mBtn_LikeCount:(UIButton *)sender{
    [self.delegate mBtn_LikeCount:self];
}
-(IBAction)mBtn_CaiCount:(UIButton *)sender{
    [self.delegate mBtn_CaiCount:self];
}

@end
