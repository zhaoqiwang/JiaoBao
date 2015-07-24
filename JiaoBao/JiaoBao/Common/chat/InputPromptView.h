//
//  InputPromptView.h
//  DocPlatform
//
//  Created by Perry on 14-11-4.
//  Copyright (c) 2014年 PAJK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputPromptView : UIView
@property (assign, nonatomic) UIControlEvents event;
@property (assign, nonatomic) NSInteger voiceLevel;

@property (assign, nonatomic) NSTimeInterval delayToHide;

- (id) initWithSuperView:(UIView *)superView;
@end
