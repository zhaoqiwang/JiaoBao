//
//  PopupWindow.m
//  JiaoBao
//
//  Created by Zqw on 15/5/20.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "PopupWindow.h"

@implementation PopupWindow
@synthesize mBtn_like,mBtn_comment,delegate,mModel_class;

-(id)init{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(10, 10, 120, 30);
        self.backgroundColor = [UIColor blackColor];
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:3.0]; //设置矩形四个圆角半径
        self.mModel_class = [[ClassModel alloc] init];
        
        //点赞
        self.mBtn_like = [UIButton buttonWithType:UIButtonTypeCustom];
        self.mBtn_like.frame = CGRectMake(0, 0, 60, 30);
        [self.mBtn_like setImage:[UIImage imageNamed:@"popupWindow_like"] forState:UIControlStateNormal];
        self.mBtn_like.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.mBtn_like setTitle:@"点赞" forState:UIControlStateNormal];
        self.mBtn_like.imageEdgeInsets = UIEdgeInsetsMake(4,0,5,0);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
        self.mBtn_like.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
        self.mBtn_like.tag = 0;
        self.mBtn_like.titleEdgeInsets = UIEdgeInsetsMake(5, 10, 4, 0);
        [self.mBtn_like addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.mBtn_like];
        
        //评论
        self.mBtn_comment = [UIButton buttonWithType:UIButtonTypeCustom];
        self.mBtn_comment.frame = CGRectMake(64, 0, 52, 30);
        self.mBtn_comment.tag = 1;
        [self.mBtn_comment setImage:[UIImage imageNamed:@"popupWindow_comment"] forState:UIControlStateNormal];
//        self.mBtn_comment.titleLabel.font = [UIFont systemFontOfSize:12];
//        [self.mBtn_comment setTitle:@"评论" forState:UIControlStateNormal];
//        self.mBtn_comment.imageEdgeInsets = UIEdgeInsetsMake(4,0,5,0);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
//        self.mBtn_comment.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
//        self.mBtn_comment.titleEdgeInsets = UIEdgeInsetsMake(5,10, 4, 0);
        [self.mBtn_comment addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.mBtn_comment];
    }
    return self;
}

-(void)clickBtn:(UIButton *)btn{
    [self.delegate PopupWindowClickBtn:self Button:btn];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
