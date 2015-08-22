//
//  CommentViewController.m
//  JiaoBao
//
//  Created by songyanming on 15/8/10.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "CommentViewController.h"
#import "KnowledgeTableViewCell.h"
#import "dm.h"
#import "utils.h"
#import "define_constant.h"
#import "CommentListTableViewCell.h"
#import "AllCommentListModel.h"
#import "ButtonViewCell.h"
#import "KnowledgeAddAnswerViewController.h"
#import "GDataXMLNode.h"
#import "TFHpple.h"

@interface CommentViewController ()
@property(nonatomic,strong)MyNavigationBar *mNav_navgationBar;
@property(nonatomic,strong)AllCommentListModel *AllCommentListModel;
@property(nonatomic,strong)KnowledgeTableViewCell*KnowledgeTableViewCell;
@end

@implementation CommentViewController
-(void)CommentsListWithNumPerPage:(id)sender
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    NSDictionary *dic = [sender object];
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
    NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
    if([ResultCode integerValue] != 0)
    {
        [MBProgressHUD showError:ResultDesc];
        return;
    }

    
    //[MBProgressHUD showSuccess:ResultDesc toView:self.view];
    self.AllCommentListModel = [dic objectForKey:@"model"];
    ButtonViewCell *btn = (ButtonViewCell*)[self.view viewWithTag:101];
    btn.mLab_title.text = [NSString stringWithFormat:@"评论%d",self.AllCommentListModel.mArr_CommentList.count];
    
    self.tableView.frame = CGRectMake(0, self.mBtnV_btn.frame.size.height+self.mBtnV_btn.frame.origin.y, [dm  getInstance].width, [self tableViewCellHeight]);
    D("tableViewFrame = %@",NSStringFromCGRect(self.tableView.frame));
    self.mainScrollView.contentSize = CGSizeMake([dm getInstance].width, self.tableView.frame.origin.y+self.tableView.frame.size.height+10);
    D("mainScrollViewFrame = %@",NSStringFromCGRect(self.mainScrollView.frame));
    self.tableView.scrollEnabled = NO;
    [self.tableView reloadData];
    
}
-(void) ButtonViewTitleBtn:(ButtonViewCell *) view
{
    if(view.tag == 100)
    {
        [[KnowledgeHttp getInstance]reportanswerWithAId:self.questionModel.answerModel.TabID];
    }
    if(view.tag == 101)
    {
        [self.mView_text setHidden:NO];
        [self.mTextF_text becomeFirstResponder];
    }
    if(view.tag == 102 )
    {
        if([self.AnswerDetailModel.LikeList isEqualToString:@"0,"])
        {
            [MBProgressHUD showText:@"你已经评价过了"];
            return;
        }
        [[KnowledgeHttp getInstance]SetYesNoWithAId:self.questionModel.answerModel.TabID yesNoFlag:@"0"];
        self.btn_tag = 1;
    }
}
-(void)refreshComment:(id)sender
{[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *dic = [sender object];
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
    NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
    if([ResultCode integerValue]!=0)
    {
        [MBProgressHUD showError:ResultDesc];
    }
    else
    {
        [MBProgressHUD showSuccess:ResultDesc];
        [[KnowledgeHttp getInstance]CommentsListWithNumPerPage:@"20" pageNum:@"1" AId:self.questionModel.answerModel.TabID];
//        [[KnowledgeHttp getInstance] AnswerDetailWithAId:self.questionModel.answerModel.TabID];
        
    }



}

-(void)AnswerDetailWithAId:(id)sender
{
    {[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *dic = [sender object];
        NSString *ResultCode = [dic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
        if([ResultCode integerValue]!=0)
        {
            [MBProgressHUD showError:ResultDesc];
        }
        else
        {
            self.AnswerDetailModel = [dic objectForKey:@"model"];
            self.KnowledgeTableViewCell = [self getMainView];
            self.mainScrollView.frame = CGRectMake(0, 44+10, [dm getInstance].width, [dm getInstance].height-44-10);
            self.mainScrollView.contentSize = CGSizeMake([dm getInstance].width, 1000);
            [self.mainScrollView addSubview:self.KnowledgeTableViewCell];
            
            NSMutableArray *temp = [NSMutableArray array];
            for (int i=0; i<3; i++) {
                ButtonViewModel *model = [[ButtonViewModel alloc] init];
                if(i == 0)
                {
                    model.mStr_title = @"举报";
                    model.mStr_img = @"buttonView5";
                    
                    
                }
                if(i == 1)
                {
                    model.mStr_title = [NSString stringWithFormat:@"评论%@",self.AnswerDetailModel.CCount];
                    model.mStr_img = @"buttonView1";
                    
                    
                }
                if(i == 2)
                {
                    model.mStr_title = [NSString stringWithFormat:@"反对%@",self.AnswerDetailModel.CaiCount];
                    model.mStr_img = @"buttonView2";
                    
                    
                }
                [temp addObject:model];
            }
            self.mBtnV_btn = [[ButtonView alloc] initFrame:CGRectMake(0, self.KnowledgeTableViewCell.frame.origin.y+self.KnowledgeTableViewCell.frame.size.height, [dm getInstance].width, 50) Array:temp];
            self.mBtnV_btn.delegate = self;
            [self.mainScrollView addSubview:self.mBtnV_btn];
            self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.mBtnV_btn.frame.size.height+self.mBtnV_btn.frame.origin.y, [dm  getInstance].width, 0) style:UITableViewStylePlain];
            self.tableView.delegate = self;
            self.tableView.dataSource = self;
            [self.mainScrollView addSubview:self.tableView];
            if(self.answerModel)
            {
                [[KnowledgeHttp getInstance]CommentsListWithNumPerPage:@"20" pageNum:@"1" AId:self.answerModel.TabID];
                return;
            }
            [[KnowledgeHttp getInstance]CommentsListWithNumPerPage:@"20" pageNum:@"1" AId:self.questionModel.answerModel.TabID];



            
        }
    }
}
-(void)SetYesNoWithAId:(id)sender
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
        self.AnswerDetailModel.LikeList = @"0,";
        if(self.btn_tag == 1)
        {
            ButtonViewCell *btn = (ButtonViewCell*)[self.view viewWithTag:102];
            btn.mLab_title.text = @"反对1";
        }

        if(self.btn_tag == 0)
        {
            self.KnowledgeTableViewCell.mLab_LikeCount.text = @"1";

        }

    }

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.btn_tag = -1;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshComment" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshComment:) name:@"refreshComment" object:nil];

    //键盘事件
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"CommentsListWithNumPerPage" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(CommentsListWithNumPerPage:) name:@"CommentsListWithNumPerPage" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"AnswerDetailWithAId" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(AnswerDetailWithAId:) name:@"AnswerDetailWithAId" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"SetYesNoWithAId" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(SetYesNoWithAId:) name:@"SetYesNoWithAId" object:nil];
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"评论"];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    //输入View坐标
    self.mView_text = [[UIView alloc] init];
    self.mView_text.frame = CGRectMake(0, 500, [dm getInstance].width, 51);
    self.mView_text.backgroundColor = [UIColor whiteColor];
    //添加边框
    self.mView_text.layer.borderWidth = .5;
    self.mView_text.layer.borderColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    [self.view addSubview:self.mView_text];

    //输入框
    self.mTextF_text = [[UITextField alloc] init];
    self.mTextF_text.frame = CGRectMake(15, 10, [dm getInstance].width-15*2, 51-20);
    self.mTextF_text.placeholder = @"请输入评论内容";
    self.mTextF_text.delegate = self;
    self.mTextF_text.font = [UIFont systemFontOfSize:14];
    self.mTextF_text.borderStyle = UITextBorderStyleRoundedRect;
    self.mTextF_text.returnKeyType = UIReturnKeyDone;//return键的类型
    [self.mView_text addSubview:self.mTextF_text];
    [self.mView_text setHidden:YES];

    [MBProgressHUD showMessage:@"" toView:self.view];
    if(self.answerModel)
    {
        [[KnowledgeHttp getInstance] AnswerDetailWithAId:self.answerModel.TabID];
        return;

    }
    [[KnowledgeHttp getInstance] AnswerDetailWithAId:self.questionModel.answerModel.TabID];

        // Do any additional setup after loading the view from its nib.
}


-(float)tableViewCellHeight
{
    float h = 0;
    NSArray *arr = self.AllCommentListModel.mArr_CommentList;
    for(int i=0;i<arr.count;i++)
    {
        commentListModel *model = [arr objectAtIndex:i];
    CGSize Size = [model.WContent sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(228, 1000)];
        float cellHeight = Size.height + 50;
        h = h + cellHeight;
    }


    return h;
}
-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return self.AllCommentListModel.mArr_CommentList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"CommentListTableViewCell";
    CommentListTableViewCell *cell = (CommentListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[CommentListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommentListTableViewCell" owner:self options:nil];
        //这时myCell对象已经通过自定义xib文件生成了
        if ([nib count]>0) {
            cell = (CommentListTableViewCell *)[nib objectAtIndex:0];
            //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
        }
        //添加图片点击事件
        //若是需要重用，需要写上以下两句代码
        UINib * n= [UINib nibWithNibName:@"CommentListTableViewCell" bundle:[NSBundle mainBundle]];
        [self.tableView registerNib:n forCellReuseIdentifier:indentifier];
    }
    commentListModel *model = [self.AllCommentListModel.mArr_CommentList objectAtIndex:indexPath.row];
    cell.headImaV.frame = CGRectMake(10, 10, 50, 50);
    [cell.headImaV sd_setImageWithURL:(NSURL *)[NSString stringWithFormat:@"%@%@",AccIDImg,model.JiaoBaoHao] placeholderImage:[UIImage  imageNamed:@"root_img"]];
    cell.UserName.text = model.UserName;
    cell.UserName.frame = CGRectMake(70, 10, 100, 21);
    cell.WContent.text = model.WContent;


    CGSize Size = [model.WContent sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(228, 1000)];
    cell.WContent.frame = CGRectMake(70,10+21+10 , 228, Size.height);
    cell.RecDate.text = model.RecDate;
    
    return cell;

}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    NSArray *arr = self.AllCommentListModel.mArr_CommentList;
    commentListModel *model = [arr objectAtIndex:indexPath.row];
    CGSize Size = [model.WContent sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(228, 1000)];
    float cellHeight = Size.height + 50;
    return cellHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)likeAction:(id)sender
{
    if([self.AnswerDetailModel.LikeList isEqualToString:@"0,"])
    {
        [MBProgressHUD showText:@"你已经评价过了"];
        return;
    }
    [[KnowledgeHttp getInstance]SetYesNoWithAId:self.questionModel.answerModel.TabID yesNoFlag:@"1"];
    self.btn_tag = 0;

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
    cell.model = self.questionModel;
    cell.answerModel = self.answerModel;
    cell.AnswerDetailModel = self.AnswerDetailModel;
    [cell.LikeBtn addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];

    //详情
    cell.mBtn_detail.frame = CGRectMake([dm getInstance].width-49, 0, 40, cell.mBtn_detail.frame.size.height);
    NSString *string_title = cell.model.Title;
    string_title = [string_title stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    CGSize size_title = [string_title sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(cell.mBtn_detail.frame.origin.x-5, 1000)];
    if (size_title.height>20) {
        size_title = CGSizeMake(size_title.width, size_title.height);
    }
    cell.mLab_title.lineBreakMode = NSLineBreakByWordWrapping;
    cell.mLab_title.font = [UIFont systemFontOfSize:14];
    cell.mLab_title.numberOfLines =0;
    cell.mLab_title.text = cell.model.Title;
    cell.mLab_title.frame = CGRectMake(9, 0, cell.mBtn_detail.frame.origin.x-5, size_title.height);

    //话题
    cell.mLab_Category0.frame = CGRectMake(30, cell.mLab_title.frame.origin.y+cell.mLab_title.frame.size.height+5, cell.mLab_Category0.frame.size.width, cell.mLab_Category0.frame.size.height);
    CGSize CategorySize = [[NSString stringWithFormat:@"%@",cell.model.CategorySuject] sizeWithFont:[UIFont systemFontOfSize:10]];
    cell.mLab_Category1.frame = CGRectMake(30+cell.mLab_Category0.frame.size.width+2, cell.mLab_Category0.frame.origin.y, CategorySize.width, cell.mLab_Category0.frame.size.height);
    cell.mLab_Category1.text = cell.model.CategorySuject;
    //访问
    CGSize ViewSize = [[NSString stringWithFormat:@"%@",cell.model.ViewCount] sizeWithFont:[UIFont systemFontOfSize:10]];
    cell.mLab_ViewCount.frame = CGRectMake([dm getInstance].width-9-ViewSize.width, cell.mLab_Category0.frame.origin.y, ViewSize.width, cell.mLab_Category0.frame.size.height);
    cell.mLab_ViewCount.text = cell.model.ViewCount;
    cell.mLab_View.frame = CGRectMake(cell.mLab_ViewCount.frame.origin.x-2-cell.mLab_View.frame.size.width, cell.mLab_Category0.frame.origin.y, cell.mLab_View.frame.size.width, cell.mLab_View.frame.size.height);
    //回答
    CGSize AnswersSize = [[NSString stringWithFormat:@"%@",cell.model.AnswersCount] sizeWithFont:[UIFont systemFontOfSize:10]];
    cell.mLab_AnswersCount.frame = CGRectMake(cell.mLab_View.frame.origin.x-5-AnswersSize.width, cell.mLab_Category0.frame.origin.y, AnswersSize.width, cell.mLab_Category0.frame.size.height);
    cell.mLab_AnswersCount.text = cell.model.AnswersCount;
    cell.mLab_Answers.frame = CGRectMake(cell.mLab_AnswersCount.frame.origin.x-2-cell.mLab_Answers.frame.size.width, cell.mLab_Category0.frame.origin.y, cell.mLab_Answers.frame.size.width, cell.mLab_Answers.frame.size.height);
    //关注
    CGSize AttSize = [[NSString stringWithFormat:@"%@",cell.model.AttCount] sizeWithFont:[UIFont systemFontOfSize:10]];
    cell.mLab_AttCount.frame = CGRectMake(cell.mLab_Answers.frame.origin.x-5-AttSize.width, cell.mLab_Category0.frame.origin.y, AttSize.width, cell.mLab_Category0.frame.size.height);
    cell.mLab_AttCount.text = cell.model.AttCount;
    cell.mLab_Att.frame = CGRectMake(cell.mLab_AttCount.frame.origin.x-2-cell.mLab_Att.frame.size.width, cell.mLab_Category0.frame.origin.y, cell.mLab_Att.frame.size.width, cell.mLab_Att.frame.size.height);
    //判断是否有回答
    if ([cell.model.AnswersCount integerValue]>0) {
        //分割线
        cell.mLab_line.hidden = NO;
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
        cell.mLab_commentCount.hidden = YES;
        cell.mLab_comment.hidden = YES;
        cell.mWebV_comment.hidden =YES;
        //分割线
        cell.mLab_line.frame = CGRectMake(20, cell.mLab_Category0.frame.origin.y+cell.mLab_Category0.frame.size.height+5, [dm getInstance].width-20, .5);
        
        //头像
        cell.mImgV_head.frame = CGRectMake(9, cell.mLab_line.frame.origin.y+15, 42, 42);
        [cell.mImgV_head sd_setImageWithURL:(NSURL *)[NSString stringWithFormat:@"%@%@",AccIDImg,self.AnswerDetailModel.JiaoBaoHao] placeholderImage:[UIImage  imageNamed:@"root_img"]];
        //姓名
        cell.mLab_IdFlag.frame = CGRectMake(cell.mImgV_head.frame.size.width+9+5, cell.mLab_line.frame.origin.y+15, 200, cell.mLab_IdFlag.frame.size.height);
        cell.mLab_IdFlag.text = self.AnswerDetailModel.IdFlag;
        cell.mLab_IdFlag.textAlignment = NSTextAlignmentLeft;
        //赞
        cell.LikeBtn.hidden = NO;


        cell.mLab_LikeCount.frame = CGRectMake([dm getInstance].width-38, cell.mLab_line.frame.origin.y+15+5, 42, 22);
        cell.LikeBtn.frame = CGRectMake(cell.mLab_LikeCount.frame.origin.x-20, cell.mLab_LikeCount.frame.origin.y-5, 44, 30);

        NSString *strLike = self.AnswerDetailModel.LikeCount;
        if ([self.AnswerDetailModel.LikeCount integerValue]>0) {
            strLike = [NSString stringWithFormat:@"%@",self.AnswerDetailModel.LikeCount];
        }
        cell.mLab_LikeCount.text = [NSString stringWithFormat:@"%@",strLike];

        cell.mLab_LikeCount.backgroundColor = [UIColor clearColor];
        cell.mLab_LikeCount.textColor = [UIColor blackColor];
        //回答标题
        NSString *string1 = self.AnswerDetailModel.ATitle;
        string1 = [string1 stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        NSString *str = [NSString stringWithFormat:@"依据 : %@",string1];
        CGSize size1 = [str sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake([dm getInstance].width-18, 1000)];
        if (size1.height>20) {
            size1 = CGSizeMake(size1.width, size1.height);
        }
        NSMutableDictionary *row1 = [NSMutableDictionary dictionary];
        NSString *name = [NSString stringWithFormat:@"<font size=14 color='#03AA36'>答 : </font> <font size=14 color=black>%@</font>",string1];
        [row1 setObject:name forKey:@"text"];
        RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:[row1 objectForKey:@"text"]];
        cell.mLab_ATitle.componentsAndPlainText = componentsDS;
        CGSize optimalSize1 = [cell.mLab_ATitle optimumSize];


        cell.mLab_ATitle.frame = CGRectMake(9, cell.mImgV_head.frame.origin.y+cell.mImgV_head.frame.size.height+15, [dm getInstance].width-18, optimalSize1.height);

        //回答内容
        NSString *string2 = self.AnswerDetailModel.Abstracts;
        string2 = [string2 stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        string2 = [string2 stringByReplacingOccurrencesOfString:@"\r\r" withString:@""];
        NSString *name2 = [NSString stringWithFormat:@"<font size=14 color='red'>依据 : </font> <font>%@</font>", string2];
        NSMutableDictionary *row2 = [NSMutableDictionary dictionary];
        [row2 setObject:name2 forKey:@"text"];
        RTLabelComponentsStructure *componentsDS2 = [RCLabel extractTextStyle:[row2 objectForKey:@"text"]];
        cell.mLab_Abstracts.componentsAndPlainText = componentsDS2;
        CGSize optimalSize2 = [cell.mLab_Abstracts optimumSize];

        cell.mLab_Abstracts.frame = CGRectMake(9, cell.mLab_ATitle.frame.origin.y+cell.mLab_ATitle.frame.size.height+10, [dm getInstance].width-18, optimalSize2.height);

        //背景色
        cell.mView_background.frame = CGRectMake(9, cell.mLab_Abstracts.frame.origin.y-3, [dm getInstance].width-18, cell.mLab_Abstracts.frame.size.height+4);
        //图片
        cell.mInt_flag = 2;
        if(cell.AnswerDetailModel.AContent)
        {
            cell.AnswerDetailModel.Thumbnail = [[NSMutableArray alloc]initWithCapacity:0];
            TFHpple *doc = [[TFHpple alloc]initWithHTMLData:[cell.AnswerDetailModel.AContent dataUsingEncoding:NSUTF8StringEncoding]];
            NSArray *htmlContent = [doc searchWithXPathQuery:@"//img"];
            for (TFHppleElement *ele in htmlContent) {
                NSString *content=[ele.attributes objectForKey:@"src"];
                if (!content) {
                    content=@"Null";
                }
                [cell.AnswerDetailModel.Thumbnail addObject:content];
            }

            
//            GDataXMLDocument *doc = [[GDataXMLDocument alloc]initWithData:[cell.AnswerDetailModel.AContent dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
//            GDataXMLElement *rootElement = [doc rootElement];
//            NSArray *levels = [rootElement nodesForXPath:@"//img" error:nil];
//            for (GDataXMLElement *level in levels)
//            {
//                NSString *urlstr = [[level attributeForName:@"src"]stringValue];
//
//                [cell.AnswerDetailModel.Thumbnail addObject:urlstr];
//            }
//
//            NSArray *arr = [cell.AnswerDetailModel.AContent componentsSeparatedByString:@"img src="];
//            if(arr.count>2)
//            {
//                for(int i=0;i<arr.count;i++)
//                {
//                    NSString *str1 = [arr objectAtIndex:i];
//                    if(i%2 == 1)
//                    {
//                        [cell.AnswerDetailModel.Thumbnail addObject:str1];
//
//                    }
// 
//
//                }
//            }
        }

        [cell.mCollectionV_pic reloadData];
        cell.mCollectionV_pic.backgroundColor = [UIColor clearColor];
        if (self.AnswerDetailModel.Thumbnail.count>0) {
            int a = (int)(self.AnswerDetailModel.Thumbnail.count/4);
            int b = (self.AnswerDetailModel.Thumbnail.count%4);
            if(b==0)
            {
                 cell.mCollectionV_pic.frame = CGRectMake(9, cell.mView_background.frame.origin.y+cell.mView_background.frame.size.height+5, [dm getInstance].width-9-2, a*([dm getInstance].width-70-40)/3+10);
            }
            else
            {
                cell.mCollectionV_pic.frame = CGRectMake(9, cell.mView_background.frame.origin.y+cell.mView_background.frame.size.height+5, [dm getInstance].width-9-2, (a+1)*([dm getInstance].width-70-40)/3+10);
            }
//            cell.mCollectionV_pic.frame = CGRectMake(9, cell.mView_background.frame.origin.y+cell.mView_background.frame.size.height+5, [dm getInstance].width-9-2, ([dm getInstance].width-70-40)/3*cell.model.answerModel.Thumbnail.count);
        }else{
            cell.mCollectionV_pic.frame = cell.mView_background.frame;
            cell.mCollectionV_pic.backgroundColor = [UIColor clearColor];
        }
        //时间
        cell.mLab_RecDate.frame = CGRectMake([ dm getInstance].width - 70, cell.mCollectionV_pic.frame.origin.y+cell.mCollectionV_pic.frame.size.height+5, cell.mLab_RecDate.frame.size.width, cell.mLab_RecDate.frame.size.height);
        cell.mLab_RecDate.text = self.AnswerDetailModel.RecDate;
        //评论
        CGSize commentSize = [[NSString stringWithFormat:@"%@",cell.model.ViewCount] sizeWithFont:[UIFont systemFontOfSize:10]];
        cell.mLab_commentCount.frame = CGRectMake([dm getInstance].width-9-commentSize.width, cell.mLab_RecDate.frame.origin.y, commentSize.width, cell.mLab_commentCount.frame.size.height);
        cell.mLab_commentCount.text = self.AnswerDetailModel.CCount;
        cell.mLab_comment.frame = CGRectMake(cell.mLab_commentCount.frame.origin.x-2-cell.mLab_comment.frame.size.width, cell.mLab_RecDate.frame.origin.y, cell.mLab_View.frame.size.width, cell.mLab_comment.frame.size.height);
        if (cell.model.answerModel.Thumbnail.count>0) {
            cell.mLab_line2.frame = CGRectMake(0, cell.mLab_RecDate.frame.origin.y+cell.mLab_RecDate.frame.size.height+10, [dm getInstance].width, 1);
        }else{
            cell.mLab_line2.frame = CGRectMake(0, cell.mImgV_head.frame.origin.y+cell.mImgV_head.frame.size.height+5, [dm getInstance].width, 1);
        }
    }else{
        //分割线
        cell.mLab_line.hidden = YES;
        //赞
        cell.mLab_LikeCount.hidden = YES;
        //头像
        cell.mImgV_head.hidden = YES;
        //姓名
        cell.mLab_IdFlag.hidden = YES;
        //回答标题
        cell.mLab_ATitle.hidden = YES;
        //回答内容
        cell.mLab_Abstracts.hidden = YES;
        //背景色
        cell.mView_background.hidden = YES;
        //图片
        [cell.mCollectionV_pic reloadData];
        cell.mCollectionV_pic.hidden = YES;
        //时间
        cell.mLab_RecDate.hidden = YES;
        //评论
        cell.mLab_commentCount.hidden = YES;
        cell.mLab_comment.hidden = YES;
        cell.mLab_line2.frame = CGRectMake(0, cell.mLab_RecDate.frame.origin.y+cell.mLab_RecDate.frame.size.height+10, [dm getInstance].width, 10);
    }
    cell.frame = CGRectMake(0, 0, [dm getInstance].width, cell.mLab_RecDate.frame.size.height+cell.mLab_RecDate.frame.origin.y+10);
    cell.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
//    [cell addGestureRecognizer:tap];
    return cell;
}

//cell的点击事件---详情
-(void)KnowledgeTableVIewCellDetailBtn:(KnowledgeTableViewCell *)knowledgeTableViewCell{
    KnowledgeAddAnswerViewController *detail = [[KnowledgeAddAnswerViewController alloc] init];
    detail.mModel_question = knowledgeTableViewCell.model;
    [utils pushViewController:detail animated:YES];
}
-(void)tapAction:(id)sender
{
    self.mView_text.hidden = YES;
    [self.mTextF_text resignFirstResponder];
}
- (void) keyboardWasShown:(NSNotification *) notif{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSValue *animationDurationValue = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         self.mView_text.hidden = NO;
                         self.mView_text.frame = CGRectMake(0, [dm getInstance].height-keyboardSize.height-51, [dm getInstance].width, 51);
                     }
                     completion:^(BOOL finished){
                         ;
                     }];
}
- (void) keyboardWasHidden:(NSNotification *) notif{
    self.mView_text.hidden = YES;
    NSDictionary *userInfo = [notif userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         self.mView_text.frame = CGRectMake(0, [dm getInstance].height, [dm getInstance].width, 51);
                     }
                     completion:^(BOOL finished){
                         ;
                     }];
}


//键盘点击DO
#pragma mark - UITextView Delegate Methods
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        //若其有输入内容，则发送
        if (self.mTextF_text.text.length>0) {
            [[KnowledgeHttp getInstance]AddCommentWithAId:self.questionModel.answerModel.TabID comment:self.mTextF_text.text RefID:@""];
        }
        return NO;
    }
    return YES;
}
-(void)myNavigationGoback{
    
    [utils popViewControllerAnimated:YES];
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
