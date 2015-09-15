//
//  ChoicenessDetailViewController.m
//  JiaoBao
//
//  Created by songyanming on 15/9/10.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "ChoicenessDetailViewController.h"
#import "KnowledgeTableViewCell.h"
#import "dm.h"
#import "KnowledgeHttp.h"
#import "KnowledgeQuestionViewController.h"

@interface ChoicenessDetailViewController ()<KnowledgeTableViewCellDelegate,UIWebViewDelegate>
@property(nonatomic,strong)KnowledgeTableViewCell *KnowledgeTableViewCell;
@property(nonatomic,strong)ShowPickedModel *ShowPickedModel;

@end

@implementation ChoicenessDetailViewController
-(void)dealloc
{
    
}
-(void)ShowPicked:(id)sender
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *dic = [sender object];
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
    NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
    if([ResultCode integerValue]!=0)
    {
        [MBProgressHUD showError:ResultDesc];
    }
    else
    {
        self.ShowPickedModel = [dic objectForKey:@"model"];
        [[KnowledgeHttp getInstance]QuestionDetailWithQId:self.ShowPickedModel.QID];
        
        self.KnowledgeTableViewCell = [self getMainView];
        [self.scrollview addSubview:self.KnowledgeTableViewCell];
    }

    
    
}
-(void)QuestionDetail:(id)noti
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSMutableDictionary *dic = [noti object];
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
    NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
    if([ResultCode integerValue]!=0)
    {
        [MBProgressHUD showError:ResultDesc];
    }
    else
    {
        self.QuestionDetailModel = [dic objectForKey:@"model"];

    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ShowPicked" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ShowPicked:) name:@"ShowPicked" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"QuestionDetail" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(QuestionDetail:) name:@"QuestionDetail" object:nil];
    [[KnowledgeHttp getInstance]ShowPickedWithTabID:self.pickContentModel.TabID];
    
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:self.pickContentModel.Title];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(KnowledgeTableViewCell*)getMainView

{
    KnowledgeTableViewCell *cell = [[KnowledgeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"KnowledgeTableViewCell" owner:self options:nil];
    if ([nib count]>0) {
        cell = (KnowledgeTableViewCell *)[nib objectAtIndex:0];
        //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
    }
    cell.delegate= self;
    cell.ShowPickedModel = self.ShowPickedModel;
    NSArray *views = [cell.contentView subviews];
    for(int i=0;i<views.count;i++)
    {
        UIView *subView = [views objectAtIndex:i];
        subView.hidden = YES;
    }
    cell.mWebV_comment.hidden = NO;
    cell.mLab_title.hidden = NO;
    cell.mView_background.hidden = NO;
    cell.mBtn_detail.hidden = NO;
    //详情
    cell.mBtn_detail.frame = CGRectMake([dm getInstance].width-52, -2, 40, cell.mBtn_detail.frame.size.height);

        [cell.mBtn_detail setTitle:@"原文" forState:UIControlStateNormal];



    NSString *string_title = cell.ShowPickedModel.Title;
    string_title = [string_title stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    CGSize size_title = [string_title sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake([dm getInstance].width-18, 1000)];
    if (size_title.height>20) {
        size_title = CGSizeMake(size_title.width, size_title.height);
    }
    cell.mLab_title.lineBreakMode = NSLineBreakByWordWrapping;
    cell.mLab_title.font = [UIFont systemFontOfSize:18];
    cell.mLab_title.numberOfLines =0;
    cell.mLab_title.text = string_title;
    cell.mLab_title.frame = CGRectMake(9, 0, cell.mBtn_detail.frame.origin.x-5, size_title.height);
    cell.mView_background.frame = CGRectMake(0, 0, [dm getInstance].width, size_title.height);

 
        [cell.mWebV_comment.scrollView setScrollEnabled:NO];
        cell.mWebV_comment.tag = -1;
        cell.mWebV_comment.delegate = self;
        NSString *content = cell.ShowPickedModel.PContent;
        content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"width:"] withString:@" "];
        content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"_width="] withString:@" "];
        content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<img"] withString:@"<img class=\"pic\""];
        NSString *tempHtml = [NSString stringWithFormat:@"<meta name=\"viewport\" style=width:%dpx, content=\"width=%d,initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=no\" /><style>.pic{max-width:%dpx; max-height: auto; width: expression(this.width >%d && this.height < this.width ? %d: true); height: expression(this.height > auto ? auto: true);}</style>%@",[dm getInstance].width,[dm getInstance].width,[dm getInstance].width,[dm getInstance].width,[dm getInstance].width,content];
        [cell.mWebV_comment loadHTMLString:tempHtml baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
        [MBProgressHUD showMessage:@"" toView:self.view];

        //加载
        //[self webViewLoadFinish:0];
        
    
    cell.frame = CGRectMake(0, 64, [dm getInstance].width, cell.mWebV_comment.frame.size.height+cell.mWebV_comment.frame.origin.y+10);
    cell.userInteractionEnabled = YES;

    return cell;
}

-(void)webViewLoadFinish:(float)height{
    self.scrollview.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height+self.mNav_navgationBar.frame.origin.y+5, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height);
    self.KnowledgeTableViewCell.mWebV_comment.frame = CGRectMake(0, self.KnowledgeTableViewCell.mLab_title.frame.origin.y+self.KnowledgeTableViewCell.mLab_title.frame.size.height, [dm getInstance].width, height);
    
    self.KnowledgeTableViewCell.frame = CGRectMake(0, 0, [dm getInstance].width, self.KnowledgeTableViewCell.mWebV_comment.frame.origin.y+self.KnowledgeTableViewCell.mWebV_comment.frame.size.height+50);
    self.scrollview.contentSize = CGSizeMake([dm getInstance].width, self.KnowledgeTableViewCell.frame.origin.y+self.KnowledgeTableViewCell.frame.size.height+20);
//    UIButton *detailBtn = [[UIButton alloc]initWithFrame:CGRectMake([dm getInstance].width/2-50, self.KnowledgeTableViewCell.frame.size.height-40, 100, 30)];
//    [self.KnowledgeTableViewCell.contentView addSubview:detailBtn];
//    detailBtn.backgroundColor = [UIColor colorWithRed:68/255.0 green:193/255.0 blue:24/255.0 alpha:1];
//    [detailBtn setTitle:@"原文详情" forState:UIControlStateNormal];
//    [detailBtn addTarget:self action:@selector(detailBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [MBProgressHUD hideHUDForView:self.view];

}
-(void)detailBtnAction:(id)sender
{
    KnowledgeQuestionViewController *queston = [[KnowledgeQuestionViewController alloc] init];
    QuestionModel *model = [[QuestionModel alloc] init];
    model.TabID = self.ShowPickedModel.QID;
    model.Title = self.pickContentModel.Title;
    model.ViewCount = self.QuestionDetailModel.ViewCount;
    model.AttCount = self.QuestionDetailModel.AttCount;
    model.AnswersCount = self.QuestionDetailModel.AnswersCount;
    //model.CategorySuject = self.QuestionDetailModel.CategorySuject;
    queston.mModel_question = model;
    [utils pushViewController:queston animated:YES];
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%d, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", [dm getInstance].width];
    [webView stringByEvaluatingJavaScriptFromString:meta];
    CGFloat webViewHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"]floatValue];
    [self webViewLoadFinish:webViewHeight+10];
}

//cell的点击事件---详情
-(void)KnowledgeTableVIewCellDetailBtn:(KnowledgeTableViewCell *)knowledgeTableViewCell{
    KnowledgeQuestionViewController *queston = [[KnowledgeQuestionViewController alloc] init];
    QuestionModel *model = [[QuestionModel alloc] init];
    model.TabID = self.ShowPickedModel.QID;
    model.Title = self.pickContentModel.Title;
    model.ViewCount = self.QuestionDetailModel.ViewCount;
    model.AttCount = self.QuestionDetailModel.AttCount;
    model.AnswersCount = self.QuestionDetailModel.AnswersCount;
    //model.CategorySuject = self.QuestionDetailModel.CategorySuject;
    queston.mModel_question = model;
    [utils pushViewController:queston animated:YES];

}

-(void)myNavigationGoback{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    self.KnowledgeTableViewCell.mWebV_comment.delegate = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
