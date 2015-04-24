//
//  utils.h
//  JiaoBao
//
//  Created by Zqw on 14-10-18.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface utils : NSObject

//生成唯一的uuid
+(NSString*) uuid;
//界面跳转相关
+ (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
+ (void)pushViewController1:(UIViewController *)viewController animated:(BOOL)animated;
+ (UIViewController *)popViewControllerAnimated:(BOOL)animated;
+ (void)popViewControllerAnimated1:(BOOL)animated;
+ (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated;
+ (NSArray *)viewControllersInStack;
+ (UIViewController *)topViewController;

//获取本地当前时间
+ (NSString *)getLocalTime;

//获取本地当前时间,光日期
+ (NSString *)getLocalTimeDate;

//将13位时间，转成标准时间
+(NSString *)longtimeToString:(double)time;

//当前时间用时间转化过之后显示的double值
+(double)todayTimeConvertToDouble;
+ (void)logDic:(NSDictionary *)dic;
+ (void)logArr:(NSArray *)arr;



@end
