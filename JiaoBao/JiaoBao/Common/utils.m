//
//  utils.m
//  JiaoBao
//
//  Created by Zqw on 14-10-18.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "utils.h"
#import "AppDelegate.h"

@implementation utils

//生成唯一的uuid
+(NSString*) uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    result = [NSString stringWithFormat:@"MIP%@",result];
    
    return result;
}
+ (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UINavigationController *navi = [(AppDelegate*)[UIApplication sharedApplication].delegate navigationController];
    [navi pushViewController:viewController animated:animated];
}

+ (void)pushViewController1:(UIViewController *)viewController animated:(BOOL)animated
{
    UINavigationController *navi = [(AppDelegate*)[UIApplication sharedApplication].delegate navigationController];
//    [navi pushViewController:viewController animated:animated];
    [navi presentViewController:viewController animated:YES completion:nil];
}

+ (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UINavigationController *navi = [(AppDelegate*)[UIApplication sharedApplication].delegate navigationController];
    return [navi popViewControllerAnimated:animated];
}

+ (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UINavigationController *navi = [(AppDelegate*)[UIApplication sharedApplication].delegate navigationController];
    return [navi popToViewController:viewController animated:animated];
}

+ (NSArray *)viewControllersInStack
{
    UINavigationController *navi = [(AppDelegate*)[UIApplication sharedApplication].delegate navigationController];
    return navi.viewControllers;
}

+ (UIViewController *)topViewController
{
    UINavigationController *navi = [(AppDelegate*)[UIApplication sharedApplication].delegate navigationController];
    return navi.topViewController;
}

+ (NSString *)getLocalTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *gmt = [NSTimeZone localTimeZone];
    [formatter setTimeZone:gmt];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date = [NSDate date];
    //    D("时间  %@",[formatter stringFromDate:date]);
    return  [formatter stringFromDate:date];
}

//获取本地当前时间,光日期
+ (NSString *)getLocalTimeDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *gmt = [NSTimeZone localTimeZone];
    [formatter setTimeZone:gmt];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *date = [NSDate date];
    return  [formatter stringFromDate:date];
}

//将13位时间，转成标准时间
+(NSString *)longtimeToString:(double)time{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time/1000];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

//当前时间用时间转化过之后显示的double值
+(double)todayTimeConvertToDouble{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    double date = (double)time;
    date = date/60/60/24 + 25569.33333;
    return date;
}
+ (void)logDic:(NSDictionary *)dic
{
    NSError *error;
    NSString *tempStr1 = [[dic description] stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:&error];
    NSLog(@"dic[%ld]:%@",dic.count,str);
}
+ (void)logArr:(NSArray *)arr
{
    NSError *error;
    NSString *tempStr1 = [[arr description] stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:&error];
    NSLog(@"arr[%ld]:%@",arr.count,str);
}


@end
