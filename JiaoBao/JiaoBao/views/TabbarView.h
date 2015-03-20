//
//  TabbarView.h
//  JiaoBao
//
//  Created by Zqw on 14-10-21.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dm.h"
#import "TabbarItem.h"
#import <QuartzCore/QuartzCore.h>

@protocol TabbarViewDelegate <NSObject>

-(void)tabbarView:(int)index;

//-(void)keypad_Action:(TabbarItem *)item;
//
//-(void)setKeypadFirstItem:(TabbarItem *)item;

@end

@interface TabbarView : UIView<TabbarItemDelegate>{
    NSMutableArray *mArr_image;
    int selectIndex;
    UIImageView *mImgV_movie;
    id<TabbarViewDelegate> tabbarView_Delegate;
    int selectAtIndex;
}
@property (nonatomic , retain) id<TabbarViewDelegate> tabbarView_Delegate;
@property (nonatomic , retain) NSMutableArray *mArr_image;
@property (nonatomic , retain) UIImageView *mImgV_movie;

@end
