//
//  ButtonViewCell.m
//  JiaoBao
//
//  Created by Zqw on 15/8/11.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "ButtonViewCell.h"

@implementation ButtonViewCell

-(instancetype)initWithFrame:(CGRect)frame Model:(ButtonViewModel *)model Flag:(int)flag{
    self = [super init];
    if (self) {
        self.frame = frame;
        
        NSString *str = [NSString stringWithFormat:@"%@",model.mStr_title];
        CGSize titleSize = [str sizeWithFont:[UIFont systemFontOfSize:12]];
        self.mLab_title = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width-titleSize.width-15)/2+17, (frame.size.height-titleSize.height)/2, frame.size.width-(frame.size.width-titleSize.width-15)/2-17, titleSize.height)];
        self.mLab_title.font = [UIFont systemFontOfSize:12];
        self.mLab_title.backgroundColor = [UIColor clearColor];
        self.mLab_title.textAlignment = NSTextAlignmentLeft;
        self.mLab_title.textColor = [UIColor grayColor];
        self.mLab_title.text = str;
        [self addSubview:self.mLab_title];
        
        self.mImgV_pic = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-titleSize.width-15)/2, self.mLab_title.frame.origin.y, 15, 15)];
        [self.mImgV_pic setImage:[UIImage imageNamed:model.mStr_img]];
        [self addSubview:self.mImgV_pic];
        
        if (flag>1) {
            self.mLab_line = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-1, 7, .5, frame.size.height-14)];
            self.mLab_line.backgroundColor = [UIColor grayColor];
            [self addSubview:self.mLab_line];
        }
        
    }
    return self;
}

-(instancetype)initWithFrame1:(CGRect)frame Model:(ButtonViewModel *)model Flag:(int)flag select:(BOOL)select{
    self = [super init];
    if (self) {
        self.frame = frame;
        self.bModel = model;
        
        self.mImgV_pic = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-18)/2, 5, 18, 18)];
        [self addSubview:self.mImgV_pic];
        
        NSString *str = [NSString stringWithFormat:@"%@",model.mStr_title];
        CGSize titleSize = [str sizeWithFont:[UIFont systemFontOfSize:12]];
        self.mLab_title = [[UILabel alloc] initWithFrame:CGRectMake(0, 5+18+5, self.frame.size.width, titleSize.height)];
        self.mLab_title.font = [UIFont systemFontOfSize:12];
        self.mLab_title.backgroundColor = [UIColor clearColor];
        self.mLab_title.textAlignment = NSTextAlignmentCenter;
        
        self.mLab_title.text = str;
        
        //判断是否默认选中
        if (select) {
            [self.mImgV_pic setImage:[UIImage imageNamed:model.mStr_imgNow]];
            self.mLab_title.textColor = [UIColor colorWithRed:54/255.0 green:168/255.0 blue:12/255.0 alpha:1];
        }else{
            [self.mImgV_pic setImage:[UIImage imageNamed:model.mStr_img]];
            self.mLab_title.textColor = [UIColor colorWithRed:80/255.0 green:79/255.0 blue:79/255.0 alpha:1];
        }
        [self addSubview:self.mLab_title];
        
//        if (flag>1) {
//            self.mLab_line = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-1, 7, .5, frame.size.height-14)];
//            self.mLab_line.backgroundColor = [UIColor grayColor];
//            [self addSubview:self.mLab_line];
//        }
        
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
