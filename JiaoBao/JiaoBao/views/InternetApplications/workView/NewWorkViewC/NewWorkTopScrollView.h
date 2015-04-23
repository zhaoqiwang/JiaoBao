//
//  NewWorkTopScrollView.h
//  JiaoBao
//
//  Created by Zqw on 15-4-23.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dm.h"
#import "NewWorkRootScrollView.h"

@interface NewWorkTopScrollView : UIScrollView<UIScrollViewDelegate>{
    UIImageView *mImgV_slide;//蓝色滑块
    NSArray *mArr_name;//名称数组
    NSInteger mInt_userSelectedChannelID;//点击按钮选择名字ID
    NSInteger mInt_scrollViewSelectedChannelID;//滑动列表选择名字ID
}

@property (strong,nonatomic) UIImageView *mImgV_slide;//蓝色滑块
@property (strong,nonatomic) NSArray *mArr_name;//名称数组
@property (assign,nonatomic) NSInteger mInt_userSelectedChannelID;//点击按钮选择名字ID
@property (assign,nonatomic) NSInteger mInt_scrollViewSelectedChannelID;//滑动列表选择名字ID


+ (NewWorkTopScrollView *)shareInstance;
//滑动撤销选中按钮
- (void)setButtonUnSelect;
//滑动选择按钮
- (void)setButtonSelect;
- (void)initWithNameButtons;

@end
