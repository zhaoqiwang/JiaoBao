//
//  TreeView_Level2_Cell.m
//  JiaoBao
//
//  Created by Zqw on 14-10-23.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "TreeView_Level2_Cell.h"

@implementation TreeView_Level2_Cell
@synthesize mLab_name,mNode,mImgV_head,mLab_detail,mLab_time,mImgV_select,delegate;

- (void)initWithSelectImg{
    UIImage *img = [UIImage imageNamed:@"forward_select1"];
    [self.mImgV_select setImage:img];
    self.mImgV_select.hidden = NO;
    self.mImgV_select.frame = CGRectMake(13, 11, 22, 22);
}
//给头像添加点击事件
-(void)headImgClick{
    self.mImgV_head.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImgClick:)];
    [self.mImgV_head addGestureRecognizer:tap];
}

-(void)tapImgClick:(UIGestureRecognizer *)gest{
    [delegate TreeView_Level2_CellTapPress:self];
}

@end
