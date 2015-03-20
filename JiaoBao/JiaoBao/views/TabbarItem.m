//
//  TabbarItem.m
//  JiaoBao
//
//  Created by Zqw on 14-10-21.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "TabbarItem.h"

@implementation TabbarItem
@synthesize imageView = _imageView;
@synthesize normalImg = _normalImg;
@synthesize highlightedImg = _highlightedImg;
@synthesize tabbar_delegate = _tabbar_delegate;
@synthesize twoImg = _twoImg;
@synthesize imgType = _imgType,mLab_0;


- (id)initWithFrame:(CGRect)frame Image:(UIImage *)img highlightedImage:(UIImage *)highlightedImage name:(NSString *)name{
    self = [super init];
    if (self) {
        // Initialization code
        self.frame = frame;
        self.normalImg = img;
        self.highlightedImg = highlightedImage;
        UIImageView *image1 = [[UIImageView alloc] initWithImage:img];
        self.imageView = image1;
        self.imgType = 1;
        [self createTabbarItem];
        self.mLab_0 =[[UILabel alloc] init];
        self.mLab_0.frame = CGRectMake(0, 30, self.frame.size.width, 19);
        self.mLab_0.text = name;
        self.mLab_0.font = [UIFont systemFontOfSize:14];
        self.mLab_0.backgroundColor = [UIColor clearColor];
        self.mLab_0.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.mLab_0];
        //添加单击手势
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressTap:)];
        tap2.delegate = self;//设置代理，防止手势和按钮的点击事件冲突
        [self addGestureRecognizer:tap2];
    }
    return self;
}
-(void)pressTap:(UITapGestureRecognizer *)tap{
    D("uuuu");
    if (_tabbar_delegate !=nil || [_tabbar_delegate respondsToSelector:@selector(tabbarItem:atIndex:)]) {
        [self.tabbar_delegate tabbarItem:self atIndex:(int)self.tag];
    }
}

//选中
-(void)selecting{
    if (_imgType == 1) {
        self.imageView.image = _highlightedImg;
//        self.mLab_0.textColor = [UIColor colorWithRed:63/255.0 green:66/255.0 blue:71/255.0 alpha:1];
        self.backgroundColor = [UIColor colorWithRed:30/255.0 green:32/255.0 blue:35/255.0 alpha:1];
        self.mLab_0.textColor = [UIColor colorWithRed:56/255.0 green:136/255.0 blue:201/255.0 alpha:1];
    }else{
        self.imageView.image = _twoImg;
        self.mLab_0.textColor = [UIColor blackColor];
    }
}
//非选中
-(void)selected{
    self.imageView.image = _normalImg;
//    self.mLab_0.textColor = [UIColor colorWithRed:47/255.0 green:50/255.0 blue:58/255.0 alpha:1];
    self.mLab_0.textColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor colorWithRed:63/255.0 green:65/255.0 blue:72/255.0 alpha:1];
}

-(void)changeImgType{
    if (_imgType == 1) {
        self.imgType = 2;
    }else{
        self.imgType = 1;
    }
}


-(void)createTabbarItem{
    self.imageView.frame = CGRectMake((self.frame.size.width-self.imageView.image.size.width)/2, 5, self.imageView.image.size.width, self.imageView.image.size.height);
    [self addSubview:self.imageView];
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
