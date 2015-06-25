//
//  MBProgressHUD+AD.h
//
//  Created by zhangandong on 14/11/27.
//  Copyright (c) 2014年 zhangandong. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (AD)
+(void)showText:(NSString *)text toView:(UIView *)view;
+(void)showText:(NSString *)text;

+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;


+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;
@end
