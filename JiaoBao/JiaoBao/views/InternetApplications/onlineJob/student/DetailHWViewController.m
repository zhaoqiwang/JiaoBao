//
//  DetailHWViewController.m
//  JiaoBao
//
//  Created by songyanming on 15/10/29.
//  Copyright © 2015年 JSY. All rights reserved.
//

#import "DetailHWViewController.h"
#import "utils.h"
#import "OnlineJobHttp.h"
#import "DetialHWCell.h"
#import "StuHomeWorkModel.h"
#import "StuHWQsModel.h"
#import "TableViewWithBlock.h"
#import "SelectionCell.h"
#import "IQKeyboardManager.h"
#import "StuSubModel.h"
#import <JavaScriptCore/JavaScriptCore.h>


@interface DetailHWViewController ()<UIAlertViewDelegate>
@property(nonatomic,strong)NSMutableArray *subArr;//提交的题目
@property(nonatomic,strong)NSMutableArray *errQuestionArr;//做错的题目 0:没做的 1:正确 2：错误
@property(nonatomic,assign)NSUInteger selectedBtnTag;//标志选择的第几题
@property(nonatomic,strong)StuHomeWorkModel *stuHomeWorkModel;//学生当前作业信息model
@property(nonatomic,strong)StuHWQsModel *stuHWQsModel;//某作业下某题的作业题及答案model
@property(nonatomic,strong)NSMutableArray *datasource;//collectionview数据源
@property(nonatomic,strong)TableViewWithBlock *mTableV_name;//显示题数范围
@property(nonatomic,assign)BOOL isOpen;//是否展开
@property(nonatomic,strong)NSTimer *timer;//计时器
@property(nonatomic,strong)NSString* serverDate;
@property(nonatomic,assign)BOOL isOverTime;
@end

@implementation DetailHWViewController
//动态改变collectionview高度
-(void)updateViewConstraints
{
    [super updateViewConstraints];
    if(self.collectionView.contentSize.height>136)
    {
        self.height.constant = 136;
    }
    else
    {
        self.height.constant = self.collectionView.contentSize.height;

    }

}

//获取作业信息
-(void)GetStuHWWithHwInfoId:(id)sender
{
    self.stuHomeWorkModel = [sender object];
    if([self.stuHomeWorkModel.HWStartTime isEqualToString:@"1970-01-01 00:00:00"]){//第一次进入做作业界面
        self.clockLabel.text = [NSString stringWithFormat:@"%@:%@",self.stuHomeWorkModel.LongTime,@"00"];
        self.countdownLabel.text = @"倒计时:";
    }
    self.questionNumLabel.text = [NSString stringWithFormat:@"共%@题",self.stuHomeWorkModel.Qsc];
    NSArray *arr = [self.stuHomeWorkModel.QsIdQId componentsSeparatedByString:@"|"];
    for(int i=0;i<arr.count;i++)
    {
        NSString *QsIdQIdStr = [arr objectAtIndex:i];
        NSArray *QsIdQIdArr = [QsIdQIdStr componentsSeparatedByString:@"_"];
        NSString *QsIdQId,*QsIdQId2,*QsIdQId3;
        if(QsIdQIdArr.count>3)
        {
            QsIdQId = [QsIdQIdArr objectAtIndex:0];
            QsIdQId2 = [QsIdQIdArr objectAtIndex:2];
            QsIdQId3 = [QsIdQIdArr objectAtIndex:3];
            [self.datasource addObject:QsIdQId];
            [self.subArr addObject:QsIdQId2];
            [self.errQuestionArr addObject:QsIdQId3];
        }
        
    }
    if(self.datasource.count<20)
    {
        [self.qNum setTitle:[NSString stringWithFormat:@"1-%ld",self.datasource.count] forState:UIControlStateNormal];
    }
    NSIndexPath *index = [NSIndexPath indexPathForItem:0 inSection:0];
    [self.collectionView reloadData];
    [self.collectionView selectItemAtIndexPath:index animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    if(self.datasource.count == 1)//如果只用一道题
    {
        if([self.FlagStr isEqualToString:@"1"]){
            if(self.isSubmit == YES){
                [self.nextBtn setTitle:@"提交" forState:UIControlStateNormal];
                self.nextBtn.enabled = NO;

            }else{
                [self.nextBtn setTitle:@"提交" forState:UIControlStateNormal];
                self.nextBtn.enabled = YES;
            }
   
        }
        else{
            [self.nextBtn setTitle:@"提交" forState:UIControlStateNormal];
            self.nextBtn.enabled = NO;

        }
    }
    __weak DetailHWViewController *weakSelf = self;

    self.mTableV_name = [[TableViewWithBlock alloc]initWithFrame:CGRectMake(self.qNum.frame.origin.x, self.qNum.frame.origin.y+self.qNum.frame.size.height, self.qNum.frame.size.width, 0)] ;
    [self.mTableV_name initTableViewDataSourceAndDelegate:^NSInteger(UITableView *tableView,NSInteger section){
        NSInteger count = [weakSelf.stuHomeWorkModel.Qsc integerValue];
        NSInteger cellCount = count/20;
        NSInteger cellCount2 = count%20;
        if(cellCount2==0)
        {
            cellCount = count/20;
        }
        else
        {
            cellCount = count/20+1;
        }
        return cellCount;
    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SelectionCell"];
            cell.frame = CGRectMake(0, 0, weakSelf.qNum.frame.size.width, 25);
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
        }
        if((indexPath.row+1)*20<[weakSelf.stuHomeWorkModel.Qsc integerValue])
        {
            cell.textLabel.text = [NSString stringWithFormat:@"%ld-%ld",indexPath.row*20+1,(indexPath.row+1)*20];

        }
        else
        {
            cell.textLabel.text = [NSString stringWithFormat:@"%ld-%ld",indexPath.row*20+1,[weakSelf.stuHomeWorkModel.Qsc integerValue]];
        }
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        [UIView animateWithDuration:0.3 animations:^{
            SelectionCell *cell = (SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
            weakSelf.mTableV_name.frame =  CGRectMake(weakSelf.qNum.frame.origin.x, weakSelf.qNum.frame.origin.y+weakSelf.qNum.frame.size.height, weakSelf.qNum.frame.size.width, 0);
            [weakSelf.qNum setTitle:cell.textLabel.text forState:UIControlStateNormal];
            weakSelf.isOpen = NO;
            NSIndexPath *index_path = [NSIndexPath indexPathForItem:indexPath.row*20 inSection:0];
            [weakSelf.collectionView reloadData];
            [weakSelf.collectionView selectItemAtIndexPath:index_path animated:YES scrollPosition:UICollectionViewScrollPositionTop];
                [[OnlineJobHttp getInstance]GetStuHWQsWithHwInfoId:weakSelf.stuHomeWorkModel.hwinfoid QsId:[weakSelf.datasource objectAtIndex:index_path.row]];
            if(indexPath.row==0){
                weakSelf.previousBtn.enabled = NO;
                weakSelf.nextBtn.enabled = YES;
            }
            else{
                weakSelf.previousBtn.enabled = YES;
            }
            weakSelf.selectedBtnTag = index_path.row;
            if(weakSelf.selectedBtnTag+1 == [weakSelf.stuHomeWorkModel.Qsc integerValue]){
                if(weakSelf.isSubmit == YES){
                    weakSelf.nextBtn.enabled = NO;
                }else{
                    weakSelf.nextBtn.enabled = YES;
                    
                }
                [weakSelf.nextBtn setTitle:@"提交" forState:UIControlStateNormal];
            }else{
                [weakSelf.nextBtn setTitle:@"下一题" forState:UIControlStateNormal];
                weakSelf.nextBtn.enabled = YES;

            }

        } completion:^(BOOL finished){

        }];
    }];
    [self.mTableV_name.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.mTableV_name.layer setBorderWidth:1];
    [self.view addSubview:self.mTableV_name];
    D("0----=-======%@,%lu",self.stuHomeWorkModel.hwinfoid,(unsigned long)self.datasource.count);
    [[OnlineJobHttp getInstance]GetStuHWQsWithHwInfoId:self.stuHomeWorkModel.hwinfoid QsId:[self.datasource objectAtIndex:0]];//获取第一题
    [MBProgressHUD showMessage:@"" toView:self.view];

}
//获取第几题的作业详情
-(void)GetStuHWQsWithHwInfoId:(id)sender
{

        
    self.stuHWQsModel = [sender object];
    

    NSString *webHtml;
    if(self.isSubmit == 1)//如果作业已经提交
    {
        if([self.stuHWQsModel.QsAns isEqualToString:self.stuHWQsModel.QsCorectAnswer])//如果答案正确
        {
            webHtml = [self.stuHWQsModel.QsCon stringByAppendingString:[NSString stringWithFormat:@"<p >作答：<span style=\"color:green\">%@</span><br />正确答案：%@<br />%@</p>",self.stuHWQsModel.QsAns,self.stuHWQsModel.QsCorectAnswer,self.stuHWQsModel.QsExplain]];
            
        }
        else//答案错误
        {
            webHtml = [self.stuHWQsModel.QsCon stringByAppendingString:[NSString stringWithFormat:@"<p >作答：<span style=\"color:red \">%@</span><br />正确答案：%@<br />%@</p>",self.stuHWQsModel.QsAns,self.stuHWQsModel.QsCorectAnswer,self.stuHWQsModel.QsExplain]];
        }

    }
    else//作业未提交不显示答案解析
    {
        webHtml = self.stuHWQsModel.QsCon;
    }
    if([webHtml isEqual:[NSNull null]])//如果获取的题目的内容是空
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.webView loadHTMLString:@"" baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
    }

    else
    {
        [self.webView loadHTMLString:webHtml baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];

    }

}
//提交题目
-(void)StuSubQsWithHwInfoId:(id)sender
{
    StuSubModel *model = [sender object];
    if(model == nil){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"提交失败" ];
        return;

    }
    if([model.reNum integerValue] == 0)//提交作业
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //[[OnlineJobHttp getInstance] GetStuHWWithHwInfoId:self.TabID];

//        NSString *strHtml = [model.HWHTML stringByAppendingString:@"<br /><button type='button' onclick ='buttonClick'>继续</button><script>function buttonClick(){alert(\"事件\");}</script>"];
        if([self.navBarName isEqualToString:@"做作业"])//获取作业成绩
        {
            self.clockLabel.text = @"已提交";
            [self.timer invalidate];
            self.timer = nil;
            NSString *html = [model.HWHTML stringByAppendingString:@"<HTML><br /><br /><div div style=\"TEXT-ALIGN: center\"><script>function clicke(){}</script><input type=\"button\" onClick=\"clicke()\" style = \"font-size:12px\" value=\"继续做作业\"/></div></HTML>"];
            [self.webView loadHTMLString:html baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
        }
        else//获取练习成绩
        {
            self.clockLabel.text = @"已提交";
            [self.timer invalidate];
            self.timer = nil;
            NSString *html = [model.HWHTML stringByAppendingString:@"<p><span style = \"color:rgb(235,115,80); font-size:11px \">选择继续练习，将无法通过手机端再次查看本次的错题，请登录电脑端查看。</span></p><div div style=\"TEXT-ALIGN: center\"><script>function clicke(){}</script><input type=\"button\" onClick=\"clicke()\" style = \"font-size:12px\" value=\"继续做练习\"/></div>"];
            [self.webView loadHTMLString:html baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
        }
        self.isSubmit = YES;//设置成已提交
        self.previousBtn.enabled = NO;
        self.nextBtn.enabled = NO;
        //[[NSNotificationCenter defaultCenter]postNotificationName:@"updateUI" object:nil];
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提交成功" message:@"本次作业得分： 100\r\n本次作业学力：10\r\n所有科目平均学历值：500\r\n" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alertView show];
//            NSString *lJs = @"document.documentElement.innerHTML";
//            NSString *html = [self.webView stringByEvaluatingJavaScriptFromString:lJs];
//            NSLog(@"html = %@",html);
        //[MBProgressHUD showSuccess:@"提交作业成功" toView:self.view];
    }

}
- (void)willPresentAlertView:(UIAlertView *)alertView {
    
    UIView *myView = [[UIView alloc] init];
    myView.backgroundColor = [UIColor redColor];
    [alertView addSubview:myView];
}
//计时器方法
-(void)timerAction{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startDate = [dateFormatter dateFromString:self.stuHomeWorkModel.HWStartTime];
    NSDate *serverDate = [dateFormatter  dateFromString:self.serverDate];

    NSCalendar* chineseClendar = [ [ NSCalendar alloc ] initWithCalendarIdentifier:NSGregorianCalendar ];
    NSUInteger unitFlags =
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    if(self.isOverTime ==NO){
        NSDateComponents *cps = [chineseClendar components:unitFlags fromDate:serverDate  toDate:startDate  options:0];
        NSInteger diffMin    = [cps minute];
        NSInteger diffSec   = [cps second];
        diffMin = [self.stuHomeWorkModel.LongTime integerValue]-1+diffMin;

        diffSec = 60+diffSec;
        if(diffSec==60)
        {
            diffMin = diffMin+1;
            diffSec = 0;
        }
        if(diffMin == 0&&diffSec == 0){
            self.isOverTime = YES;
            //        self.clockLabel.text  = @"已超时";
            //        [self.timer invalidate];
            //        self.timer = nil;
        }
        self.clockLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",(long)diffMin,(long)diffSec];
        self.serverDate = [dateFormatter stringFromDate:[ NSDate dateWithTimeInterval:1 sinceDate:serverDate]];
        
    }
    else{
        NSDateComponents *cps = [chineseClendar components:unitFlags fromDate:startDate  toDate:serverDate  options:0];
        NSInteger diffDay = [cps day];
        NSInteger diffHour = [cps hour];
        NSInteger diffMin    = [cps minute];
        NSInteger diffSec   = [cps second];
        diffMin = diffMin+diffHour*60+diffDay*24*60-[self.stuHomeWorkModel.LongTime integerValue];
//        if(diffMin==0){
//            self.isOverTime = YES;
//            //        self.clockLabel.text  = @"已超时";
//            //        [self.timer invalidate];
//            //        self.timer = nil;
//            return;
//        }
        //diffSec = 60+diffSec;
        if(diffSec==60)
        {
            diffMin = diffMin+1;
            diffSec = 0;
        }
        self.countdownLabel.text = @"已超时:";
        self.clockLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",(long)diffMin,(long)diffSec];
        self.serverDate = [dateFormatter stringFromDate:[ NSDate dateWithTimeInterval:1 sinceDate:serverDate]];
        
    }

}
-(void)dealloc
{
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.timer invalidate];
    self.timer = nil;
}
-(void)GetSQLDateTime:(id)sender{
    NSString *serverDate = [sender object];
    self.serverDate = serverDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *currentDate = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: currentDate];
    NSDate *startDate = [dateFormatter dateFromString:self.stuHomeWorkModel.HWStartTime];
    NSDate *localeStartDate = [startDate  dateByAddingTimeInterval: interval];
    NSDate *serverTime = [dateFormatter dateFromString:serverDate ];

        
        NSCalendar* chineseClendar = [ [ NSCalendar alloc ] initWithCalendarIdentifier:NSGregorianCalendar ];
        NSUInteger unitFlags =
        NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
        NSDateComponents *cps = [chineseClendar components:unitFlags fromDate:startDate  toDate:serverTime  options:0];
    NSInteger diffDay = [cps day];
        NSInteger diffHour = [cps hour];
        NSInteger diffMin    = [cps minute];
        if((diffMin+diffHour*60+diffDay*24*60)>=[self.stuHomeWorkModel.LongTime integerValue]){//超过规定时间（如30min）显示已超时
            self.countdownLabel.text = @"已超时:";
            
            NSDateComponents *cps2 = [chineseClendar components:unitFlags fromDate:startDate  toDate:serverTime  options:0];
            NSInteger diffHour = [cps2 hour];
            NSInteger diffMin    = [cps2 minute];
            NSInteger diffSec   = [cps2 second];
            diffMin = diffMin+diffHour*60-[self.stuHomeWorkModel.LongTime integerValue];

            if(diffSec==60)
            {
                diffMin = diffMin+1;
                diffSec = 0;
            }
            self.clockLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",(long)diffMin,(long)diffSec];
            self.isOverTime = YES;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
            [self.timer fire];
            
        }
        else{
            NSDateComponents *cps = [chineseClendar components:unitFlags fromDate:serverTime  toDate:startDate  options:0];
            NSInteger diffMin    = [cps minute];
            NSInteger diffSec   = [cps second];
            diffMin = [self.stuHomeWorkModel.LongTime integerValue]-1+diffMin;
            diffSec = 60+diffSec;
            if(diffSec==60)
            {
                diffSec = 0;
            }
            if(!self.timer)
            {
                if(diffMin == [self.stuHomeWorkModel.LongTime integerValue]){
                    self.clockLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",(long)diffMin+1,(long)diffSec];
                    
                }else{
                    self.clockLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",(long)diffMin,(long)diffSec];
                    
                }
                sleep(0.5);
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
                [self.timer fire];
                self.countdownLabel.text = @"倒计时:";

                
            }
            
        }
        
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.subArr = [[NSMutableArray alloc]initWithCapacity:0];
    self.errQuestionArr = [[NSMutableArray alloc]initWithCapacity:0];
    //self.webView.scrollView.scrollEnabled = NO;
    if(self.isSubmit == YES)
    {
//        self.previousBtn.enabled = NO;
//        self.nextBtn.enabled = NO;
//        self.webView.userInteractionEnabled = NO;
//        self.webView.scrollView.scrollEnabled = YES;
    }
    //self.webView.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag; // 当拖动时移除键盘
    self.qNum.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.qNum.layer.borderWidth = 1;
    self.qNum.layer.cornerRadius = 0.2;
    self.datasource = [[NSMutableArray alloc]initWithCapacity:0];
    //键盘事件
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
    //获取服务器时间
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetSQLDateTime:) name:@"GetSQLDateTime" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(StuSubQsWithHwInfoId:) name:@"StuSubQsWithHwInfoId" object:nil];

    //获取作业信息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetStuHWWithHwInfoId:) name:@"GetStuHWWithHwInfoId" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetStuHWQsWithHwInfoId:) name:@"GetStuHWQsWithHwInfoId" object:nil];
    //输入框弹出键盘问题
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;//控制整个功能是否启用
    manager.shouldResignOnTouchOutside = YES;//控制点击背景是否收起键盘
    manager.shouldToolbarUsesTextFieldTintColor = YES;//控制键盘上的工具条文字颜色是否用户自定义
    manager.enableAutoToolbar = NO;//控制是否显示键盘上的工具条
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:self.navBarName];
    self.hwNameLabel.text = self.hwName;
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    [[OnlineJobHttp getInstance] GetStuHWWithHwInfoId:self.TabID];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"DetialHWCell" bundle:nil]forCellWithReuseIdentifier:@"DetailHWCell"];
    // Do any additional setup after loading the view from its nib.
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self updateViewConstraints];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if([self.stuHWQsModel.QsT isEqualToString:@"1"])
    {
        NSString *inputNum = [NSString stringWithFormat:@"document.getElementsByTagName('input').length"];
        NSUInteger inputCount = [[self.webView stringByEvaluatingJavaScriptFromString:inputNum]integerValue];
        for(int i=0;i<inputCount;i++)
        {
            if(self.isSubmit == YES)//如果作业已经完成
            {
                NSString *type = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].type",i];
                NSString *valueStr = [self.webView stringByEvaluatingJavaScriptFromString:type];
                if([valueStr isEqualToString:@"radio"])
                {
                    NSString *checkStr = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].disabled = true",i];
                    [self.webView stringByEvaluatingJavaScriptFromString:checkStr];
                }

            }

            else//如果作业没有完成
            {
                if([self.FlagStr isEqualToString:@"2"])
                {
                    NSString *checkStr = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].disabled = true",i];
                    [self.webView stringByEvaluatingJavaScriptFromString:checkStr];
                }

            }
            NSString *value = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].value",i];
            NSString *valueStr = [self.webView stringByEvaluatingJavaScriptFromString:value];

            if([valueStr isEqualToString:self.stuHWQsModel.QsAns])//如果radio的值等于正确答案
            {
                NSString *checkStr = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].checked = true",i];
                if([self.FlagStr isEqualToString:@"1"])//如果当前界面是学生界面
                {
                    if(self.isSubmit == YES)//学生界面且作业已经提交
                    {
                        NSString *disabled = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].disabled = true",i];
                        [self.webView stringByEvaluatingJavaScriptFromString:disabled];
                        [self.webView stringByEvaluatingJavaScriptFromString:checkStr];

                    }
                    
                    else//学生界面且作业没有提交
                    {
                        [self.webView stringByEvaluatingJavaScriptFromString:checkStr];

                    }
                }
                else
                {
                    if(self.isSubmit == YES)//家长界面且作业已经提交
                    {
                        NSString *disabled = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].disabled = true",i];
                        [self.webView stringByEvaluatingJavaScriptFromString:disabled];
                        [self.webView stringByEvaluatingJavaScriptFromString:checkStr];


                    }
                    else//家长界面且作业没有提交
                    {
                        NSString *disabled = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].disabled = true",i];
                        [self.webView stringByEvaluatingJavaScriptFromString:disabled];
                    }
                }
            }
        
    }
    }
    else if ([self.stuHWQsModel.QsT isEqualToString:@"2"])
    {
        NSArray *textArr;
        NSLog(@"dfrnflre;gm;r = %@",self.stuHWQsModel.QsAns);
        if([self.stuHWQsModel.QsAns isEqual:[NSNull null]])
        {
            NSString *inputNum = [NSString stringWithFormat:@"document.getElementsByTagName('input').length"];
            NSUInteger inputCount = [[self.webView stringByEvaluatingJavaScriptFromString:inputNum]integerValue];
            for(int i=0;i<inputCount;i++)
            {
                NSString *type = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].type",i];
                NSString *typeStr = [self.webView stringByEvaluatingJavaScriptFromString:type];
                if(![typeStr isEqualToString:@"text"])
                {
                    continue;
                }
                if([typeStr isEqualToString:@"text"])
                {
                    if([self.FlagStr isEqualToString:@"1"])
                    {
                        if(self.isSubmit == YES)
                        {
                            NSString *disabled = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].disabled = true",i];
                            [self.webView stringByEvaluatingJavaScriptFromString:disabled];
                            
                        }
                        else
                        {
                            
                        }
                    }
                    else
                    {
                            NSString *disabled = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].disabled = true",i];
                            [self.webView stringByEvaluatingJavaScriptFromString:disabled];
                    }
                }
            }
        }
        else
        {
            textArr = [self.stuHWQsModel.QsAns componentsSeparatedByString:@"," ];
            NSLog(@"textArr_num = %@",[textArr objectAtIndex:textArr.count-1]);
            NSString *inputNum = [NSString stringWithFormat:@"document.getElementsByTagName('input').length"];
            NSUInteger inputCount = [[self.webView stringByEvaluatingJavaScriptFromString:inputNum]integerValue];
            BOOL isText = NO;
            for(int i=0;i<inputCount;i++)
            {
                
                NSString *type = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].type",i];
                NSString *typeStr = [self.webView stringByEvaluatingJavaScriptFromString:type];
                if(![typeStr isEqualToString:@"text"])
                {
                    continue;
                }
                if([typeStr isEqualToString:@"text"])
                {
                    if(i==0){
                        isText = YES;
                    }
                    NSString *checkStr;
                    if(i<=textArr.count)
                    {
                        if(isText == YES){
                            checkStr = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].value = '%@'",i,[textArr objectAtIndex:i]];
                            
                        }else{
                            checkStr = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].value = '%@'",i,[textArr objectAtIndex:i-1]];
                            
                        }

                    }
                    else
                    {
                        checkStr = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].value = '%@'",i,@""];
                    }
                    
                    NSLog(@"checkStr = %@",checkStr);
                    if([self.FlagStr isEqualToString:@"1"])
                    {
                        if(self.isSubmit == YES)
                        {
                            NSString *disabled = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].disabled = true",i];
                            [self.webView stringByEvaluatingJavaScriptFromString:disabled];
                            [self.webView stringByEvaluatingJavaScriptFromString:checkStr];
                            
                        }
                        
                        else
                        {
                            [self.webView stringByEvaluatingJavaScriptFromString:checkStr];
                            
                        }
                    }
                    else
                    {
                        if(self.isSubmit == YES)
                        {
                            NSString *disabled = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].disabled = true",i];
                            [self.webView stringByEvaluatingJavaScriptFromString:disabled];
                            [self.webView stringByEvaluatingJavaScriptFromString:checkStr];
                            
                        }
                        
                        else
                        {
                            NSString *disabled = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].disabled = true",i];
                            [self.webView stringByEvaluatingJavaScriptFromString:disabled];
                        }
                        
                        
                    }
                    
                    
                }
                
            }
        }
        
    }
    //倒计时
    if(self.isSubmit == NO){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *currentDate = [NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate: currentDate];
        NSDate *localeCurrentDate = [currentDate  dateByAddingTimeInterval: interval];
        if([self.FlagStr isEqualToString:@"1"]){
            if([self.navBarName isEqualToString:@"做练习"]){
            }else{
                if([self.stuHomeWorkModel.HWStartTime isEqualToString:@"1970-01-01 00:00:00"]){//第一次进入做作业界面
                    self.clockLabel.text = [NSString stringWithFormat:@"%@:%@",self.stuHomeWorkModel.LongTime,@"00"];
                    self.stuHomeWorkModel.HWStartTime = [dateFormatter stringFromDate:currentDate];
                    if(!self.timer)
                    {
                        self.serverDate = self.stuHomeWorkModel.HWStartTime;
                        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
                        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
                        
                        
                    }
                    
                }else{//再次进入做作业界面 从服务器获取开始时间
                    
                    if(!self.serverDate){
                        [[OnlineJobHttp getInstance]GetSQLDateTime];
                    }
                }
            }

        }
 
        
    }
    else//已经提交的作业不显示倒计时
    {
        self.clockLabel.hidden = YES;
        self.countdownLabel.hidden = YES;
    }

    [MBProgressHUD hideHUDForView:self.view animated:YES];

    JSContext *content = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    __weak DetailHWViewController *weakSelf = self;

    content[@"clicke"] = ^() {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更UI
             [weakSelf.navigationController popViewControllerAnimated:YES];
        });
        
    };

    
}
#pragma mark - Collection View Data Source
//每一组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section{

    return self.datasource.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//定义并返回每个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DetialHWCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DetailHWCell" forIndexPath:indexPath];
    cell.numLabel.text = [NSString stringWithFormat:@"%ld",(long)(indexPath.row+1)];
    if([self.FlagStr integerValue]==1){
        if(self.isSubmit == 0&&[[self.errQuestionArr objectAtIndex:indexPath.row]integerValue]!=0)
        {
            cell.numLabel.backgroundColor = [UIColor colorWithRed:164/255.0 green:234/255.0 blue:183/255.0 alpha:1];
            
        }
        else if (self.isSubmit == 0&&[[self.errQuestionArr objectAtIndex:indexPath.row]integerValue]== 0)
        {
             cell.numLabel.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        }
        
        else if(self.isSubmit == 1&&[[self.errQuestionArr objectAtIndex:indexPath.row]integerValue]==2)
        {
            cell.numLabel.textColor = [UIColor blackColor];
            cell.numLabel.backgroundColor = [UIColor redColor];
        }
        
        else if (self.isSubmit == 1&&[[self.errQuestionArr objectAtIndex:indexPath.row]integerValue]==0)
        {
            //cell.numLabel.textColor = [UIColor redColor];
            //cell.numLabel.backgroundColor = [UIColor colorWithRed:164/255.0 green:234/255.0 blue:183/255.0 alpha:1];
            cell.numLabel.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];

        }
        else
        {
          cell.numLabel.backgroundColor = [UIColor colorWithRed:164/255.0 green:234/255.0 blue:183/255.0 alpha:1];      }
        }
    
    else
    {
        if(self.isSubmit == 1&&[[self.errQuestionArr objectAtIndex:indexPath.row]integerValue]==2)
        {
           cell.numLabel.textColor = [UIColor blackColor];
          cell.numLabel.backgroundColor = [UIColor redColor];

           //cell.numLabel.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        }
        
        else if (self.isSubmit == 1&&[[self.errQuestionArr objectAtIndex:indexPath.row]integerValue]==0)
        {
             cell.numLabel.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
            //cell.numLabel.backgroundColor = [UIColor colorWithRed:164/255.0 green:234/255.0 blue:183/255.0 alpha:1];
        }
        
        else
        {
            cell.numLabel.backgroundColor = [UIColor colorWithRed:164/255.0 green:234/255.0 blue:183/255.0 alpha:1];

           //cell.numLabel.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        }
    }

    if(cell.selected == YES)
    {
            cell.numLabel.textColor = [UIColor whiteColor];
            cell.numLabel.backgroundColor = [UIColor colorWithRed:11.0/255 green:169.0/255 blue:53.0/255 alpha:1];

    }
    
    else
    {
        if(self.isSubmit == 1&&[[self.errQuestionArr objectAtIndex:indexPath.row]integerValue]==2)
        {
            cell.numLabel.textColor = [UIColor blackColor];
        }
        
        else
        {
            cell.numLabel.textColor = [UIColor blackColor];
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    if(indexPath.row == 0)
    {
        self.previousBtn.enabled = NO;
    }
    else
    {
        self.previousBtn.enabled = YES;
    }
//    if(self.isSubmit ==  YES)
//    {
//        self.previousBtn.enabled = NO;
//        self.nextBtn.enabled = NO;
//    }
    if(indexPath.row+1 == [self.stuHomeWorkModel.Qsc integerValue])
    {
        if(self.isSubmit == YES)
        {
            [self.nextBtn setTitle:@"提交" forState:UIControlStateNormal];
            self.nextBtn.enabled = NO;

        }
        else
        {
            if([self.FlagStr isEqualToString:@"1"]){
                [self.nextBtn setTitle:@"提交" forState:UIControlStateNormal];
                self.nextBtn.enabled = YES;
   
            }
            else{
                [self.nextBtn setTitle:@"提交" forState:UIControlStateNormal];
                self.nextBtn.enabled = NO;
            }
        }
        
    }
    else
    {
        [self.nextBtn setTitle:@"下一题" forState:UIControlStateNormal];
        self.nextBtn.enabled = YES;
    }
    if(self.datasource.count>self.selectedBtnTag)//最后一题要做判断
    {
        if([self.stuHWQsModel.QsT isEqualToString:@"1"])
        {
            BOOL isFinish = false;
            NSString *inputNum = [NSString stringWithFormat:@"document.getElementsByTagName('input').length"];
            NSUInteger inputCount = [[self.webView stringByEvaluatingJavaScriptFromString:inputNum]integerValue];
            for(int i=0;i<inputCount;i++)
            {
                NSString *type = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].type",i];
                NSString *typeStr = [self.webView stringByEvaluatingJavaScriptFromString:type];
                if(![typeStr isEqualToString:@"radio"])
                {
                    continue;
                }
                NSString *checkStr = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].checked",i];
                
                //            NSString *checkStr = [NSString stringWithFormat:@"document.getElementsByName('TopicRadio')[%d].checked",i];
                NSString *isChecked = [self.webView stringByEvaluatingJavaScriptFromString:checkStr];
                NSLog(@"isChecked = %@",isChecked);
                if([isChecked isEqualToString:@"true"])
                {

                    NSString *value = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].value",i];
                    NSString *answer = [self.webView stringByEvaluatingJavaScriptFromString:value];
                    if(self.isSubmit == NO)
                    {
                        if(self.datasource.count-1==self.selectedBtnTag)
                        {
                            
                        }
                        else
                        {
                            
                            [[OnlineJobHttp getInstance]StuSubQsWithHwInfoId:self.stuHomeWorkModel.hwinfoid QsId:[self.datasource objectAtIndex:self.selectedBtnTag] Answer:answer];
                            [self.errQuestionArr replaceObjectAtIndex:self.selectedBtnTag withObject:@"1"];
                            //[self.collectionView reloadData];
                        }
 
                    }

                    isFinish = YES;
                    
                }
                
                
            }

            
        }
        else
        {
            BOOL isFinish = false;
            NSString *inputNum = [NSString stringWithFormat:@"document.getElementsByTagName('input').length"];
            NSUInteger inputCount = [[self.webView stringByEvaluatingJavaScriptFromString:inputNum]integerValue];
            NSString *answer = @"";
            for(int i=0;i<inputCount;i++)
            {
                NSString *checkStr = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].value",i];
                NSString *value = [self.webView stringByEvaluatingJavaScriptFromString:checkStr];
                value = [value stringByReplacingOccurrencesOfString:@"," withString:@" "];
                value = [value stringByReplacingOccurrencesOfString:@"'" withString:@"’"];
                NSString *type = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].type",i];
                NSString *typeStr = [self.webView stringByEvaluatingJavaScriptFromString:type];
                if(![typeStr isEqualToString:@"text"])
                {
                    continue;
                }
                NSString *content;
                if(i == inputCount-1)
                {
                    content = [value stringByAppendingString:@""];
                }
                else
                {
                    content = [value stringByAppendingString:@","];
                    
                }
                NSLog(@"content = %@",content);
                if(i>=0&&i<inputCount-1)
                {
                    if([content isEqualToString:@","]== NO)
                    {
                        isFinish = YES;
                    }
                    answer =[answer stringByAppendingString:content];
                    
                }
                else if (i==inputCount-1)
                {
                    if([content isEqualToString:@""]== NO)
                    {
                        isFinish = YES;
                    }
                    answer =[answer stringByAppendingString:content];
                }
                
            }
            if(isFinish == false)
            {

            }
            else
            {
                if(self.datasource.count-1==self.selectedBtnTag)
                {
//                    [[OnlineJobHttp getInstance]StuSubQsWithHwInfoId:self.stuHomeWorkModel.hwinfoid QsId:[self.datasource objectAtIndex:self.selectedBtnTag] Answer:answer];
                }
                
                else
                {
                    if(self.isSubmit == NO)
                    {

                        [[OnlineJobHttp getInstance]StuSubQsWithHwInfoId:self.stuHomeWorkModel.hwinfoid QsId:[self.datasource objectAtIndex:self.selectedBtnTag] Answer:answer];
                        [self.errQuestionArr replaceObjectAtIndex:self.selectedBtnTag withObject:@"1"];
                        //[self.collectionView reloadData];

                    }

                }
                
            }
            
        }
    }

    DetialHWCell *cell = (DetialHWCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.numLabel.textColor = [UIColor colorWithRed:0 green:127/255.0 blue:55/255.0 alpha:1];
    [[OnlineJobHttp getInstance]GetStuHWQsWithHwInfoId:self.stuHomeWorkModel.hwinfoid QsId:[self.datasource objectAtIndex:indexPath.row]];
    [MBProgressHUD showMessage:@"" toView:self.view];
    self.selectedBtnTag = indexPath.row;
    [self.collectionView reloadData];
    [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    [self changeQuestionRange:[cell.numLabel.text intValue]-1];
 
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetialHWCell *cell = (DetialHWCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.numLabel.textColor = [UIColor blackColor];
    cell.selected = NO;
    
}

//每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(51, 24);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

//导航条返回按钮回调
-(void)myNavigationGoback{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //输入框弹出键盘问题
//    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
//    manager.enable = NO;//控制整个功能是否启用
//    manager.shouldResignOnTouchOutside = NO;//控制点击背景是否收起键盘
//    manager.shouldToolbarUsesTextFieldTintColor = NO;//控制键盘上的工具条文字颜色是否用户自定义
//    manager.enableAutoToolbar = NO;//控制是否显示键盘上的工具条
    [utils popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)previousBtnAction:(id)sender {
    [self.nextBtn setTitle:@"下一题" forState:UIControlStateNormal];
    self.nextBtn.enabled = YES;
    UIButton *btn = (UIButton*)sender;
    if(self.selectedBtnTag == 0)
    {
        btn.enabled = NO;
    }
    else
    {
        btn.enabled = YES;
        self.selectedBtnTag--;
        if(self.selectedBtnTag == 0)
        {
            btn.enabled = NO;
        }
        NSIndexPath *index = [NSIndexPath indexPathForItem:self.selectedBtnTag inSection:0];
        [self changeQuestionRange:(int)index.row];

        [MBProgressHUD showMessage:@"" toView:self.view];
        [self.collectionView reloadData];
        [self.collectionView selectItemAtIndexPath:index animated:YES scrollPosition:UICollectionViewScrollPositionTop ];
                [[OnlineJobHttp getInstance]GetStuHWQsWithHwInfoId:self.stuHomeWorkModel.hwinfoid QsId:[self.datasource objectAtIndex:index.row]];

    }

}

- (IBAction)nextBtnAction:(id)sender {
    UIButton *btn = (UIButton*)sender;
    if(self.datasource.count>self.selectedBtnTag)//最后一题要做判断
    {
    if([self.stuHWQsModel.QsT isEqualToString:@"1"])
    {
        BOOL isFinish = false;
        NSString *inputNum = [NSString stringWithFormat:@"document.getElementsByTagName('input').length"];
        NSUInteger inputCount = [[self.webView stringByEvaluatingJavaScriptFromString:inputNum]integerValue];
        for(int i=0;i<inputCount;i++)
        {
            NSString *type = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].type",i];
            NSString *typeStr = [self.webView stringByEvaluatingJavaScriptFromString:type];
            if(![typeStr isEqualToString:@"radio"])
            {
                continue;
            }
            NSString *checkStr = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].checked",i];
//            NSString *checkStr = [NSString stringWithFormat:@"document.getElementsByName('TopicRadio')[%d].checked",i];
            NSString *isChecked = [self.webView stringByEvaluatingJavaScriptFromString:checkStr];
            NSLog(@"isChecked = %@",isChecked);
            if([isChecked isEqualToString:@"true"])
            {
                NSIndexPath *index = [NSIndexPath indexPathForItem:self.selectedBtnTag+1 inSection:0];
                [self.collectionView reloadData];

                NSString *value = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].value",i];
                NSString *answer = [self.webView stringByEvaluatingJavaScriptFromString:value];
//                [[OnlineJobHttp getInstance]StuSubQsWithHwInfoId:self.stuHomeWorkModel.hwinfoid QsId:[self.datasource objectAtIndex:self.selectedBtnTag] Answer:answer];
                self.selectedBtnTag++;
                if(self.selectedBtnTag+1>= [self.stuHomeWorkModel.Qsc integerValue])
                {
                    if (self.isSubmit == YES) {
                        [btn setTitle:@"下一题" forState:UIControlStateNormal];
                        btn.enabled = NO;
                    }else{
                        [btn setTitle:@"提交" forState:UIControlStateNormal];

                    }
                }
                else
                {
                    [self.collectionView selectItemAtIndexPath:index animated:YES scrollPosition:UICollectionViewScrollPositionTop];
                    [btn setTitle:@"下一题" forState:UIControlStateNormal];
                }

                isFinish = YES;
                if(self.datasource.count==self.selectedBtnTag-1)
                {
                    self.previousBtn.enabled = YES;
                    if(self.isSubmit == NO)
                    {
                        {
                            [[OnlineJobHttp getInstance]StuSubQsWithHwInfoId:self.stuHomeWorkModel.hwinfoid QsId:[self.datasource objectAtIndex:self.selectedBtnTag] Answer:answer];
                            [MBProgressHUD showMessage:@"" toView:self.view];

                        }

                    }

                }
                
                else
                {
                self.previousBtn.enabled = YES;
                [[OnlineJobHttp getInstance]StuSubQsWithHwInfoId:self.stuHomeWorkModel.hwinfoid QsId:[self.datasource objectAtIndex:self.selectedBtnTag-1] Answer:answer];
                [MBProgressHUD showMessage:@"" toView:self.view];
                if(index.row<self.datasource.count)
                {
                    [[OnlineJobHttp getInstance]GetStuHWQsWithHwInfoId:self.stuHomeWorkModel.hwinfoid QsId:[self.datasource objectAtIndex:index.row]];
                    [self changeQuestionRange:(int)index.row];

//                    }

                }
                }

            }

            
        }
        if(isFinish == false)
        {
            if(self.isSubmit == NO){
                if([self.FlagStr isEqualToString:@"1"]){
                    if(self.selectedBtnTag+1>= [self.stuHomeWorkModel.Qsc integerValue]){
                        [MBProgressHUD showError:@"题目没有完成，无法提交"];

                    }else{
                        [MBProgressHUD showError:@"题目没有完成，无法进入下一题"];
 
                    }


                }else{
                    self.previousBtn.enabled = YES;
                    [[OnlineJobHttp getInstance]GetStuHWQsWithHwInfoId:self.stuHomeWorkModel.hwinfoid QsId:[self.datasource objectAtIndex:self.selectedBtnTag+1]];
                    NSIndexPath *index = [NSIndexPath indexPathForItem:self.selectedBtnTag+1 inSection:0];
                    self.selectedBtnTag++;
                    if(self.selectedBtnTag+1>= [self.stuHomeWorkModel.Qsc integerValue])
                    {
                            [btn setTitle:@"提交" forState:UIControlStateNormal];
                            btn.enabled = NO;
                    }
                    else
                    {
                        [btn setTitle:@"下一题" forState:UIControlStateNormal];
                        btn.enabled = YES;
                    }
                    [self.collectionView reloadData];
                    [self.collectionView selectItemAtIndexPath:index animated:YES scrollPosition:UICollectionViewScrollPositionTop];
                }

            }
            else{
                self.previousBtn.enabled = YES;
                [[OnlineJobHttp getInstance]GetStuHWQsWithHwInfoId:self.stuHomeWorkModel.hwinfoid QsId:[self.datasource objectAtIndex:self.selectedBtnTag+1]];
                NSIndexPath *index = [NSIndexPath indexPathForItem:self.selectedBtnTag+1 inSection:0];
                self.selectedBtnTag++;
                if(self.selectedBtnTag+1>= [self.stuHomeWorkModel.Qsc integerValue])
                {
                    if(self.isSubmit == NO){
                        [btn setTitle:@"提交" forState:UIControlStateNormal];
                    }
                    else
                    {
                        btn.enabled = NO;
                    }
                }
                else
                {
                    [btn setTitle:@"下一题" forState:UIControlStateNormal];
                }
                [self.collectionView reloadData];
                [self.collectionView selectItemAtIndexPath:index animated:YES scrollPosition:UICollectionViewScrollPositionTop];
            }


        }
        else
        {
            if(self.isSubmit == NO){

            [self.errQuestionArr replaceObjectAtIndex:self.selectedBtnTag-1 withObject:@"1"];
            }
            
        }

    }
    else
    {
        BOOL isFinish = false;
        NSString *inputNum = [NSString stringWithFormat:@"document.getElementsByTagName('input').length"];
        NSUInteger inputCount = [[self.webView stringByEvaluatingJavaScriptFromString:inputNum]integerValue];
        NSString *answer = @"";
        for(int i=0;i<inputCount;i++)
        {
            NSString *checkStr = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].value",i];
            NSString *value = [self.webView stringByEvaluatingJavaScriptFromString:checkStr];
            value = [value stringByReplacingOccurrencesOfString:@"," withString:@" "];
            value = [value stringByReplacingOccurrencesOfString:@"'" withString:@"’"];
            NSString *type = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].type",i];
            NSString *typeStr = [self.webView stringByEvaluatingJavaScriptFromString:type];
            if(![typeStr isEqualToString:@"text"])
            {
                continue;
            }

            NSString *content;
            if(i>=0)
            {
                if([value isEqualToString:@""]== NO)
                {
                    isFinish = YES;
                }
                if(i == inputCount-1)
                {
                    content = [value stringByAppendingString:@""];
                }
                else
                {
                    content = [value stringByAppendingString:@","];
                    
                }
                answer =[answer stringByAppendingString:content];
                
                NSLog(@"content = %@",content);
                
            }

        }
        if(isFinish == false)
        {
            if(self.isSubmit == NO){
                if([self.FlagStr isEqualToString:@"1"]){
                    if(self.selectedBtnTag+1>= [self.stuHomeWorkModel.Qsc integerValue]){
                        [MBProgressHUD showError:@"题目没有完成，无法提交"];
                        
                    }else{
                        [MBProgressHUD showError:@"题目没有完成，无法进入下一题"];
                        
                    }

                }else{
                    self.previousBtn.enabled = YES;
                    [[OnlineJobHttp getInstance]GetStuHWQsWithHwInfoId:self.stuHomeWorkModel.hwinfoid QsId:[self.datasource objectAtIndex:self.selectedBtnTag+1]];
                    NSIndexPath *index = [NSIndexPath indexPathForItem:self.selectedBtnTag+1 inSection:0];
                    self.selectedBtnTag++;
                    if(self.selectedBtnTag+1>= [self.stuHomeWorkModel.Qsc integerValue])
                    {
                            [btn setTitle:@"提交" forState:UIControlStateNormal];
                            btn.enabled = NO;
                    }
                    else
                    {
                        [btn setTitle:@"下一题" forState:UIControlStateNormal];
                        btn.enabled = YES;
                    }
                    [self.collectionView reloadData];
                    [self.collectionView selectItemAtIndexPath:index animated:YES scrollPosition:UICollectionViewScrollPositionTop];
                }
            }
            else{
                self.previousBtn.enabled = YES;
                [[OnlineJobHttp getInstance]GetStuHWQsWithHwInfoId:self.stuHomeWorkModel.hwinfoid QsId:[self.datasource objectAtIndex:self.selectedBtnTag+1]];
                NSIndexPath *index = [NSIndexPath indexPathForItem:self.selectedBtnTag+1 inSection:0];
                self.selectedBtnTag++;
                if(self.selectedBtnTag+1>= [self.stuHomeWorkModel.Qsc integerValue])
                {
                    if(self.isSubmit == NO){
                        [btn setTitle:@"提交" forState:UIControlStateNormal];
                    }
                    else
                    {
                        btn.enabled = NO;
                    }
                }
                else
                {
                    [btn setTitle:@"下一题" forState:UIControlStateNormal];
                }
                [self.collectionView reloadData];
                [self.collectionView selectItemAtIndexPath:index animated:YES scrollPosition:UICollectionViewScrollPositionTop];
            }
        }
        else
        {   if(self.isSubmit == NO){

            [self.errQuestionArr replaceObjectAtIndex:self.selectedBtnTag withObject:@"1"];
        }
            self.previousBtn.enabled = YES;

            if(self.datasource.count-1==self.selectedBtnTag)
            {
                if(self.isSubmit == NO){
                    {
                        [[OnlineJobHttp getInstance]StuSubQsWithHwInfoId:self.stuHomeWorkModel.hwinfoid QsId:[self.datasource objectAtIndex:self.selectedBtnTag] Answer:answer];
                        [MBProgressHUD showMessage:@"" toView:self.view];
                        [self.collectionView reloadData];
                        
                    }

                }
            }
            
            else
            {
                if(self.isSubmit == NO){
                    {

                [[OnlineJobHttp getInstance]StuSubQsWithHwInfoId:self.stuHomeWorkModel.hwinfoid QsId:[self.datasource objectAtIndex:self.selectedBtnTag] Answer:answer];
                [MBProgressHUD showMessage:@"" toView:self.view];
                    }
            }
                [[OnlineJobHttp getInstance]GetStuHWQsWithHwInfoId:self.stuHomeWorkModel.hwinfoid QsId:[self.datasource objectAtIndex:self.selectedBtnTag+1]];
                self.selectedBtnTag++;
                [self changeQuestionRange:(int)self.selectedBtnTag];

                if(self.selectedBtnTag+1>= [self.stuHomeWorkModel.Qsc integerValue])
                {
                    if(self.isSubmit == NO){
                    [btn setTitle:@"提交" forState:UIControlStateNormal];
                    }
                    else
                    {
                        btn.enabled = NO;
                    }
                }
                else
                {
                    [btn setTitle:@"下一题" forState:UIControlStateNormal];
                }
                NSIndexPath *index = [NSIndexPath indexPathForItem:self.selectedBtnTag inSection:0];
                [self.collectionView reloadData];
                [self.collectionView selectItemAtIndexPath:index animated:YES scrollPosition:UICollectionViewScrollPositionTop];
            }

        }
 
    }
    }
    if(self.datasource.count ==1)
    {
        self.previousBtn.enabled = NO;
    }
//    if(self.selectedBtnTag == 0)
//    {
//        [MBProgressHUD showError:@"没有上一题了"];
//        return;
//    }


}
-(void)getQuestionWebContent
{
    
}
- (IBAction)qNumQustion:(id)sender {
    if(self.isOpen == YES)
    {
        self.mTableV_name.frame =  CGRectMake(self.qNum.frame.origin.x, self.qNum.frame.origin.y+self.qNum.frame.size.height, self.qNum.frame.size.width, 0);
        self.isOpen = NO;
    }
    else
    {
        NSInteger count = self.datasource.count;
        NSInteger cellCount = count/20;
        NSInteger cellCount2 = count%20;
        if(cellCount2==0)
        {
            cellCount = count/20;
        }
        else
        {
            cellCount = count/20+1;
        }
        self.mTableV_name.frame =  CGRectMake(self.qNum.frame.origin.x, self.qNum.frame.origin.y+self.qNum.frame.size.height, self.qNum.frame.size.width, cellCount*25);
        self.isOpen = YES;
    }
}

- (void) keyboardWasShown:(NSNotification *) notif
{
    self.view.frame = CGRectMake(0, -self.collectionView.frame.size.height-self.collectionView.frame.origin.y+30, [dm getInstance].width, self.view.frame.size.height);
    
}
- (void) keyboardWasHidden:(NSNotification *) notif
{
     self.view.frame = CGRectMake(0, 0, [dm getInstance].width, self.view.frame.size.height);

}
-(void)changeQuestionRange:(int)num
{
    int a = (int)(num)/20;
    if((a+1)*20<self.datasource.count)
    {
        NSString *aStr = [NSString stringWithFormat:@"%d-%d",20*a+1,(a+1)*20];
        [self.qNum setTitle:aStr forState:UIControlStateNormal];
        NSIndexPath *index = [NSIndexPath indexPathForRow:a inSection:0];
        [self.mTableV_name selectRowAtIndexPath:index animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    else
    {
        NSString *aStr = [NSString stringWithFormat:@"%d-%lu",20*a+1,(unsigned long)self.datasource.count];
        [self.qNum setTitle:aStr forState:UIControlStateNormal];
        NSIndexPath *index = [NSIndexPath indexPathForRow:a inSection:0];
        [self.mTableV_name selectRowAtIndexPath:index animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

@end
