//
//  JTCalendar.m
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import "JTCalendar.h"
#import "SignInHttp.h"

#define NUMBER_PAGES_LOADED 5 // Must be the same in JTCalendarView, JTCalendarMenuView, JTCalendarContentView

@interface JTCalendar(){
    JTCalendarAppearance *calendarAppearance;
    BOOL cacheLastWeekMode;
}

@end

@implementation JTCalendar




- (instancetype)init
{
    self = [super init];
    if(!self)
    {
        return nil;
    }
    
    self->_currentDate = [NSDate date];
    calendarAppearance = [JTCalendarAppearance new];


    
    return self;
}

- (void)setMenuMonthsView:(JTCalendarMenuView *)menuMonthsView
{
    [self->_menuMonthsView setDelegate:nil];
    [self->_menuMonthsView setCalendarManager:nil];
    
    self->_menuMonthsView = menuMonthsView;
    [self->_menuMonthsView setDelegate:self];
    [self->_menuMonthsView setCalendarManager:self];
    
    cacheLastWeekMode = self.calendarAppearance.isWeekMode;
    
    [self.menuMonthsView setCurrentDate:self.currentDate];
    [self.menuMonthsView reloadAppearance];
}

- (void)setContentView:(JTCalendarContentView *)contentView
{
    [self->_contentView setDelegate:nil];
    [self->_contentView setCalendarManager:nil];
    
    self->_contentView = contentView;
    [self->_contentView setDelegate:self];
    [self->_contentView setCalendarManager:self];
    
    [self.contentView setCurrentDate:self.currentDate];
    [self.contentView reloadAppearance];
}

- (void)reloadData
{


    //[[SignInHttp getInstance]WorkPlanSelectContentByMonth:nil UserID:nil strSelectDate:[dm getInstance].monthStr];
    // Position to the middle page
    CGFloat pageWidth = CGRectGetWidth(self.contentView.frame);
    self.contentView.contentOffset = CGPointMake(pageWidth * ((NUMBER_PAGES_LOADED / 2)), self.contentView.contentOffset.y);
 
    CGFloat menuPageWidth = CGRectGetWidth([self.menuMonthsView.subviews.firstObject frame]);
    self.menuMonthsView.contentOffset = CGPointMake(menuPageWidth * ((NUMBER_PAGES_LOADED / 2)), self.menuMonthsView.contentOffset.y);
    
    [self.contentView reloadData];
}

- (void)reloadAppearance
{
    [self.menuMonthsView reloadAppearance];
    [self.contentView reloadAppearance];
    
    if(cacheLastWeekMode != self.calendarAppearance.isWeekMode){
        cacheLastWeekMode = self.calendarAppearance.isWeekMode;
        [self setCurrentDate:self.currentDate]; // Reload all data
    }
}

- (void)setCurrentDate:(NSDate *)currentDate
{


    self->_currentDate = currentDate;
    
    [self.menuMonthsView setCurrentDate:currentDate];
    [self.contentView setCurrentDate:currentDate];
    
    [self reloadData]; // For be on the good page and update all DayView
}

- (JTCalendarAppearance *)calendarAppearance
{
    return calendarAppearance;
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if(self.calendarAppearance.isWeekMode){
        return;
    }
    
    if(sender == self.menuMonthsView && self.menuMonthsView.scrollEnabled){
        self.contentView.contentOffset = CGPointMake(sender.contentOffset.x * calendarAppearance.ratioContentMenu, self.contentView.contentOffset.y);
    }
    else if(sender == self.contentView && self.contentView.scrollEnabled){
        self.menuMonthsView.contentOffset = CGPointMake(sender.contentOffset.x / calendarAppearance.ratioContentMenu, self.menuMonthsView.contentOffset.y);
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [dm getInstance].strFlag = @"0" ;
    [dm getInstance].scrollArr = nil;
 self.startContentOffsetX = scrollView.contentOffset.x;
    if(scrollView == self.contentView){
        self.menuMonthsView.scrollEnabled = NO;
    }
    else if(scrollView == self.menuMonthsView){
        self.contentView.scrollEnabled = NO;
    }
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{    //将要停止前的坐标
    
    self.willEndContentOffsetX = scrollView.contentOffset.x;
    
}

// Use for scroll with scrollRectToVisible or setContentOffset
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self updatePage];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.endContentOffsetX = scrollView.contentOffset.x;
    
    if (self.endContentOffsetX < self.willEndContentOffsetX && self.willEndContentOffsetX < self.startContentOffsetX) { //画面从右往左移动，前一页
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *adcomps = [[NSDateComponents alloc] init];
        [adcomps setYear:0];
        [adcomps setMonth:-1];
        [adcomps setDay:0];
        NSDate* currentDate2 = [calendar dateByAddingComponents:adcomps toDate:self.currentDate options:0];
        //[self.calendar setCurrentDate:nextDate];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM"];
        NSString *dateString = [dateFormatter stringFromDate:currentDate2];
     
        
        [[SignInHttp getInstance]WorkPlanSelectContentByMonth:nil UserID:nil strSelectDate:dateString];
        
    } else if (self.endContentOffsetX > self.willEndContentOffsetX && self.willEndContentOffsetX > self.startContentOffsetX) {//画面从左往右移动，后一页
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *adcomps = [[NSDateComponents alloc] init];
        [adcomps setYear:0];
        [adcomps setMonth:1];
        [adcomps setDay:0];
        NSDate* currentDate2 = [calendar dateByAddingComponents:adcomps toDate:self.currentDate options:0];
        //[self.calendar setCurrentDate:nextDate];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM"];
        NSString *dateString = [dateFormatter stringFromDate:currentDate2];


        
        [[SignInHttp getInstance]WorkPlanSelectContentByMonth:nil UserID:nil strSelectDate:dateString];
        
    }
    [self updatePage];
    
}

- (void)updatePage
{

    CGFloat pageWidth = CGRectGetWidth(self.contentView.frame);
    CGFloat fractionalPage = self.contentView.contentOffset.x / pageWidth;
        
    int currentPage = roundf(fractionalPage);
    if (currentPage == (NUMBER_PAGES_LOADED / 2)){
        self.menuMonthsView.scrollEnabled = YES;
        self.contentView.scrollEnabled = YES;
        return;
    }
    
    NSCalendar *calendar = calendarAppearance.calendar;
    NSDateComponents *dayComponent = [NSDateComponents new];
    
    if(!self.calendarAppearance.isWeekMode){
        dayComponent.month = currentPage - (NUMBER_PAGES_LOADED / 2);
    }
    else{
        dayComponent.day = 7 * (currentPage - (NUMBER_PAGES_LOADED / 2));
    }
    
    NSDate *currentDate = [calendar dateByAddingComponents:dayComponent toDate:self.currentDate options:0];
    
    [self setCurrentDate:currentDate];

    
    self.menuMonthsView.scrollEnabled = YES;
    self.contentView.scrollEnabled = YES;
}

- (void)loadNextMonth
{
    if(self.calendarAppearance.isWeekMode){
        NSLog(@"JTCalendar loadNextMonth ignored");
        return;
    }
    
    self.menuMonthsView.scrollEnabled = NO;
    
    CGRect frame = self.contentView.frame;
    frame.origin.x = frame.size.width * ((NUMBER_PAGES_LOADED / 2) + 1);
    frame.origin.y = 0;
    [self.contentView scrollRectToVisible:frame animated:YES];
}

- (void)loadPreviousMonth
{
    if(self.calendarAppearance.isWeekMode){
        NSLog(@"JTCalendar loadPreviousMonth ignored");
        return;
    }
    
    self.menuMonthsView.scrollEnabled = NO;
    
    CGRect frame = self.contentView.frame;
    frame.origin.x = frame.size.width * ((NUMBER_PAGES_LOADED / 2) - 1);
    frame.origin.y = 0;
    [self.contentView scrollRectToVisible:frame animated:YES];
}

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
