//
//  ButtonView.h
//  JiaoBao
//
//  Created by Zqw on 15/8/10.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonViewModel.h"
#import "ButtonViewCell.h"

@protocol ButtonViewDelegate;

@interface ButtonView : UIView

@property (nonatomic,strong) NSMutableArray *mArr_data;
@property (weak,nonatomic) id<ButtonViewDelegate> delegate;
@property (nonatomic,assign) int flag;//上下排列1，还是左右排序0区分

-(id)initFrame:(CGRect)rect Array:(NSMutableArray*)array Flag:(int)flag index:(int)index;

@end

@protocol ButtonViewDelegate <NSObject>

@optional

//点击
-(void) ButtonViewTitleBtn:(ButtonViewCell *) view;

@end