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
    NSDictionary *dic = [sender object];
    self.ShowPickedModel = [dic objectForKey:@"model"];
    self.KnowledgeTableViewCell = [self getMainView];
    [self.scrollview addSubview:self.KnowledgeTableViewCell];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ShowPicked" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ShowPicked:) name:@"ShowPicked" object:nil];
    [[KnowledgeHttp getInstance]ShowPickedWithTabID:self.pickContentModel.TabID];
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"回答"];
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
    

    NSString *string_title = cell.ShowPickedModel.Title;
    string_title = [string_title stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    CGSize size_title = [string_title sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake([dm getInstance].width-18, 1000)];
    if (size_title.height>20) {
        size_title = CGSizeMake(size_title.width, size_title.height);
    }
    cell.mLab_title.lineBreakMode = NSLineBreakByWordWrapping;
    cell.mLab_title.font = [UIFont systemFontOfSize:14];
    cell.mLab_title.numberOfLines =0;
    cell.mLab_title.text = cell.ShowPickedModel.Title;
    cell.mLab_title.frame = CGRectMake(9, 0, [dm getInstance].width-18, size_title.height);
    

 
        [cell.mWebV_comment.scrollView setScrollEnabled:NO];
        cell.mWebV_comment.tag = -1;
        cell.mWebV_comment.delegate = self;
        NSString *content = cell.ShowPickedModel.PContent;
        content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"width:"] withString:@" "];
        content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"_width="] withString:@" "];
        content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<img"] withString:@"<img class=\"pic\""];
        NSString *tempHtml = [NSString stringWithFormat:@"<meta name=\"viewport\" style=width:%dpx, content=\"width=%d,initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=no\" /><style>.pic{max-width:%dpx; max-height: auto; width: expression(this.width >%d && this.height < this.width ? %d: true); height: expression(this.height > auto ? auto: true);}</style>%@",[dm getInstance].width-18,[dm getInstance].width-18,[dm getInstance].width-18,[dm getInstance].width-18,[dm getInstance].width-18,content];
        [cell.mWebV_comment loadHTMLString:tempHtml baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
        //加载
        //[self webViewLoadFinish:0];
        
    
    cell.frame = CGRectMake(0, 64, [dm getInstance].width, cell.mWebV_comment.frame.size.height+cell.mWebV_comment.frame.origin.y+10);
    cell.userInteractionEnabled = YES;

    return cell;
}

-(void)webViewLoadFinish:(float)height{
    self.scrollview.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height+self.mNav_navgationBar.frame.origin.y+5, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height);
    self.KnowledgeTableViewCell.mWebV_comment.frame = CGRectMake(0, self.KnowledgeTableViewCell.mLab_title.frame.origin.y+self.KnowledgeTableViewCell.mLab_title.frame.size.height, [dm getInstance].width, height+160);
    
    self.KnowledgeTableViewCell.frame = CGRectMake(0, 0, [dm getInstance].width, self.KnowledgeTableViewCell.mWebV_comment.frame.origin.y+self.KnowledgeTableViewCell.mWebV_comment.frame.size.height+50);
    self.scrollview.contentSize = CGSizeMake([dm getInstance].width, self.KnowledgeTableViewCell.frame.origin.y+self.KnowledgeTableViewCell.frame.size.height+20);
    UIButton *detailBtn = [[UIButton alloc]initWithFrame:CGRectMake([dm getInstance].width/2-50, self.KnowledgeTableViewCell.frame.size.height-40, 100, 30)];
    [self.KnowledgeTableViewCell.contentView addSubview:detailBtn];
    detailBtn.backgroundColor = [UIColor lightGrayColor];
    [detailBtn setTitle:@"原文详情" forState:UIControlStateNormal];

}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%d, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", [dm getInstance].width-18];
    [webView stringByEvaluatingJavaScriptFromString:meta];
    CGFloat webViewHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"]floatValue];
    [self webViewLoadFinish:webViewHeight+10];
}

-(void)myNavigationGoback{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    self.KnowledgeTableViewCell.mWebV_comment.delegate = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
