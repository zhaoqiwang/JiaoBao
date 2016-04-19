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
#import "utils.h"
int cellRefreshCount, newHeight;
@interface StuErrViewController ()
@property(nonatomic,strong)NSMutableArray *datasource;
@property(nonatomic,assign)NSInteger flag;
@property(nonatomic,assign)NSInteger mInt_index;
@property(nonatomic,assign)int mInt_reloadData;
@property(nonatomic,strong)StuErrModel *errModel;
@end

@implementation StuErrViewController
-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"GetStuHWQsWithHwInfoId" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetStuHWQsWithHwInfoId:) name:@"GetStuHWQsWithHwInfoId" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"GetStuErr" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetStuErr:) name:@"GetStuErr" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self];

    
}
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

    if(self.mInt_index==self.datasource.count){
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.tableVIew headerEndRefreshing];
        [self.tableVIew footerEndRefreshing];
        [self.tableVIew reloadData];

    }
    
}

-(void)GetStuHWQsWithHwInfoId:(id)sender{
    [MBProgressHUD hideHUDForView:self.view];
    StuHWQsModel *model = [sender object];
    StuErrModel *errModel = [self.datasource objectAtIndex:self.mInt_index];
    NSString *errNum;
    if([errModel.DoC integerValue]==1){
        errNum = @" *";
    }else if ([errModel.DoC integerValue]==2){
        errNum = @" * *";
    }else if ([errModel.DoC integerValue]==3){
       errNum = @" * * *";
    }else{
       errNum = @" *"; 
    }
    model.QsCon = [NSString stringWithFormat:@"<div style = \"background:rgb(240,240,240);font-size:13px\">%@<span style=\"color:red \">%@</span> &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp&nbsp &nbsp &nbsp &nbsp&nbsp &nbsp &nbsp&nbsp&nbsp &nbsp &nbsp&nbsp&nbsp &nbsp &nbsp&nbsp&nbsp难度：%@</div>%@",errModel.Tabid,errNum,errModel.QsLv,model.QsCon];


    model.QsCon = [model.QsCon stringByAppendingString:[NSString stringWithFormat:@"<p >作答：<span style=\"color:red \">%@</span><br />正确答案：%@<br /><span style=\"color:rgb(235,115,80) \">%@</span></p>",errModel.Answer,model.QsCorectAnswer,model.QsExplain]];
    model.QsCon = [model.QsCon stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"</p>"] withString:@""];
    model.QsCon = [model.QsCon stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"</br>"] withString:@"\r"];
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType};
    NSAttributedString *string = [[NSAttributedString alloc] initWithData:[model.QsCon dataUsingEncoding:NSUnicodeStringEncoding] options:options documentAttributes:nil error:nil];
    model.attributedString = string;
    self.textView.attributedText = string;
    model.cellHeight = self.textView.contentSize.height;

    if([model.QsCon isEqual:[NSNull null]]){

        
    }
    else{
       [self.webDataArr addObject:model];
        
    }



    self.mInt_index++;
    if(self.mInt_index<self.datasource.count){
        StuErrModel *errModel = [self.datasource objectAtIndex:self.mInt_index];
        [[OnlineJobHttp getInstance]GetStuHWQsWithHwInfoId:@"0" QsId:errModel.QsID];
        [MBProgressHUD showMessage:@"" toView:self.view];
    }
    else{
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.tableVIew reloadData];
    }

    
}
-(void)GetStuErr:(id)sender{
    
    if (self.mInt_reloadData ==0)
    {
        self.datasource = [sender object];
        if(self.datasource.count>0){
            StuErrModel *model = [self.datasource objectAtIndex:0];
            [MBProgressHUD showMessage:@"" toView:self.view];
            [[OnlineJobHttp getInstance]GetStuHWQsWithHwInfoId:@"0" QsId:model.QsID];
            
        }
        else{
            
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showSuccess:@"无数据" toView:self.view];
            [self.tableVIew reloadData];
            [self.tableVIew headerEndRefreshing];
             [self.tableVIew footerEndRefreshing];
        }
        
    }
    else
    {
        NSArray *arr = [sender object];
        if(arr.count == 0)
        {
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showSuccess:@"没有更多了" toView:self.view];
            return;
        }
        [self.datasource addObjectsFromArray:arr];
        if(arr.count>0){
            StuErrModel *model = [arr objectAtIndex:0];
            [MBProgressHUD showMessage:@"" toView:self.view];
            [[OnlineJobHttp getInstance] GetStuHWQsWithHwInfoId:@"0" QsId:model.QsID];
            
        }
        else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        self.mInt_reloadData=0;
    }

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
    self.errModel = [[StuErrModel alloc]init];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetStuHWQsWithHwInfoId" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetStuHWQsWithHwInfoId:) name:@"GetStuHWQsWithHwInfoId" object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetStuErr" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetStuErr:) name:@"GetStuErr" object:nil];
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
    //NSLog(@"Cell----indexPath====%ld",(long)indexPath.row);
        static NSString *indentifier = @"StuErrCell";
        StuErrCell *cell = (StuErrCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StuErrCell" owner:self options:nil];
            if ([nib count]>0) {
                cell = (StuErrCell *)[nib objectAtIndex:0];
            }
        }
    //若是需要重用，需要写上以下两句代码
    UINib * n= [UINib nibWithNibName:@"StuErrCell" bundle:[NSBundle mainBundle]];
    [self.tableVIew registerNib:n forCellReuseIdentifier:indentifier];

    StuHWQsModel *model = [self.webDataArr objectAtIndex:indexPath.row];
//        CGFloat webViewHeight = [[cell.webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"]floatValue];
//        model.cellHeight = webViewHeight;
//    [cell.webView loadHTMLString:model.QsCon baseURL:nil];
    //NSString *content = model.QsCon;
//    NSAttributedString *content = [[NSAttributedString alloc]initWithString:model.QsCon];
    cell.textview.attributedText = model.attributedString;
//    NSString *tempHtml = [utils clearHtml:content width:0];
//    NSLog(@"cell = %@",cell);
//    cell.webView.opaque = NO; //不设置这个值 页面背景始终是白色
//    [cell.webView setBackgroundColor:[UIColor clearColor]];
//    [cell.webView loadHTMLString:tempHtml baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];

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
    [self.tableVIew reloadData];
    self.mInt_index = 0;
    if(self.mModel_stuInf){
        self.errModel.StuId = self.mModel_stuInf.StudentID;
        
    }
    else {
        self.errModel.StuId = self.mModel_gen.StudentID;
        
    }
    self.errModel.IsSelf = @"0";
    self.errModel.PageIndex = @"1";
    self.errModel.PageSize = @"10";
    self.errModel.chapterID = model.chapterID;
    self.errModel.gradeCode = model.GradeCode;
    self.errModel.subjectCode = model.subjectCode;
    self.errModel.unid = model.VersionCode;
    [self.conditionBtn setTitle:[NSString stringWithFormat:@"%@ %@ %@ %@",model.GradeName,model.subjectName,model.VersionName,model.chapterName] forState:UIControlStateNormal];
    NSString *str = [self.conditionBtn titleForState:UIControlStateNormal];
    NSLog(@"str = %@",str);
    [[OnlineJobHttp getInstance]GetStuErr:self.errModel];

    
    
}
#pragma mark 开始进入刷新状态
- (void)headerRereshing{
    //检查网络情况
    if([utils checkNetWork:self.view tableView:self.tableVIew]){
        return;
    }
    self.mInt_reloadData = 0;
    [self sendRequest];
}

- (void)footerRereshing{
    //检查网络情况
    if([utils checkNetWork:self.view tableView:self.tableVIew]){
        return;
    }

    self.mInt_reloadData = 1;
    [self sendRequest];
}
-(void)sendRequest{
    NSString *page = @"";
    if (self.mInt_reloadData == 0) {
        [self.webDataArr removeAllObjects];
        [self.tableVIew reloadData];
        self.mInt_index =0;
        page = @"1";
        [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    }else{
        NSMutableArray *array = self.webDataArr;
        if (array.count>=10&&array.count%10==0) {
            page = [NSString stringWithFormat:@"%d",(int)array.count/10+1];
            [MBProgressHUD showMessage:@"加载中..." toView:self.view];
        } else {
            [self.tableVIew headerEndRefreshing];
            [self.tableVIew footerEndRefreshing];
            self.mInt_reloadData = 0;
            [MBProgressHUD showSuccess:@"没有更多了" toView:self.view];
            return;
        }
    }
    if(self.mModel_stuInf){
        self.errModel.StuId = self.mModel_stuInf.StudentID;
        
    }
    else {
        self.errModel.StuId = self.mModel_gen.StudentID;
        
    }
    self.errModel.IsSelf = @"0";
    self.errModel.PageIndex = page;
    self.errModel.PageSize = @"10";
    [[OnlineJobHttp getInstance]GetStuErr:self.errModel];
}

@end
