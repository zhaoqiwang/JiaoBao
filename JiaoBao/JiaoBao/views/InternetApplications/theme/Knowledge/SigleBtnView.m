//
//  SigleBtnView.m
//  JiaoBao
//
//  Created by Zqw on 15/9/21.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "SigleBtnView.h"

@implementation SigleBtnView

//          此按钮宽度，可传0   按钮高度                按钮标题
-(id)initWidth:(float)width height:(float)height title:(NSString *)title{
    self = [super init];
    if (self) {
        self.mInt_flag = 1;
        
        self.mImg_head = [[UIImageView alloc] init];
        self.mImg_head.frame = CGRectMake(0, (height-14)/2, 14, 14);
        [self.mImg_head setImage:[UIImage imageNamed:@"selected"]];
        [self addSubview:self.mImg_head];
        
        //
        CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:12]];
        self.mLab_title = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, titleSize.width, height)];
        self.mLab_title.text = title;
        self.mLab_title.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.mLab_title];
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonViewClick:)];
        [self addGestureRecognizer:tap];
        
        self.frame = CGRectMake(0, 0, self.mLab_title.frame.origin.x+titleSize.width, height);
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
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
