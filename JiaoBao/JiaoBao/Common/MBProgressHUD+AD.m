//
//  MBProgressHUD+AD.m
//
//  Created by zhangandong on 14/11/27.
//  Copyright (c) 2014年 zhangandong. All rights reserved.
//

#import "MBProgressHUD+AD.h"
#import "Reachability.h"
#import "define_constant.h"

@implementation MBProgressHUD (AD)
#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:2.0];
}

#pragma mark 显示提醒文字（不带成功与否标志）
+(void)showText:(NSString *)text toView:(UIView *)view{
    [self show:text icon:nil view:view];
}

+(void)showText:(NSString *)text{
    [self showText:text toView:nil];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    if (error.length==0) {
        error = @"超时";
    }
    [self show:error icon:@"error.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    //检查当前网络是否可用
//    if ([self checkNetWork:view]) {
////        return;
//    }else{
        if (message.length==0) {
            message = @"加载中...";
        }
        if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
        // 快速显示一个提示信息
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.labelText = message;
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        // YES代表需要蒙版效果
        hud.dimBackground = NO;
        return hud;
//    }
//    return nil;
}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

+ (void)hideHUDForView:(UIView *)view
{
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}

//检查当前网络是否可用
+(BOOL)checkNetWork:(UIView *)view{
    if([Reachability isEnableNetwork]==NO){
        [MBProgressHUD showError:NETWORKENABLE toView:view];
        return YES;
    }else{
        return NO;
    }
}

@end
