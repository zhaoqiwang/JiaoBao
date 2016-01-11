//
//  KnowledgeAddAnswerViewController.m
//  JiaoBao
//
//  Created by Zqw on 15/8/11.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "KnowledgeAddAnswerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "IQKeyboardManager.h"
#import "TFHpple.h"

@interface KnowledgeAddAnswerViewController ()
@property(nonatomic,assign)NSRange cursorPosition;

@end

@implementation KnowledgeAddAnswerViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
    //问题详情
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"QuestionDetail" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QuestionDetail:) name:@"QuestionDetail" object:nil];
    //提交答案
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AddAnswer" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddAnswer:) name:@"AddAnswer" object:nil];
    //上传图片
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UploadImg" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UploadImg:) name:@"UploadImg" object:nil];
    //获取答案详情
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"AnswerDetailWithAId" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(AnswerDetailWithAId:) name:@"AnswerDetailWithAId" object:nil];
    //修改答案
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UpdateAnswer" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(AddAnswer:) name:@"UpdateAnswer" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mInt_index = 1;

    
    self.mArr_pic = [NSMutableArray array];
    self.mInt_flag = 0;
    //输入框弹出键盘问题
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;//控制整个功能是否启用
    manager.shouldResignOnTouchOutside = YES;//控制点击背景是否收起键盘
    manager.shouldToolbarUsesTextFieldTintColor = NO;//控制键盘上的工具条文字颜色是否用户自定义
    manager.enableAutoToolbar = NO;//控制是否显示键盘上的工具条
    
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:[NSString stringWithFormat:@"%@",self.mModel_question.Title]];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    
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
    //添加边框
    self.mTextV_answer.layer.borderWidth = .5;
    self.mTextV_answer.layer.borderColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    //将图层的边框设置为圆脚
    self.mTextV_answer.layer.cornerRadius = 5;
    self.mTextV_answer.layer.masksToBounds = YES;
    //添加边框
    self.mTextV_content.layer.borderWidth = .5;
    self.mTextV_content.layer.borderColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    //将图层的边框设置为圆脚
    self.mTextV_content.layer.cornerRadius = 5;
    self.mTextV_content.layer.masksToBounds = YES;
    //依据审核
    self.mSigleBtn = [[SigleBtnView alloc] initWidth:0 height:40 title:@"依据审核" select:1 sigle:0];
    [self.mScrollV_view addSubview:self.mSigleBtn];
    self.mSigleBtn.hidden = YES;
    //问题明细
    [[KnowledgeHttp getInstance] QuestionDetailWithQId:self.mModel_question.TabID];
    //如果已经回答过，取自己回答的答案明细
    if ([self.mStr_MyAnswerId intValue]>0) {
        [[KnowledgeHttp getInstance] AnswerDetailWithAId:self.mStr_MyAnswerId];
    }
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
}

//答案详情回调
-(void)AnswerDetailWithAId:(id)sender{
    NSDictionary *dic = [sender object];
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
    NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
    if([ResultCode integerValue]!=0){
        [MBProgressHUD showError:ResultDesc];
    }else{
        AnswerDetailModel *model = [dic objectForKey:@"model"];
        self.mTextV_answer.text = model.ATitle;
//        NSString *contentStr = [model.AContent stringByReplacingOccurrencesOfString:@"<img " withString:@"<img height=\"30\" width=\"30\""];
//        NSString *content = contentStr;
//        content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<p>"] withString:@""];
//        content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"</p>"] withString:@""];
        //content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"</br>"] withString:@"\r"];
//        NSDictionary *options = @{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType};
//        NSAttributedString *string = [[NSAttributedString alloc] initWithData:[content dataUsingEncoding:NSUnicodeStringEncoding] options:options documentAttributes:nil error:nil];
//        //textView是UITextView
//        self.mTextV_content.attributedText = string;
        NSData* htmlData = [model.AContent dataUsingEncoding:NSUTF8StringEncoding];
        
        TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
        NSArray *aArray = [xpathParser searchWithXPathQuery:@"//img"];
                model.AContent = [model.AContent stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<p>"] withString:@""];
                model.AContent = [model.AContent stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"</p>"] withString:@""];
        model.AContent = [model.AContent stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"</br>"] withString:@"\r"];
        model.AContent =[model.AContent stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<br>"] withString:@""];
        model.AContent =[model.AContent stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<br/>"] withString:@""];


        NSString *contentText = model.AContent;
        NSString *tempStr = model.AContent;
        for (int i =0; i < aArray.count; i++) {
            TFHppleElement *aElement = [aArray objectAtIndex:i];
            NSDictionary *aAttributeDict = [aElement attributes];
            NSString *srcStr = [aAttributeDict objectForKey:@"src"];
            NSString *_srcStr = [aAttributeDict objectForKey:@"src"];
            contentText = [contentText stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"_src=\"%@\"",_srcStr] withString:@""];
            contentText = [contentText stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"_src='%@'",_srcStr] withString:@""];
            tempStr = [tempStr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"_src=\"%@\"",_srcStr] withString:@""];
            tempStr = [tempStr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"_src='%@'",_srcStr] withString:@""];
            UploadImgModel *ImgModel = [[UploadImgModel alloc]init];
            if([tempStr containsString:srcStr]){
                ImgModel.url = [NSString stringWithFormat:@"<img src='%@'/>",srcStr];
                if(![tempStr containsString:ImgModel.url]){
                    ImgModel.url = [NSString stringWithFormat:@"<img src=\"%@\" />",srcStr];

                }
                if(![tempStr containsString:ImgModel.url]){
                    ImgModel.url = [NSString stringWithFormat:@"<img src='%@' />",srcStr];
                    
                }
                if(![tempStr containsString:ImgModel.url]){
                    ImgModel.url = [NSString stringWithFormat:@"<img src=\"%@\"/>",srcStr];
                    
                }

            }


            ImgModel.originalName = @"";
            ImgModel.size = @"";
            ImgModel.type = @"";
            
            NSRange range = [contentText rangeOfString:ImgModel.url];
            ImgModel.cursorPosition = NSMakeRange(range.location, 1);
            tempStr = [tempStr stringByReplacingOccurrencesOfString:ImgModel.url withString:@""];
            contentText = [contentText stringByReplacingOccurrencesOfString:ImgModel.url withString:@" "];
            NSLog(@"contentText = %@ tempStr = %@",contentText,tempStr);

            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:srcStr]]];
            NSTextAttachment *textAttach = [[NSTextAttachment alloc]init];
            textAttach.image = image;
            textAttach.bounds=CGRectMake(0, 0, 30, 30);
            NSAttributedString *strA = [NSAttributedString attributedStringWithAttachment:textAttach];
            ImgModel.attributedString = strA;
            [self.mArr_pic addObject:ImgModel];
            
        }
        NSMutableAttributedString *str=[[NSMutableAttributedString alloc] initWithString:tempStr];

        for(long i=0;i<self.mArr_pic.count;i++){
            UploadImgModel *imgModel = [self.mArr_pic objectAtIndex:i];
            [str insertAttributedString:imgModel.attributedString atIndex:imgModel.cursorPosition.location];
        }
        self.mTextV_content.attributedText = str;

        

        self.mLab_answer.hidden = YES;
        self.mLab_content.hidden = YES;
        //切换按钮显示标题
        [self.mBtn_submit setTitle:@"修改答案" forState:UIControlStateNormal];
        [self.mBtn_anSubmit setTitle:@"匿名修改" forState:UIControlStateNormal];
    }
}
//如果解析的网页不是utf8编码，如gbk编码，可以先将其转换为utf8编码再对其进行解析

-(NSData *) toUTF8:(NSData *)sourceData {
    CFStringRef gbkStr = CFStringCreateWithBytes(NULL, [sourceData bytes], [sourceData length], kCFStringEncodingGB_18030_2000, false);
    
    if (gbkStr == NULL) {
        return nil;
    } else {
        NSString *gbkString = (__bridge NSString *)gbkStr;
        //根据网页源代码中编码方式进行修改，此处为从gbk转换为utf8
        NSString *utf8_String = [gbkString stringByReplacingOccurrencesOfString:@"META http-equiv=\"Content-Type\" content=\"text/html; charset=GBK\""
                                                                     withString:@"META http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\""];
        
        return [utf8_String dataUsingEncoding:NSUTF8StringEncoding];
    }
}
//提交答案
-(void)AddAnswer:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSMutableDictionary *dic = noti.object;
    NSString *code = [dic objectForKey:@"code"];
    NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
    if ([code integerValue]==0) {
        [MBProgressHUD showSuccess:ResultDesc ];

//        self.mTextV_content.text = @"";
//        self.mTextV_answer.text = @"";
//        self.mLab_answer.hidden = NO;
//        self.mLab_content.hidden = NO;
        //切换按钮显示标题
        [self.mBtn_submit setTitle:@"修改答案" forState:UIControlStateNormal];
        [self.mBtn_anSubmit setTitle:@"匿名修改" forState:UIControlStateNormal];
        
        if ([self.mStr_MyAnswerId intValue]>0) {
            
        }else{
            self.mView_titlecell.mLab_AnswersCount.text = [NSString stringWithFormat:@"%d",[self.mModel_questionDetail.AnswersCount intValue]+1];
            self.mModel_questionDetail.AnswersCount = [NSString stringWithFormat:@"%d",[self.mModel_questionDetail.AnswersCount intValue]+1];
            self.mStr_MyAnswerId = [dic objectForKey:@"Data"];
        }
//        if (self.mInt_flag==1) {
//            //问题明细
//            [[KnowledgeHttp getInstance] QuestionDetailWithQId:self.mModel_question.TabID];
//        }
        [self.mTextV_answer resignFirstResponder];
        [self.mTextV_content resignFirstResponder];
        //通知其余界面，更新答案数据
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updataQuestionDetailModel" object:self.mModel_questionDetail];
        //通知其余界面，更新访问量等数据
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updataQuestionDetail" object:self.mModel_questionDetail];
        //界面显示，停留2秒
        [MBProgressHUD showSuccess:ResultDesc toView:self.view];
        D("dufghdjfgh-====%d",self.mInt_view);
        if (self.mInt_view == 1) {
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(myNavigationGoback) userInfo:nil repeats:NO];
        }else{
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(gotoView) userInfo:nil repeats:NO];
            
        }
    }else{
        [MBProgressHUD showSuccess:ResultDesc toView:self.view];
    }
}

-(void)gotoView{
    KnowledgeQuestionViewController *queston = [[KnowledgeQuestionViewController alloc] init];
    queston.mModel_question = self.mModel_question;
    [utils pushViewController:queston animated:YES];
}

//问题详情
-(void)QuestionDetail:(NSNotification *)noti{
    NSMutableDictionary *dic = noti.object;
    NSString *code = [dic objectForKey:@"code"];
    if ([code integerValue] ==0) {
        self.mModel_questionDetail = [dic objectForKey:@"model"];
        if ([self.mModel_questionDetail.QFlag intValue] == 1) {
            self.mLab_content.text = @"答案内容(可选)回答该问题最好提供依据";
        }else{
            self.mLab_content.text = @"内容描述，不少于5个字";
        }
        //通知其余界面，更新访问量等数据
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updataQuestionDetail" object:self.mModel_questionDetail];
        if (self.mInt_flag ==0) {
            [self addDetailCell:self.mModel_questionDetail];
            //判断是否发送自己的答案详情协议
            if ([self.mStr_MyAnswerId intValue]>0) {
                
            }else{
                if ([self.mModel_questionDetail.MyAnswerId intValue]>0) {
                    self.mStr_MyAnswerId = self.mModel_questionDetail.MyAnswerId;
//                    self.mBtn_anSubmit.hidden = YES;
                    [[KnowledgeHttp getInstance] AnswerDetailWithAId:self.mModel_questionDetail.MyAnswerId];//答案明细
                }
            }
        }
    }else{
        [MBProgressHUD hideHUDForView:self.view];
        NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
        [MBProgressHUD showSuccess:ResultDesc toView:self.view];
    }
}

-(void)addDetailCell:(QuestionDetailModel *)model{
    self.mView_titlecell.hidden = NO;
    self.mView_titlecell.askImgV.hidden = NO;
    //标题
//    self.mView_titlecell.mLab_title.frame = CGRectMake(9, 10, [dm getInstance].width-9*2, 16);
//    NSString *title1 = [model.Title stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    title1 = [title1 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//    self.mView_titlecell.mLab_title.text = title1;
//    [self.mView_titlecell.mLab_title setNumberOfLines:0];
//    self.mView_titlecell.mLab_title.lineBreakMode = NSLineBreakByWordWrapping;//换行方式
//    CGSize labelsize = [title1 sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake([dm getInstance].width-9*2,99999) lineBreakMode:NSLineBreakByWordWrapping];
//    self.mView_titlecell.mLab_title.frame = CGRectMake(9, 10, [dm getInstance].width-9*2, labelsize.height);
    self.mView_titlecell.mLab_title.hidden = NO;
    NSString *string1 = model.Title;
    string1 = [string1 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string1 = [string1 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    self.mView_titlecell.askImgV.frame = CGRectMake(9, 10, 19, 19);
    NSString *name = [NSString stringWithFormat:@"<font size=14 color=#2589D1>%@</font>",string1];
    NSMutableDictionary *row1 = [NSMutableDictionary dictionary];
    [row1 setObject:name forKey:@"text"];
    self.mView_titlecell.mLab_title.lineBreakMode = RTTextLineBreakModeCharWrapping;
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:[row1 objectForKey:@"text"]];
    self.mView_titlecell.mLab_title.componentsAndPlainText = componentsDS;
    CGSize titleSize = [self.mView_titlecell.mLab_title optimumSize];
    self.mView_titlecell.mLab_title.frame = CGRectMake(10+self.mView_titlecell.askImgV.frame.size.width, 10, [dm getInstance].width-9*2- self.mView_titlecell.answerImgV.frame.size.width, titleSize.height);
    //详情
    self.mView_titlecell.mBtn_detail.hidden = YES;
    //话题
    self.mView_titlecell.mLab_Category0.frame = CGRectMake(30, self.mView_titlecell.mLab_title.frame.origin.y+self.mView_titlecell.mLab_title.frame.size.height+5, self.mView_titlecell.mLab_Category0.frame.size.width, 21);
    CGSize CategorySize = [[NSString stringWithFormat:@"%@",self.mModel_question.CategorySuject] sizeWithFont:[UIFont systemFontOfSize:10]];
    self.mView_titlecell.mLab_Category1.frame = CGRectMake(30+self.mView_titlecell.mLab_Category0.frame.size.width+2, self.mView_titlecell.mLab_Category0.frame.origin.y, CategorySize.width, 21);
    self.mView_titlecell.mLab_Category1.text = self.mModel_question.CategorySuject;
    self.mView_titlecell.mLab_Category1.hidden = NO;
    self.mView_titlecell.mLab_Category0.hidden = NO;
    //访问
    CGSize ViewSize = [[NSString stringWithFormat:@"%@",model.ViewCount] sizeWithFont:[UIFont systemFontOfSize:10]];
    self.mView_titlecell.mLab_ViewCount.frame = CGRectMake([dm getInstance].width-9-ViewSize.width, self.mView_titlecell.mLab_Category0.frame.origin.y, ViewSize.width, 21);
    self.mView_titlecell.mLab_ViewCount.text = model.ViewCount;
    self.mView_titlecell.mLab_ViewCount.hidden = NO;
    self.mView_titlecell.mLab_View.frame = CGRectMake(self.mView_titlecell.mLab_ViewCount.frame.origin.x-2-self.mView_titlecell.mLab_View.frame.size.width, self.mView_titlecell.mLab_Category0.frame.origin.y, self.mView_titlecell.mLab_View.frame.size.width, 21);
    self.mView_titlecell.mLab_View.hidden = NO;
    //回答
    CGSize AnswersSize = [[NSString stringWithFormat:@"%@",model.AnswersCount] sizeWithFont:[UIFont systemFontOfSize:10]];
    self.mView_titlecell.mLab_AnswersCount.frame = CGRectMake(self.mView_titlecell.mLab_View.frame.origin.x-5-AnswersSize.width, self.mView_titlecell.mLab_Category0.frame.origin.y, AnswersSize.width+10, 21);
    self.mView_titlecell.mLab_AnswersCount.text = model.AnswersCount;
    self.mView_titlecell.mLab_AnswersCount.hidden = NO;
    self.mView_titlecell.mLab_Answers.frame = CGRectMake(self.mView_titlecell.mLab_AnswersCount.frame.origin.x-2-self.mView_titlecell.mLab_Answers.frame.size.width, self.mView_titlecell.mLab_Category0.frame.origin.y, self.mView_titlecell.mLab_Answers.frame.size.width, 21);
    self.mView_titlecell.mLab_Answers.hidden = NO;
    //关注
    CGSize AttSize = [[NSString stringWithFormat:@"%@",model.AttCount] sizeWithFont:[UIFont systemFontOfSize:10]];
    self.mView_titlecell.mLab_AttCount.frame = CGRectMake(self.mView_titlecell.mLab_Answers.frame.origin.x-5-AttSize.width, self.mView_titlecell.mLab_Category0.frame.origin.y, AttSize.width, 21);
    self.mView_titlecell.mLab_AttCount.text = model.AttCount;
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
//    NSString *string2 = model.KnContent;
//    string2 = [string2 stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
//    string2 = [string2 stringByReplacingOccurrencesOfString:@"\r\r" withString:@""];
//    NSString *name2 = [NSString stringWithFormat:@"<font size=14 color='red'>详情 : </font> <font>%@</font>", string2];
//    NSString *string = [NSString stringWithFormat:@"详情 : %@",string2];
//    CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake([dm getInstance].width-18, 1000)];
//    self.mView_titlecell.mLab_Abstracts.frame = CGRectMake(9, self.mView_titlecell.mView_background.frame.origin.y+self.mView_titlecell.mView_background.frame.size.height+10, [dm getInstance].width-18, size.height);
//    NSMutableDictionary *row2 = [NSMutableDictionary dictionary];
//    [row2 setObject:name2 forKey:@"text"];
//    RTLabelComponentsStructure *componentsDS2 = [RCLabel extractTextStyle:[row2 objectForKey:@"text"]];
//    self.mView_titlecell.mLab_Abstracts.componentsAndPlainText = componentsDS2;
    //webview
    self.mView_titlecell.mWebV_comment.hidden = NO;
    [self.mView_titlecell.mWebV_comment.scrollView setScrollEnabled:NO];
    self.mView_titlecell.mWebV_comment.tag = -1;
    self.mView_titlecell.mWebV_comment.delegate = self;
    NSString *content = model.KnContent;
//    D("doifjgj-===kncontent-=====%@",model.KnContent);
    NSString *tempHtml = [utils clearHtml:content width:18];
    [self.mView_titlecell.mWebV_comment loadHTMLString:tempHtml baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
    //加载
    [self webViewLoadFinish:0 Width:0];
}

-(void)webViewLoadFinish:(float)height Width:(float)width{
    self.mView_titlecell.mWebV_comment.frame = CGRectMake(0, self.mView_titlecell.mView_background.frame.origin.y+self.mView_titlecell.mView_background.frame.size.height, [dm getInstance].width, height);
    self.mView_titlecell.mWebV_comment.scrollView.contentSize = CGSizeMake(width, height);
    //图片
    [self.mView_titlecell.mCollectionV_pic reloadData];
    self.mView_titlecell.mCollectionV_pic.hidden = NO;
//    if (model.Thumbnail.count>0) {
//        self.mView_titlecell.mCollectionV_pic.frame = CGRectMake(9, self.mView_titlecell.mLab_Abstracts.frame.origin.y+self.mView_titlecell.mLab_Abstracts.frame.size.height+5, [dm getInstance].width-65, ([dm getInstance].width-65-30)/3);
//    }else{
        self.mView_titlecell.mCollectionV_pic.frame = self.mView_titlecell.mWebV_comment.frame;
//    }
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
    
    //回答
    self.mTextV_answer.frame = CGRectMake(9, self.mView_titlecell.frame.origin.y+self.mView_titlecell.frame.size.height+10, [dm getInstance].width-18, 30);
    //内容描述
    self.mTextV_content.frame = CGRectMake(9, self.mTextV_answer.frame.origin.y+self.mTextV_answer.frame.size.height+10, [dm getInstance].width-27-40, 60);
    //照片按钮
    self.mBtn_photo.frame = CGRectMake([dm getInstance].width-49, self.mTextV_content.frame.origin.y, 40, 40);
    //依据审核
    self.mSigleBtn.hidden = NO;
    self.mSigleBtn.frame = CGRectMake(([dm getInstance].width-70*2-30*2-self.mSigleBtn.frame.size.width)/2, self.mTextV_content.frame.origin.y+self.mTextV_content.frame.size.height+10, self.mSigleBtn.frame.size.width, self.mSigleBtn.frame.size.height);
    //提交按钮
    self.mBtn_submit.frame = CGRectMake(self.mSigleBtn.frame.origin.x+self.mSigleBtn.frame.size.width+30, self.mTextV_content.frame.origin.y+self.mTextV_content.frame.size.height+10, 70, self.mBtn_submit.frame.size.height);
    self.mBtn_anSubmit.frame = CGRectMake(self.mBtn_submit.frame.origin.x+100, self.mBtn_submit.frame.origin.y, 70, self.mBtn_submit.frame.size.height);
    //提示信息坐标
    [self placeTextFrame];
    self.mScrollV_view.contentSize = CGSizeMake([dm getInstance].width, self.mBtn_submit.frame.origin.y+self.mBtn_submit.frame.size.height+20);
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:self.view];
    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%d, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", [dm getInstance].width];
    [webView stringByEvaluatingJavaScriptFromString:meta];
    CGFloat webViewHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"]floatValue];
    CGFloat webViewWidth = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollWidth"]floatValue];
    [self webViewLoadFinish:webViewHeight+10 Width:webViewWidth];
}

-(void)placeTextFrame{
    self.mLab_answer.frame = CGRectMake(12, self.mTextV_answer.frame.origin.y+3, self.mLab_answer.frame.size.width, self.mLab_answer.frame.size.height);
    self.mLab_content.frame = CGRectMake(12, self.mTextV_content.frame.origin.y+3, self.mLab_content.frame.size.width, self.mLab_content.frame.size.height);
}

-(IBAction)mBtn_submit:(id)sender{
    [self submitAnswer:0];
}
-(IBAction)mBtn_anSubmit:(id)sender{
    [self submitAnswer:1];
}
-(IBAction)mBtn_photo:(id)sender{
    self.cursorPosition = [self.mTextV_content selectedRange];
    [self.mTextV_content resignFirstResponder];
    [self.mTextV_answer resignFirstResponder];
    if(self.mArr_pic.count>=20)
    {
        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你只能上传20张图片" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertview show];
        return;
    }
    //先判断是否加入单位，没有，则不能进行交互
    JoinUnit
    //没有昵称，不能对求知进行输入性操作
    NoNickName
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照", @"从相册选择", nil];
    }else {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
    }
    
    sheet.tag = 255;
    [sheet showInView:self.view];
    self.tfContentTag = self.mArr_pic.count;

}

//提交答案
-(void)submitAnswer:(int)flag{
    //先判断是否加入单位，没有，则不能进行交互
    JoinUnit
    //没有昵称，不能对求知进行输入性操作
    NoNickName
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    self.mInt_flag = 1;
    if ([utils isBlankString:self.mTextV_answer.text]) {
        [MBProgressHUD showError:@"请输入答案标题" toView:self.view];
        return;
    }
    if (self.mTextV_answer.text.length>100) {
        [MBProgressHUD showError:@"答案标题超出限制" toView:self.view];
        return;
    }
    
    //计算除去图片后的汉字,计算内容中图片的大小
    NSString *tempcontent = self.mTextV_content.text;
    float tempF = 0;
    for (int i=0; i<self.mArr_pic.count; i++) {
        UploadImgModel *model = [self.mArr_pic objectAtIndex:i];
        NSString *temp = model.originalName;
        NSRange range = [tempcontent rangeOfString:temp];//判断字符串是否包含
        if (range.length >0){//包含
            tempF = tempF+[model.size floatValue];
        }
        tempcontent = [tempcontent stringByReplacingOccurrencesOfString:temp withString:@""];
    }
    if (tempcontent.length>0) {
        if ([utils isBlankString:tempcontent]) {
            [MBProgressHUD showError:@"请输入答案内容" toView:self.view];
            return;
        }
    }
    if (tempcontent.length<5&&tempcontent.length>0) {
        [MBProgressHUD showError:@"内容描述不得少于五个字" toView:self.view];
        return;
    }
    //图片总大小，需小于10M
    if (tempF>=1024*1024*1000) {
        [MBProgressHUD showError:@"内容或图片输入不得超过10M" toView:self.view];
        return;
    }
    NSString *name = @"";
    if (flag ==0) {
        name = [dm getInstance].NickName;
    }
    UITextView *tempView = [[UITextView alloc]init];
    tempView.attributedText = self.mTextV_content.attributedText;
    for (long i=self.mArr_pic.count-1; i<self.mArr_pic.count; i--) {
        UploadImgModel *model = [self.mArr_pic objectAtIndex:i];
        NSRange range = NSMakeRange(model.cursorPosition.location, 1);
        //NSString *temp = model.originalName;
        //content = [content stringByReplacingOccurrencesOfString:temp withString:model.url];
        NSMutableAttributedString *strz =  [[NSMutableAttributedString alloc]initWithAttributedString: tempView.attributedText];
        [strz replaceCharactersInRange:range withString:model.url];
        tempView.attributedText = strz;
        
    }
    NSString *content = tempView.text;
//    for (int i=0; i<self.mArr_pic.count; i++) {
//        UploadImgModel *model = [self.mArr_pic objectAtIndex:i];
//        NSString *temp = model.originalName;
//        content = [content stringByReplacingOccurrencesOfString:temp withString:model.url];
//    }
    if (content.length>4000) {
        [MBProgressHUD showError:@"您输入内容字数过多" toView:self.view];
        return;
    }
//    content = [NSString stringWithFormat:@"<p>%@</p>",content];
    //如果已经回答过
    content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"\n"] withString:@"</br>"];

    content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"\r"] withString:@"</br>"];
    if ([self.mStr_MyAnswerId intValue]>0) {
        [[KnowledgeHttp getInstance] UpdateAnswerWithTabID:self.mStr_MyAnswerId Title:self.mTextV_answer.text AContent:content UserName:name Flag:[NSString stringWithFormat:@"%d",self.mSigleBtn.mInt_flag]];
    }else{
        [[KnowledgeHttp getInstance] AddAnswerWithQId:self.mModel_question.TabID Title:self.mTextV_answer.text AContent:content UserName:name Flag:[NSString stringWithFormat:@"%d",self.mSigleBtn.mInt_flag]];
    }
    [MBProgressHUD showMessage:@"提交中..." toView:self.view];
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange {
    return YES;
}

//如果输入超过规定的字数100，就不再让输入
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //输入删除时
    if ([text isEqualToString:@""]) {
        if([textView isEqual:self.mTextV_content]){
            NSMutableArray *picArr = [self.mArr_pic mutableCopy];
            for (int i=0; i<self.mArr_pic.count; i++) {
                UploadImgModel *model = [self.mArr_pic objectAtIndex:i];
                if(range.length==1){
                    if(range.location < model.cursorPosition.location){
                        model.cursorPosition = NSMakeRange(model.cursorPosition.location-1, model.cursorPosition.length);
                    }
                    else{
                        if(range.location == model.cursorPosition.location ){
                            [self.mArr_pic removeObject:model];
                            i--;
                        }
                        
                    }
                } else{
                    if(range.location<=model.cursorPosition.location&&range.location+range.length>model.cursorPosition.location){
                        [self.mArr_pic removeObject:model];
                        i--;
                        
                    }
                    else if(range.location<=model.cursorPosition.location&&range.location+range.length<=model.cursorPosition.location){
                        model.cursorPosition = NSMakeRange(model.cursorPosition.location-range.length, model.cursorPosition.length);
                        
                    }else if(range.location>model.cursorPosition.location){
                        
                    }
                }
                
                
            }
            
        }

        return YES;
    }

    // Any new character added is passed in as the "text" parameter
    if ([self.mTextV_answer isFirstResponder]) {
        {
            if(range.location==99&&text.length==1)
            {
                NSLog(@"text = %@",text);
                
                if([text isEqualToString:@"➋"])
                {
                    text = @"a";
                }else if([text isEqualToString:@"➌"]){
                    text = @"d";
                }else if([text isEqualToString:@"➍"]){
                    text = @"g";
                }else if([text isEqualToString:@"➎"]){
                    text = @"j";
                }else if([text isEqualToString:@"➏"]){
                    text = @"m";
                }else if([text isEqualToString:@"➐"]){
                    text = @"p";
                }else if([text isEqualToString:@"➑"]){
                    text = @"t";
                }else if([text isEqualToString:@"➒"]){
                    text = @"w";
                }else if([text isEqualToString:@"☻"]){
                    text = @"^";
                }else {
                }
            }
            NSString *Sumstr = [NSString stringWithFormat:@"%@%@",textView.text,text];
            if(Sumstr.length>99)
            {
                textView.text = [Sumstr substringToIndex:100];
                if ([self.mTextV_answer isFirstResponder]){
                    self.mLab_answer.hidden = YES;
 
                }
                return NO;
            }
        }

        if ([text isEqualToString:@"\n"]) {
            text = @" ";
            textView.text = [NSString stringWithFormat:@"%@ ",textView.text];
            self.mLab_answer.hidden = YES;
            // Be sure to test for equality using the "isEqualToString" message
            
            // Return FALSE so that the final '\n' character doesn't get added
            return NO;
        }
    } else{
        for (int i=0; i<self.mArr_pic.count; i++) {
            UploadImgModel *model = [self.mArr_pic objectAtIndex:i];
            if(range.location <= model.cursorPosition.location){
                model.cursorPosition = NSMakeRange(model.cursorPosition.location+text.length, model.cursorPosition.length);
            }
            
        }
    }


    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}

//点击开始编辑：
-(void)textViewDidBeginEditing:(UITextView *)textView{
    //先判断是否加入单位，没有，则不能进行交互
    JoinUnitTextV
    //没有昵称，不能交互
    NoNickNameTextV
}

//在这个地方计算输入的字数
- (void)textViewDidChange:(UITextView *)textView{
    if([textView isEqual:self.mTextV_answer])
        {
            if(textView.text.length>100)
            {
                textView.text = [textView.text substringToIndex:100];
            }
        }
    int  textL =(int)[textView.text length];
    if ([self.mTextV_answer isFirstResponder]) {
        if (textL==0) {
            self.mLab_answer.hidden = NO;
        }else{
            self.mLab_answer.hidden = YES;
        }
    }else if ([self.mTextV_content isFirstResponder]) {
        if (textL==0) {
            self.mLab_content.hidden = NO;
        }else{
            self.mLab_content.hidden = YES;
        }
    }
}

#pragma mark - action sheet delegte
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    return;
                case 1: //相机
                {
                    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                    imagePickerController.delegate = self;
                    imagePickerController.allowsEditing = NO;
                    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
                        self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
                    }
//                    self.tfContentTag = self.mArr_pic.count;
                    [self presentViewController:imagePickerController animated:YES completion:^{}];
                }
                    break;
                case 2: //相册
                {
                    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
                    
                    elcPicker.maximumImagesCount = 1; //Set the maximum number of images to select to 10
                    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
                    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
                    elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
                    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage]; //Supports image and movie types
                    
                    elcPicker.imagePickerDelegate = self;
//                    self.tfContentTag= self.mArr_pic.count;
                    
                    [self presentViewController:elcPicker animated:YES completion:nil];
                }
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                return;
            } else {
                ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
                
                elcPicker.maximumImagesCount = 1; //Set the maximum number of images to select to 10
                elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
                elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
                elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
                elcPicker.mediaTypes = @[(NSString *)kUTTypeImage]; //Supports image and movie types
                
                elcPicker.imagePickerDelegate = self;
//                self.tfContentTag= self.mArr_pic.count;
                
                [self presentViewController:elcPicker animated:YES completion:nil];
            }
            
        }
        
        
    }
}

//上传图片回调
-(void)UploadImg:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSMutableDictionary *dic = noti.object;
    NSString *flag = [dic objectForKey:@"flag"];
    if ([flag integerValue]==0) {
        self.imageCount--;
        UploadImgModel *model = [dic objectForKey:@"model"];
        if(self.imageCount == 0)
        {
            [MBProgressHUD showSuccess:@"上传成功" toView:self.view];
            NSInteger index = self.cursorPosition.location;
            for (int i=0; i<self.mArr_pic.count; i++) {
                UploadImgModel *model = [self.mArr_pic objectAtIndex:i];
                if(index <= model.cursorPosition.location){
                    model.cursorPosition = NSMakeRange(model.cursorPosition.location+1, model.cursorPosition.length);
                }
                
                
                
            }
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *tempPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"file-%@",[dm getInstance].jiaoBaoHao]];
            NSString *imgPath=[tempPath stringByAppendingPathComponent:[NSString stringWithFormat:@"[图片%d].png",self.mInt_index-1]];
            UIImage *image = [UIImage imageWithContentsOfFile:imgPath];
            NSMutableAttributedString *str=[[NSMutableAttributedString alloc] initWithAttributedString:self.mTextV_content.attributedText];
            NSTextAttachment *textAttach = [[NSTextAttachment alloc]init];
            textAttach.image = image;
            textAttach.bounds=CGRectMake(0, 0, 30, 30);
            model.cursorPosition = self.cursorPosition;
            NSAttributedString *strA = [NSAttributedString attributedStringWithAttachment:textAttach];
            [str insertAttributedString:strA atIndex:index];
            model.attributedString = strA;
            self.mTextV_content.attributedText = str;
            [self.mArr_pic addObject:model];
            
            NSArray *arr = [self.mArr_pic sortedArrayUsingComparator:^NSComparisonResult(UploadImgModel *p1, UploadImgModel *p2){
                
                NSNumber *p1_num = [NSNumber numberWithInteger:p1.cursorPosition.location ];
                NSNumber *p2_num = [NSNumber numberWithInteger:p2.cursorPosition.location ];
                
                return [p1_num compare:p2_num];
            }];
            self.mArr_pic =[NSMutableArray arrayWithArray:arr];

        }
        self.mLab_content.hidden = YES;
    }else{
        [MBProgressHUD showError:@"失败" toView:self.view];
    }
}
#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    self.imageCount = 1;
    D("info_count = %ld",(unsigned long)info.count);
    [picker dismissViewControllerAnimated:YES completion:^{
        
        
        
    }];
    [MBProgressHUD showMessage:@"正在上传" toView:self.view];
    
    UIImage* image=[info objectForKey:UIImagePickerControllerEditedImage];
    if (!image) {
        image=[info objectForKey:UIImagePickerControllerOriginalImage];
    }
    image = [self fixOrientation:image];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *tempPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"file-%@",[dm getInstance].jiaoBaoHao]];
    //判断文件夹是否存在
    if(![fileManager fileExistsAtPath:tempPath]) {//如果不存在
        [fileManager createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSData *imageData = UIImageJPEGRepresentation(image,0);
    NSString *imgPath=[tempPath stringByAppendingPathComponent:[NSString stringWithFormat:@"[图片%d].png",self.mInt_index]];
    D("图片路径是：%@",imgPath);
    
    
    BOOL yesNo=[[NSFileManager defaultManager] fileExistsAtPath:imgPath];
    if (!yesNo) {//不存在，则直接写入后通知界面刷新
        BOOL result = [imageData writeToFile:imgPath atomically:YES];
        for (;;) {
            if (result) {
                NSString *name = [NSString stringWithFormat:@"[图片%d]",self.mInt_index];
                
                [[ShareHttp getInstance] shareHttpUploadSectionImgWith:imgPath Name:name];
                break;
            }
        }
    }else {
        //存在
        BOOL blDele= [fileManager removeItemAtPath:imgPath error:nil];//先删除
        if (blDele) {//删除成功后，写入，通知界面
            BOOL result = [imageData writeToFile:imgPath atomically:YES];
            for (;;) {
                if (result) {
                    NSString *name = [NSString stringWithFormat:@"[图片%d]",self.mInt_index];
                    
                    [[ShareHttp getInstance] shareHttpUploadSectionImgWith:imgPath Name:name];
                    break;
                }
            }
        }
    }
    
    self.mInt_index ++;
    //[self.mProgressV hide:YES];
}

#pragma mark ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    self.imageCount = info.count;
    if(info.count>0)
    {
        [MBProgressHUD showMessage:@"正在上传图片" toView:self.view];
        
    }
    [self dismissViewControllerAnimated:YES completion:^{
        //发送选中图片上传请求
        if (info.count>0) {
            D("info.count-===%lu",(unsigned long)info.count);
        }
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        //文件名
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *tempPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"file-%@",[dm getInstance].jiaoBaoHao]];
        //判断文件夹是否存在
        if(![fileManager fileExistsAtPath:tempPath]) {//如果不存在
            [fileManager createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
        for (NSDictionary *dict in info) {
            if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
                if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                    UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                    
                    
                    
                    NSData *imageData = UIImageJPEGRepresentation(image,0);
                    
                    // NSLog(@"%lu",(unsigned long)imageData.length);
                    
                    NSString *imgPath=[tempPath stringByAppendingPathComponent:[NSString stringWithFormat:@"[图片%d].png",self.mInt_index]];
                    
                    //NSString *imgPath=[tempPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",timeSp]];
                    //[self.mArr_pic addObject:[NSString stringWithFormat:@"%@.png",timeSp]];
                    D("图片路径是：%@",imgPath);
                    
                    BOOL yesNo=[[NSFileManager defaultManager] fileExistsAtPath:imgPath];
                    if (!yesNo) {//不存在，则直接写入后通知界面刷新
                        BOOL result = [imageData writeToFile:imgPath atomically:YES];
                        for (;;) {
                            if (result) {
                                NSString *name = [NSString stringWithFormat:@"[图片%d]",self.mInt_index];
                                
                                [[ShareHttp getInstance] shareHttpUploadSectionImgWith:imgPath Name:name];
                                //                                self.mTextV_content.text = [NSString stringWithFormat:@"%@%@",self.mTextV_content.text,name];
                                self.mInt_index ++;
                                break;
                            }
                        }
                    }else {
                        //存在
                        BOOL blDele= [fileManager removeItemAtPath:imgPath error:nil];//先删除
                        if (blDele) {//删除成功后，写入，通知界面
                            BOOL result = [imageData writeToFile:imgPath atomically:YES];
                            for (;;) {
                                if (result) {
                                    NSString *name = [NSString stringWithFormat:@"[图片%d]",self.mInt_index];
                                    
                                    [[ShareHttp getInstance] shareHttpUploadSectionImgWith:imgPath Name:name];
                                    //                                    self.mTextV_content.text = [NSString stringWithFormat:@"%@%@",self.mTextV_content.text,name];
                                    self.mInt_index ++;
                                    
                                    break;
                                }
                            }
                        }
                    }
                } else {
                    NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
                }
            }
            else {
                NSLog(@"Uknown asset type");
            }
            timeSp = [NSString stringWithFormat:@"%d",[timeSp intValue] +1];
        }
        
        
    }];
    // [self.mProgressV hide:YES];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [IQKeyboardManager sharedManager].enable = NO;//控制整个功能是否启用
    [utils popViewControllerAnimated:YES];
}
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (void)didReceiveMemoryWarning {
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
