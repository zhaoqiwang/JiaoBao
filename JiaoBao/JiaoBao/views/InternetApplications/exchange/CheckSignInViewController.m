//
//  CheckSignInViewController.m
//  JiaoBao
//
//  Created by SongYanming on 2017/11/7.
//  Copyright © 2017年 JSY. All rights reserved.
//

#import "CheckSignInViewController.h"
#import "Reachability.h"
#import "MobClick.h"
#import "UIImageView+WebCache.h"
#import "CheckModel.h"

@interface CheckSignInViewController ()
@property(nonatomic,weak)UITextField *currTF;
@property(nonatomic,strong)NSString *rowCount;
@end

@implementation CheckSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //签到回调
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getMySingInfo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMySingInfo:) name:@"getMySingInfo" object:nil];
    // Do any additional setup after loading the view from its nib.
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"签到查询"];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    //选择日期
    self.beginDate.inputView = self.datePicker;
    self.endDate.inputView = self.datePicker;
    self.beginDate.inputAccessoryView = self.toolBar;
    self.endDate.inputAccessoryView = self.toolBar;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    self.beginDate.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]];
    self.endDate.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]];
    //添加表格的下拉刷新和上拉加载更多
    [self.mTableV_detailist addHeaderWithTarget:self action:@selector(headerRereshing)];
    self.mTableV_detailist.headerPullToRefreshText = @"下拉刷新";
    self.mTableV_detailist.headerReleaseToRefreshText = @"松开后刷新";
    self.mTableV_detailist.headerRefreshingText = @"正在刷新...";
    [self.mTableV_detailist addFooterWithTarget:self action:@selector(footerRereshing)];
    self.mTableV_detailist.footerPullToRefreshText = @"上拉加载更多";
    self.mTableV_detailist.footerReleaseToRefreshText = @"松开加载更多数据";
    self.mTableV_detailist.footerRefreshingText = @"正在加载...";
    self.mTableV_detailist.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.automaticallyAdjustsScrollViewInsets = false;
    //查询到的签到数组
    self.mArr_detail = [[NSMutableArray alloc] init];
    self.mInt_page = 1;//默认获取第一页
    self.mInt_refresh=2;
}

-(void)getMySingInfo:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSMutableDictionary *dic = noti.object;
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
    NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
    if ([ResultCode intValue] == 0) {
        if (self.mInt_refresh == 1) {//1是加载，2是刷新
            self.rowCount=[[[dic objectForKey:@"Data"]objectFromJSONString]objectForKey:@"rowCount"];
            NSArray *tempArr = [[[dic objectForKey:@"Data"]objectFromJSONString]objectForKey:@"infolist"];
            [self.mArr_detail addObjectsFromArray:tempArr];
            
            
        } else if (self.mInt_refresh == 2){//1是加载，2是刷新
            self.mInt_page = 1;
            self.rowCount=[[[dic objectForKey:@"Data"]objectFromJSONString]objectForKey:@"rowCount"];
            self.mArr_detail =[[[dic objectForKey:@"Data"]objectFromJSONString]objectForKey:@"infolist"];
            if(self.mArr_detail.count==0){
                [MBProgressHUD showError:@"没有签到记录" toView:self.view];
            }
        }
        [self.mTableV_detailist reloadData];
        [self.mTableV_detailist headerEndRefreshing];
        [self.mTableV_detailist footerEndRefreshing];
    } else {
        [MBProgressHUD showError:ResultDesc toView:self.view];
    }
}

//检查当前网络是否可用
-(BOOL)checkNetWork{
    if([Reachability isEnableNetwork]==NO){
        [MBProgressHUD showError:NETWORKENABLE toView:self.view];
        return YES;
    }else{
        return NO;
    }
}

//发送获取请求
-(void)firstSendHttp{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    [[SignInHttp getInstance] searchMySignInfoWithSDate:self.beginDate.text eDate:self.endDate.text num:20 pageNum:self.mInt_page rowCount:0];
    [MBProgressHUD showMessage:@"" toView:self.view];
    
    
}
//发送获取请求
-(void)sendhttpRequest{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    if (self.mInt_refresh == 2) {//1是加载，2是刷新
        self.mInt_page=1;
        [self firstSendHttp];
    } else if (self.mInt_refresh == 1){//1是加载，2是刷新
        if (self.mArr_detail.count>=20&&self.mArr_detail.count%20==0) {
            self.mInt_page++;
            [[SignInHttp getInstance] searchMySignInfoWithSDate:self.beginDate.text eDate:self.endDate.text num:20 pageNum:self.mInt_page rowCount:self.rowCount];
            [MBProgressHUD showMessage:@"" toView:self.view];
        } else {
            [self.mTableV_detailist footerEndRefreshing];
            [MBProgressHUD showError:@"没有更多了" toView:self.view];
        }
    }
}

//导航条返回按钮
-(void)myNavigationGoback{
    [utils popViewControllerAnimated:YES];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing{
    self.mInt_refresh = 2;
    self.mInt_page=1;
    [self sendhttpRequest];
}

- (void)footerRereshing{
    self.mInt_refresh = 1;
    [self sendhttpRequest];
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mArr_detail.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"CheckSignInCell";
    CheckSignInCell *cell = (CheckSignInCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[CheckSignInCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CheckSignInCell" owner:self options:nil];
        //这时myCell对象已经通过自定义xib文件生成了
        if ([nib count]>0) {
            cell = (CheckSignInCell *)[nib objectAtIndex:0];
            //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
        }
        //添加图片点击事件
        //若是需要重用，需要写上以下两句代码
        UINib * n= [UINib nibWithNibName:@"CheckSignInCell" bundle:[NSBundle mainBundle]];
        [self.mTableV_detailist registerNib:n forCellReuseIdentifier:indentifier];
    }
    NSDictionary *dic =[self.mArr_detail objectAtIndex:indexPath.row];
    cell.beginDateL.text = [[dic objectForKey:@"RecDate"]stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    cell.endDateL.text = [dic objectForKey:@"UserName"];
    cell.unitL.text = [dic objectForKey:@"UserShortName"];
    
    return cell;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    return 62.5;
}

//点击查询按钮
- (IBAction)checkAction:(id)sender {
    [self.currTF endEditing:YES];
    NSLog(@"发送请求");
    if([self.beginDate.text isEqualToString: @""]){
        [MBProgressHUD showError:@"请输入开始时间" toView:self.view];
        return;
    }
    if([self.endDate.text isEqualToString: @""]){
        [MBProgressHUD showError:@"请输入结束时间" toView:self.view];
        return;
    }
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *beginDate = [inputFormatter dateFromString:self.beginDate.text];

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    //实例化一个日期的对象,这个对象不是NSDate的是NSDateComponents的
    
    NSDateComponents *com = [[NSDateComponents alloc] init];
    
    //做一个标示，表示我们要什么内容
    
    NSInteger flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    //从一个日期里面把这些内容取出来
    
    com = [calendar components:flags fromDate:beginDate];
    NSInteger beginyear = [com year];
    NSInteger beginmonth = [com month];
    NSInteger beginday = [com day];
    
    //从一个日期里面把这些内容取出来
     NSDate *endDate = [inputFormatter dateFromString:self.endDate.text];
    com = [calendar components:flags fromDate:endDate];
    NSInteger endyear = [com year];
    NSInteger endmonth = [com month];
    NSInteger endday = [com day];
    if(beginyear==endyear&&beginmonth==endmonth&&beginday<=endday){
        
    }else{
        [MBProgressHUD showError:@"查询开始和结束时间要求在同一个月份!" toView:self.view];
        return;
        
    }

    self.mInt_refresh = 2;
    self.mInt_page=1;
    [self sendhttpRequest];
    
}
//开始编辑输入框
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.currTF = textField;
    return YES;
}
//点击取消
- (IBAction)cancelAction:(id)sender {
    [self.currTF endEditing: YES];
}
//点击完成
- (IBAction)doneAction:(id)sender {
    [self.currTF endEditing: YES];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    self.currTF.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:self.datePicker.date]];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
