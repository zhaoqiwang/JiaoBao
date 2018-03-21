//
//  NewWorkRootScrollView.m
//  JiaoBao
//
//  Created by Zqw on 15-4-23.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "NewWorkRootScrollView.h"

@implementation NewWorkRootScrollView
@synthesize mInt,moreUnitView,insideView,homeClassView;
#define POSITIONID (int)self.contentOffset.x/[dm getInstance].width

//+ (NewWorkRootScrollView *)shareInstance {
//    static NewWorkRootScrollView *__singletion;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        __singletion=[[self alloc] initWithFrame:CGRectMake(0, 44+40+[dm getInstance].statusBar, [dm getInstance].width, [dm getInstance].height-43*1-[dm getInstance].statusBar-44)];
//    });
//    return __singletion;
//}

-(void)dealloc1{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame{
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 11.0) {
        CGRect frame = CGRectMake(0, 44+40+[dm getInstance].statusBar+20, [dm getInstance].width, [dm getInstance].height-43*1-[dm getInstance].statusBar-44);
        self = [super initWithFrame:frame];
    }else{
        CGRect frame = CGRectMake(0, 44+40+[dm getInstance].statusBar, [dm getInstance].width, [dm getInstance].height-43*1-[dm getInstance].statusBar-44+20);
        self = [super initWithFrame:frame];
    }
    
    if (self) {
        self.delegate = self;
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 11.0) {
            self.contentSize = CGSizeMake([dm getInstance].width*3, [dm getInstance].height-43-[dm getInstance].statusBar-44);
        }else{
            self.contentSize = CGSizeMake([dm getInstance].width*3, [dm getInstance].height-43-[dm getInstance].statusBar-44);
        }
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"selectNameButton" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectNameButton:) name:@"selectNameButton" object:nil];
        self.pagingEnabled = YES;
        self.userInteractionEnabled = YES;
        self.bounces = YES;
        self.bouncesZoom = NO;//是否有弹簧效果
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        [self setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1]];
        userContentOffsetX = 0;
        self.mInt = 0;
//        //内部事务
//        self.insideView = [[InsideWorkView alloc] initWithFrame1:CGRectMake([dm getInstance].width*0, 0, [dm getInstance].width, self.frame.size.height)];
//        [self addSubview:self.insideView];
        //家校互动
        self.homeClassView = [[HomeClassWorkView alloc] initWithFrame1:CGRectMake([dm getInstance].width*1, 0, [dm getInstance].width, self.frame.size.height)];
        [self addSubview:self.homeClassView];
        //多单位事务
        self.moreUnitView = [[MoreUnitWorkView alloc] initWithFrame1:CGRectMake([dm getInstance].width*2, 0, [dm getInstance].width, self.frame.size.height)];
        [self addSubview:self.moreUnitView];
    }
    return self;
}

-(void)selectNameButton:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self];
    int a = [noti.object intValue];
    self.mInt = a;
    [self setContentOffset:CGPointMake(a*[dm getInstance].width, 0) animated:NO];
}

//开始滑动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    userContentOffsetX = self.contentOffset.x;
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
//    if (isLeftScroll) {
//        if (self.contentOffset.x <= [dm getInstance].width*5) {
//            [[NewWorkTopScrollView shareInstance] setContentOffset:CGPointMake(0, 0) animated:YES];
//        }
//        else {
//            [[NewWorkTopScrollView shareInstance] setContentOffset:CGPointMake((POSITIONID-4)*64+45, 0) animated:YES];
//        }
//    }
//    else {
//        if (self.contentOffset.x >= [dm getInstance].width*5) {
//            [[NewWorkTopScrollView shareInstance] setContentOffset:CGPointMake(2*64+45, 0) animated:YES];
//        }
//        else {
//            [[NewWorkTopScrollView shareInstance] setContentOffset:CGPointMake(0, 0) animated:YES];
//        }
//    }
}
//滑动结束后调用改变值
- (void)adjustTopScrollViewButton:(UIScrollView *)scrollView{
    NSString *a = [NSString stringWithFormat:@"%d",POSITIONID+100];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"adjustTopScrollViewButton" object:a];
//    [[NewWorkTopScrollView shareInstance] setButtonUnSelect];
//    [NewWorkTopScrollView shareInstance].mInt_scrollViewSelectedChannelID = POSITIONID+100;
//    [[NewWorkTopScrollView shareInstance] setButtonSelect];
}

@end
