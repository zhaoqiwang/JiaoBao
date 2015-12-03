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
#import <JavaScriptCore/JavaScriptCore.h>

@interface ChoicenessDetailViewController ()<KnowledgeTableViewCellDelegate,UIWebViewDelegate,UIScrollViewDelegate>
@property(nonatomic,strong)KnowledgeTableViewCell *KnowledgeTableViewCell;
@property(nonatomic,strong)ShowPickedModel *ShowPickedModel;
@property(nonatomic,strong)UIWebView *webView;

@end

@implementation ChoicenessDetailViewController
-(void)dealloc
{
    
}
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if([scrollView isEqual:self.KnowledgeTableViewCell.mWebV_comment])
//    {
//    CGPoint point = scrollView.contentOffset;
//    if (point.x > 0) {
//        scrollView.contentOffset = CGPointMake(0, point.y);//这里不要设置为CGPointMake(0, point.y)，这样我们在文章下面左右滑动的时候，就跳到文章的起始位置，不科学
//    }
//    }
//}
-(void)ShowPicked:(id)sender
{
    //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
//        self.webView = [[UIWebView alloc]initWithFrame: CGRectMake(0, self.mNav_navgationBar.frame.size.height+self.mNav_navgationBar.frame.origin.y, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height)];
//        self.webView.tag = -1;
//        self.webView.delegate = self;
//        //cell.mWebV_comment.scrollView.bounces = NO;
//        self.webView.scrollView.showsHorizontalScrollIndicator = NO;
//        self.webView.scrollView.showsVerticalScrollIndicator = NO;
//        NSMutableString *content = [self.ShowPickedModel.PContent mutableCopy];
//        
//        [content insertString:[NSString stringWithFormat:@"<p><img align='absmiddle' src = 'ask@2x.png' width = 20 height = 20> %@<button type='button'align='absmiddle' onclick = \"onClick\">详情</button></p>",self.ShowPickedModel.Title] atIndex:12];
//        content = [[content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"width:"] withString:@" "]mutableCopy];
//        content = [[content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"_width="] withString:@" "]mutableCopy];
//        content = [[content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<img"] withString:@"<img class=\"pic\""]mutableCopy];
//        NSString *tempHtml = [NSString stringWithFormat:@"<meta name=\"viewport\" style=width:%dpx, content=\"width=%d,initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=no\" /><style>.pic{max-width:%dpx; max-height: auto; width: expression(this.width >%d && this.height < this.width ? %d: true); height: expression(this.height > auto ? auto: true);}</style>%@",[dm getInstance].width,[dm getInstance].width,[dm getInstance].width-10,[dm getInstance].width,[dm getInstance].width,content];
//        [self.webView loadHTMLString:tempHtml baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
//        [self.view addSubview:self.webView];
        self.KnowledgeTableViewCell = [self getMainView];
        [self.scrollview addSubview:self.KnowledgeTableViewCell];
    }

    
    
}
-(void)QuestionDetail:(id)noti
{
    //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
    [MBProgressHUD showMessage:@"" toView:self.view];
    
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
    cell.askImgV.hidden = NO;
    //详情
    cell.mBtn_detail.frame = CGRectMake([dm getInstance].width-52, -2, 40, cell.mBtn_detail.frame.size.height);
    [cell.mBtn_detail setTitle:@"原文" forState:UIControlStateNormal];

//    NSString *string_title = cell.ShowPickedModel.Title;
//    string_title = [string_title stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
//    CGSize size_title = [string_title sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake([dm getInstance].width-18, 1000)];
//    if (size_title.height>20) {
//        size_title = CGSizeMake(size_title.width, size_title.height);
//    }
//    cell.mLab_title.lineBreakMode = NSLineBreakByWordWrapping;
//    cell.mLab_title.font = [UIFont systemFontOfSize:18];
//    cell.mLab_title.numberOfLines =0;
//    cell.mLab_title.text = string_title;
//    cell.mLab_title.frame = CGRectMake(9, 0, cell.mBtn_detail.frame.origin.x-5, size_title.height);
    cell.askImgV.image = [UIImage imageNamed:@"ask"];
    cell.askImgV.frame = CGRectMake(9, 3, 19, 19);
    NSString *string1 = cell.ShowPickedModel.Title;
    string1 = [string1 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string1 = [string1 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    NSString *name = [NSString stringWithFormat:@" <font size=14 color=#2589D1 >%@</font>",string1];
    NSMutableDictionary *row1 = [NSMutableDictionary dictionary];
    [row1 setObject:name forKey:@"text"];
    cell.mLab_title.lineBreakMode = RTTextLineBreakModeCharWrapping;
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:[row1 objectForKey:@"text"]];
    cell.mLab_title.componentsAndPlainText = componentsDS;
    CGSize titleSize = [cell.mLab_title optimumSize];
    cell.mLab_title.frame = CGRectMake(9+cell.askImgV.frame.size.width, 3, cell.mBtn_detail.frame.origin.x-5-cell.askImgV.frame.size.width, titleSize.height);
    cell.mView_background.frame = CGRectMake(0, 0, [dm getInstance].width, titleSize.height+8);
 
        [cell.mWebV_comment.scrollView setScrollEnabled:NO];
        cell.mWebV_comment.tag = -1;
        cell.mWebV_comment.delegate = self;
    //cell.mWebV_comment.scrollView.bounces = NO;
    cell.mWebV_comment.scrollView.showsHorizontalScrollIndicator = NO;
    cell.mWebV_comment.scrollView.showsVerticalScrollIndicator = NO;
        NSMutableString *content = [cell.ShowPickedModel.PContent mutableCopy];
    
//    [content insertString:[NSString stringWithFormat:@"<p><img align='absmiddle' src = 'ask@2x.png' width = 20 height = 20> %@</p>",cell.ShowPickedModel.Title] atIndex:12];
//       content = [[content stringByReplacingOccurrencesOfString:@"答" withString:@"<p><img align='absmiddle' src = 'ask@2x.png'></p>"] mutableCopy];
//        content = [[content stringByReplacingOccurrencesOfString:@"内容" withString:@"<p><img align='absmiddle' src = 'anwser@2x.png'></p>"] mutableCopy];
    content = [[content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@">答"] withString:@"style = \"background:rgb(23,158,41);border-radius:3px;color:white;padding:1px 2px 1px 2px;\">答"]mutableCopy];
    content = [[content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@">内容"] withString:@"style = \"background:rgb(23,158,41);border-radius:3px;color:white ;padding:1px 1px 1px 1px;\">内容"]mutableCopy];
    content = [[content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@">依据"] withString:@"style = \"background:rgb(251,68,8);border-radius:3px;color:white ;padding:1px 1px 1px 1px;\">依据"]mutableCopy];

        content = [[content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"width:"] withString:@" "]mutableCopy];
        content = [[content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"_width="] withString:@" "]mutableCopy];
        content = [[content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"\n"] withString:@"</br>"]mutableCopy];
        content = [[content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<img"] withString:@"<img class=\"pic\""]mutableCopy];
    content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"nowrap"] withString:@""];
        NSString *tempHtml = [NSString stringWithFormat:@"<meta name=\"viewport\" style=width:%dpx, content=\"width=%d,initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=no\" /><style>.pic{max-width:%dpx; max-height: auto; width: expression(this.width >%d && this.height < this.width ? %d: true); height: expression(this.height > auto ? auto: true);}</style>%@",[dm getInstance].width,[dm getInstance].width,[dm getInstance].width-10,[dm getInstance].width,[dm getInstance].width,content];
        [cell.mWebV_comment loadHTMLString:tempHtml baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
        //[MBProgressHUD showMessage:@"" toView:self.view];

        //加载
        //[self webViewLoadFinish:0];
    
    cell.frame = CGRectMake(0, 64, [dm getInstance].width, cell.mWebV_comment.frame.size.height+cell.mWebV_comment.frame.origin.y+10);
    //cell.userInteractionEnabled = YES;
    return cell;
}

-(void)webViewLoadFinish:(float)height Width:(float)width{
    self.KnowledgeTableViewCell.mWebV_comment.backgroundColor = [UIColor clearColor];
    self.scrollview.bounces = NO;
//    self.webView.frame =  CGRectMake(0, self.mNav_navgationBar.frame.size.height+self.mNav_navgationBar.frame.origin.y+5, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height);
//    if([[[UIDevice currentDevice] systemVersion] floatValue] <= 9.0f)
//    {
//        
//    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f)
    {
        self.scrollview.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height+self.mNav_navgationBar.frame.origin.y+5, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height);
        self.KnowledgeTableViewCell.mWebV_comment.frame = CGRectMake(0, self.KnowledgeTableViewCell.mLab_title.frame.origin.y+self.KnowledgeTableViewCell.mLab_title.frame.size.height+5, width, height);
        
        self.KnowledgeTableViewCell.frame = CGRectMake(0, 0, self.KnowledgeTableViewCell.mWebV_comment.frame.size.width, self.KnowledgeTableViewCell.mWebV_comment.frame.origin.y+self.KnowledgeTableViewCell.mWebV_comment.frame.size.height);
        self.scrollview.contentSize = CGSizeMake([dm getInstance].width, self.KnowledgeTableViewCell.frame.origin.y+self.KnowledgeTableViewCell.frame.size.height);

    }
    else
    {
        if(self.KnowledgeTableViewCell.mWebV_comment.scrollView.contentSize.width>[dm getInstance].width)
        {

            self.scrollview.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height+self.mNav_navgationBar.frame.origin.y+5, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height);
            self.KnowledgeTableViewCell.mWebV_comment.frame = CGRectMake(0, self.KnowledgeTableViewCell.mLab_title.frame.origin.y+self.KnowledgeTableViewCell.mLab_title.frame.size.height+5, [dm getInstance].width, height);
            
            self.KnowledgeTableViewCell.frame = CGRectMake(0, 0, self.KnowledgeTableViewCell.mWebV_comment.frame.size.width, self.KnowledgeTableViewCell.mWebV_comment.frame.origin.y+self.KnowledgeTableViewCell.mWebV_comment.frame.size.height);
            self.scrollview.contentSize = CGSizeMake([dm getInstance].width, self.KnowledgeTableViewCell.frame.origin.y+self.KnowledgeTableViewCell.frame.size.height);
//
//            self.scrollview.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height+self.mNav_navgationBar.frame.origin.y+5, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height);
//            self.KnowledgeTableViewCell.mWebV_comment.frame = CGRectMake(0, self.KnowledgeTableViewCell.mLab_title.frame.origin.y+self.KnowledgeTableViewCell.mLab_title.frame.size.height+5, self.KnowledgeTableViewCell.mWebV_comment.scrollView.contentSize.width, height);
//            
//            self.KnowledgeTableViewCell.frame = CGRectMake(0, 0, self.KnowledgeTableViewCell.mWebV_comment.scrollView.contentSize.width, self.KnowledgeTableViewCell.mWebV_comment.frame.origin.y+self.KnowledgeTableViewCell.mWebV_comment.frame.size.height);
//            self.scrollview.contentSize = CGSizeMake(self.KnowledgeTableViewCell.mWebV_comment.scrollView.contentSize.width, self.KnowledgeTableViewCell.frame.origin.y+self.KnowledgeTableViewCell.frame.size.height);
//            self.KnowledgeTableViewCell.mWebV_comment.scrollView.scrollEnabled = YES;
//            self.scrollview.scrollEnabled = NO;
        }
        else
        {
            self.scrollview.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height+self.mNav_navgationBar.frame.origin.y+5, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height);
            self.KnowledgeTableViewCell.mWebV_comment.frame = CGRectMake(0, self.KnowledgeTableViewCell.mLab_title.frame.origin.y+self.KnowledgeTableViewCell.mLab_title.frame.size.height+5, [dm getInstance].width, height);
            
            self.KnowledgeTableViewCell.frame = CGRectMake(0, 0, self.KnowledgeTableViewCell.mWebV_comment.frame.size.width, self.KnowledgeTableViewCell.mWebV_comment.frame.origin.y+self.KnowledgeTableViewCell.mWebV_comment.frame.size.height);
            self.scrollview.contentSize = CGSizeMake([dm getInstance].width, self.KnowledgeTableViewCell.frame.origin.y+self.KnowledgeTableViewCell.frame.size.height);
        }

    }


        D("frame-== %@",NSStringFromCGSize(self.KnowledgeTableViewCell.mWebV_comment.scrollView.contentSize));

    [MBProgressHUD hideHUDForView:self.view animated:YES];

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
//    JSContext *content = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    content[@"onClick"] = ^() {
//        
//        
//    };
    
    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '90%'";
    [webView stringByEvaluatingJavaScriptFromString:str];
    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%d, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", [dm getInstance].width];
    [webView stringByEvaluatingJavaScriptFromString:meta];
    CGFloat webViewHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"]floatValue];
    CGFloat webViewWidth = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetWidth"]floatValue];

    if(self.KnowledgeTableViewCell.mWebV_comment.scrollView.contentSize.width>[dm getInstance].width)
    {
        float a =[dm getInstance].width/(self.KnowledgeTableViewCell.mWebV_comment.scrollView.contentSize.width);
        NSString *str =  [NSString stringWithFormat:@"%.0f%%",a*100-8];
        NSString *str2 = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%@'",str];
        [webView stringByEvaluatingJavaScriptFromString:str2];
        
        NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%d, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", [dm getInstance].width];
        [webView stringByEvaluatingJavaScriptFromString:meta];
        CGFloat webViewHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"]floatValue];
        CGFloat webViewWidth = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetWidth"]floatValue];
        [self webViewLoadFinish:webViewHeight+20 Width:webViewWidth+16];

    }
    else
    {
        [self webViewLoadFinish:webViewHeight+20 Width:webViewWidth+16];

    }

}

//cell的点击事件---详情
-(void)KnowledgeTableVIewCellDetailBtn:(KnowledgeTableViewCell *)knowledgeTableViewCell{
    if([self.QuestionDetailModel.TabID intValue]>0){
        KnowledgeQuestionViewController *queston = [[KnowledgeQuestionViewController alloc] init];
        QuestionModel *model = [[QuestionModel alloc] init];
        model.TabID = self.ShowPickedModel.QID;
        model.Title = self.pickContentModel.Title;
        model.ViewCount = self.QuestionDetailModel.ViewCount;
        model.AttCount = self.QuestionDetailModel.AttCount;
        model.AnswersCount = self.QuestionDetailModel.AnswersCount;
        model.CategorySuject = self.QuestionDetailModel.Category;
        //model.CategorySuject = self.QuestionDetailModel.CategorySuject;
        queston.mModel_question = model;
        [utils pushViewController:queston animated:YES];
    }else{
        [MBProgressHUD showError:@"找不到记录"];
    }
}

-(void)myNavigationGoback{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    self.KnowledgeTableViewCell.mWebV_comment.delegate = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
