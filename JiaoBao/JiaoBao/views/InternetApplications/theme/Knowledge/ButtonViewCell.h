//
//  ButtonViewCell.h
//  JiaoBao
//
//  Created by Zqw on 15/8/11.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonViewModel.h"

@interface ButtonViewCell : UIView

@property (nonatomic,strong) UIImageView *mImgV_pic;
@property (nonatomic,strong) UILabel *mLab_title;
@property (nonatomic,strong) UILabel *mLab_line;

-(instancetype)initWithFrame:(CGRect)frame Model:(ButtonViewModel *)model Flag:(int)flag;

@end
