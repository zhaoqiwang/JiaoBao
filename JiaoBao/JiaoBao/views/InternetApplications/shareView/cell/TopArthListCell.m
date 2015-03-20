//
//  TopArthListCell.m
//  JiaoBao
//
//  Created by Zqw on 14-11-18.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "TopArthListCell.h"

@implementation TopArthListCell
@synthesize mImgV_headImg,mLab_title,mLab_name,mLab_time,mImgV_viewCount,mLab_viewCount,mImgV_likeCount,mLab_likeCount,delegate,mLab_line;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)init:(TopArthListCell *)cell{
    if (cell!=nil) {
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(TopArthListCellLongPress:)];
        [self addGestureRecognizer:longPress];
    }
}

-(void)TopArthListCellLongPress:(UILongPressGestureRecognizer *)longPress{
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
            [self.delegate TopArthListCellLongPress:self];
            break;
//        case UIGestureRecognizerStateEnded:
//            D("press long ended");
//            
//            break;
//        case UIGestureRecognizerStateFailed:
//            D("press long failed");
//            break;
//        case UIGestureRecognizerStateChanged:
//            D("press long changed");
//            break;
        default:
            NSLog(@"press long else");
            break;
    }
}
//给头像添加点击事件
-(void)headImgClick{
    self.mImgV_headImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImgClick:)];
    [self.mImgV_headImg addGestureRecognizer:tap];
}

-(void)tapImgClick:(UIGestureRecognizer *)gest{
    [delegate TopArthListCellTapPress:self];
}

@end
