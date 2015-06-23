//
//  TabbarItem.h
//  JiaoBao
//
//  Created by Zqw on 14-10-21.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Loger.h"

@protocol TabbarItemDelegate <NSObject>

-(void)tabbarItem:(UIView *)item atIndex:(int)index;

@end

@interface TabbarItem : UIView<UIGestureRecognizerDelegate>{
    UIImageView *_imageView;
    UIImage *_normalImg;
    UIImage *_highlightedImg;
    UIImage *_twoImg;
//    id<TabbarItemDelegate> _tabbar_delegate;
    int _imgType;
    UILabel *mLab_0;
}
@property (nonatomic , assign) int imgType;
@property (nonatomic , weak) id<TabbarItemDelegate> tabbar_delegate;
@property (nonatomic , retain) UIImageView *imageView;
@property (nonatomic , retain) UIImage *normalImg;
@property (nonatomic , retain) UIImage *highlightedImg;
@property (nonatomic , retain) UIImage *twoImg;
@property (nonatomic , retain) UILabel *mLab_0;

- (id)initWithFrame:(CGRect)frame Image:(UIImage *)img highlightedImage:(UIImage *)highlightedImage name:(NSString *)name;
//选中
-(void)selecting;
//非选中
-(void)selected;

-(void)changeImgType;

@end
