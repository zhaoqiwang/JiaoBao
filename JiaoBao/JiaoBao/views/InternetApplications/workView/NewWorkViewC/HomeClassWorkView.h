//
//  HomeClassWorkView.h
//  JiaoBao
//
//  Created by Zqw on 15-4-23.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dm.h"

#import "NewWorkTopView.h"
#import "HomeClassTopScrollView.h"
#import "HomeClassRootScrollView.h"

@interface HomeClassWorkView : UIView<NewWorkTopViewProtocol>{
    UIScrollView *mScrollV_all;//放所有控件
    NewWorkTopView *mViewTop;//上半部分
}

@property (nonatomic,strong) UIScrollView *mScrollV_all;//放所有控件
@property (nonatomic,strong) NewWorkTopView *mViewTop;//上半部分
@property(nonatomic,strong)UIView *bottomView;

- (id)initWithFrame1:(CGRect)frame;

@end
