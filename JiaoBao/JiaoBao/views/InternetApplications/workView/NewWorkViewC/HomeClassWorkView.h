//
//  HomeClassWorkView.h
//  JiaoBao
//
//  Created by Zqw on 15-4-23.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dm.h"
#import "MBProgressHUD.h"

#import "NewWorkTopView.h"
#import "HomeClassTopScrollView.h"
#import "HomeClassRootScrollView.h"

@interface HomeClassWorkView : UIView<NewWorkTopViewProtocol,MBProgressHUDDelegate>{
    UIScrollView *mScrollV_all;//放所有控件
    NewWorkTopView *mViewTop;//上半部分
}

@property (nonatomic,strong) UIScrollView *mScrollV_all;//放所有控件
@property (nonatomic,strong) NewWorkTopView *mViewTop;//上半部分
@property(nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong) MBProgressHUD *mProgressV;//

- (id)initWithFrame1:(CGRect)frame;
-(void)resetFrame;
-(void)setFrame;


-(void)dealloc1;

@end
