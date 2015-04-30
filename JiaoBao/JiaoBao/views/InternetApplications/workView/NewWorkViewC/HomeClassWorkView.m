//
//  HomeClassWorkView.m
//  JiaoBao
//
//  Created by Zqw on 15-4-23.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "HomeClassWorkView.h"

@implementation HomeClassWorkView
@synthesize mViewTop,mScrollV_all;

- (id)initWithFrame1:(CGRect)frame{
    self = [super init];
    if (self) {
        // Initialization code
        self.frame = frame;
        //总框
        self.mScrollV_all = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10, [dm getInstance].width, self.frame.size.height-10)];
        [self addSubview:self.mScrollV_all];
        //上半部分
        self.mViewTop = [[NewWorkTopView alloc] init];
        self.mViewTop.delegate = self;
        [self addSubview:self.mViewTop];
        [self addSubview:[HomeClassRootScrollView shareInstance]];

//        //root
        [self addSubview:[HomeClassTopScrollView shareInstance]];
        [HomeClassTopScrollView shareInstance].frame = CGRectMake(0, self.mViewTop.frame.size.height+self.mViewTop.frame.origin.y+10, [dm getInstance].width, 48);
//        self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.mViewTop.frame.size.height+self.mViewTop.frame.origin.y+48+10, [dm getInstance].width, 300)];
//        [self addSubview:self.bottomView];
        [HomeClassRootScrollView shareInstance].frame = CGRectMake(0, self.mViewTop.frame.size.height+self.mViewTop.frame.origin.y+48+10, [dm getInstance].width, 300);
        //[HomeClassRootScrollView shareInstance].backgroundColor = [UIColor redColor];


        
    }
    return self;
}

//点击发送按钮
-(void)mBtn_send:(UIButton *)btn{
    
    
}


@end
