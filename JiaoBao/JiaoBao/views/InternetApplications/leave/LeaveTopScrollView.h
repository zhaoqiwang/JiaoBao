//
//  LeaveTopScrollView.h
//  JiaoBao
//
//  Created by Zqw on 16/3/11.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeaveView.h"
#import "ButtonViewModel.h"
#import "dm.h"
#import "Loger.h"

@protocol LeaveViewDelegate;

@interface LeaveTopScrollView : UIScrollView

@property (nonatomic,strong) NSMutableArray *mArr_data;
@property (weak,nonatomic) id<LeaveViewDelegate> delegate;
@property (nonatomic,assign) int flag;//上下排列1，还是左右排序0区分

-(id)initFrame:(CGRect)rect Array:(NSMutableArray*)array Flag:(int)flag index:(int)index;

@end

@protocol LeaveViewDelegate <NSObject>

@optional

//点击
-(void) LeaveViewTitleBtn:(LeaveView *) view;

@end

