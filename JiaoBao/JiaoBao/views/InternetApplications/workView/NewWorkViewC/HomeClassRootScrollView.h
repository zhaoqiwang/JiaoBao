//
//  HomeClassRootScrollView.h
//  JiaoBao
//  家校互动显示内容scrollView
//  Created by songyanming on 15/4/27.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dm.h"
#import <QuartzCore/QuartzCore.h>
#import "HomeClassTopScrollView.h"
#import "InsideWorkView.h"
#import "HomeClassWorkView.h"
#import "MoreUnitWorkView.h"
#import "ClassMessage.h"
#import "CharacterView.h"
#import "SchoolMessage.h"
#import "PatriarchView.h"

@interface HomeClassRootScrollView : UIScrollView<UIScrollViewDelegate>{
    BOOL isLeftScroll;
    CGFloat userContentOffsetX;
//    InsideWorkView *insideView;//内部事务
//    HomeClassWorkView *homeClassView;//家校互动
//    MoreUnitWorkView *moreUnitView;//多单位事务
    int mInt;//当前显示第几个页面
}

@property (assign,nonatomic) int mInt;//当前显示第几个页面
//@property (strong,nonatomic) InsideWorkView *insideView;//内部事务
//@property (strong,nonatomic) HomeClassWorkView *homeClassView;//家校互动
//@property (strong,nonatomic) MoreUnitWorkView *moreUnitView;//多单位事务
@property(strong,nonatomic)ClassMessage *classMessageView;
@property(strong,nonatomic)CharacterView *characterView;
@property(strong,nonatomic)SchoolMessage *schoolMessage;
@property(strong,nonatomic)PatriarchView *patriarchView;


+ (HomeClassRootScrollView *)shareInstance;
+ (void)destroyDealloc;

@end
