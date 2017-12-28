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
#import <UMAnalytics/MobClick.h>

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
@property(nonatomic,strong)DetailQueryViewController *detail;



@end

@implementation SignInViewController
//动态改变高度
-(void)updateViewConstraints
{
    [super updateViewConstraints];
    if([dm getInstance].statusBar>20){
        
//        self.top.constant = 54;
 
    }
    
}
-(void)dealloc
{
    [self.detail removeFromParentViewController];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    self.calendar.contentView.delegate = nil;
    self.calendar.menuMonthsView.delegate = nil;
    self.calendar = nil;
    self.calendarView = nil;
    self.menuView = nil;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:UMMESSAGE];
    [MobClick beginLogPageView:UMPAGE];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:UMMESSAGE];
    [MobClick endLogPageView:UMPAGE];

}
-(void)getDateMark:(id)sender
{
    NSString *dateStr = [sender object];
    self.dateArr = nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSString *dateString = [dateFormatter stringFromDate:self.currentDate];
    if(dateStr&&[dateStr isEqual:[NSNull null]]==NO)
    {
        [dm getInstance].scrollArr = [dateStr componentsSeparatedByString:@","];
        self.dateArr = [dm getInstance].scrollArr;
    }
    D("dateArr = %@",self.dateArr);
    if([self.strFlag isEqualToString:@"addYear"])
    {
        [self.calendar reloadData];
    }
    else if([self.strFlag isEqualToString:@"minusYear"])
    {
        [self.calendar reloadData];
    }
    else
    {
        if([[dm getInstance].strFlag isEqualToString:@"0"])
        {
            [self.calendar reloadData];
            [dm getInstance].strFlag =@"1";
        }
        else
        {
            if(self.firstFlag ==NO)
            {
                [self.calendar updatePage];
                
                
            }
            else
            {
                self.firstFlag = NO;
            }
            
        }

    }
    
        if([self.selcetedDateStr rangeOfString:dateString].location!=NSNotFound)
        {
            self.detail.selectedDateStr = self.selcetedDateStr;
        }
        else
        {
            self.detail.selectedDateStr = @"";
            
        }


    
    self.strFlag = @"";
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [dm getInstance].classStr = @"SignInViewController";
    NSString *str = [NSString stringWithFormat:@"%@",[dm getInstance].mStr_unit];
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@""];
    //    [self.mNav_navgationBar setRightBtn:[UIImage imageNamed:@"appNav_contact"]];
    [self.mNav_navgationBar setRightBtnTitle:@"填写"];
    
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar leftBtnAction:str];
    [self.view addSubview:self.mNav_navgationBar];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getDateMark:) name:@"getDateMark" object:nil];
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
    self.currentDate = self.calendar.currentDate;
    self.firstFlag = YES;
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy-MM"];
    NSString *dateString = [dateFormatter2 stringFromDate:self.calendar.currentDate];
    [[SignInHttp getInstance]WorkPlanSelectContentByMonth:nil UserID:nil strSelectDate:dateString];

    //通过通知获取最多延迟时间
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetDelayedTime:) name:@"GetDelayedTime" object:nil];
    //通过通知获取组列表数据
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getUnitGroups:) name:@"getUnitGroups" object:nil];
//请求最多延迟时间
    [[SignInHttp getInstance]getDelayedTime:[NSString stringWithFormat:@"%d",[dm getInstance].UID]];
    //请求组数据
    [[SignInHttp getInstance]getUnitGroups:[dm getInstance].UID];
    self.detail = [[DetailQueryViewController alloc]initWithNibName:@"DetailQueryViewController" bundle:nil];
    self.detail.selectedDateStr = self.selcetedDateStr;
    [self addChildViewController:self.detail];
    [self.detail didMoveToParentViewController:self];
    [self.bottomView addSubview:self.detail.view];
    
    //self.calendarView.delegate = self;
    // Do any additional setup after loading the view from its nib.
    
}

//点击导航栏右侧按钮方法
-(void)navigationRightAction:(UIButton *)sender
{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *slectedDate = [dateFormatter dateFromString:self.selcetedDateStr];

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
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
    NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
    if(ResultCode)
    {
        if([ResultCode integerValue]==0)
        {
            if([dic objectForKey:@"Data"])
            {
                self.delayTime = [[dic objectForKey:@"Data"] integerValue];

            }
            
        }
        else
        {
            [MBProgressHUD showError:@"获取延迟时间失败" toView:self.view];
            
        }
        
    }


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
//    NSString *str = [NSString stringWithFormat:@"%@",[[self.groupArr objectAtIndex:0]objectForKey:@"GroupName"]];
//    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@""];
////    [self.mNav_navgationBar setRightBtn:[UIImage imageNamed:@"appNav_contact"]];
//    [self.mNav_navgationBar setRightBtnTitle:@"填写"];
//
//    self.mNav_navgationBar.delegate = self;
//    [self.mNav_navgationBar leftBtnAction:str];
//    [self.view addSubview:self.mNav_navgationBar];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.calendar reloadData]; // （必须要在这里调用）Must be call in viewDidAppear
}


- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSLog(@"calendarHaveEventDate = %@" ,date);
    NSString *currentDateString = [dateFormatter stringFromDate:calendar.currentDate];
    if([dateString isEqualToString:currentDateString])
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd"];
        NSInteger dayInt;
        if([dateFormatter stringFromDate:date])
        {
            dayInt = [[dateFormatter stringFromDate:date]integerValue];
        }
        
        NSString *dayString = [NSString stringWithFormat:@"%ld",(long)dayInt];
        if([self.dateArr containsObject:dayString])
        {
            return 1;

        }

        
    }
    return 0;
}
//选择日期的方法
- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];

    NSString *destDateString = [dateFormatter stringFromDate:date];
    self.selcetedDateStr = destDateString;
    self.detail.selectedDateStr = destDateString;


    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//点击提交按钮所响应的方法
- (IBAction)submitAction:(id)sender
{    DetailQueryViewController *detail = [[DetailQueryViewController alloc]init];
    detail.selectedDateStr = self.selcetedDateStr;
    [self.navigationController pushViewController:detail animated:YES];



    
    
}
//点击请求所响应的方法
- (IBAction)queryAction:(id)sender {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *slectedDate = [dateFormatter dateFromString:self.selcetedDateStr];

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

-(void)myNavigationGoback
{
    [self.navigationController popViewControllerAnimated:NO];
}
- (IBAction)leftBtnAction:(id)sender {
    JTCalendar *jt_calendar = self.calendar;

    jt_calendar.contentView.contentOffset = CGPointMake(jt_calendar.contentView.contentOffset.x -jt_calendar.contentView.frame.size.width/2, jt_calendar.contentView.contentOffset.y);
    jt_calendar.menuMonthsView.contentOffset = CGPointMake(jt_calendar.contentView.contentOffset.x -jt_calendar.menuMonthsView.frame.size.width/2, jt_calendar.menuMonthsView.contentOffset.y);
    //[jt_calendar updatePage];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:-1];
    [adcomps setDay:0];
    self.currentDate = [calendar dateByAddingComponents:adcomps toDate:self.calendar.currentDate options:0];
    //[self.calendar setCurrentDate:nextDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSString *dateString = [dateFormatter stringFromDate:self.currentDate];
    [[SignInHttp getInstance]WorkPlanSelectContentByMonth:nil UserID:nil strSelectDate:dateString];

}

- (IBAction)rightBtnAction:(id)sender {
    JTCalendar *jt_calendar = self.calendar;
    jt_calendar.contentView.contentOffset = CGPointMake(jt_calendar.contentView.contentOffset.x +jt_calendar.contentView.frame.size.width/2, jt_calendar.contentView.contentOffset.y);
    jt_calendar.menuMonthsView.contentOffset = CGPointMake(jt_calendar.contentView.contentOffset.x +jt_calendar.menuMonthsView.frame.size.width/2, jt_calendar.menuMonthsView.contentOffset.y);
    //[jt_calendar updatePage];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:1];
    [adcomps setDay:0];
    self.currentDate = [calendar dateByAddingComponents:adcomps toDate:self.calendar.currentDate options:0];
    //[self.calendar setCurrentDate:nextDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSString *dateString = [dateFormatter stringFromDate:self.currentDate];
    [[SignInHttp getInstance]WorkPlanSelectContentByMonth:nil UserID:nil strSelectDate:dateString];

}

- (IBAction)minusYearAction:(id)sender {
    JTCalendar *jt_calendar = self.calendar;

    jt_calendar.contentView.contentOffset = CGPointMake(jt_calendar.contentView.contentOffset.x -jt_calendar.contentView.frame.size.width*6, jt_calendar.contentView.contentOffset.y);
    jt_calendar.menuMonthsView.contentOffset = CGPointMake(jt_calendar.contentView.contentOffset.x -jt_calendar.menuMonthsView.frame.size.width*6, jt_calendar.menuMonthsView.contentOffset.y);
    [jt_calendar updatePage];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:0];
    [adcomps setDay:0];
    self.currentDate = [calendar dateByAddingComponents:adcomps toDate:self.calendar.currentDate options:0];
    //[self.calendar setCurrentDate:nextDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSString *dateString = [dateFormatter stringFromDate:self.currentDate];
    [[SignInHttp getInstance].ASIFormDataRequest clearDelegatesAndCancel];
    [[SignInHttp getInstance]WorkPlanSelectContentByMonth:nil UserID:nil strSelectDate:dateString];
    self.strFlag = @"minusYear";

}

- (IBAction)addYearAction:(id)sender {
    JTCalendar *jt_calendar = self.calendar;

    jt_calendar.contentView.contentOffset = CGPointMake(jt_calendar.contentView.contentOffset.x +jt_calendar.contentView.frame.size.width*6, jt_calendar.contentView.contentOffset.y);
    jt_calendar.menuMonthsView.contentOffset = CGPointMake(jt_calendar.contentView.contentOffset.x +jt_calendar.menuMonthsView.frame.size.width*6, jt_calendar.menuMonthsView.contentOffset.y);
    [jt_calendar updatePage];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:0];
    [adcomps setDay:0];
    self.currentDate = [calendar dateByAddingComponents:adcomps toDate:self.calendar.currentDate options:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSString *dateString = [dateFormatter stringFromDate:self.currentDate];
    [[SignInHttp getInstance].ASIFormDataRequest clearDelegatesAndCancel];
    [[SignInHttp getInstance]WorkPlanSelectContentByMonth:nil UserID:nil strSelectDate:dateString];
    self.strFlag = @"addYear";

    //[self.calendar setCurrentDate:nextDate];

}


@end
