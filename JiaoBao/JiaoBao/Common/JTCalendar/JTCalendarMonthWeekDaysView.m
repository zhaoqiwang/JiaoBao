//
//  JTCalendarMonthWeekDaysView.m
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import "JTCalendarMonthWeekDaysView.h"

@implementation JTCalendarMonthWeekDaysView

static NSArray *cacheDaysOfWeeks;

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
    for(NSString *day in [self daysOfWeek]){
        UILabel *view = [UILabel new];
        
        view.font = self.calendarManager.calendarAppearance.weekDayTextFont;
        view.textColor = self.calendarManager.calendarAppearance.weekDayTextColor;
        
        view.textAlignment = NSTextAlignmentCenter;
        view.text = day;
        
        [self addSubview:view];
    }
}

- (NSArray *)daysOfWeek
{
    if(cacheDaysOfWeeks){
        return cacheDaysOfWeeks;
    }
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    NSMutableArray *days = [[dateFormatter standaloneWeekdaySymbols] mutableCopy];
        
    // Redorder days for be conform to calendar
    {
        NSCalendar *calendar = self.calendarManager.calendarAppearance.calendar;
        NSUInteger firstWeekday = (calendar.firstWeekday + 6) % 7; // Sunday == 1, Saturday == 7
                
        for(int i = 0; i < firstWeekday; ++i){
            id day = [days firstObject];
            [days removeObjectAtIndex:0];
            [days addObject:day];
        }
    }
    
    switch(self.calendarManager.calendarAppearance.weekDayFormat){
        case JTCalendarWeekDayFormatSingle:
            for(NSInteger i = 0; i < days.count; ++i){
                NSString *day = days[i];
                [days replaceObjectAtIndex:i withObject:[[day uppercaseString] substringToIndex:1]];
            }
            break;
        case JTCalendarWeekDayFormatShort:
            for(NSInteger i = 0; i < days.count; ++i){
                NSString *day = days[i];
                [days replaceObjectAtIndex:i withObject:[[day uppercaseString] substringToIndex:3]];
            }
            break;
        case JTCalendarWeekDayFormatFull:
            for(NSInteger i = 0; i < days.count; ++i){
                NSString *day = days[i];
                [days replaceObjectAtIndex:i withObject:[day uppercaseString]];
            }
            break;
    }
    
    cacheDaysOfWeeks = days;
    return cacheDaysOfWeeks;
}

- (void)layoutSubviews
{
    CGFloat x = 0;
    CGFloat width = self.frame.size.width / 7.;
    CGFloat height = self.frame.size.height;
    
    for(UIView *view in self.subviews){
        view.frame = CGRectMake(x, 0, width, height);
        x = CGRectGetMaxX(view.frame);
    }
    
    // No need to call [super layoutSubviews]
}

+ (void)beforeReloadAppearance
{
    cacheDaysOfWeeks = nil;
}

- (void)reloadAppearance
{
    for(int i = 0; i < self.subviews.count; ++i){
        UILabel *view = [self.subviews objectAtIndex:i];
        
        view.font = self.calendarManager.calendarAppearance.weekDayTextFont;
        view.textColor = self.calendarManager.calendarAppearance.weekDayTextColor;
        NSString *chWeek = [self weekToChinese:[[self daysOfWeek] objectAtIndex:i]];
        view.text = chWeek;
    }
}

- (NSString *) weekToChinese:(NSString *) enWeek {
    if (!([enWeek length] > 0)) {
        return nil;
    }
    NSString *upperWeek = [enWeek uppercaseString];
    NSString *chWeek = nil;
    if ([upperWeek isEqualToString:@"星期一"]) {
        chWeek = @"周一";
    } else if([upperWeek isEqualToString:@"星期二"]) {
        chWeek = @"周二";
    } else if([upperWeek isEqualToString:@"星期三"]) {
        chWeek = @"周三";
    } else if([upperWeek isEqualToString:@"星期四"]) {
        chWeek = @"周四";
    } else if([upperWeek isEqualToString:@"星期五"]) {
        chWeek = @"周五";
    } else if([upperWeek isEqualToString:@"星期六"]) {
        chWeek = @"周六";
    } else if([upperWeek isEqualToString:@"星期日"]) {
        chWeek = @"周日";
    }
    return chWeek;
}


@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
