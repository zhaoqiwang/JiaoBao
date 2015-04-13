//
//  SignInViewController.m
//  JiaoBao
//
//  Created by songyanming on 15/3/5.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "SignInViewController.h"
#import "JTCalendar.h"
#import "DetailSubmitViewController.h"
#import "DetailQueryViewController.h"
#import "SignInHttp.h"
#import "SVProgressHUD.h"
#import "KxMenu.h"

@interface SignInViewController ()<JTCalendarDataSource>
@property (weak, nonatomic) IBOutlet JTCalendarMenuView *menuView;
@property (nonatomic, weak) IBOutlet JTCalendarContentView *calendarView;
@property (strong, nonatomic) JTCalendar *calendar;
- (IBAction)submitAction:(id)sender;//点击提交按钮
- (IBAction)queryAction:(id)sender;//点击查询按钮
@property(nonatomic,strong)NSString *selcetedDateStr;//选择的日期字符串
@property(nonatomic,strong)NSArray *groupArr;//点击导航栏右侧按钮所获列表数据
@property(nonatomic,assign)NSUInteger selectedTag;//点击组数据列表行的标志


@end

@implementation SignInViewController
-(void)dealloc
{
    self.calendar = nil;
    self.calendarView = nil;
    self.menuView = nil;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.calendar = [JTCalendar new];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];

    NSString *destDateString = [dateFormatter stringFromDate:self.calendar.currentDate];
    self.selcetedDateStr = destDateString;
    
    {
        self.calendar.calendarAppearance.calendar.firstWeekday = 2; // Sunday == 1, Saturday == 7
        self.calendar.calendarAppearance.dayCircleRatio = 9. / 10.;
        self.calendar.calendarAppearance.ratioContentMenu = 1.;
    }
    [self.calendar setMenuMonthsView:self.menuView];
    [self.calendar setContentView:self.calendarView];
    [self.calendar setDataSource:self];

    
    //通过通知获取最多延迟时间
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetDelayedTime:) name:@"GetDelayedTime" object:nil];
    //通过通知获取组列表数据
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getUnitGroups:) name:@"getUnitGroups" object:nil];
//请求最多延迟时间
    [[SignInHttp getInstance]getDelayedTime:[NSString stringWithFormat:@"%d",[dm getInstance].UID]];
    //请求组数据
    [[SignInHttp getInstance]getUnitGroups:[dm getInstance].UID];
    //self.calendarView.delegate = self;
    // Do any additional setup after loading the view from its nib.
}

//点击导航栏右侧按钮方法
-(void)navigationRightAction:(UIButton *)sender
{
    NSMutableArray *menuItems =[[NSMutableArray alloc]initWithCapacity:0];
    for(int i=0;i<self.groupArr.count;i++)
    {
        KxMenuItem *menuItem = [KxMenuItem menuItem:[[self.groupArr objectAtIndex:i]objectForKey:@"GroupName"]
                                              image:[UIImage imageNamed:@"appNav_groupChat"]
                                             target:self
                                             action:@selector(selecteGroup:)];
        menuItem.tag = i;
        [menuItems addObject:menuItem];
    }
    [utils logArr:menuItems];


    
    //    KxMenuItem *first = menuItems[0];
    //    first.foreColor = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
    //    first.alignment = NSTextAlignmentCenter;
    
    [KxMenu showMenuInView:self.view
                  fromRect:sender.frame
                 menuItems:menuItems];
    
}
//点击组数据列表某行的方法
-(void)selecteGroup:(id)sender
{
    KxMenuItem *menuItem = sender;
    self.selectedTag = menuItem.tag;
    self.mNav_navgationBar.label_Title.text = menuItem.title;
    
    
}



//获取最多延迟时间
-(void)GetDelayedTime:(id)sender
{
    NSDictionary *dic = [sender object];
    NSLog(@"dic[2] = %@",[dic objectForKey:@"Data"]);
}
//获取组数据列表
-(void)getUnitGroups:(id)sender
{
    self.groupArr = [sender object];
    //添加导航条
    NSString *str = [NSString stringWithFormat:@"%@",[[self.groupArr objectAtIndex:0]objectForKey:@"GroupName"]];
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@""];
    [self.mNav_navgationBar setRightBtn:[UIImage imageNamed:@"appNav_contact"]];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar leftBtnAction:str];
    [self.view addSubview:self.mNav_navgationBar];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.calendar reloadData]; // （必须要在这里调用）Must be call in viewDidAppear
}
-(void)viewWillDisappear:(BOOL)animated
{
//    self.calendar = nil;
//    self.calendarView = nil;
//    self.menuView = nil;
    
}

- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date
{
    return NO;
}
//选择日期的方法
- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeInterval  interval = 24*60*60;
    
    NSDate *destDate = [date dateByAddingTimeInterval:interval];
    NSLog(@"destDate = %@",destDate);
    //self.calendar.currentDateSelected = destDate;

    NSLog(@"date = %@",date);
    NSString *destDateString = [dateFormatter stringFromDate:date];
    NSLog(@"destDateString = %@",destDateString);
    self.selcetedDateStr = destDateString;
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//点击提交按钮所响应的方法
- (IBAction)submitAction:(id)sender
{
    NSTimeZone* localzone = [NSTimeZone localTimeZone];
    NSTimeZone* GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSDate *curDate = [NSDate date];
    NSLog(@"curDate = %@",curDate);
    NSTimeInterval  interval = 24*60*60;
    NSDate *destDate = [self.calendar.currentDateSelected dateByAddingTimeInterval:interval];
    NSLog(@"destDate = %@",destDate);
    DetailSubmitViewController *detail = [[DetailSubmitViewController alloc]init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:GTMzone];
    [dateFormatter setTimeZone:localzone];

    NSString *date = [dateFormatter stringFromDate:curDate];
    NSString *date2 = [dateFormatter stringFromDate:destDate];
    NSDate *selectDate = [dateFormatter dateFromString:date2];
    NSDate *currDate = [dateFormatter dateFromString:date];
    NSLog(@"selectDate = %@ currDate = %@",selectDate,currDate);

//    long long currentDate = [date longLongValue];
//    long long selectedDate = [date2 longLongValue];
//    if(selectedDate == 0)
//    {
//        selectedDate = currentDate;
//    }

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    
    unsigned int unitFlags = NSDayCalendarUnit|NSHourCalendarUnit;
    //NSDate *selectDate = [dateFormatter dateFromString:self.selcetedDateStr];
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:selectDate toDate:currDate options:0];
    NSUInteger days = [comps day];
    NSLog(@"days = %ld",days);
        
//    NSLog(@"current = %ld,selectedDate = %ld",(long)currentDate,( long)selectedDate);
//    long long dayInterval = currentDate-selectedDate;
//    NSLog(@"dayInterval = %ld",( long)dayInterval);

//    NSLog(@"current = %@,selectedDate = %@",self.calendar.currentDate,self.calendar.currentDateSelected);
//    NSTimeInterval timeInterval = [self.calendar.currentDate timeIntervalSinceDate:self.calendar.currentDateSelected];
//    NSLog(@"timeinterval = %f",timeInterval);
//    NSUInteger dayInterval =   (NSUInteger) timeInterval/(24*60*60);
//    NSLog(@"dayinterval = %ld",(unsigned long)dayInterval);
    if(days >3)
    {
        [SVProgressHUD showErrorWithStatus:@"超出期限"];
    }
    else if(days <0)
    {
        
        //NSLog(@"dayInterval = %ld",(unsigned long)dayInterval);
        [SVProgressHUD showErrorWithStatus:@"不能提前提报日程"];

        
        

        
    }
    else
    {
        //detail.dayInterval = dayInterval;
        
        detail.selectedStr = self.selcetedDateStr;
        detail.groupDic = [self.groupArr objectAtIndex:self.selectedTag];
        [utils logDic:detail.groupDic];
        
        [self.navigationController pushViewController:detail animated:YES];


        
    }

    
    
}
//点击请求所响应的方法
- (IBAction)queryAction:(id)sender {
    DetailQueryViewController *detail = [[DetailQueryViewController alloc]init];
    detail.selectedDateStr = self.selcetedDateStr;
    
    [self.navigationController pushViewController:detail animated:YES];
}

-(void)myNavigationGoback{
    [self.navigationController popViewControllerAnimated:NO];
}
- (IBAction)leftBtnAction:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"leftBtnAction" object:@"left"];
}

- (IBAction)rightBtnAction:(id)sender {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"rightBtnAction" object:@"right"];
}

- (IBAction)minusYearAction:(id)sender {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"minusYearAction" object:@"minusYear"];
}

- (IBAction)addYearAction:(id)sender {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"addYearAction" object:@"addYear"];
}


@end
