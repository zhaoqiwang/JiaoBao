//
//  Nav_internetAppView.h
//  JiaoBao
//
//  Created by Zqw on 14-10-22.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dm.h"

@protocol Nav_internetAppViewDelegate;

@interface Nav_internetAppView : UIView{
    UILabel *mLab_name;//部门和姓名
    UIButton *mBtn_search;//搜索按钮
    UIButton *mBtn_add;//添加按钮
    UIButton *mBtn_setting;//设置
    UIScrollView *mScrollV_name;//放部门、姓名
//    id<Nav_internetAppViewDelegate> delegate;
}
@property (strong,nonatomic) UILabel *mLab_name;//部门和姓名
@property (strong,nonatomic) UIButton *mBtn_search;//搜索按钮
@property (strong,nonatomic) UIButton *mBtn_add;//添加按钮
@property (strong,nonatomic) UIButton *mBtn_setting;//设置
@property (strong,nonatomic) UIScrollView *mScrollV_name;//放部门、姓名
@property (weak,nonatomic) id<Nav_internetAppViewDelegate> delegate;


//单
+(Nav_internetAppView *)getInstance;

-(id)initWithName:(NSString *)name;

@end

@protocol Nav_internetAppViewDelegate <NSObject>

//点击按钮
-(void)Nav_internetAppViewClickBtnWith:(UIButton *)btn;

@end