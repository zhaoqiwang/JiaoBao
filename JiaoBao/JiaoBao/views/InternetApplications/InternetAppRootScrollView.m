//
//  InternetAppRootScrollView.m
//  JiaoBao
//
//  Created by Zqw on 14-10-22.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "InternetAppRootScrollView.h"

@implementation InternetAppRootScrollView
@synthesize workView,shareView,showView,notiView,mInt,themeView,classView;
#define POSITIONID (int)self.contentOffset.x/[dm getInstance].width

+ (InternetAppRootScrollView *)shareInstance {
    static InternetAppRootScrollView *__singletion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        __singletion=[[self alloc] initWithFrame:CGRectMake(0, 49+40+[dm getInstance].statusBar, [dm getInstance].width, [dm getInstance].height-49*1-[dm getInstance].statusBar-40)];
        __singletion=[[self alloc] initWithFrame:CGRectMake(0, 43+[dm getInstance].statusBar, [dm getInstance].width, [dm getInstance].height-43*1-[dm getInstance].statusBar-48)];
    });
    return __singletion;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        if (SHOWRONGYUN == 1) {
            self.contentSize = CGSizeMake([dm getInstance].width*5, [dm getInstance].height-43-[dm getInstance].statusBar-48);
        }else{
            self.contentSize = CGSizeMake([dm getInstance].width*4, [dm getInstance].height-43-[dm getInstance].statusBar-48);
        }
        
        self.pagingEnabled = YES;
        self.userInteractionEnabled = YES;
        self.bounces = YES;
        self.bouncesZoom = NO;//是否有弹簧效果
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        [self setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1]];
        userContentOffsetX = 0;
        self.mInt = 0;
        if (SHOWRONGYUN == 1) {
            //添加事务
//            self.workView = [[WorkView alloc] initWithFrame1:CGRectMake([dm getInstance].width*1, 0, [dm getInstance].width, self.frame.size.height)];
//            self.workView = [[WorkView_new alloc] initWithFrame1:CGRectMake([dm getInstance].width*1, 0, [dm getInstance].width, self.frame.size.height)];
            self.workView = [[WorkView_new2 alloc] initWithFrame1:CGRectMake([dm getInstance].width*1, 0, [dm getInstance].width, self.frame.size.height)];
            [self addSubview:self.workView];
            //添加分享
            self.shareView = [[ShareViewNew alloc] initWithFrame1:CGRectMake([dm getInstance].width*2, 0, [dm getInstance].width, self.frame.size.height)];
            [self addSubview:self.shareView];
            //添加展示
//            self.showView = [[ShowViewNew alloc] initWithFrame1:CGRectMake([dm getInstance].width*3, 0, [dm getInstance].width, self.frame.size.height)];
//            [self addSubview:self.showView];
            self.classView = [[ClassView alloc] initWithFrame1:CGRectMake([dm getInstance].width*3, 0, [dm getInstance].width, self.frame.size.height)];
            [self addSubview:self.classView];
            //主题
            self.themeView = [[ThemeView alloc] initWithFrame1:CGRectMake([dm getInstance].width*4, 0, [dm getInstance].width, self.frame.size.height)];
            [self addSubview:self.themeView];
        }else{
            //添加事务
//            self.workView = [[WorkView_new alloc] initWithFrame1:CGRectMake([dm getInstance].width*0, 0, [dm getInstance].width, self.frame.size.height)];
            self.workView = [[WorkView_new2 alloc] initWithFrame1:CGRectMake([dm getInstance].width*0, 0, [dm getInstance].width, self.frame.size.height)];
            [self addSubview:self.workView];
            //添加分享
            self.shareView = [[ShareViewNew alloc] initWithFrame1:CGRectMake([dm getInstance].width*1, 0, [dm getInstance].width, self.frame.size.height)];
            [self addSubview:self.shareView];
            //添加展示
//            self.showView = [[ShowViewNew alloc] initWithFrame1:CGRectMake([dm getInstance].width*2, 0, [dm getInstance].width, self.frame.size.height)];
//            [self addSubview:self.showView];
            self.classView = [[ClassView alloc] initWithFrame1:CGRectMake([dm getInstance].width*2, 0, [dm getInstance].width, self.frame.size.height)];
            [self addSubview:self.classView];
            //主题
            self.themeView = [[ThemeView alloc] initWithFrame1:CGRectMake([dm getInstance].width*3, 0, [dm getInstance].width, self.frame.size.height)];
            [self addSubview:self.themeView];
        }
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
            [[InternetAppTopScrollView shareInstance] setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        else {
            [[InternetAppTopScrollView shareInstance] setContentOffset:CGPointMake((POSITIONID-4)*64+45, 0) animated:YES];
        }
    }
    else {
        if (self.contentOffset.x >= [dm getInstance].width*5) {
            [[InternetAppTopScrollView shareInstance] setContentOffset:CGPointMake(2*64+45, 0) animated:YES];
        }
        else {
            [[InternetAppTopScrollView shareInstance] setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
}
//滑动结束后调用改变值
- (void)adjustTopScrollViewButton:(UIScrollView *)scrollView{
    [[InternetAppTopScrollView shareInstance] setButtonUnSelect];
    [InternetAppTopScrollView shareInstance].mInt_scrollViewSelectedChannelID = POSITIONID+100;
    [[InternetAppTopScrollView shareInstance] setButtonSelect];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
