//
//  UIViewController+HUD.m
//  Kata51SDK
//
//  Created by srj on 15/4/21.
//  Copyright (c) 2015年 KATA. All rights reserved.
//

#import "UIViewController+HUD.h"
#import "MBProgressHud.h"
#import <objc/runtime.h>

NSString * const kHudPropertyKey = @"kViewControllerHud";

@implementation UIViewController (HUD)
@dynamic hud;

#pragma mark - Stores HUD as instance variable within the ViewController
- (void)setHud:(MBProgressHUD *)hud {
    objc_setAssociatedObject(self, (__bridge const void *)(kHudPropertyKey), hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MBProgressHUD *)hud {
    return objc_getAssociatedObject(self, (__bridge const void *)(kHudPropertyKey));
}

- (void)showHud {
    [self showHudWithTitle:nil andSubtitle:nil animated:YES];
}

- (void)showHudAnimated:(BOOL)animated {
    [self showHudWithTitle:nil andSubtitle:nil animated:animated];
}

- (void)showHudWithTitle:(NSString*)title {
    [self showHudWithTitle:title andSubtitle:nil animated:YES];
}

- (void)showHudWithTitle:(NSString*)title animated:(BOOL)animated {
    [self showHudWithTitle:title andSubtitle:nil animated:animated];
}

- (void)showHudWithTitle:(NSString*)title andSubtitle:(NSString*)subtitle {
    [self showHudWithTitle:title andSubtitle:subtitle animated:YES];
}

- (void)showHudWithTitle:(NSString*)title andSubtitle:(NSString*)subtitle animated:(BOOL)animated {
    BOOL alreadyInstanitated = YES;
    if(![self hud]) {
        [self setHud:[[MBProgressHUD alloc] initWithView:[self view]]];
        [[self hud] setRemoveFromSuperViewOnHide:YES];
        alreadyInstanitated = NO;
    }
    
    // Customize the HUD...
    [[self hud] setLabelText:(title ? title : @"加载中...")];
    if(subtitle) {
        [[self hud] setDetailsLabelText:subtitle];
    }
    
    // Display the HUD if required...
    if(!alreadyInstanitated) {
        [[self view] addSubview:[self hud]];
        [[self hud] show:animated];
    }
}

#pragma mark - Hide Options

- (void)hideHud {
    [self hideHudAnimated:YES];
}

- (void)hideHudAfterDelay:(NSTimeInterval)delay {
    [self hideHudAnimated:YES after:delay];
}

- (void) hideHudAnimated:(BOOL)animated{
    if([self hud]) {
        [[self hud] hide:animated];
        [self setHud:nil];
    }
}

- (void) hideHudAnimated:(BOOL)animated after:(NSTimeInterval)delay{
    if([self hud]) {
        [[self hud] hide:animated afterDelay:delay];
        [self setHud:nil];
    }
}

@end
