//
//  HomeClassRootScrollView.m
//  JiaoBao
//
//  Created by songyanming on 15/4/27.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "HomeClassRootScrollView.h"

@implementation HomeClassRootScrollView
#define POSITIONID (int)self.contentOffset.x/[dm getInstance].width

+ (HomeClassRootScrollView *)shareInstance {
    static HomeClassRootScrollView *__singletion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __singletion=[[self alloc] initWithFrame:CGRectMake(0, 44+40+[dm getInstance].statusBar, [dm getInstance].width, [dm getInstance].height-43*1-[dm getInstance].statusBar-44)];
    });
    return __singletion;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.contentSize = CGSizeMake([dm getInstance].width*4, [dm getInstance].height-43-[dm getInstance].statusBar-44);
        
        self.pagingEnabled = NO;
        self.userInteractionEnabled = YES;
        self.scrollEnabled = NO;
        self.bounces = YES;
        self.bouncesZoom = NO;//是否有弹簧效果
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        [self setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1]];
        userContentOffsetX = 0;
        self.mInt = 0;
        self.classMessageView = [[ClassMessage alloc] initWithFrame:CGRectMake([dm getInstance].width*0, 0, [dm getInstance].width, self.frame.size.height)];
        [self addSubview:self.classMessageView];
        //self.classMessageView.backgroundColor = [UIColor redColor];
        self.characterView = [[CharacterView alloc] initWithFrame:CGRectMake([dm getInstance].width*1, 0, [dm getInstance].width, self.frame.size.height)];
        [self addSubview:self.characterView];
        self.schoolMessage = [[SchoolMessage alloc] initWithFrame:CGRectMake([dm getInstance].width*2, 0, [dm getInstance].width, self.frame.size.height)];
        [self addSubview:self.schoolMessage];
        self.patriarchView = [[PatriarchView alloc] initWithFrame:CGRectMake([dm getInstance].width*3, 0, [dm getInstance].width, self.frame.size.height)];
        [self addSubview:self.patriarchView];
    }
    return self;
}

//开始滑动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    userContentOffsetX = self.contentOffset.x;
}
//滑动过程中
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}
//滑动结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (userContentOffsetX < self.contentOffset.x) {
        isLeftScroll = YES;
    }
    else {
        isLeftScroll = NO;
    }
    self.mInt = scrollView.contentOffset.x/[dm getInstance].width;
    //调整顶部滑条按钮状态
    [self adjustTopScrollViewButton:scrollView];
    if (isLeftScroll) {
        if (self.contentOffset.x <= [dm getInstance].width*5) {
            [[HomeClassTopScrollView shareInstance] setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        else {
            [[HomeClassTopScrollView shareInstance] setContentOffset:CGPointMake((POSITIONID-4)*64+45, 0) animated:YES];
        }
    }
    else {
        if (self.contentOffset.x >= [dm getInstance].width*5) {
            [[HomeClassTopScrollView shareInstance] setContentOffset:CGPointMake(2*64+45, 0) animated:YES];
        }
        else {
            [[HomeClassTopScrollView shareInstance] setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
}
//滑动结束后调用改变值
- (void)adjustTopScrollViewButton:(UIScrollView *)scrollView{
    [[HomeClassTopScrollView shareInstance] setButtonUnSelect];
    [HomeClassTopScrollView shareInstance].mInt_scrollViewSelectedChannelID = POSITIONID+100;
    [[HomeClassTopScrollView shareInstance] setButtonSelect];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
