//
//  NewWorkRootScrollView.h
//  JiaoBao
//
//  Created by Zqw on 15-4-23.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dm.h"
#import <QuartzCore/QuartzCore.h>
#import "NewWorkTopScrollView.h"
#import "InsideWorkView.h"
#import "HomeClassWorkView.h"
#import "MoreUnitWorkView.h"

@interface NewWorkRootScrollView : UIScrollView<UIScrollViewDelegate>{
    BOOL isLeftScroll;
    CGFloat userContentOffsetX;
    InsideWorkView *insideView;//内部事务
    HomeClassWorkView *homeClassView;//家校互动
    MoreUnitWorkView *moreUnitView;//多单位事务
    int mInt;//当前显示第几个页面
}

@property (assign,nonatomic) int mInt;//当前显示第几个页面
@property (strong,nonatomic) InsideWorkView *insideView;//内部事务
@property (strong,nonatomic) HomeClassWorkView *homeClassView;//家校互动
@property (strong,nonatomic) MoreUnitWorkView *moreUnitView;//多单位事务

+ (NewWorkRootScrollView *)shareInstance;

@end
