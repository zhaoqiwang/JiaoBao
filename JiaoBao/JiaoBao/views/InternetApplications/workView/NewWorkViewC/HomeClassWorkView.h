//
//  HomeClassWorkView.h
//  JiaoBao
//  家校互动主界面
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
@property (nonatomic,assign) int flag;//0新建，1转发
@property (nonatomic,strong) NSString *mStr_content;//转发时，传过来的内容
@property (nonatomic,strong) NSMutableArray *mArr_list;//转发时，传过来的附件列表

- (id)initWithFrame1:(CGRect)frame;
-(void)resetFrame;
-(void)setFrame;


-(void)dealloc1;

@end
