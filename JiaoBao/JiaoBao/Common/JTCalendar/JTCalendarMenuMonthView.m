//
//  JTCalendarMenuMonthView.m
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import "JTCalendarMenuMonthView.h"

@interface JTCalendarMenuMonthView(){
    UILabel *textLabel;
}

@end

@implementation JTCalendarMenuMonthView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (void)commonInit
{
    {
        textLabel = [UILabel new];
        [self addSubview:textLabel];
        
        textLabel.textAlignment = NSTextAlignmentCenter;
    }
}

- (void)setMonthIndex:(NSInteger)monthIndex year:(NSUInteger)year
{
    static NSDateFormatter *dateFormatter;
//    NSDate *date = [NSDate date];
//    NSDateFormatter *yearFormatter = [[NSDateFormatter alloc] init];
//    [yearFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSString *destDateString = [dateFormatter stringFromDate:date];
//    NSLog(@"year = %@",destDateString);
    
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        
        dateFormatter.timeZone = self.calendarManager.calendarAppearance.calendar.timeZone;
    }
    

    while(monthIndex <= 0){
        monthIndex += 12;
        
    }
//    NSCalendar *calendar = self.calendarManager.calendarAppearance.calendar;
//    NSDateComponents *comps = [calendar components:NSMonthCalendarUnit fromDate:currentDate];
//    NSInteger currentMonthIndex = comps.month;

//    NSArray *arr = [dateFormatter standaloneMonthSymbols];
//    for(int i=0;i<arr.count;i++)
//    {
//        NSLog(@"arr[%d] = %@",i,[arr objectAtIndex:i]);
//
//        
//    }
    NSString *chMonth = [self monthToChinese:[[dateFormatter standaloneMonthSymbols][monthIndex - 1] capitalizedString]];
    textLabel.text = [NSString stringWithFormat:@"%ld年%@",year,chMonth];
}

- (void)layoutSubviews
{
    textLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);

    // No need to call [super layoutSubviews]
}

- (void)reloadAppearance
{
    textLabel.textColor = self.calendarManager.calendarAppearance.menuMonthTextColor;
    textLabel.font = self.calendarManager.calendarAppearance.menuMonthTextFont;
}

#pragma - mark  自定义方法 用于汉化日历的星期
- (NSString *) weekToChinese:(NSString *) enWeek {
    if (!([enWeek length] > 0)) {
        return nil;
    }
    NSString *upperWeek = [enWeek uppercaseString];
    NSString *chWeek = nil;
    if ([upperWeek isEqualToString:@"MON"]) {
        chWeek = @"周一";
    } else if([upperWeek isEqualToString:@"TUE"]) {
        chWeek = @"周二";
    } else if([upperWeek isEqualToString:@"WED"]) {
        chWeek = @"周三";
    } else if([upperWeek isEqualToString:@"THU"]) {
        chWeek = @"周四";
    } else if([upperWeek isEqualToString:@"FRI"]) {
        chWeek = @"周五";
    } else if([upperWeek isEqualToString:@"SAT"]) {
        chWeek = @"周六";
    } else if([upperWeek isEqualToString:@"SUN"]) {
        chWeek = @"周日";
    }
    return chWeek;
}

#pragma - mark  自定义方法 用于汉化日历的月份
- (NSString *) monthToChinese:(NSString *) enMonth {
    
    if (!([enMonth length] > 0)) {
        return nil;
    }
    NSMutableString *chMonth = [[NSMutableString alloc] init];
    NSArray *arr = [enMonth componentsSeparatedByString:@" "];
    NSString *arrMonth = [arr objectAtIndex:0];
    //NSString *arrYear = [arr objectAtIndex:1];
    if ([arrMonth isEqualToString:@"一月"]) {
        [chMonth appendString:@"1月"];
    } else if([arrMonth isEqualToString:@"二月"]) {
        [chMonth appendString:@"2月"];
    } else if([arrMonth isEqualToString:@"三月"]) {
        [chMonth appendString:@"3月"];
    } else if([arrMonth isEqualToString:@"四月"]) {
        [chMonth appendString:@"4月"];
    } else if([arrMonth isEqualToString:@"五月"]) {
        [chMonth appendString:@"5月"];
    } else if([arrMonth isEqualToString:@"六月"]) {
        [chMonth appendString:@"6月"];
    } else if([arrMonth isEqualToString:@"七月"]) {
        [chMonth appendString:@"7月"];
    } else if([arrMonth isEqualToString:@"八月"]) {
        [chMonth appendString:@"8月"];
    } else if([arrMonth isEqualToString:@"九月"]) {
        [chMonth appendString:@"9月"];
    } else if([arrMonth isEqualToString:@"十月"]) {
        [chMonth appendString:@"10月"];
    } else if([arrMonth isEqualToString:@"十一月"]) {
        [chMonth appendString:@"11月"];
    } else if([arrMonth isEqualToString:@"十二月"]) {
        [chMonth appendString:@"12月"];
    }
    //[chMonth appendFormat:@"  %@", arrYear];
    return chMonth;
}



@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
