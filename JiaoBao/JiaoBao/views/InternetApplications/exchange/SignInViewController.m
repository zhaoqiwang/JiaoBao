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
#import "MobClick.h"

@interface SignInViewController ()<JTCalendarDataSource>
@property (weak, nonatomic) IBOutlet JTCalendarMenuView *menuView;
@property (nonatomic, weak) IBOutlet JTCalendarContentView *calendarView;
@property (strong, nonatomic) JTCalendar *calendar;
- (IBAction)submitAction:(id)sender;//点击提交按钮
- (IBAction)queryAction:(id)sender;//点击查询按钮
@property(nonatomic,strong)NSString *selcetedDateStr;//选择的日期字符串
@property(nonatomic,strong)NSArray *groupArr;//点击导航栏右侧按钮所获列表数据
@property(nonatomic,assign)NSUInteger selectedTag;//点击组数据列表行的标志
@property(nonatomic,assign)NSInteger delayTime;


@end

@implementation SignInViewController
-(void)dealloc
{
//    self.calendar = nil;
//    self.calendarView = nil;
//    self.menuView = nil;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:[NSString stringWithFormat:@"%@%@",[NSString stringWithUTF8String:object_getClassName(self)],UMMESSAGE]];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:[NSString stringWithFormat:@"%@%@",[NSString stringWithUTF8String:object_getClassName(self)],UMMESSAGE]];
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
   // self.mNav_navgationBar.label_Title.text = menuItem.title;
    [self.mNav_navgationBar leftBtnAction:menuItem.title];

}

//获取最多延迟时间
-(void)GetDelayedTime:(id)sender
{
    [MBProgressHUD hideHUDForView:self.view];
    if([[sender object] isKindOfClass:[NSString class]])
    {
        [MBProgressHUD showError:[sender object] toView:self.view];
        return;
        
    }
    NSDictionary *dic = [sender object];
    self.delayTime = [[dic objectForKey:@"Data"] integerValue];

}
//获取组数据列表
-(void)getUnitGroups:(id)sender
{
    [MBProgressHUD hideHUDForView:self.view];
    if([[sender object] isKindOfClass:[NSString class]])
    {
        [MBProgressHUD showError:[sender object] toView:self.view];
        return;
        
    }
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


- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date
{
    return NO;
}
//选择日期的方法
- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
   // NSTimeInterval  interval = 24*60*60;
    
//    NSDate *destDate = [date dateByAddingTimeInterval:interval];
//    NSLog(@"destDate = %@",destDate);
//    //self.calendar.currentDateSelected = destDate;
//
//    NSLog(@"date = %@",date);
    NSString *destDateString = [dateFormatter stringFromDate:date];
    self.selcetedDateStr = destDateString;
//    NSDate *curDate = [NSDate date];
//    NSString *destDateString2 = [dateFormatter stringFromDate:curDate];
//    NSLog(@"curDate = %@",destDateString2);

    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//点击提交按钮所响应的方法
- (IBAction)submitAction:(id)sender
{
//    NSTimeZone* localzone = [NSTimeZone localTimeZone];
//    NSTimeZone* GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0];
//    NSDate *curDate = [NSDate date];
//    NSLog(@"curDate = %@",curDate);
//    NSTimeInterval  interval = 24*60*60;
//    NSDate *destDate = [self.calendar.currentDateSelected dateByAddingTimeInterval:interval];
//    NSLog(@"destDate = %@",destDate);
//    DetailSubmitViewController *detail = [[DetailSubmitViewController alloc]init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *slectedDate = [dateFormatter dateFromString:self.selcetedDateStr];
//    [dateFormatter setTimeZone:GTMzone];
//    [dateFormatter setTimeZone:localzone];
    NSDate *curDate = [NSDate date];
    NSString *curDateStr = [dateFormatter stringFromDate:curDate];
    NSDate *currDate = [dateFormatter dateFromString:curDateStr];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    int unitFlags = NSDayCalendarUnit|NSHourCalendarUnit;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:currDate toDate:slectedDate options:0];
    NSInteger days = [comps day];

    if(days <(-self.delayTime))
    {
        [MBProgressHUD showError:@"超出期限" toView:self.view];

    }
    else if(days >0)
    {
        [MBProgressHUD showError:@"不能提前提报日程" toView:self.view];

    }
    else
    {
        DetailSubmitViewController *detail = [[DetailSubmitViewController alloc]init];
        detail.selectedStr = self.selcetedDateStr;
        detail.groupDic = [self.groupArr objectAtIndex:self.selectedTag];
        [self.navigationController pushViewController:detail animated:YES];

    }


    
    
}
//点击请求所响应的方法
- (IBAction)queryAction:(id)sender {
    DetailQueryViewController *detail = [[DetailQueryViewController alloc]init];
    detail.selectedDateStr = self.selcetedDateStr;
    [self.navigationController pushViewController:detail animated:YES];
}

-(void)myNavigationGoback
{
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
