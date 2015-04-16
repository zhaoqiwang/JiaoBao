//
//  ClassTableViewCell.m
//  JiaoBao
//
//  Created by Zqw on 15-3-26.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "ClassTableViewCell.h"

@implementation ClassTableViewCell
@synthesize mImgV_head,mLab_name,mLab_class,mLab_assessContent,mView_background,mImgV_airPhoto,mLab_content,mLab_time,mLab_click,mLab_clickCount,mLab_assess,mLab_assessCount,mLab_like,mLab_likeCount,mView_img,mImgV_0,mImgV_1,mImgV_2,delegate,mModel_class,ClassDelegate;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//给头像添加点击事件
-(void)thumbImgClick{
    self.mModel_class = [mModel_class init];
    self.mImgV_0.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImgClick0:)];
    [self.mImgV_0 addGestureRecognizer:tap];
    
    self.mImgV_1.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImgClick1:)];
    [self.mImgV_1 addGestureRecognizer:tap2];
    
    self.mImgV_2.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImgClick2:)];
    [self.mImgV_2 addGestureRecognizer:tap3];
}

-(void)tapImgClick0:(UIGestureRecognizer *)gest{
    [delegate ClassTableViewCellTapPress0:self ImgV:self.mImgV_0];
}

-(void)tapImgClick1:(UIGestureRecognizer *)gest{
    [delegate ClassTableViewCellTapPress1:self ImgV:self.mImgV_1];
}

-(void)tapImgClick2:(UIGestureRecognizer *)gest{
    [delegate ClassTableViewCellTapPress2:self ImgV:self.mImgV_2];
}

//给班级添加点击事件
-(void)classLabClick{
    self.mLab_class.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(classLabClick:)];
    [self.mLab_class addGestureRecognizer:tap];
}

-(void)classLabClick:(UIGestureRecognizer *)gest{
    [ClassDelegate ClassTableViewCellClassTapPress:self];
}

@end
