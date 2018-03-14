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

+ (void)popViewControllerAnimated1:(BOOL)animated
{
    UINavigationController *navi = [(AppDelegate*)[UIApplication sharedApplication].delegate navigationController];
//    return
    [navi dismissViewControllerAnimated:YES completion:nil];
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

+(NSString*) getFileSize:(int) number
{
    NSString* smble = @"";
    
    if(number>1024*1024*1024) {
        return [NSString stringWithFormat:@"%.2fG",number/1024.f/1024.f/1024.f];
    } else if(number>1024*1024) {
        return [NSString stringWithFormat:@"%.3fM", number/1024.f/1024.f];
    } else if(number>1024) {
        return [NSString stringWithFormat:@"%.1fKB",  number/1024.f];
    } else if(number>=0) {
        return [NSString stringWithFormat:@"%iBytes", number];
    }
    
    return [NSString stringWithFormat:@"%@%dB", smble, 0];
}

//判断字符串是否为空、是否都是空格
+ (BOOL)isBlankString:(NSString *)string{
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
+ (void)logDic:(NSDictionary *)dic
{
    NSString *tempStr1 = [[dic description] stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [NSPropertyListSerialization propertyListFromData:tempData mutabilityOption:NSPropertyListImmutable format:NULL errorDescription:NULL];
    NSLog(@"dic:%@",str);
}

//去掉html中的无用标签，适配手机
+(NSString *)clearHtml:(NSString *)content width:(int)tempW{
    content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"&nbsp;"] withString:@" "];
    content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"height"] withString:@" "];
    content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"width"] withString:@" "];
    content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"table"] withString:@"div"];
    content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"tbody"] withString:@"div"];
    content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"tr>"] withString:@"p>"];
    content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"td>"] withString:@"div>"];
    content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"\n"] withString:@"</br>"];
    content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<img"] withString:@"<img class=\"pic\""];
    content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"nowrap"] withString:@""];
    content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"white-space"] withString:@""];
    content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"href"] withString:@""];
    
    content = [content stringByReplacingOccurrencesOfString:@"src=\"//" withString:@"src=\"http://www."];
    content = [NSString stringWithFormat:@"<div style=\"word-break: break-all; word-wrap:break-word;\">%@</div>",content];
    
    NSString *tempHtml = [NSString stringWithFormat:@"<meta name=\"viewport\" style=width:%dpx, content=\"width=%d,initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=no\" /><style>.pic{max-width:%dpx; max-height: auto; width: expression(this.width >%d && this.height < this.width ? %d: true); height: expression(this.height > auto ? auto: true);}</style>%@",[dm getInstance].width-tempW,[dm getInstance].width-tempW,[dm getInstance].width-tempW,[dm getInstance].width-tempW,[dm getInstance].width-tempW,content];
    return tempHtml;
}

//检查当前网络是否可用
+(BOOL)checkNetWork:(UIView *)view tableView:(UITableView *)tableView{
    if ([self checkNetWork2:view]) {
        [tableView headerEndRefreshing];
        [tableView footerEndRefreshing];
        return YES;
    }
    return NO;
}

//检查当前网络是否可用
+(BOOL)checkNetWork2:(UIView *)view{
    if([Reachability isEnableNetwork]==NO){
        [MBProgressHUD showError:NETWORKENABLE toView:view];
        return YES;
    }else{
        return NO;
    }
}

//过滤错题本中的输入框等 - html文本 - 0直接去掉，1替换text
+(NSString *)filterHTML:(NSString *)html Flag:(int)flag{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        if (flag == 0) {
            [scanner scanUpToString:@"<input type=\"radio\"" intoString:nil];
        }else{
            [scanner scanUpToString:@"<input type=\"text\"" intoString:nil];
        }
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        if (flag == 0) {
            html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
        }else{
            html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@" (   ) "];
        }
    }
    return html;
}
//textField限制字数 num(限制的字数大小)--（textField range string是UITextViewDelegate里的参数)
+(BOOL)textFiledWordLimit:(NSInteger)num textField:(UITextField *)textField range:(NSRange)range string:(NSString*)string{
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage]; // 键盘输入模式
    
    if([toBeString isContainsEmoji])
    {
        if (textField.text.length>num) {
            NSString *b = [textField.text substringFromIndex:textField.text.length-1];
            if([b isContainsEmoji]) {
                textField.text = [toBeString substringToIndex:textField.text.length - 1];
                toBeString = textField.text;
            }
        }
        if (textField.text.length>num) {
            NSString *b = [textField.text substringFromIndex:textField.text.length-2];
            if([b isContainsEmoji]) {
                textField.text = [toBeString substringToIndex:textField.text.length - 2];
                toBeString = textField.text;
            }
        }
    }
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            
            if (toBeString.length > num) {
                
                textField.text = [toBeString substringToIndex:num];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        
        if (toBeString.length > num) {
            textField.text = [toBeString substringToIndex:num];
        }
    }
    
    //输入删除时
    if([string isEqualToString:@""]) {
        return YES;
    }
    //系统九宫格限制字数
    if(range.location==num-1&&string.length==1)
    {
        
        if([string isEqualToString:@"➋"])
        {
            string = @"a";
        }else if([string isEqualToString:@"➌"]){
            string = @"d";
        }else if([string isEqualToString:@"➍"]){
            string = @"g";
        }else if([string isEqualToString:@"➎"]){
            string = @"j";
        }else if([string isEqualToString:@"➏"]){
            string = @"m";
        }else if([string isEqualToString:@"➐"]){
            string = @"p";
        }else if([string isEqualToString:@"➑"]){
            string = @"t";
        }else if([string isEqualToString:@"➒"]){
            string = @"w";
        }else if([string isEqualToString:@"☻"]){
            string = @"^";
        }else {
        }
    }
    NSString *Sumstr = [NSString stringWithFormat:@"%@%@",textField.text,string];
    //限制为50字
    if(Sumstr.length>num-1)
    {
        textField.text = [Sumstr substringToIndex:num];
        return NO;
    }

    return YES;
}
//textView限制字数 num(限制的字数大小)--（textView text range是UITextViewDelegate里的参数）--textField（负责显示placehold的textfield）
+(BOOL)textViewWordLimit:(NSInteger)num textView:(UITextView*)textView text:(NSString*)text range:(NSRange)range textField:(UITextField*)textField{
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage]; // 键盘输入模式
    
    if([toBeString isContainsEmoji])
    {
        if (textField.text.length>num) {
            NSString *b = [textField.text substringFromIndex:textField.text.length-1];
            if([b isContainsEmoji]) {
                textField.text = [toBeString substringToIndex:textField.text.length - 1];
                toBeString = textField.text;
            }
        }
        if (textField.text.length>num) {
            NSString *b = [textField.text substringFromIndex:textField.text.length-2];
            if([b isContainsEmoji]) {
                textField.text = [toBeString substringToIndex:textField.text.length - 2];
                toBeString = textField.text;
            }
        }
    }
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            
            if (toBeString.length > num) {
                
                textField.text = [toBeString substringToIndex:num];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        
        if (toBeString.length > num) {
            textField.text = [toBeString substringToIndex:num];
        }
    }
    //输入删除时
    if([text isEqualToString:@""]) {
        return YES;
    }
    //系统九宫格限制字数
    if(range.location==num-1&&text.length==1)
    {
        
        if([text isEqualToString:@"➋"])
        {
            text = @"a";
        }else if([text isEqualToString:@"➌"]){
            text = @"d";
        }else if([text isEqualToString:@"➍"]){
            text = @"g";
        }else if([text isEqualToString:@"➎"]){
            text = @"j";
        }else if([text isEqualToString:@"➏"]){
            text = @"m";
        }else if([text isEqualToString:@"➐"]){
            text = @"p";
        }else if([text isEqualToString:@"➑"]){
            text = @"t";
        }else if([text isEqualToString:@"➒"]){
            text = @"w";
        }else if([text isEqualToString:@"☻"]){
            text = @"^";
        }else {
        }
    }
    NSString *Sumstr = [NSString stringWithFormat:@"%@%@",textView.text,text];
    //限制为50字
    if(Sumstr.length>num-1)
    {
        textView.text = [Sumstr substringToIndex:num];
        textField.hidden = YES;
        return NO;
    }

    return YES;
    
}

//得到应用角标数字
+(int)getAppIconBadgeNumber{
    NSString *tempNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"IconBadgeNumber"];
    return [tempNum intValue];
}

//改变应用角标
+(void)modifyAppIconBadgeNumber:(NSInteger)num{
    [[NSUserDefaults standardUserDefaults] setValue:@(num) forKey:@"IconBadgeNumber"];
    [UIApplication sharedApplication].applicationIconBadgeNumber = num;
}

@end
