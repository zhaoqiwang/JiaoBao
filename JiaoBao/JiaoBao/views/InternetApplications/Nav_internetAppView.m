//
//  Nav_internetAppView.m
//  JiaoBao
//
//  Created by Zqw on 14-10-22.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "Nav_internetAppView.h"
#import "define_constant.h"

//static Nav_internetAppView *nav_internetAppView = nil;

#define Nav_width 44
#define Nav_height 43

@implementation Nav_internetAppView

@synthesize mLab_name,mBtn_add,mBtn_search,mBtn_setting,mScrollV_name,delegate;

+(Nav_internetAppView *)getInstance{
//    if (nav_internetAppView == nil) {
//        nav_internetAppView = [[Nav_internetAppView alloc] init];
//        for (UIView *view in nav_internetAppView.subviews) {
//            [view removeFromSuperview];
//        }
//    }
//    return nav_internetAppView;
    static Nav_internetAppView *nav_internetAppView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nav_internetAppView = [[Nav_internetAppView alloc] initWithName:@""];
    });
    return nav_internetAppView;
}
//-(id)init{
//    self = [super init];
//    if (self) {
//        
//    }
//    return self;
//}

-(id)initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [dm getInstance].width, Nav_height+[dm getInstance].statusBar);
        self.backgroundColor = [UIColor colorWithRed:33/255.0 green:41/255.0 blue:43/255.0 alpha:1];
        //设置按钮
        self.mBtn_setting = [UIButton buttonWithType:UIButtonTypeCustom];
        self.mBtn_setting.frame = CGRectMake([dm getInstance].width-Nav_width, 0+[dm getInstance].statusBar, Nav_width, Nav_height);
        [self.mBtn_setting setImage:[UIImage imageNamed:@"appNav_setting"] forState:UIControlStateNormal];
        self.mBtn_setting.tag = 1;
        [self.mBtn_setting addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.mBtn_setting];
        //添加按钮
        
        self.mBtn_add = [UIButton buttonWithType:UIButtonTypeCustom];
        self.mBtn_add.frame = CGRectMake([dm getInstance].width-Nav_width*2, 0+[dm getInstance].statusBar, Nav_width, Nav_height);
        [self.mBtn_add setImage:[UIImage imageNamed:@"appNav_add"] forState:UIControlStateNormal];
        self.mBtn_add.tag = 2;
        [self.mBtn_add addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.mBtn_add];
        
        
        //        //搜索按钮
        //        self.mBtn_search = [UIButton buttonWithType:UIButtonTypeCustom];
        //        self.mBtn_search.frame = CGRectMake([dm getInstance].width-Nav_width*3, 0+[dm getInstance].statusBar, Nav_width, Nav_height);
        //        [self.mBtn_search setImage:[UIImage imageNamed:@"appNav_search"] forState:UIControlStateNormal];
        //        self.mBtn_search.tag = 3;
        //        [self.mBtn_search addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchDown];
        //        [self addSubview:self.mBtn_search];
        //名字
        if (name.length==0) {
            name = @"                                                               ";
        }
        self.mScrollV_name = [[UIScrollView alloc] initWithFrame:CGRectMake(15, 0+[dm getInstance].statusBar, [dm getInstance].width-11-Nav_width*2-10, Nav_height)];
        CGSize newSize = [name sizeWithFont:[UIFont systemFontOfSize:15]];
        self.mLab_name = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, newSize.width, Nav_height)];
        self.mLab_name.backgroundColor = [UIColor clearColor];
        self.mLab_name.font = [UIFont systemFontOfSize:15];
        self.mLab_name.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1];
        self.mLab_name.text = name;
        [self.mScrollV_name addSubview:self.mLab_name];
        self.mScrollV_name.contentSize = CGSizeMake(newSize.width, Nav_height);
        [self addSubview:self.mScrollV_name];
    }
    return self;
}
-(void)clickBtn:(UIButton *)btn
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(Nav_internetAppViewClickBtnWith:)]) {
        [self.delegate Nav_internetAppViewClickBtnWith:btn];
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
