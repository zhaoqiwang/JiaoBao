//
//  WorkViewListCell.m
//  JiaoBao
//
//  Created by Zqw on 15-2-9.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "WorkViewListCell.h"
#import "CommentCell.h"

@implementation WorkViewListCell
@synthesize mImgV_head,mLab_content,mLab_line,mLab_name,mLab_time,mImgV_unRead,mLab_unRead,delegate,mLab_unit;


//给头像添加点击事件
-(void)headImgClick{
    self.mImgV_head.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImgClick:)];
    [self.mImgV_head addGestureRecognizer:tap];
}

-(void)tapImgClick:(UIGestureRecognizer *)gest{
    [delegate WorkViewListCellTapPress:self];
}

//- (void)awakeFromNib {
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
