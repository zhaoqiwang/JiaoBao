//
//  SigleNameImgBtnView.m
//  JiaoBao
//
//  Created by Zqw on 15/10/15.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "SigleNameImgBtnView.h"

@implementation SigleNameImgBtnView

//          此按钮宽度，可传0   按钮高度                按钮标题                是否选中，是1否0
-(id)initWidth:(float)width height:(float)height title:(NSString *)title select:(int)flag{
    self = [super init];
    if (self) {
        self.mInt_flag = flag;
        
        CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:12]];
        self.mLab_title = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, titleSize.width, height)];
        self.mLab_title.text = title;
        self.mLab_title.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.mLab_title];
        
        self.mImg_head = [[UIImageView alloc] init];
        self.mImg_head.frame = CGRectMake(16+titleSize.width+2, (height-14)/2, 14, 14);
        if (self.mInt_flag ==1) {
            [self.mImg_head setImage:[UIImage imageNamed:@"selected"]];
        }else{
            [self.mImg_head setImage:[UIImage imageNamed:@"blank"]];
        }
        [self addSubview:self.mImg_head];
        
        //
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonViewClick:)];
        [self addGestureRecognizer:tap];
        
        self.frame = CGRectMake(0, 0, self.mImg_head.frame.origin.x+16, height);
    }
    return self;
}

-(void)buttonViewClick:(UIGestureRecognizer *)gest{
    if (self.mInt_flag ==1) {
        self.mInt_flag =0;
        [self.mImg_head setImage:[UIImage imageNamed:@"blank"]];
    }else{
        self.mInt_flag = 1;
        [self.mImg_head setImage:[UIImage imageNamed:@"selected"]];
    }
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(SigleNameImgBtnViewClick:)]) {
        [self.delegate SigleNameImgBtnViewClick:self];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
