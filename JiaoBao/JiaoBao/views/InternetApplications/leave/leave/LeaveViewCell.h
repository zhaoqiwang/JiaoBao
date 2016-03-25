//
//  LeaveView.h
//  JiaoBao
//
//  Created by Zqw on 16/3/11.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonViewModel.h"

@interface LeaveViewCell : UIView

@property (nonatomic,strong) UIImageView *mImgV_pic;
@property (nonatomic,strong) UILabel *mLab_title;
@property (nonatomic,strong) UILabel *mLab_line;
@property (nonatomic,strong) ButtonViewModel *bModel;//

//上下
-(instancetype)initWithFrame1:(CGRect)frame Model:(ButtonViewModel *)model Flag:(int)flag select:(BOOL)select;

@end
