//
//  ChoicenessDetailViewController.m
//  JiaoBao
//
//  Created by songyanming on 15/9/10.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "ChoicenessDetailViewController.h"
#import "KnowledgeTableViewCell.h"
#import "PickContentModel.h"
#import "dm.h"

@interface ChoicenessDetailViewController ()<KnowledgeTableViewCellDelegate,UIWebViewDelegate>
@property(nonatomic,strong)PickContentModel *pickContentModel;
@property(nonatomic,strong)KnowledgeTableViewCell *KnowledgeTableViewCell;

@end

@implementation ChoicenessDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.KnowledgeTableViewCell = [self getMainView];
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
    cell.pickContentModel = self.pickContentModel;
    

    NSString *string_title = cell.pickContentModel.Title;
    string_title = [string_title stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    CGSize size_title = [string_title sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(cell.mBtn_detail.frame.origin.x-5, 1000)];
    if (size_title.height>20) {
        size_title = CGSizeMake(size_title.width, size_title.height);
    }
    cell.mLab_title.lineBreakMode = NSLineBreakByWordWrapping;
    cell.mLab_title.font = [UIFont systemFontOfSize:14];
    cell.mLab_title.numberOfLines =0;
    cell.mLab_title.text = cell.pickContentModel.Title;
    cell.mLab_title.frame = CGRectMake(9, 0, cell.mBtn_detail.frame.origin.x-5, size_title.height);
    

 
        [cell.mWebV_comment.scrollView setScrollEnabled:NO];
        cell.mWebV_comment.tag = -1;
        cell.mWebV_comment.delegate = self;
        NSString *content = cell.pickContentModel.Abstracts;
        content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"width:"] withString:@" "];
        content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"_width="] withString:@" "];
        content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<img"] withString:@"<img class=\"pic\""];
        NSString *tempHtml = [NSString stringWithFormat:@"<meta name=\"viewport\" style=width:%dpx, content=\"width=%d,initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=no\" /><style>.pic{max-width:%dpx; max-height: auto; width: expression(this.width >%d && this.height < this.width ? %d: true); height: expression(this.height > auto ? auto: true);}</style>%@",[dm getInstance].width-18,[dm getInstance].width-18,[dm getInstance].width-18,[dm getInstance].width-18,[dm getInstance].width-18,content];
        [cell.mWebV_comment loadHTMLString:tempHtml baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
        //加载
        //[self webViewLoadFinish:0];
        
    
    cell.frame = CGRectMake(0, 10, [dm getInstance].width, cell.mWebV_comment.frame.size.height+cell.mWebV_comment.frame.origin.y+10);
    cell.userInteractionEnabled = YES;

    return cell;
}

-(void)webViewLoadFinish:(float)height{
    self.KnowledgeTableViewCell.mWebV_comment.frame = CGRectMake(9, self.KnowledgeTableViewCell.mLab_title.frame.origin.y+3, [dm getInstance].width, height);
    
    
    self.KnowledgeTableViewCell.frame = CGRectMake(0, 5, [dm getInstance].width, self.KnowledgeTableViewCell.mWebV_comment.frame.origin.y+self.KnowledgeTableViewCell.mWebV_comment.frame.size.height);


    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%d, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", [dm getInstance].width-18];
    [webView stringByEvaluatingJavaScriptFromString:meta];
    CGFloat webViewHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"]floatValue];
    [self webViewLoadFinish:webViewHeight+10];
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
