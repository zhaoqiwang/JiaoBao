//
//  Forward_cell.m
//  JiaoBao
//
//  Created by Zqw on 14-11-6.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "Forward_cell.h"

@implementation Forward_cell
@synthesize mLab_name,mImgV_select;

//- (void)awakeFromNib {
//    // Initialization code
//}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectedBackgroundView.backgroundColor = [UIColor grayColor];
        // Initialization code
        UIImage *img = [UIImage imageNamed:@"forward_select1"];
        self.mImgV_select = [[UIImageView alloc] initWithFrame:CGRectMake(5, (self.frame.size.height-img.size.height)/2, img.size.width, img.size.height)];
        [self.mImgV_select setImage:img];
        [self addSubview:self.mImgV_select];
        
        self.mLab_name = [[UILabel alloc] initWithFrame:CGRectMake(self.mImgV_select.frame.origin.x+img.size.width+5, 2, self.frame.size.width-47, 36)];
        self.mLab_name.font = [UIFont systemFontOfSize:12];
        self.mLab_name.backgroundColor = [UIColor clearColor];
        [self addSubview:self.mLab_name];
    }
    return self;
}

@end
