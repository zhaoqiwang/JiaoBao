//
//  ButtonView.h
//  JiaoBao
//
//  Created by Zqw on 15/8/10.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonViewModel.h"

@protocol ButtonViewDelegate;

@interface ButtonView : UIView

@property (nonatomic,strong) NSMutableArray *mArr_data;
@property (weak,nonatomic) id<ButtonViewDelegate> delegate;

-(id)initFrame:(CGRect)rect Array:(NSMutableArray*)array;

@end

@protocol ButtonViewDelegate <NSObject>

@optional

//点击
-(void) ButtonViewTitleBtn:(UIView *) view;

@end