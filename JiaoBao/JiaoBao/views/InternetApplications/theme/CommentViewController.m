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
#import "IQKeyboardManager.h"
#import "AirthCommentsListCell.h"

@interface CommentViewController ()
@property(nonatomic,strong)MyNavigationBar *mNav_navgationBar;
@property(nonatomic,strong)AllCommentListModel *AllCommentListModel;
@property(nonatomic,strong)KnowledgeTableViewCell*KnowledgeTableViewCell;
@property(nonatomic,assign)int mInt_reloadData;
@end

@implementation CommentViewController

//评论列表回调
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
    if (self.mInt_reloadData ==0)
    {
        self.AllCommentListModel = [dic objectForKey:@"model"];

    }
    else
    {
        AllCommentListModel *model =[dic objectForKey:@"model"];
        if(model.mArr_CommentList.count == 0)
        {
            [MBProgressHUD showSuccess:@"没有更多了" toView:self.view];

        }
        [self.AllCommentListModel.mArr_CommentList addObjectsFromArray:model.mArr_CommentList];
    }

//    self.tableView.frame = CGRectMake(0, self.mBtnV_btn.frame.size.height+self.mBtnV_btn.frame.origin.y, [dm  getInstance].width, [self tableViewCellHeight]);
//    self.mainScrollView.contentSize = CGSizeMake([dm getInstance].width, self.tableView.frame.origin.y+self.tableView.frame.size.height+10);
//    self.tableView.scrollEnabled = NO;
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
    [self.tableView reloadData];
    
    
}
//举报 评论 反对点击方法
-(void) ButtonViewTitleBtn:(ButtonViewCell *) view
{
    if(view.tag == 100)
    {
        if(self.answerModel)
        {
            [[KnowledgeHttp getInstance]reportanswerWithAId:self.answerModel.TabID];

        }
        else
        {
            [[KnowledgeHttp getInstance]reportanswerWithAId:self.questionModel.answerModel.TabID];

        }
    }
    if(view.tag == 101)
    {
        [self.mView_text setHidden:NO];
        [self.mTextF_text becomeFirstResponder];
        
    }
    if(view.tag == 102 )
    {

        if(self.answerModel)
        {
            [[KnowledgeHttp getInstance]SetYesNoWithAId:self.answerModel.TabID yesNoFlag:@"0"];
            
            
        }
        else
        {
            [[KnowledgeHttp getInstance]SetYesNoWithAId:self.questionModel.answerModel.TabID yesNoFlag:@"0"];

        }
        self.btn_tag = 1;
    }
}
//添加评论回调
-(void)refreshComment:(id)sender
{
    self.mTextF_text.text = @"";
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
        [MBProgressHUD showSuccess:ResultDesc];
        if(self.answerModel)
        {
            [[KnowledgeHttp getInstance]CommentsListWithNumPerPage:@"20" pageNum:@"1" AId:self.answerModel.TabID];
        }
        else
        {
            [[KnowledgeHttp getInstance]CommentsListWithNumPerPage:@"20" pageNum:@"1" AId:self.questionModel.answerModel.TabID];
            
        }
        //获取答案详情
        if(self.answerModel)//答案列表跳转用answerModel
        {
            [[KnowledgeHttp getInstance] AnswerDetailWithAId:self.answerModel.TabID];
            
        }
        else
        {
            [[KnowledgeHttp getInstance] AnswerDetailWithAId:self.questionModel.answerModel.TabID];//首页跳转用questionModel.answerModel

            
        }
        
    }



}
//答案详情回调
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
            





        }
    }
}
//举报回调
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
        NSString *Data = [dic objectForKey:@"Data"];
if([Data integerValue]==-1)
{

        [MBProgressHUD showText:@"你已经评价过了"];

    return;
}
        if(self.btn_tag == 1)
        {
            ButtonViewCell *btn = (ButtonViewCell*)[self.view viewWithTag:102];
            NSString *str = [btn.mLab_title.text stringByReplacingOccurrencesOfString:@"反对" withString:@""];
            NSUInteger num = [str integerValue]+1;
            btn.mLab_title.text = [NSString stringWithFormat:@"反对%ld",num];
            [MBProgressHUD showText:@"反对成功"];

        }

        if(self.btn_tag == 0)
        {
            NSUInteger num = [self.KnowledgeTableViewCell.mLab_LikeCount.text integerValue]+1;

            self.KnowledgeTableViewCell.mLab_LikeCount.text = [NSString stringWithFormat:@"%ld",num];
            [MBProgressHUD showText:@"点赞成功"];


        }
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
    
    //输入框弹出键盘问题
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;//控制整个功能是否启用
    manager.shouldResignOnTouchOutside = YES;//控制点击背景是否收起键盘
    manager.shouldToolbarUsesTextFieldTintColor = NO;//控制键盘上的工具条文字颜色是否用户自定义
    manager.enableAutoToolbar = NO;//控制是否显示键盘上的工具条
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.mInt_reloadData = 0;
    self.btn_tag = -1;
    
    //添加评论成功后刷新数据
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshComment" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshComment:) name:@"refreshComment" object:nil];

    //键盘事件
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
    //获取评论列表
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"CommentsListWithNumPerPage" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(CommentsListWithNumPerPage:) name:@"CommentsListWithNumPerPage" object:nil];
    //获取答案详情
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"AnswerDetailWithAId" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(AnswerDetailWithAId:) name:@"AnswerDetailWithAId" object:nil];
    //举报
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"SetYesNoWithAId" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(SetYesNoWithAId:) name:@"SetYesNoWithAId" object:nil];
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"回答"];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    
    //输入View坐标
    self.mView_text = [[UIView alloc] init];
    self.mView_text.frame = CGRectMake(0, 300, [dm getInstance].width, 51);
    self.mView_text.backgroundColor = [UIColor whiteColor];
    
    //添加边框
    self.mView_text.layer.borderWidth = .5;
    self.mView_text.layer.borderColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];

    //输入框
    self.mTextF_text = [[UITextField alloc] init];
    self.mTextF_text.frame = CGRectMake(15, 10, [dm getInstance].width-15*2, 51-20);
    self.mTextF_text.placeholder = @"请输入评论内容";
    self.mTextF_text.delegate = self;
    self.mTextF_text.font = [UIFont systemFontOfSize:14];
    self.mTextF_text.borderStyle = UITextBorderStyleRoundedRect;
    self.mTextF_text.returnKeyType = UIReturnKeyDone;//return键的类型
    [self.mView_text setHidden:YES];

    [MBProgressHUD showMessage:@"" toView:self.view];
    //获取答案详情
    if(self.answerModel)//答案列表跳转用answerModel
    {
        [[KnowledgeHttp getInstance] AnswerDetailWithAId:self.answerModel.TabID];

    }
    else
    {
        [[KnowledgeHttp getInstance] AnswerDetailWithAId:self.questionModel.answerModel.TabID];//首页跳转用questionModel.answerModel

    }
    if(self.answerModel)
    {
        [[KnowledgeHttp getInstance]CommentsListWithNumPerPage:@"20" pageNum:@"1" AId:self.answerModel.TabID];
    }
    else
    {
        [[KnowledgeHttp getInstance]CommentsListWithNumPerPage:@"20" pageNum:@"1" AId:self.questionModel.answerModel.TabID];

        
    }
        // Do any additional setup after loading the view from its nib.
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
        page = @"1";
        [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    }else{

        NSMutableArray *array = self.AllCommentListModel.mArr_CommentList;
        if (array.count>=20&&array.count%20==0) {

            page = [NSString stringWithFormat:@"%d",(int)array.count/20+1];
            [MBProgressHUD showMessage:@"加载中..." toView:self.view];
        } else {
            [self.tableView headerEndRefreshing];
            [self.tableView footerEndRefreshing];
            [MBProgressHUD showSuccess:@"没有更多了" toView:self.view];
            return;
        }
    }
    if(self.answerModel)
    {
        [[KnowledgeHttp getInstance]CommentsListWithNumPerPage:@"20" pageNum:page AId:self.answerModel.TabID];
        return;
    }
    [[KnowledgeHttp getInstance]CommentsListWithNumPerPage:@"20" pageNum:page AId:self.questionModel.answerModel.TabID];}
//获取评论列表cell高度
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
#pragma mark - TableView Data Source

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return self.AllCommentListModel.mArr_CommentList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"AirthCommentsListCell";
    AirthCommentsListCell *cell = (AirthCommentsListCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[AirthCommentsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AirthCommentsListCell" owner:self options:nil];
        //这时myCell对象已经通过自定义xib文件生成了
        if ([nib count]>0) {
            cell = (AirthCommentsListCell *)[nib objectAtIndex:0];
            //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
        }
        
        //若是需要重用，需要写上以下两句代码
        UINib * n= [UINib nibWithNibName:@"AirthCommentsListCell" bundle:[NSBundle mainBundle]];
        [self.tableView registerNib:n forCellReuseIdentifier:indentifier];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.tag = indexPath.row;
        commentListModel *model = [self.AllCommentListModel.mArr_CommentList objectAtIndex:indexPath.row];

    //commentsListModel *model = [self.mModel_commentList.commentsList objectAtIndex:indexPath.row];
    //第几楼
    cell.mLab_Number.frame = CGRectMake(10, 10, 50, 15);
    cell.mLab_Number.text = model.Number;
    //头像
    
    [cell.mImg_head sd_setImageWithURL:(NSURL *)[NSString stringWithFormat:@"%@%@",AccIDImg,model.JiaoBaoHao] placeholderImage:[UIImage  imageNamed:@"root_img"]];
    //人名、单位名
    NSString *tempName = [NSString stringWithFormat:@"%@@%@",model.JiaoBaoHao,model.UserName];
    CGSize sizeName = [tempName sizeWithFont:[UIFont systemFontOfSize:12]];
    cell.mLab_UnitShortname.frame = CGRectMake(70, 10, sizeName.width, 15);
    cell.mLab_UnitShortname.text = tempName;
    //时间
    CGSize sizeTime = [model.RecDate sizeWithFont:[UIFont systemFontOfSize:12]];
    cell.mLab_time.frame = CGRectMake([dm getInstance].width-10-sizeTime.width, 10, sizeTime.width, 15);
    cell.mLab_time.text = model.RecDate;
    NSArray *refArr;
    if(model.RefIds)
    {
        refArr = [model.RefIds componentsSeparatedByString:@","];

    }
    if (refArr.count>0) {
        cell.mView_RefID.hidden = NO;
        int m=0;
        for (int i=0; i<refArr.count; i++) {
            NSString *tempTab = [refArr objectAtIndex:i];
            for (int a=0; a<self.AllCommentListModel.mArr_refcomments.count; a++) {
                commentListModel *refModel = [self.AllCommentListModel.mArr_refcomments objectAtIndex:a];
                if ([tempTab intValue] == [refModel.TabID intValue]) {
                    UIView *tempView = [[UIView alloc] init];
                    UILabel *tempLab = [[UILabel alloc] init];
                    UIButton *tempBtnLike = [UIButton buttonWithType:UIButtonTypeCustom];
                    UIButton *tempBtnCai = [UIButton buttonWithType:UIButtonTypeCustom];
                    //显示内容
                    NSString *tempTitle = [NSString stringWithFormat:@"%@@%@:%@",refModel.JiaoBaoHao,refModel.UserName,refModel.WContent];
                    CGSize sizeTitle = [tempTitle sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake([dm getInstance].width-90, 99999)];
                    tempLab.frame = CGRectMake(10, 5, sizeTitle.width, sizeTitle.height);
                    tempLab.text = tempTitle;
                    tempLab.font = [UIFont systemFontOfSize:12];
                    tempLab.numberOfLines = 99999;
                    [tempView addSubview:tempLab];
                    //踩
                    NSString *tempCaiCount = [NSString stringWithFormat:@"踩(%@)",refModel.CaiCount];
                    CGSize sizeCai = [tempCaiCount sizeWithFont:[UIFont systemFontOfSize:12]];
                    tempBtnCai.frame = CGRectMake([dm getInstance].width-100-sizeCai.width, tempLab.frame.origin.y+tempLab.frame.size.height+10, sizeCai.width+15, 20);
                    [tempBtnCai setTitle:tempCaiCount forState:UIControlStateNormal];
                    tempBtnCai.titleLabel.font = [UIFont systemFontOfSize:12];
                    [tempBtnCai setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                    tempBtnCai.restorationIdentifier = refModel.TabIDStr;
                    tempBtnCai.hidden = YES;
                    //边框
                    [tempBtnCai.layer setMasksToBounds:YES];
                    [tempBtnCai.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
                    [tempBtnCai.layer setBorderWidth:1.0]; //边框宽度
                    CGColorRef colorref = [UIColor blueColor].CGColor;
                    [tempBtnCai.layer setBorderColor:colorref];//边框颜色
                    [tempBtnCai addTarget:self action:@selector(tempViewBtnCai:) forControlEvents:UIControlEventTouchUpInside];
                    [tempView addSubview:tempBtnCai];
                    //顶
                    NSString *tempLikeCount = [NSString stringWithFormat:@"顶(%@)",refModel.LikeCount];
                    CGSize sizeLike = [tempLikeCount sizeWithFont:[UIFont systemFontOfSize:12]];
                    tempBtnLike.frame = CGRectMake(tempBtnCai.frame.origin.x-25-sizeLike.width, tempBtnCai.frame.origin.y, sizeLike.width+15, 20);
                    [tempBtnLike setTitle:tempLikeCount forState:UIControlStateNormal];
                    tempBtnLike.titleLabel.font = [UIFont systemFontOfSize:12];
                    [tempBtnLike setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                    tempBtnLike.restorationIdentifier = refModel.TabIDStr;
                    tempBtnLike.hidden = YES;
                    //边框
                    [tempBtnLike.layer setMasksToBounds:YES];
                    [tempBtnLike.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
                    [tempBtnLike.layer setBorderWidth:1.0]; //边框宽度
                    [tempBtnLike.layer setBorderColor:colorref];//边框颜色
                    [tempBtnLike addTarget:self action:@selector(tempViewBtnLike:) forControlEvents:UIControlEventTouchUpInside];
                    [tempView addSubview:tempBtnLike];
                    //设置坐标
                    tempView.frame = CGRectMake(0, m, [dm getInstance].width-80, tempBtnLike.frame.origin.y+tempBtnLike.frame.size.height);
                    tempView.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
                    m = m+tempView.frame.size.height;
                    [cell.mView_RefID addSubview:tempView];
                    cell.mView_RefID.frame = CGRectMake(70, 35, [dm getInstance].width-90, tempView.frame.origin.y+tempView.frame.size.height);
                }
            }
        }
    }else{
        cell.mView_RefID.hidden = YES;
        cell.mView_RefID.frame = cell.mLab_time.frame;
    }
    
    //内容
    CGSize sizeContent = [model.WContent sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake([dm getInstance].width-90, 99999)];
    cell.mLab_Commnets.frame = CGRectMake(70, cell.mView_RefID.frame.origin.y+cell.mView_RefID.frame.size.height+10, sizeContent.width, sizeContent.height);
    cell.mLab_Commnets.text = model.WContent;
    cell.mLab_Commnets.numberOfLines = 99999;
    //回复按钮
    CGSize sizeReply = [@"回复" sizeWithFont:[UIFont systemFontOfSize:12]];
    cell.mBtn_reply.frame = CGRectMake([dm getInstance].width-30-sizeReply.width, cell.mLab_Commnets.frame.origin.y+cell.mLab_Commnets.frame.size.height+10, sizeReply.width+20, 30);
    //踩按钮
    NSString *tempCai = [NSString stringWithFormat:@"踩(%@)",model.CaiCount];
    CGSize sizeCai = [tempCai sizeWithFont:[UIFont systemFontOfSize:12]];
    cell.mBtn_CaiCount.frame = CGRectMake(cell.mBtn_reply.frame.origin.x-30-sizeCai.width, cell.mBtn_reply.frame.origin.y, sizeCai.width+20, 30);
    [cell.mBtn_CaiCount setTitle:tempCai forState:UIControlStateNormal];
    //顶按钮
    NSString *tempLike = [NSString stringWithFormat:@"顶(%@)",model.LikeCount];
    CGSize sizeLike = [tempLike sizeWithFont:[UIFont systemFontOfSize:12]];
    cell.mBtn_LikeCount.frame = CGRectMake(cell.mBtn_CaiCount.frame.origin.x-30-sizeLike.width, cell.mBtn_CaiCount.frame.origin.y, sizeLike.width+20, 30);
    [cell.mBtn_LikeCount setTitle:tempLike forState:UIControlStateNormal];
    
    
    //给头像添加点击事件
    cell.delegate = self;
    [cell headImgClick];
    
    int a=0;
    float b = cell.mBtn_LikeCount.frame.origin.y+cell.mBtn_LikeCount.frame.size.height+10;
    float c = cell.mImg_head.frame.origin.y+cell.mImg_head.frame.size.height+10;
    if (b>c) {
        a=b;
    }else{
        a=c;
    }
    cell.frame = CGRectMake(0, 0, [dm getInstance].width, a);
    return cell;

//    static NSString *indentifier = @"CommentListTableViewCell";
//    CommentListTableViewCell *cell = (CommentListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
//    if (cell == nil) {
//        cell = [[CommentListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommentListTableViewCell" owner:self options:nil];
//        //这时myCell对象已经通过自定义xib文件生成了
//        if ([nib count]>0) {
//            cell = (CommentListTableViewCell *)[nib objectAtIndex:0];
//            //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
//        }
//        //添加图片点击事件
//        //若是需要重用，需要写上以下两句代码
//        UINib * n= [UINib nibWithNibName:@"CommentListTableViewCell" bundle:[NSBundle mainBundle]];
//        [self.tableView registerNib:n forCellReuseIdentifier:indentifier];
//    }
//    commentListModel *model = [self.AllCommentListModel.mArr_CommentList objectAtIndex:indexPath.row];
//    cell.headImaV.frame = CGRectMake(10, 10, 50, 50);
//    [cell.headImaV sd_setImageWithURL:(NSURL *)[NSString stringWithFormat:@"%@%@",AccIDImg,model.JiaoBaoHao] placeholderImage:[UIImage  imageNamed:@"root_img"]];
//    cell.UserName.text = model.UserName;
//    cell.UserName.frame = CGRectMake(70, 10, 100, 21);
//    cell.WContent.text = model.WContent;
//
//
//    CGSize Size = [model.WContent sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(228, 1000)];
//    cell.WContent.frame = CGRectMake(70,10+21+10 , 228, Size.height);
//    cell.RecDate.text = model.RecDate;
//    
//    return cell;

}
-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    UITableViewCell *cell= [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        return cell.frame.size.height;
    }
    return 0;
}
//-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
//    NSArray *arr = self.AllCommentListModel.mArr_CommentList;
//    commentListModel *model = [arr objectAtIndex:indexPath.row];
//    CGSize Size = [model.WContent sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(228, 1000)];
//    float cellHeight = Size.height + 50;
//    return cellHeight;
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.mView_text setHidden:NO];
    [self.mTextF_text becomeFirstResponder];
    self.cellmodel = [self.AllCommentListModel.mArr_CommentList objectAtIndex:indexPath.row];
    
}
//点击点赞按钮
-(void)likeAction:(id)sender
{
//    if([self.AnswerDetailModel.LikeList isEqualToString:@"0,"])
//    {
//        [MBProgressHUD showText:@"你已经评价过了"];
//        return;
//    }
    if(self.answerModel)
    {
        [[KnowledgeHttp getInstance]SetYesNoWithAId:self.answerModel.TabID yesNoFlag:@"1"];

        
    }
    else
    {
    [[KnowledgeHttp getInstance]SetYesNoWithAId:self.questionModel.answerModel.TabID yesNoFlag:@"1"];
    }
    self.btn_tag = 0;

}


//获取上面的cellview
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
    cell.mBtn_detail.frame = CGRectMake([dm getInstance].width-52, 0, 40, cell.mBtn_detail.frame.size.height);
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
        cell.mLab_Abstracts.hidden = YES;
        //背景色
        cell.mView_background.hidden = YES;
        //图片
        cell.mCollectionV_pic.hidden = NO;
        //时间
        cell.mLab_RecDate.hidden = NO;
        //评论
        cell.mLab_commentCount.hidden = YES;
        cell.mLab_comment.hidden = YES;
        cell.mWebV_comment.hidden =NO;
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
        
        //NSString *str = [NSString stringWithFormat:@"依据 : %@",string1];
//        CGSize size1 = [str sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake([dm getInstance].width-18, 1000)];
//        if (size1.height>20) {
//            size1 = CGSizeMake(size1.width, size1.height);
//        }
        NSMutableDictionary *row1 = [NSMutableDictionary dictionary];
        NSString *name = [NSString stringWithFormat:@"<font size=14 color='#03AA03'>答 : </font> <font size=14 color=black>%@</font>",string1];
        [row1 setObject:name forKey:@"text"];
        RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:[row1 objectForKey:@"text"]];
        cell.mLab_ATitle.componentsAndPlainText = componentsDS;
        CGSize optimalSize1 = [cell.mLab_ATitle optimumSize];


        cell.mLab_ATitle.frame = CGRectMake(9, cell.mImgV_head.frame.origin.y+cell.mImgV_head.frame.size.height+15, [dm getInstance].width-18, optimalSize1.height);
        [cell.mWebV_comment.scrollView setScrollEnabled:NO];
        cell.mWebV_comment.tag = -1;
        cell.mWebV_comment.delegate = self;
        NSString *content = self.AnswerDetailModel.AContent;
        content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"width:"] withString:@" "];
        content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"_width="] withString:@" "];
        content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<img"] withString:@"<img class=\"pic\""];
        NSString *tempHtml = [NSString stringWithFormat:@"<meta name=\"viewport\" style=width:%dpx, content=\"width=%d,initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=no\" /><style>.pic{max-width:%dpx; max-height: auto; width: expression(this.width >%d && this.height < this.width ? %d: true); height: expression(this.height > auto ? auto: true);}</style>%@",[dm getInstance].width-18,[dm getInstance].width-18,[dm getInstance].width-18,[dm getInstance].width-18,[dm getInstance].width-18,content];
        [cell.mWebV_comment loadHTMLString:tempHtml baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
        //加载
        //[self webViewLoadFinish:0];

        //回答内容
        NSString *string2 = self.AnswerDetailModel.AContent;
        string2 = [string2 stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        string2 = [string2 stringByReplacingOccurrencesOfString:@"\r\r" withString:@""];
        NSString *name2;
        if([self.AnswerDetailModel.Flag integerValue]==0)
        {
            name2 = [NSString stringWithFormat:@"无内容"];

        }
        else if([self.AnswerDetailModel.Flag integerValue]==1)
        {
            name2 = [NSString stringWithFormat:@"<font size=14 color='red'>内容 : </font> <font>%@</font>", string2];

        }
        else
        {
            name2 = [NSString stringWithFormat:@"<font size=14 color='red'>依据 : </font> <font>%@</font>", string2];

        }
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
    cell.frame = CGRectMake(0, 10, [dm getInstance].width, cell.mLab_RecDate.frame.size.height+cell.mLab_RecDate.frame.origin.y+10);
    cell.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
//    [cell addGestureRecognizer:tap];
    return cell;
}
-(void)webViewLoadFinish:(float)height{
    self.KnowledgeTableViewCell.mWebV_comment.frame = CGRectMake(9, self.KnowledgeTableViewCell.mLab_Abstracts.frame.origin.y-3, [dm getInstance].width-18, height);
   

    self.KnowledgeTableViewCell.frame = CGRectMake(0, 0, [dm getInstance].width, self.KnowledgeTableViewCell.mWebV_comment.frame.origin.y+self.KnowledgeTableViewCell.mWebV_comment.frame.size.height);
    self.tableHeadView = [[UIView alloc]init];
    [self.tableHeadView addSubview:self.KnowledgeTableViewCell];
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
    [self.tableHeadView addSubview:self.mBtnV_btn];
    self.tableHeadView.frame = CGRectMake(0, 0, [dm getInstance].width, self.mBtnV_btn.frame.origin.y+self.mBtnV_btn.frame.size.height);
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.mNav_navgationBar.frame.size.height, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height) style:UITableViewStylePlain];
    self.tableView.tableHeaderView = self.tableHeadView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    self.tableView.headerPullToRefreshText = @"下拉刷新";
    self.tableView.headerReleaseToRefreshText = @"松开后刷新";
    self.tableView.headerRefreshingText = @"正在刷新...";
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    self.tableView.footerPullToRefreshText = @"上拉加载更多";
    self.tableView.footerReleaseToRefreshText = @"松开加载更多数据";
    self.tableView.footerRefreshingText = @"正在加载...";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.mView_text];
    
    [self.mView_text addSubview:self.mTextF_text];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    //self.tableView.footerHidden = YES;
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];

}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%d, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", [dm getInstance].width-18];
    [webView stringByEvaluatingJavaScriptFromString:meta];
    CGFloat webViewHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"]floatValue];
    [self webViewLoadFinish:webViewHeight+10];
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
        if (![utils isBlankString:textField.text]) {
            if(self.answerModel)
            {
                    [[KnowledgeHttp getInstance]AddCommentWithAId:self.answerModel.TabID comment:textField.text RefID:self.cellmodel.TabIDStr];
            }
            else
            {
                [[KnowledgeHttp getInstance]AddCommentWithAId:self.questionModel.answerModel.TabID comment:textField.text RefID:self.cellmodel.TabID];
            }

        }
        else
        {
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



@end
