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
        
        NSString *str = [NSString stringWithFormat:@"     %@",model.mStr_title];
        CGSize titleSize = [str sizeWithFont:[UIFont systemFontOfSize:12]];
        self.mLab_title = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width-titleSize.width)/2, (frame.size.height-titleSize.height)/2, titleSize.width, titleSize.height)];
        self.mLab_title.font = [UIFont systemFontOfSize:12];
        self.mLab_title.backgroundColor = [UIColor clearColor];
        self.mLab_title.textAlignment = NSTextAlignmentRight;
        self.mLab_title.textColor = [UIColor grayColor];
        self.mLab_title.text = str;
        [self addSubview:self.mLab_title];
        
        self.mImgV_pic = [[UIImageView alloc] initWithFrame:CGRectMake(self.mLab_title.frame.origin.x, self.mLab_title.frame.origin.y, 15, 15)];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
