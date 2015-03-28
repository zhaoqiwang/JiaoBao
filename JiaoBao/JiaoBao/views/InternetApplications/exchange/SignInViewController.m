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
- (IBAction)submitAction:(id)sender;
- (IBAction)queryAction:(id)sender;
@property(nonatomic,strong)NSString *selcetedDateStr;
@property(nonatomic,strong)NSArray *groupArr;
@property(nonatomic,assign)NSUInteger selectedTag;


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
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"日程"];
    [self.mNav_navgationBar setRightBtn:[UIImage imageNamed:@"appNav_contact"]];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetDelayedTime:) name:@"GetDelayedTime" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getUnitGroups:) name:@"getUnitGroups" object:nil];

    [[SignInHttp getInstance]getDelayedTime:[NSString stringWithFormat:@"%d",[dm getInstance].UID]];
    [[SignInHttp getInstance]getUnitGroups:[dm getInstance].UID];
    //self.calendarView.delegate = self;
    // Do any additional setup after loading the view from its nib.
}
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

-(void)selecteGroup:(id)sender
{
    KxMenuItem *menuItem = sender;
    self.selectedTag = menuItem.tag;
    
}




-(void)GetDelayedTime:(id)sender
{
    NSDictionary *dic = [sender object];
    NSLog(@"dic[2] = %@",[dic objectForKey:@"Data"]);
}
-(void)getUnitGroups:(id)sender
{
    self.groupArr = [sender object];
    
    
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

- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSTimeInterval  interval = 24*60*60;
//    
//    NSDate *destDate = [date dateByAddingTimeInterval:interval];
//    NSLog(@"destDate = %@",destDate);

    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    NSLog(@"destDateString = %@",destDateString);
    self.selcetedDateStr = destDateString;
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)submitAction:(id)sender
{
    DetailSubmitViewController *detail = [[DetailSubmitViewController alloc]init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSTimeInterval timeInterval = [self.calendar.currentDate timeIntervalSinceDate:self.calendar.currentDateSelected];
    NSLog(@"timeinterval = %f",timeInterval);
    NSUInteger dayInterval =   (NSUInteger) timeInterval/(24*60*60);
    NSLog(@"dayinterval = %ld",dayInterval);
    if(dayInterval >3)
    {
        [SVProgressHUD showErrorWithStatus:@"超出期限"];
    }
    else
    {
        detail.dayInterval = dayInterval;
        detail.selectedStr = self.selcetedDateStr;
        detail.groupDic = [self.groupArr objectAtIndex:self.selectedTag];
        [utils logDic:detail.groupDic];
        
        [self.navigationController pushViewController:detail animated:YES];
        
    }

    
    
}

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
