//
//  RecordViewController.m
//  JiaoBao
//
//  Created by songyanming on 15/3/20.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "RecordViewController.h"
#import "JTCalendar.h"
#import "SignInHttp.h"
#import "SVProgressHUD.h"
#import "RecordCell.h"

@interface RecordViewController ()<JTCalendarDataSource>
@property (weak, nonatomic) IBOutlet JTCalendarMenuView *menuView;
@property (nonatomic, weak) IBOutlet JTCalendarContentView *calendarView;
@property (strong, nonatomic) JTCalendar *calendar;
@property(nonatomic,strong)NSArray *datasource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSArray *dicArr;
@property(nonatomic,strong)NSMutableArray *selectedArrSymbol;


@end

@implementation RecordViewController
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.calendar reloadData];

    
     // （必须要在这里调用）Must be call in viewDidAppear
}
-(void)GetSignInList:(id)sender
{
    if(sender)
    {

    NSArray *arr = [sender object];
    
    NSMutableArray *mArr = [[NSMutableArray alloc]initWithCapacity:0];
    self.selectedArrSymbol = [[NSMutableArray alloc]initWithCapacity:0];
    for(int i=0;i<arr.count;i++)
    {
        NSDictionary *dic = [arr objectAtIndex:i];
        NSArray *array = [dic objectForKey:@"daylist"];
        
        
        if([array isEqual:[NSNull null]])
        {
            
            
        }
        else
        {
   
                NSDictionary *dictionary = [array objectAtIndex:0];
                NSString *year = [dictionary objectForKey:@"Year"];
                NSString *month = [dictionary objectForKey:@"Month"];
                NSString *day = [dictionary objectForKey:@"Day"];
                NSString *date = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
                [self.selectedArrSymbol addObject:date];
            
            [mArr addObject:array];
        }
        
    }
    self.datasource = mArr;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [NSDate date];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    if([self.selectedArrSymbol containsObject:destDateString])
    {
        NSUInteger index = [self.selectedArrSymbol indexOfObject:destDateString];
        self.dicArr = [self.datasource objectAtIndex:index];
    
    }
    else
    {
        self.dicArr = nil;
    }
    }

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetSignInList:) name:@"GetSignInList" object:nil];
    self.calendar = [JTCalendar new];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    
    NSString *destDateString = [dateFormatter stringFromDate:self.calendar.currentDate];
    NSArray *dateArr = [destDateString componentsSeparatedByString:@"-"];
    [[SignInHttp getInstance]GetSignInListForMobile:[dateArr objectAtIndex:0] Month:[dateArr objectAtIndex:1]];

    {
        self.calendar.calendarAppearance.calendar.firstWeekday = 2; // Sunday == 1, Saturday == 7
        self.calendar.calendarAppearance.dayCircleRatio = 9. / 10.;
        self.calendar.calendarAppearance.ratioContentMenu = 1.;
    }
    [self.calendar setMenuMonthsView:self.menuView];
    [self.calendar setContentView:self.calendarView];
    [self.calendar setDataSource:self];
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"签到记录"];

    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];

    // Do any additional setup after loading the view from its nib.
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
    if([self.selectedArrSymbol containsObject:destDateString])
    {
        NSUInteger arrIndex = [self.selectedArrSymbol indexOfObject:destDateString];
        self.dicArr = [self.datasource objectAtIndex:arrIndex];
        [self.tableView reloadData];
        
    }
    else{
        self.dicArr = nil;
        [self.tableView reloadData];

    }


    
    
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.dicArr.count>0)
    {
        return 1;
    }
    else
    {
        return 0;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dicArr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[[NSBundle mainBundle]loadNibNamed:@"sectionView" owner:self options:nil]objectAtIndex:0];
    return headerView;

}

- (void)configureCell:(RecordCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.dicArr objectAtIndex:indexPath.row];
    cell.dateTimeLabel.text = [dic objectForKey:@"SignInDateTime"];
    cell.TypeNameLabel.text = [dic objectForKey:@"SignInTypeName"];
    cell.signInFlagLabel.text = [dic objectForKey:@"SignInFlag"];
    cell.placeLabel.text = [dic objectForKey:@"Place"];

    
    
    
    
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             identifier];
    if(cell == nil)
    {
        NSArray *cellArr = [[NSBundle mainBundle]loadNibNamed:@"RecordCell" owner:self options:nil];
        cell = (RecordCell*)[cellArr objectAtIndex:0];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
    
}


-(void)myNavigationGoback
{
    
    [utils popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
