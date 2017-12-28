//
//  UIViewController+HUD.h
//  Kata51SDK
//
//  Created by srj on 15/4/21.
//  Copyright (c) 2015年 KATA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBProgressHUD;

@interface UIViewController (HUD)
@property (nonatomic, strong) MBProgressHUD *hud;

#pragma mark - Show Options

- (void)showHud;
- (void)showHudAnimated:(BOOL)animated;
- (void)showHudWithTitle:(NSString*)title; // Animated by default
- (void)showHudWithTitle:(NSString*)title animated:(BOOL)animated;
- (void)showHudWithTitle:(NSString*)title andSubtitle:(NSString*)subtitle; // Animated by default
- (void)showHudWithTitle:(NSString*)title andSubtitle:(NSString*)subtitle animated:(BOOL)animated;

#pragma mark - Hide Options

- (void)hideHud; // Animated by default
- (void)hideHudAnimated:(BOOL)animated;
- (void)hideHudAfterDelay:(NSTimeInterval)delay;
@end
