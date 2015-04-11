//
//  InternetAppRootScrollView.h
//  JiaoBao
//
//  Created by Zqw on 14-10-22.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dm.h"
#import <QuartzCore/QuartzCore.h>
#import "InternetAppTopScrollView.h"
//#import "WorkView.h"
#import "ShareView.h"
#import "ShowView.h"
#import "NoticeView.h"
#import "ShowViewNew.h"
#import "ShareViewNew.h"
#import "ThemeView.h"
#import "WorkView_new.h"
#import "ClassView.h"
#import "WorkView_new2.h"

@interface InternetAppRootScrollView : UIScrollView<UIScrollViewDelegate>{
    BOOL isLeftScroll;
    CGFloat userContentOffsetX;
//    WorkView *workView;//事务
//    WorkView_new *workView;
    WorkView_new2 *workView;
//    ShareView *shareView;//分享
    ShareViewNew *shareView;//分享
//    ShowView *showView;//展示
    ShowViewNew *showView;//展示
    NoticeView *notiView;//内务
    ThemeView *themeView;//主题
    ClassView *classView;//学校
    int mInt;//当前显示第几个页面
}

//@property (strong,nonatomic) WorkView *workView;
//@property (strong,nonatomic) WorkView_new *workView;
@property (strong,nonatomic) WorkView_new2 *workView;
@property (strong,nonatomic) ShareViewNew *shareView;//分享
@property (strong,nonatomic) ShowViewNew *showView ;//展示
@property (strong,nonatomic) NoticeView *notiView;//内务
@property (assign,nonatomic) int mInt;//当前显示第几个页面
@property (strong,nonatomic) ThemeView *themeView;//主题
@property (strong,nonatomic) ClassView *classView;//学校

+ (InternetAppRootScrollView *)shareInstance;

@end
