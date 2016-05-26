//
//  KnowledgeRecommentAddAnswerViewController.m
//  JiaoBao
//
//  Created by Zqw on 15/8/14.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "KnowledgeRecommentAddAnswerViewController.h"

@interface KnowledgeRecommentAddAnswerViewController ()

@end

@implementation KnowledgeRecommentAddAnswerViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mTableV_answer.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view from its nib.
    //推荐问题详情
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ShowRecomment" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShowRecomment:) name:@"ShowRecomment" object:nil];
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:[NSString stringWithFormat:@"%@",self.mModel_question.Title]];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    self.mInt_index = 0;
    
    //
    self.mScrollV_view.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height);
    [self.view addSubview:self.mScrollV_view];
    
    //标题话题等显示
    static NSString *indentifier = @"KnowledgeTableViewCell";
    if (self.mView_titlecell == nil) {
        self.mView_titlecell = [[KnowledgeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"KnowledgeTableViewCell" owner:self options:nil];
        //这时myCell对象已经通过自定义xib文件生成了
        if ([nib count]>0) {
            self.mView_titlecell = (KnowledgeTableViewCell *)[nib objectAtIndex:0];
            //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
        }
    }
    //先隐藏
    self.mView_titlecell.hidden = YES;
    [self.mScrollV_view addSubview:self.mView_titlecell];
    
    //
    [[KnowledgeHttp getInstance] ShowRecommentWithTable:self.mModel_question.tabid];
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
}

//推荐问题详情
-(void)ShowRecomment:(NSNotification *)noti{
    NSMutableDictionary *dic = noti.object;
    NSString *code = [dic objectForKey:@"ResultCode"];
    [MBProgressHUD hideHUDForView:self.view];
    if ([code integerValue] ==0) {
        self.mModel_recomment = [dic objectForKey:@"model"];
        
        NSMutableArray *array = self.mModel_recomment.answerArray;
        
        if (array.count==0) {
            [MBProgressHUD showError:@"有答案已被删除或已屏蔽!" toView:self.view];
        }
        int m=0;
        for (int i=0; i<array.count; i++) {
//            UIWebView *tempWeb = [[UIWebView alloc]  initWithFrame:CGRectMake(0, 0, [dm getInstance].width-85, 0)];
            AnswerModel *model = [array objectAtIndex:i];
            if (m==0&&[model.TabID intValue]==0) {
                m++;
                [MBProgressHUD showError:@"有答案已被删除或已屏蔽!" toView:self.view];
            }
        }
        
        NSURL *url = [[NSURL alloc] initWithString:self.mModel_recomment.questionModel.KnContent];
        self.mView_titlecell.mWebV_comment.delegate = self;
        self.mView_titlecell.mWebV_comment.tag = -1;
        self.mView_titlecell.mWebV_comment.scrollView.bounces = NO;
        [self.mView_titlecell.mWebV_comment loadRequest:[NSURLRequest requestWithURL:url]];
        
//        [MBProgressHUD showMessage:@"加载中..." toView:self.view];
        self.mInt_index =1;
        
        [self.mTableV_answer reloadData];
        [self addDetailCell:self.mModel_recomment Float:0];
    }else{
        NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
        [MBProgressHUD showError:ResultDesc toView:self.view];
    }
}

-(void)addDetailCell:(RecommentAddAnswerModel *)model Float:(float)height{
    self.mView_titlecell.hidden = NO;
    self.mView_titlecell.askImgV.hidden = NO;
    self.mView_titlecell.delegate = self;
    //标题
//    self.mView_titlecell.mLab_title.frame = CGRectMake(9, 10, [dm getInstance].width-9*2, 16);
//    self.mView_titlecell.mLab_title.frame = CGRectMake(9, 10, [dm getInstance].width-9*2-40, self.mView_titlecell.mLab_title.frame.size.height);
//    self.mView_titlecell.mLab_title.text = model.questionModel.Title;
    self.mView_titlecell.mLab_title.hidden = NO;
    NSString *string1 = model.questionModel.Title;
    string1 = [string1 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string1 = [string1 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    self.mView_titlecell.askImgV.image = [UIImage imageNamed:@"ask"];
    self.mView_titlecell.askImgV.frame = CGRectMake(9, 10, 19, 19);
    NSString *name = [NSString stringWithFormat:@"<font size=14 color=#2589D1 >%@</font>",string1];
    NSMutableDictionary *row1 = [NSMutableDictionary dictionary];
    [row1 setObject:name forKey:@"text"];
    self.mView_titlecell.mLab_title.lineBreakMode = RTTextLineBreakModeCharWrapping;
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:[row1 objectForKey:@"text"]];
    self.mView_titlecell.mLab_title.componentsAndPlainText = componentsDS;
    CGSize titleSize = [self.mView_titlecell.mLab_title optimumSize];
    self.mView_titlecell.mLab_title.frame = CGRectMake(self.mView_titlecell.askImgV.frame.origin.x+self.mView_titlecell.askImgV.frame.size.width, self.mView_titlecell.askImgV.frame.origin.y, [dm getInstance].width-9*2-40- self.mView_titlecell.askImgV.frame.size.width, titleSize.height);
    //详情
    self.mView_titlecell.mBtn_detail.hidden = NO;
    [self.mView_titlecell.mBtn_detail setTitle:@"原文" forState:UIControlStateNormal];
    self.mView_titlecell.mBtn_detail.frame = CGRectMake([dm getInstance].width-49, 3, 40, self.mView_titlecell.mBtn_detail.frame.size.height);
    //话题
    self.mView_titlecell.mLab_Category0.frame = CGRectMake(30, self.mView_titlecell.mLab_title.frame.origin.y+self.mView_titlecell.mLab_title.frame.size.height+5, self.mView_titlecell.mLab_Category0.frame.size.width, 21);
    CGSize CategorySize = [[NSString stringWithFormat:@"%@",self.mModel_question.CategorySuject] sizeWithFont:[UIFont systemFontOfSize:10]];
    self.mView_titlecell.mLab_Category1.frame = CGRectMake(30+self.mView_titlecell.mLab_Category0.frame.size.width+2, self.mView_titlecell.mLab_Category0.frame.origin.y, CategorySize.width, 21);
    self.mView_titlecell.mLab_Category1.text = self.mModel_question.CategorySuject;
    self.mView_titlecell.mLab_Category1.hidden = NO;
    self.mView_titlecell.mLab_Category0.hidden = NO;
    //访问
    CGSize ViewSize = [[NSString stringWithFormat:@"%@",model.questionModel.ViewCount] sizeWithFont:[UIFont systemFontOfSize:10]];
    self.mView_titlecell.mLab_ViewCount.frame = CGRectMake([dm getInstance].width-9-ViewSize.width, self.mView_titlecell.mLab_Category0.frame.origin.y, ViewSize.width, 21);
    self.mView_titlecell.mLab_ViewCount.text = model.questionModel.ViewCount;
    self.mView_titlecell.mLab_ViewCount.hidden = NO;
    self.mView_titlecell.mLab_View.frame = CGRectMake(self.mView_titlecell.mLab_ViewCount.frame.origin.x-2-self.mView_titlecell.mLab_View.frame.size.width, self.mView_titlecell.mLab_Category0.frame.origin.y, self.mView_titlecell.mLab_View.frame.size.width, 21);
    self.mView_titlecell.mLab_View.hidden = NO;
    //回答
    CGSize AnswersSize = [[NSString stringWithFormat:@"%@",model.questionModel.AnswersCount] sizeWithFont:[UIFont systemFontOfSize:10]];
    self.mView_titlecell.mLab_AnswersCount.frame = CGRectMake(self.mView_titlecell.mLab_View.frame.origin.x-5-AnswersSize.width, self.mView_titlecell.mLab_Category0.frame.origin.y, AnswersSize.width, 21);
    self.mView_titlecell.mLab_AnswersCount.text = model.questionModel.AnswersCount;
    self.mView_titlecell.mLab_AnswersCount.hidden = NO;
    self.mView_titlecell.mLab_Answers.frame = CGRectMake(self.mView_titlecell.mLab_AnswersCount.frame.origin.x-2-self.mView_titlecell.mLab_Answers.frame.size.width, self.mView_titlecell.mLab_Category0.frame.origin.y, self.mView_titlecell.mLab_Answers.frame.size.width, 21);
    self.mView_titlecell.mLab_Answers.hidden = NO;
    //关注
    CGSize AttSize = [[NSString stringWithFormat:@"%@",self.mModel_question.AttCount] sizeWithFont:[UIFont systemFontOfSize:10]];
    self.mView_titlecell.mLab_AttCount.frame = CGRectMake(self.mView_titlecell.mLab_Answers.frame.origin.x-5-AttSize.width, self.mView_titlecell.mLab_Category0.frame.origin.y, AttSize.width, 21);
    self.mView_titlecell.mLab_AttCount.text = self.mModel_question.AttCount;
    self.mView_titlecell.mLab_AttCount.hidden = NO;
    self.mView_titlecell.mLab_Att.frame = CGRectMake(self.mView_titlecell.mLab_AttCount.frame.origin.x-2-self.mView_titlecell.mLab_Att.frame.size.width, self.mView_titlecell.mLab_Category0.frame.origin.y, self.mView_titlecell.mLab_Att.frame.size.width, 21);
    self.mView_titlecell.mLab_Att.hidden = NO;
    //赞
    self.mView_titlecell.mLab_LikeCount.hidden = YES;
    //头像
    self.mView_titlecell.mImgV_head.hidden = YES;
    //姓名
    self.mView_titlecell.mLab_IdFlag.hidden = YES;
    //回答标题
    self.mView_titlecell.mLab_ATitle.hidden = YES;
    //背景色
    self.mView_titlecell.mView_background.hidden = NO;
    self.mView_titlecell.mView_background.frame = CGRectMake(0, 0, [dm getInstance].width, self.mView_titlecell.mLab_Category0.frame.origin.y+self.mView_titlecell.mLab_Category0.frame.size.height+10);
    //回答内容
    self.mView_titlecell.mLab_Abstracts.hidden = YES;

    self.mView_titlecell.mWebV_comment.hidden = NO;
    [self.mView_titlecell.mWebV_comment.scrollView setScrollEnabled:YES];
    self.mView_titlecell.mWebV_comment.tag = -1;
    
    //加载
    [self webViewLoadFinish:height];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:self.view];
    NSString *meta;
    if (webView.tag==-1) {
        meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%d, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", [dm getInstance].width-10];
    }else{
//        meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%d, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", [dm getInstance].width-75];
    }
    [webView stringByEvaluatingJavaScriptFromString:meta];
    webView.keyboardDisplayRequiresUserAction = NO;
    //禁用用户选择
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    // 禁用长按弹出框
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    CGFloat webViewHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"]floatValue];
    CGFloat webViewWidth = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetWidth"]floatValue];
    if (webView.tag == -1) {
        [self addDetailCell:self.mModel_recomment Float:webViewHeight];
    }else{
        CGRect frame = webView.frame;
        frame.size.width = [dm getInstance].width-75;
        frame.size.height = 1;
        webView.frame = frame;
        frame.size.height = webView.scrollView.contentSize.height;
        [webView setBackgroundColor:[UIColor clearColor]];
        webView.scrollView.contentSize = CGSizeMake(webViewWidth, frame.size.height);
        
        CGSize fittingSize = webView.scrollView.contentSize;
//        CGSize fittingSize = [self.mWebV_temp sizeThatFits:CGSizeZero];
        NSLog(@"webView:%@，%f",NSStringFromCGSize(fittingSize),webViewHeight);
        AnswerModel *model = [self.mModel_recomment.answerArray objectAtIndex:webView.tag];
        model.floatH = fittingSize.height;
        [webView removeFromSuperview];
        [self.mTableV_answer reloadData];
        self.mTableV_answer.frame = CGRectMake(0, self.mView_titlecell.frame.origin.y+self.mView_titlecell.frame.size.height, [dm getInstance].width, self.mTableV_answer.contentSize.height);
        self.mScrollV_view.contentSize = CGSizeMake([dm getInstance].width, self.mTableV_answer.frame.origin.y+self.mTableV_answer.contentSize.height);
    }
    //加载答案
    if (self.mInt_index-1<(int)self.mModel_recomment.answerArray.count) {
        NSMutableArray *array = self.mModel_recomment.answerArray;
        AnswerModel *model;
        for (int i=self.mInt_index-1; i<self.mModel_recomment.answerArray.count; i++) {
            model = [array objectAtIndex:self.mInt_index-1];
            if ([model.Flag integerValue]==0) {
                self.mInt_index++;
            }else{
                break;
            }
        }
        
        if ([model.Flag integerValue]>0) {//非无内容
            [MBProgressHUD showMessage:@"加载中..." toView:self.view];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1000ull * NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
                UIWebView *tempWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [dm getInstance].width-75, 0)];
                tempWeb.delegate = self;
                tempWeb.tag = self.mInt_index-1;
                NSURL *url = [[NSURL alloc] initWithString:model.Abstracts];
                tempWeb.scrollView.bounces = NO;
                [tempWeb loadRequest:[NSURLRequest requestWithURL:url]];
                [self.view addSubview:tempWeb];
                [tempWeb setHidden:YES];
//                self.mWebV_temp.tag = self.mInt_index-1;
//                NSURL *url = [[NSURL alloc] initWithString:model.Abstracts];
//                self.mWebV_temp.scrollView.bounces = NO;
//                self.mWebV_temp.delegate = self;
//                [self.mWebV_temp loadRequest:[NSURLRequest requestWithURL:url]];
                self.mInt_index++;
            });
        }
    }
}

#pragma mark 禁止webview中的链接点击
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    if(navigationType==UIWebViewNavigationTypeLinkClicked){//判断是否是点击链接
        return NO;
    }else{
        return YES;
    }
}

-(void)webViewLoadFinish:(float)height{
    self.mView_titlecell.mWebV_comment.frame = CGRectMake(5, self.mView_titlecell.mView_background.frame.origin.y+self.mView_titlecell.mView_background.frame.size.height, [dm getInstance].width-10, height);
    [self.mView_titlecell.mWebV_comment.scrollView setScrollEnabled:NO];
    //图片
    [self.mView_titlecell.mCollectionV_pic reloadData];
    self.mView_titlecell.mCollectionV_pic.hidden = NO;
    self.mView_titlecell.mCollectionV_pic.frame = self.mView_titlecell.mWebV_comment.frame;
    //时间
    
    self.mView_titlecell.mLab_RecDate.hidden = YES;
    //评论
    self.mView_titlecell.mLab_commentCount.hidden = YES;
    self.mView_titlecell.mLab_comment.hidden = YES;
    //分割线
    self.mView_titlecell.mLab_line.hidden = NO;
    self.mView_titlecell.mLab_line.frame = CGRectMake(0, self.mView_titlecell.mCollectionV_pic.frame.origin.y+self.mView_titlecell.mCollectionV_pic.frame.size.height+5, [dm getInstance].width, .5);
    self.mView_titlecell.mLab_line2.hidden = YES;
    self.mView_titlecell.frame = CGRectMake(0, 0, [dm getInstance].width, self.mView_titlecell.mLab_line.frame.origin.y+1);
    self.mTableV_answer.frame = CGRectMake(0, self.mView_titlecell.frame.origin.y+self.mView_titlecell.frame.size.height, [dm getInstance].width, self.mTableV_answer.contentSize.height);
    
    self.mScrollV_view.contentSize = CGSizeMake([dm getInstance].width, self.mTableV_answer.frame.origin.y+self.mTableV_answer.contentSize.height);
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mModel_recomment.answerArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"KnowledgeTableViewCell";
    KnowledgeTableViewCell *cell = (KnowledgeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[KnowledgeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"KnowledgeTableViewCell" owner:self options:nil];
        //这时myCell对象已经通过自定义xib文件生成了
        if ([nib count]>0) {
            cell = (KnowledgeTableViewCell *)[nib objectAtIndex:0];
            //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
        }
        //添加图片点击事件
        //若是需要重用，需要写上以下两句代码
        UINib * n= [UINib nibWithNibName:@"KnowledgeTableViewCell" bundle:[NSBundle mainBundle]];
        [self.mTableV_answer registerNib:n forCellReuseIdentifier:indentifier];
    }
    //添加点击事件
    //    cell.delegate = self;
//    [cell addTapClick];
    cell.mInt_flag = 1;
    NSMutableArray *array = self.mModel_recomment.answerArray;
    AnswerModel *model = [array objectAtIndex:indexPath.row];
    if ([model.TabID intValue]>0) {
        for (UIView *view in cell.subviews) {
            view.hidden = NO;
        }
    }else{
        for (UIView *view in cell.subviews) {
            view.hidden = YES;
        }
    }
//    AnswerByIdModel *model = [array objectAtIndex:indexPath.row];
    cell.RecommentAnswerModel = model;
    cell.basisImagV.hidden = NO;
    cell.mLab_title.hidden = YES;
    cell.mBtn_detail.hidden = YES;
    //话题
    cell.mLab_Category0.hidden = YES;
    cell.mLab_Category1.hidden = YES;
    //访问
    cell.mLab_ViewCount.hidden = YES;
    cell.mLab_View.hidden = YES;
    //回答
    cell.mLab_AnswersCount.hidden = YES;
    cell.mLab_Answers.hidden = YES;
    //关注
    cell.mLab_AttCount.hidden = YES;
    cell.mLab_Att.hidden = YES;
    //分割线
    cell.mLab_line.hidden = YES;
    //赞
    cell.mLab_LikeCount.hidden = NO;
    //头像
    cell.mImgV_head.hidden = NO;
    //姓名
    cell.mLab_IdFlag.hidden = NO;
    //回答标题
    cell.mLab_ATitle.hidden = NO;
    //回答内容
    cell.mLab_Abstracts.hidden = NO;
    //背景色
    cell.mView_background.hidden = NO;
    //图片
    cell.mCollectionV_pic.hidden = NO;
    //时间
    cell.mLab_RecDate.hidden = NO;
    //评论
    cell.mLab_commentCount.hidden = NO;
    cell.mLab_comment.hidden = NO;
    //分割线
    cell.mLab_line2.hidden = YES;
    cell.mLab_line.frame = CGRectMake(20, 5, [dm getInstance].width-20, .5);
    //赞
    cell.mLab_LikeCount.frame = CGRectMake(9, 10, 42, 22);
    NSString *strLike = model.LikeCount;
    if ([model.LikeCount integerValue]>99) {
        strLike = @"99+";
    }
    cell.mLab_LikeCount.text = [NSString stringWithFormat:@"%@赞",strLike];
    //头像
    cell.mImgV_head.frame = CGRectMake(9, cell.mLab_LikeCount.frame.origin.y+22+10, 42, 42);
    [cell.mImgV_head sd_setImageWithURL:(NSURL *)[NSString stringWithFormat:@"%@%@",AccIDImg,model.JiaoBaoHao] placeholderImage:[UIImage  imageNamed:@"root_img"]];
    //姓名
    CGSize nameSize = [model.IdFlag sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(42, MAXFLOAT)];
    if (nameSize.height>21) {
        nameSize = CGSizeMake(nameSize.width, 30);
        cell.mLab_IdFlag.numberOfLines = 2;
        cell.mLab_IdFlag.frame = CGRectMake(9, cell.mImgV_head.frame.origin.y+42+10, 42, nameSize.height);
    }else{
        cell.mLab_IdFlag.numberOfLines = 1;
        cell.mLab_IdFlag.frame = CGRectMake(9, cell.mImgV_head.frame.origin.y+42+10, 42, nameSize.height);
    }
    
    cell.mLab_IdFlag.text = model.IdFlag;
    //回答标题
    cell.answerImgV.hidden = NO;
    NSString *string1 = model.ATitle;
    string1 = [string1 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string1 = [string1 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    cell.answerImgV.frame = CGRectMake(60, cell.mLab_LikeCount.frame.origin.y, 26, 16);
    NSString *name = [NSString stringWithFormat:@"<font size=12 color=black>%@</font>",string1];
    NSMutableDictionary *row1 = [NSMutableDictionary dictionary];
    [row1 setObject:name forKey:@"text"];
//    cell.mLab_ATitle.lineBreakMode = RTTextLineBreakModeTruncatingTail;
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:[row1 objectForKey:@"text"]];
    cell.mLab_ATitle.componentsAndPlainText = componentsDS;
    CGSize titleSize = [string1 sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake([dm getInstance].width-9-10-cell.answerImgV.frame.size.width-cell.answerImgV.frame.origin.x, MAXFLOAT)];
    cell.mLab_ATitle.frame = CGRectMake(60+cell.answerImgV.frame.size.width+5, cell.mLab_LikeCount.frame.origin.y+2, [dm getInstance].width-9-10-cell.answerImgV.frame.size.width-cell.answerImgV.frame.origin.x, titleSize.height);

    //回答内容
    NSString *name2 = @"";
    if ([model.Flag integerValue]==0) {//无内容
        cell.mView_background.hidden = YES;
        cell.basisImagV.image = [UIImage imageNamed:@"noContent"];
        cell.basisImagV.frame = CGRectMake(cell.mImgV_head.frame.origin.x+cell.mImgV_head.frame.size.width+10, cell.mLab_ATitle.frame.origin.y+cell.mLab_ATitle.frame.size.height+5, 36, 16);
        cell.basisImagV.hidden = NO;
        
    }else if ([model.Flag integerValue]==1){//有内容
        cell.mView_background.hidden = YES;
        cell.mView_background.frame = cell.mImgV_head.frame;
        cell.basisImagV.image = [UIImage imageNamed:@"content"];
        cell.basisImagV.frame = CGRectMake(cell.mImgV_head.frame.origin.x+cell.mImgV_head.frame.size.width+10, cell.mLab_ATitle.frame.origin.y+cell.mLab_ATitle.frame.size.height+5, 26, 16);
    }else if ([model.Flag integerValue]==2){//有证据
        cell.basisImagV.image = [UIImage imageNamed:@"basis"];
        cell.basisImagV.frame = CGRectMake(cell.mImgV_head.frame.origin.x+cell.mImgV_head.frame.size.width+10, cell.mLab_ATitle.frame.origin.y+cell.mLab_ATitle.frame.size.height+5, 29, 29);
    }

    cell.mLab_Abstracts.frame = CGRectMake(63, cell.basisImagV.frame.origin.y+cell.basisImagV.frame.size.height+2, [dm getInstance].width-75, 21);
    NSMutableDictionary *row2 = [NSMutableDictionary dictionary];
    [row2 setObject:name2 forKey:@"text"];
    RTLabelComponentsStructure *componentsDS2 = [RCLabel extractTextStyle:[row2 objectForKey:@"text"]];
    cell.mLab_Abstracts.componentsAndPlainText = componentsDS2;
    cell.mLab_Abstracts.hidden = YES;
    //
    cell.mWebV_comment.hidden = NO;
    cell.mWebV_comment.tag = indexPath.row;
//    cell.mWebV_comment.scalesPageToFit = YES;
    [cell.mWebV_comment.scrollView setScrollEnabled:NO];
    cell.mWebV_comment.scrollView.bounces = NO;
    cell.mWebV_comment.frame = CGRectMake(63, cell.mLab_Abstracts.frame.origin.y, [dm getInstance].width-75, model.floatH);
//    cell.mWebV_comment.userInteractionEnabled = NO;
    cell.mWebV_comment.opaque = NO; //不设置这个值 页面背景始终是白色
    [cell.mWebV_comment setBackgroundColor:[UIColor clearColor]];
    NSString *content = model.Abstracts;
    if (content.length==0&&[model.Flag integerValue]==2) {
        content = @"此答案已被修改";
        NSString *tempHtml = [utils clearHtml:content width:85];
        [cell.mWebV_comment loadHTMLString:tempHtml baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
    }else{
        NSURL *url = [[NSURL alloc] initWithString:model.Abstracts];
        cell.mWebV_comment.scrollView.bounces = NO;
        [cell.mWebV_comment loadRequest:[NSURLRequest requestWithURL:url]];
    }
    
    //背景色
    cell.mView_background.frame = CGRectMake(cell.mWebV_comment.frame.origin.x-2, cell.mWebV_comment.frame.origin.y-3-29, [dm getInstance].width-70, cell.mWebV_comment.frame.size.height+4+29);
    //图片
    [cell.mCollectionV_pic reloadData];
    cell.mCollectionV_pic.backgroundColor = [UIColor clearColor];
    if (model.Thumbnail.count>0) {
        cell.mCollectionV_pic.frame = CGRectMake(63, cell.mView_background.frame.origin.y+cell.mView_background.frame.size.height+5+20, [dm getInstance].width-65, ([dm getInstance].width-65-30)/3);
    }else{
        cell.mCollectionV_pic.frame = cell.mView_background.frame;
    }
    //时间
    cell.mLab_RecDate.frame = CGRectMake(cell.mLab_ATitle.frame.origin.x, cell.mView_background.frame.origin.y+cell.mView_background.frame.size.height+5, cell.mLab_RecDate.frame.size.width, cell.mLab_RecDate.frame.size.height);
    cell.mLab_RecDate.text = model.RecDate;
    //评论
    CGSize commentSize = [[NSString stringWithFormat:@"%@",model.CCount] sizeWithFont:[UIFont systemFontOfSize:10]];
    cell.mLab_commentCount.frame = CGRectMake([dm getInstance].width-9-commentSize.width, cell.mLab_RecDate.frame.origin.y, commentSize.width, cell.mLab_commentCount.frame.size.height);
    cell.mLab_commentCount.text = model.CCount;
    cell.mLab_comment.frame = CGRectMake(cell.mLab_commentCount.frame.origin.x-2-cell.mLab_comment.frame.size.width, cell.mLab_RecDate.frame.origin.y, cell.mLab_View.frame.size.width, cell.mLab_comment.frame.size.height);
    //计算姓名和时间的高度
    float nameF = cell.mLab_IdFlag.frame.origin.y+cell.mLab_IdFlag.frame.size.height;
    float dateF = cell.mLab_RecDate.frame.origin.y+cell.mLab_RecDate.frame.size.height;
    cell.mLab_line2.hidden = NO;
    if (nameF<dateF) {
        cell.mLab_line2.frame = CGRectMake(0, dateF+10, [dm getInstance].width, 10);
    }else{
        cell.mLab_line2.frame = CGRectMake(0, nameF+10, [dm getInstance].width, 10);
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    return [self cellHeight:indexPath];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(float)cellHeight:(NSIndexPath *)indexPath{
    float tempF = 0.0;
    float tempF1 = 0.0;
    NSMutableArray *array = self.mModel_recomment.answerArray;
    AnswerModel *model = [array objectAtIndex:indexPath.row];
    if ([model.TabID intValue]>0) {
        
    }else{
        return tempF;
    }
    
    //赞
    tempF1 = tempF1+10+22;
    //头像
    tempF1 = tempF1+10+42;
    //姓名
    CGSize nameSize = [model.IdFlag sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(42, MAXFLOAT)];
    if (nameSize.height>21) {
        nameSize = CGSizeMake(nameSize.width, 30);
        tempF1 = tempF1+10+nameSize.height;
    }else{
        tempF1 = tempF1+10+nameSize.height;
    }
    tempF1 = tempF1+20;
    
    //回答标题
    NSString *string1 = model.ATitle;
    string1 = [string1 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string1 = [string1 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//    cell.answerImgV.frame = CGRectMake(60, cell.mLab_LikeCount.frame.origin.y, 26, 16);
    CGSize titleSize = [string1 sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake([dm getInstance].width-9-10-26-60, MAXFLOAT)];
    tempF = tempF+10+3+titleSize.height;
    if ([model.Flag integerValue]==0) {//无内容
        tempF = tempF+5+16;
    }else if ([model.Flag integerValue]==1){//有内容
        tempF = tempF+5+16;
    }else if ([model.Flag integerValue]==2){//有证据
        tempF = tempF+5+29;
    }
    tempF = tempF+21;
    //
    tempF = tempF+model.floatH;
    
    //背景色
    //图片
    //时间
    tempF = tempF+5+21;
    //计算姓名和时间的高度
    if (tempF<tempF1) {
        return tempF1;
    }else{
        return tempF;
    }
}

//详情按钮
-(void)KnowledgeTableVIewCellDetailBtn:(KnowledgeTableViewCell *) knowledgeTableViewCell{
    CheckNetWorkSelfView
    KnowledgeQuestionViewController *queston = [[KnowledgeQuestionViewController alloc] init];
    QuestionModel *model = [[QuestionModel alloc] init];
    model.TabID = self.mModel_question.TabID;
    model.ViewCount = self.mModel_question.ViewCount;
    model.AttCount = self.mModel_question.AttCount;
    model.AnswersCount = self.mModel_question.AnswersCount;
    model.Title = self.mModel_question.Title;
    model.CategorySuject = self.mModel_question.CategorySuject;
    model.CategoryId = self.mModel_question.CategoryId;
    queston.mModel_question = model;
    [utils pushViewController:queston animated:YES];
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

//导航条返回按钮回调
-(void)myNavigationGoback{
    self.mView_titlecell = nil;
    self.mTableV_answer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [utils popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
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
