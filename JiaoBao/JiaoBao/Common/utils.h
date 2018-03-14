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

//计算文件大小
+(NSString*) getFileSize:(int) number;

//判断字符串是否为空、是否都是空格
+ (BOOL)isBlankString:(NSString *)string;
//
+ (void)logDic:(NSDictionary *)dic;

//去掉html中的无用标签，适配手机
+(NSString *)clearHtml:(NSString *)content width:(int)tempW;

//检查当前网络是否可用
+(BOOL)checkNetWork:(UIView *)view tableView:(UITableView *)tableView;

//过滤错题本中的输入框等 - html文本 - 0直接去掉，1替换text
+(NSString *)filterHTML:(NSString *)html Flag:(int)flag;

//textField限制字数 num(限制的字数大小)--（textField range string是UITextViewDelegate里的参数)
+(BOOL)textFiledWordLimit:(NSInteger)num textField:(UITextField *)textField range:(NSRange)range string:(NSString*)string;

//textView限制字数 num(限制的字数大小)--（textView text range是UITextViewDelegate里的参数）--textField（负责显示placehold的textfield）
+(BOOL)textViewWordLimit:(NSInteger)num textView:(UITextView*)textView text:(NSString*)text range:(NSRange)range textField:(UITextField*)textField;

//得到应用角标数字
+(int)getAppIconBadgeNumber;

//改变应用角标
+(void)modifyAppIconBadgeNumber:(NSInteger)num;

@end
