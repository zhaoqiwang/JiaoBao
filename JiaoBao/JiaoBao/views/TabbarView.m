//
//  TabbarView.m
//  JiaoBao
//
//  Created by Zqw on 14-10-21.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "TabbarView.h"

//#define TABBAR_BTN_WIDTH 80.0
#define TABBAR_BTN_HEIGHT 49.0
#define TABBAR_BTN_Y 0
#define TABBAR_IMGVIEW_INDEX 0

@implementation TabbarView
@synthesize mArr_image,mImgV_movie,tabbarView_Delegate;


-(id)init{
    self = [super init];
    if (self) {
//        UIImage *img = [UIImage imageNamed:@"mytabbar_bg"];
        self.frame = CGRectMake(0, [dm getInstance].height-TABBAR_BTN_HEIGHT, [dm getInstance].width, TABBAR_BTN_HEIGHT);
//        self.layer.contents = (id)img.CGImage;
        self.backgroundColor = [UIColor grayColor];
        NSMutableArray *arr1 = [[NSMutableArray alloc] init];
        self.mArr_image = arr1;
        selectIndex = 0;
        [self createTabbar];
    }
    return self;
}

-(void)tabbarItem:(UIView *)item atIndex:(int)index{
    TabbarItem *item1 = [mArr_image objectAtIndex:index];
    [self image_Animations:mImgV_movie.frame.origin.x End:item1.frame.origin.x];
    [item1 selecting];
    for (int i = 0 ; i<mArr_image.count; i++) {
        if (i==index) {
            continue;
        }
        TabbarItem *item2 = [mArr_image objectAtIndex:i];
        [item2 selected];
    }
    if (self.tabbarView_Delegate!=nil && [self.tabbarView_Delegate respondsToSelector:@selector(tabbarView:)]) {
        [self.tabbarView_Delegate tabbarView:index];
    }
    selectIndex = index;
}

#pragma mark 拨号盘收起
- (void)image_Animations:(float)starX End:(float)endX{
    [UIView beginAnimations:@"Opacity" context:nil];
    [UIView setAnimationRepeatCount:1];
    [UIView setAnimationDuration:.25];
    CGAffineTransform newTransform =CGAffineTransformMakeTranslation(endX-starX, 0);
    [self.mImgV_movie setTransform:newTransform];
    CGRect rect = self.mImgV_movie.frame;
    rect.origin.x = endX;
    self.mImgV_movie.frame = rect;
    [UIView commitAnimations];
}

-(void)createTabbar{
    //每个的宽度
    int width = [dm getInstance].width/2;
    TabbarItem *tabbar0 = [[TabbarItem alloc] initWithFrame:CGRectMake(0*width, TABBAR_BTN_Y, width, TABBAR_BTN_HEIGHT) Image:[UIImage imageNamed:@"tabbar_app1"] highlightedImage:[UIImage imageNamed:@"tabbar_app2"] name:@"互联应用"];
    tabbar0.tag = 0;
    [tabbar0 selecting];
    tabbar0.tabbar_delegate = self;
    [self addSubview:tabbar0];
    [self.mArr_image addObject:tabbar0];
    
//    TabbarItem *tabbar1 = [[TabbarItem alloc] initWithFrame:CGRectMake(1*width, TABBAR_BTN_Y, width, TABBAR_BTN_HEIGHT) Image:[UIImage imageNamed:@"tabbar_student1"] highlightedImage:[UIImage imageNamed:@"tabbar_student2"] name:@"学生档案"];
//    tabbar1.tag = 1;
//    tabbar1.tabbar_delegate = self;
//    [self addSubview:tabbar1];
//    [self.mArr_image addObject:tabbar1];
    
    TabbarItem *tabbar2 = [[TabbarItem alloc] initWithFrame:CGRectMake(1*width, TABBAR_BTN_Y, width, TABBAR_BTN_HEIGHT) Image:[UIImage imageNamed:@"tabbar_center1"] highlightedImage:[UIImage imageNamed:@"tabbar_center2"] name:@"应用中心"];
//    tabbar2.tag = 2;
    tabbar2.tag = 1;
    tabbar2.tabbar_delegate = self;
    [self addSubview:tabbar2];
    [self.mArr_image addObject:tabbar2];
    
    
//    UIImageView *imagemovie = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mytabbar_movie"]];
//    self.mImgV_movie = imagemovie;
//    self.mImgV_movie.frame = CGRectMake(1*width, TABBAR_BTN_Y, width, TABBAR_BTN_HEIGHT);
//    [self insertSubview:mImgV_movie atIndex:0];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
