//
//  StuErrViewController.m
//  JiaoBao
//
//  Created by SongYanming on 16/3/18.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "StuErrViewController.h"
#import "StuErrCell.h"
#import "StuErrModel.h"
#import "OnlineJobHttp.h"
#import "StuHWQsModel.h"
#import "TFHpple.h"
int cellRefreshCount, newHeight;
@interface StuErrViewController ()
@property(nonatomic,strong)NSMutableArray *datasource;
@property(nonatomic,assign)NSInteger flag;
@property(nonatomic,assign)NSInteger mInt_index;
@property(nonatomic,assign)int mInt_reloadData;
@end

@implementation StuErrViewController
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"web_tag = %ld mInt_index = %ld" ,(long)webView.tag,self.mInt_index);
    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%d, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", [dm getInstance].width];
    [webView stringByEvaluatingJavaScriptFromString:meta];
    CGRect frame = webView.frame;
    frame.size.width = [dm getInstance].width;
    frame.size.height = 1;
    webView.frame = frame;
    frame.size.height = webView.scrollView.contentSize.height;
    
    StuHWQsModel *model = [self.webDataArr objectAtIndex:webView.tag];
    model.cellHeight = frame.size.height;
//        model.webFlag = YES;
//        self.mInt_index++;

    
    //}
    if(self.mInt_index==self.webDataArr.count){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableVIew headerEndRefreshing];
        [self.tableVIew footerEndRefreshing];
        [self.tableVIew reloadData];

    }
    
}

-(void)GetStuHWQsWithHwInfoId:(id)sender{
    StuHWQsModel *model = [sender object];
    model.QsCon = [model.QsCon stringByAppendingString:[NSString stringWithFormat:@"<p >作答：<span style=\"color:red \">%@</span><br />正确答案：%@<br /><span style=\"color:rgb(235,115,80) \">%@</span></p><hr style=\"height:30px;border:none;border-top:1px solid #555555;\" />",model.QsAns,model.QsCorectAnswer,model.QsExplain]];
    if([model.QsCon isEqual:[NSNull null]]){
    }
    else{
       [self.webDataArr addObject:model];
        
    }
    
    UIWebView *tempWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [dm getInstance].width, 0)];
    tempWeb.delegate = self;
    tempWeb.tag = self.mInt_index;
    NSString *content = model.QsCon;
    NSString *tempHtml = [utils clearHtml:content width:0];
    tempWeb.opaque = NO; //不设置这个值 页面背景始终是白色
    [tempWeb setBackgroundColor:[UIColor clearColor]];
    [tempWeb.scrollView setScrollEnabled:NO];
    [tempWeb loadHTMLString:tempHtml baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
    [self.view addSubview:tempWeb];
    [tempWeb setHidden:YES];
    self.mInt_index++;
    
    if(self.mInt_index<self.datasource.count){
        StuErrModel *errModel = [self.datasource objectAtIndex:self.mInt_index];
        [[OnlineJobHttp getInstance]GetStuHWQsWithHwInfoId:errModel.HwID QsId:errModel.QsID];
    }
    else{

    }

    
}
-(void)GetStuErr:(id)sender{
    if (self.mInt_reloadData ==0)
    {
        self.datasource = [sender object];
        if(self.datasource.count>0){
            StuErrModel *model = [self.datasource objectAtIndex:0];
            [[OnlineJobHttp getInstance]GetStuHWQsWithHwInfoId:model.HwID QsId:model.QsID];
            
        }
        else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        
    }
    else
    {
        NSArray *arr = [sender object];
        if(arr.count == 0)
        {
            
            [MBProgressHUD showSuccess:@"没有更多了" toView:self.view];
            return;
        }
        [self.datasource addObjectsFromArray:arr];
        if(arr.count>0){
            StuErrModel *model = [arr objectAtIndex:0];
            [[OnlineJobHttp getInstance]GetStuHWQsWithHwInfoId:model.HwID QsId:model.QsID];
            
        }
        else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        self.mInt_reloadData=0;
    }
    //self.datasource = [sender object];
    //for (int i=0; i<self.datasource.count; i++) {



   // }

}
- (void)viewDidLoad {
    [super viewDidLoad];
        UINib * n= [UINib nibWithNibName:@"StuErrCell" bundle:[NSBundle mainBundle]];
        [self.tableVIew registerNib:n forCellReuseIdentifier:@"StuErrCell"];
    self.tableVIew.tableFooterView = [[UIView alloc]init];
    [self.tableVIew addHeaderWithTarget:self action:@selector(headerRereshing)];
    self.tableVIew.headerPullToRefreshText = @"下拉刷新";
    self.tableVIew.headerReleaseToRefreshText = @"松开后刷新";
    self.tableVIew.headerRefreshingText = @"正在刷新...";
    [self.tableVIew addFooterWithTarget:self action:@selector(footerRereshing)];
    self.tableVIew.footerPullToRefreshText = @"上拉加载更多";
    self.tableVIew.footerReleaseToRefreshText = @"松开加载更多数据";
    self.tableVIew.footerRefreshingText = @"正在加载...";
    [self.tableVIew headerEndRefreshing];
    [self.tableVIew footerEndRefreshing];
    self.mInt_index = 0;
    self.webDataArr = [NSMutableArray array];
    self.datasource = [[NSMutableArray alloc]initWithCapacity:0];


    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetStuHWQsWithHwInfoId:) name:@"GetStuHWQsWithHwInfoId" object:nil];

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetStuErr:) name:@"GetStuErr" object:nil];
    [self sendRequest];
    // Do any additional setup after loading the view from its nib.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.webDataArr.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
        StuHWQsModel *model = [self.webDataArr objectAtIndex:indexPath.row];
//    NSLog(@"Height----indexPath====%ld %ld",(long)indexPath.row,(long)model.cellHeight);
    if (model.QsCon.length==0) {
        return 0;
    }
        return model.cellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Cell----indexPath====%ld",(long)indexPath.row);
        static NSString *indentifier = @"StuErrCell";
        StuErrCell *cell = (StuErrCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StuErrCell" owner:self options:nil];
            if ([nib count]>0) {
                cell = (StuErrCell *)[nib objectAtIndex:0];
            }
        }

    StuHWQsModel *model = [self.webDataArr objectAtIndex:indexPath.row];
//        CGFloat webViewHeight = [[cell.webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"]floatValue];
//        model.cellHeight = webViewHeight;
//    [cell.webView loadHTMLString:model.QsCon baseURL:nil];
    NSString *content = model.QsCon;
    NSString *tempHtml = [utils clearHtml:content width:0];
    cell.webView.opaque = NO; //不设置这个值 页面背景始终是白色
    [cell.webView setBackgroundColor:[UIColor clearColor]];
    [cell.webView loadHTMLString:tempHtml baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];

//    if(model.webFlag==NO){
//        cell.webView.delegate = self;
//        cell.webView.tag = indexPath.row;
//    }
//    else{
//        cell.webView.delegate = nil;
//        //cell.webView.frame = CGRectMake(0, 0, [dm getInstance].width, model.cellHeight);
//    }

        return cell;

}
-(void)dealloc{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)conditionAction:(id)sender {
    SelectChapteridViewController *detail = [[SelectChapteridViewController alloc]init];
    detail.delegate  = self;
    [self.navigationController pushViewController:detail animated:YES];
    
}
//筛选回调
-(void) SelectChapteridViewSure:(PublishJobModel *) model{
    [self.webDataArr removeAllObjects];
    self.mInt_index = 0;
    StuErrModel *errModel = [[StuErrModel alloc]init];
    if(self.mModel_stuInf){
        errModel.StuId = self.mModel_stuInf.StudentID;
        
    }
    else {
        errModel.StuId = self.mModel_gen.StudentID;
        
    }
    errModel.IsSelf = @"0";
    errModel.PageIndex = @"1";
    errModel.PageSize = @"20";
    errModel.chapterID = model.chapterID;

    [[OnlineJobHttp getInstance]GetStuErr:errModel];

    
    
}
#pragma mark 开始进入刷新状态
- (void)headerRereshing{
    self.mInt_reloadData = 0;
    [self sendRequest];
}

- (void)footerRereshing{
    self.mInt_reloadData = 1;
    [self sendRequest];
}
-(void)sendRequest{
    NSString *page = @"";
    if (self.mInt_reloadData == 0) {
        [self.webDataArr removeAllObjects];
        self.mInt_index =0;
        page = @"1";
        [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    }else{
        NSMutableArray *array = self.webDataArr;
        if (array.count>=20&&array.count%20==0) {
            page = [NSString stringWithFormat:@"%d",(int)array.count/20+1];
            [MBProgressHUD showMessage:@"加载中..." toView:self.view];
        } else {
            [self.tableVIew headerEndRefreshing];
            [self.tableVIew footerEndRefreshing];
            self.mInt_reloadData = 0;
            [MBProgressHUD showSuccess:@"没有更多了" toView:self.view];
            return;
        }
    }
    StuErrModel *errModel = [[StuErrModel alloc]init];
    if(self.mModel_stuInf){
        errModel.StuId = self.mModel_stuInf.StudentID;
        
    }
    else {
        errModel.StuId = self.mModel_gen.StudentID;
        
    }
    errModel.IsSelf = @"0";
    errModel.PageIndex = page;
    errModel.PageSize = @"20";
    [[OnlineJobHttp getInstance]GetStuErr:errModel];
}

@end
