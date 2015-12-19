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
#import "OnlineJobHttp.h"

@interface CommentViewController ()<UIActionSheetDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,strong)MyNavigationBar *mNav_navgationBar;
@property(nonatomic,strong)AllCommentListModel *AllCommentListModel;
@property(nonatomic,strong)KnowledgeTableViewCell *KnowledgeTableViewCell;
@property(nonatomic,assign)int mInt_reloadData;
@property(nonatomic,strong)UIButton *btn;//评论的支持和反对按钮（被点击的）
@property(nonatomic,strong)NSString *hideHUDTag;
@end

@implementation CommentViewController

//评论列表回调
-(void)CommentsListWithNumPerPage:(id)sender
{
    if([self.hideHUDTag isEqualToString:@"1"])
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    }
    self.hideHUDTag = @"0";

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
    JoinUnit
    if(view.tag == 100)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否举报" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        alert.delegate = self;
        alert.tag= 10000;

    }
    if(view.tag == 101)
    {
        NoNickName

        self.cellmodel.TabID = @"";
        self.mInt_reloadData = 0;
        [self.mView_text setHidden:NO];
        [self.mTextV_text becomeFirstResponder];
        
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
    self.mTextV_text.text = @"";
    //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *dic = [sender object];
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
    NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
    if([ResultCode integerValue]!=0)
    {
        [MBProgressHUD showError:@"目标可能已经被删除"];
    }
    else
    {
        [MBProgressHUD showSuccess:ResultDesc toView:self.view];
        if(self.answerModel)
        {
            [[KnowledgeHttp getInstance]CommentsListWithNumPerPage:@"20" pageNum:@"1" RowCount:@"0" AId:self.answerModel.TabID];
            //[[KnowledgeHttp getInstance]CommentsListWithNumPerPage:@"20" pageNum:@"1" AId:self.answerModel.TabID];
        }
        else
        {
            [[KnowledgeHttp getInstance]CommentsListWithNumPerPage:@"20" pageNum:@"1" RowCount:@"0"  AId:self.questionModel.answerModel.TabID];
            
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
            self.AnswerDetailModel = [dic objectForKey:@"model"];
            if([self.AnswerDetailModel.TabID integerValue]==0)
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                self.hideHUDTag = @"1";
                [MBProgressHUD showError:@"该条回答已被屏蔽或删除"];
            }
            if(self.KnowledgeTableViewCell == nil)
            {
                self.KnowledgeTableViewCell = [self getMainView];

            }
            else
            {
            ButtonViewCell *btnView101 = (ButtonViewCell*)[self.view viewWithTag:101];
            btnView101.mLab_title.text = [NSString stringWithFormat:@"评论%@",self.AnswerDetailModel.CCount];
            }
        }
    }
}
//反对称赞回调
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
        else if([Data integerValue]==-2)
        {
            [MBProgressHUD showText:@"答案可能已被删除"];
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
    
//    //输入框弹出键盘问题
//    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
//    manager.enable = NO;//控制整个功能是否启用
//    manager.shouldResignOnTouchOutside = YES;//控制点击背景是否收起键盘
//    manager.shouldToolbarUsesTextFieldTintColor = NO;//控制键盘上的工具条文字颜色是否用户自定义
//    manager.enableAutoToolbar = NO;//控制是否显示键盘上的工具条
}

-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer

{
    self.mView_text.hidden = YES;
    [self.view endEditing:YES];

    
}
-(void)AddScoreWithtabid:(id)sender
{
    NSString *resultCode = [sender object];
    NSString *btnTitle = [self.btn titleForState:UIControlStateNormal];
    if([resultCode integerValue]==0){
        [MBProgressHUD showSuccess:@"成功" toView:self.view];
   
    }
    else{
        [MBProgressHUD showError:@"目标可能已被删除" toView:self.view];
    }
    if(self.btn.tag>=0)
    {
        commentListModel *Model = [self.AllCommentListModel.mArr_CommentList objectAtIndex:self.btn.tag];
        NSArray *arry=[btnTitle componentsSeparatedByString:@"("];
        if(arry.count>0)
        {
            NSString *name = [arry objectAtIndex:0];
            NSString*str = [arry objectAtIndex:1];
            
            NSString *string = [str stringByReplacingOccurrencesOfString:@")" withString:@""];

            int num = [string intValue];
            if ([name isEqualToString:@"赞"]) {
                Model.LikeCount = [NSString stringWithFormat:@"%d",num+1];
                Model.Likeselected = YES;
            }
            else
            {
                Model.CaiCount = [NSString stringWithFormat:@"%d",num+1];
                Model.Caiselected = YES;

            }
            //[self.btn setTitle:[NSString stringWithFormat:@"%@(%d)",name,num+1] forState:UIControlStateNormal];
        }


    }
    else
    {
        commentListModel *refModel = [self.AllCommentListModel.mArr_refcomments objectAtIndex:[self.btn.restorationIdentifier intValue]];
        NSArray *arry=[btnTitle componentsSeparatedByString:@"("];
        if(arry.count>0)
        {
            NSString *name = [arry objectAtIndex:0];
            NSString*str = [arry objectAtIndex:1];
            
            NSString *string = [str stringByReplacingOccurrencesOfString:@")" withString:@""];
            
            int num = [string intValue];
            if ([name isEqualToString:@"赞"]) {
                refModel.LikeCount = [NSString stringWithFormat:@"%d",num+1];
                refModel.Likeselected = YES;
            }
            else
            {
                refModel.CaiCount = [NSString stringWithFormat:@"%d",num+1];
                refModel.Caiselected = YES;
                
            }
            //[self.btn setTitle:[NSString stringWithFormat:@"%@(%d)",name,num+1] forState:UIControlStateNormal];
            
        }

    }
    [self.tableView reloadData];
//    self.btn.enabled = NO;
//    [self.btn.layer setMasksToBounds:YES];
//    [self.btn.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
//    [self.btn.layer setBorderWidth:1.0]; //边框宽度
//    CGColorRef colorref = [UIColor grayColor].CGColor;
//    [self.btn.layer setBorderColor:colorref];
//    [self.btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];




}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.hideHUDTag = @"0";
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    singleTap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:singleTap];
    //[[KnowledgeHttp getInstance]AddMyAttQWithqId:@"11"];
    //[[KnowledgeHttp getInstance]AtMeForAnswerWithAccId:@"5233355" qId:@"11"];
    //[[KnowledgeHttp getInstance]MyAttQIndexWithnumPerPage:@"10" pageNum:@"1" RowCount:@"0"];
    //[[KnowledgeHttp getInstance]MyAnswerIndexWithnumPerPage:@"10" pageNum:@"1" RowCount:@"0"];
//    [[KnowledgeHttp getInstance]GetMyattCate];
//    [[KnowledgeHttp getInstance]AddMyattCateWithuid:@"11,15,45"];
    //[[KnowledgeHttp getInstance]GetAtMeUsersWithuid:@"" catid:@"3"];
    self.mInt_reloadData = 0;
    self.btn_tag = -1;
    //评论的赞和反对回调
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AddScoreWithtabid" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddScoreWithtabid:) name:@"AddScoreWithtabid" object:nil];
    //通知界面，更新访问量等数据
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updataQuestionDetail" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataQuestionDetail:) name:@"updataQuestionDetail" object:nil];
    //通知界面，更新答案数据
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updataQuestionDetailModel" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataQuestionDetailModel:) name:@"updataQuestionDetailModel" object:nil];
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
    self.mTextV_text = [[UITextView alloc] init];
    self.mTextV_text.frame = CGRectMake(15, 10, [dm getInstance].width-15*2-40, 51-20);
    //self.mTextV_text.placeholder = @"请输入评论内容";
    self.mTextV_text.delegate = self;
    self.mTextV_text.font = [UIFont systemFontOfSize:14];
    self.mTextV_text.layer.borderWidth = .5;
    self.mTextV_text.layer.borderColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    //self.mTextV_text.borderStyle = UITextBorderStyleRoundedRect;
    //self.mTextF_text.returnKeyType = UIReturnKeyDone;//return键的类型
    self.doneBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.doneBtn.frame =CGRectMake(self.mTextV_text.frame.origin.x+self.mTextV_text.frame.size.width+10, 10, 30, 31);
    [self.doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.doneBtn addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.mView_text setHidden:YES];

    D("dspfgijagopfjdp-====%@,%@",self.answerModel.TabID,self.questionModel.answerModel.TabID);
    [MBProgressHUD showMessage:@"" toView:self.view];

    if ([self.answerModel.TabID isEqualToString:@"(null)"]) {
        [MBProgressHUD showSuccess:@"当前回答可能已被删除" toView:self.view];
    }else{
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
            [[KnowledgeHttp getInstance]CommentsListWithNumPerPage:@"20" pageNum:@"1" RowCount:@"0"  AId:self.answerModel.TabID];
        }
        else
        {

            [[KnowledgeHttp getInstance]CommentsListWithNumPerPage:@"20" pageNum:@"1" RowCount:@"0"  AId:self.questionModel.answerModel.TabID];
        }
    }
        // Do any additional setup after loading the view from its nib.
}
#pragma mark 开始进入刷新状态
- (void)headerRereshing{
    self.hideHUDTag = @"1";
    self.mInt_reloadData = 0;
    [self sendRequest];
}

- (void)footerRereshing{
    self.hideHUDTag = @"1";
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
        [[KnowledgeHttp getInstance]CommentsListWithNumPerPage:@"20" pageNum:page RowCount:self.AllCommentListModel.RowCount AId:self.answerModel.TabID];
        return;
    }
    [[KnowledgeHttp getInstance]CommentsListWithNumPerPage:@"20" pageNum:page RowCount:self.AllCommentListModel.RowCount AId:self.questionModel.answerModel.TabID];
}
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
    if(self.topButtonTag == 1)
    {
        return 0;
    }
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
        
//        //若是需要重用，需要写上以下两句代码
//        UINib * n= [UINib nibWithNibName:@"AirthCommentsListCell" bundle:[NSBundle mainBundle]];
//        [self.tableView registerNib:n forCellReuseIdentifier:indentifier];
        
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
    if([model.UserName isEqual:[NSNull null]]||[model.UserName isEqualToString: @""])
    {
        model.UserName = model.JiaoBaoHao;
    }
    NSString *tempName = [NSString stringWithFormat:@"%@",model.UserName];
    CGSize sizeName = [tempName sizeWithFont:[UIFont systemFontOfSize:12]];
    cell.mLab_UnitShortname.frame = CGRectMake(70, 10, 180, 15);
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
                    if([refModel.UserName isEqual:[NSNull null]])
                    {
                        refModel.UserName = refModel.JiaoBaoHao;
                    }
                    NSString *tempTitle = [NSString stringWithFormat:@"%@:%@",refModel.UserName,refModel.WContent];
                    tempLab.font = [UIFont systemFontOfSize:12];
                    tempLab.numberOfLines = 99999;
                    tempLab.lineBreakMode = NSLineBreakByWordWrapping;
                    CGSize sizeTitle = [tempTitle sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake([dm getInstance].width-90, 99999)];
                    tempLab.frame = CGRectMake(10, 5, sizeTitle.width, sizeTitle.height);
                    tempLab.text = tempTitle;
                    [tempView addSubview:tempLab];
                    //踩
                    NSString *tempCaiCount = [NSString stringWithFormat:@"踩(%@)",refModel.CaiCount];
                    CGSize sizeCai = [tempCaiCount sizeWithFont:[UIFont systemFontOfSize:12]];
                    tempBtnCai.frame = CGRectMake([dm getInstance].width-100-sizeCai.width, tempLab.frame.origin.y+tempLab.frame.size.height+10, sizeCai.width+15, 20);
                    [tempBtnCai setTitle:tempCaiCount forState:UIControlStateNormal];
                    tempBtnCai.titleLabel.font = [UIFont systemFontOfSize:12];
                    tempBtnCai.restorationIdentifier = [NSString stringWithFormat:@"%d",a ];
                    tempBtnCai.tag = -2;
                    //tempBtnCai.hidden = YES;
                    //边框
                    if(refModel.Caiselected == YES)
                    {
                        tempBtnCai.enabled = NO;
                        [tempBtnCai.layer setMasksToBounds:YES];
                        [tempBtnCai.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
                        [tempBtnCai.layer setBorderWidth:1.0]; //边框宽度
                        CGColorRef colorref = [UIColor grayColor].CGColor;
                        [tempBtnCai.layer setBorderColor:colorref];//边框颜色
                        [tempBtnCai addTarget:self action:@selector(tempViewBtnCai:) forControlEvents:UIControlEventTouchUpInside];
                        [tempView addSubview:tempBtnCai];
                        [tempBtnCai setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                        
                    }else{
                        tempBtnCai.enabled = YES;
                        [tempBtnCai.layer setMasksToBounds:YES];
                        [tempBtnCai.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
                        [tempBtnCai.layer setBorderWidth:1.0]; //边框宽度
                        CGColorRef colorref = [UIColor blueColor].CGColor;
                        [tempBtnCai.layer setBorderColor:colorref];//边框颜色
                        [tempBtnCai addTarget:self action:@selector(tempViewBtnCai:) forControlEvents:UIControlEventTouchUpInside];
                        [tempView addSubview:tempBtnCai];
                        [tempBtnCai setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];

                    }
                    if(refModel.Likeselected == YES){
                        tempBtnLike.enabled = NO;
                        CGColorRef colorref = [UIColor grayColor].CGColor;

                        [tempBtnLike.layer setMasksToBounds:YES];
                        [tempBtnLike.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
                        [tempBtnLike.layer setBorderWidth:1.0]; //边框宽度
                        [tempBtnLike.layer setBorderColor:colorref];//边框颜色
                        [tempBtnLike addTarget:self action:@selector(tempViewBtnLike:) forControlEvents:UIControlEventTouchUpInside];
                        [tempView addSubview:tempBtnLike];
                        [tempBtnLike setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

                        
                    }else{
                        tempBtnLike.enabled = YES;
                        CGColorRef colorref = [UIColor blueColor].CGColor;

                        [tempBtnLike.layer setMasksToBounds:YES];
                        [tempBtnLike.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
                        [tempBtnLike.layer setBorderWidth:1.0]; //边框宽度
                        [tempBtnLike.layer setBorderColor:colorref];//边框颜色
                        [tempBtnLike addTarget:self action:@selector(tempViewBtnLike:) forControlEvents:UIControlEventTouchUpInside];
                        [tempView addSubview:tempBtnLike];
                        [tempBtnLike setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];

                        
                    }

                    //顶
                    NSString *tempLikeCount = [NSString stringWithFormat:@"赞(%@)",refModel.LikeCount];
                    CGSize sizeLike = [tempLikeCount sizeWithFont:[UIFont systemFontOfSize:12]];
                    tempBtnLike.frame = CGRectMake(tempBtnCai.frame.origin.x-25-sizeLike.width, tempBtnCai.frame.origin.y, sizeLike.width+15, 20);
                    [tempBtnLike setTitle:tempLikeCount forState:UIControlStateNormal];
                    tempBtnLike.titleLabel.font = [UIFont systemFontOfSize:12];
                    tempBtnLike.restorationIdentifier = [NSString stringWithFormat:@"%d",a ];
                    tempBtnLike.tag = -1;

                    //tempBtnLike.hidden = YES;
                    //边框

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
    cell.mBtn_reply.frame = CGRectMake([dm getInstance].width, cell.mLab_Commnets.frame.origin.y+cell.mLab_Commnets.frame.size.height+10, sizeReply.width+20, 30);
    cell.mBtn_reply.hidden = YES;
    //踩按钮
    NSString *tempCai = [NSString stringWithFormat:@"踩(%@)",model.CaiCount];
    CGSize sizeCai = [tempCai sizeWithFont:[UIFont systemFontOfSize:12]];
    cell.mBtn_CaiCount.frame = CGRectMake(cell.mBtn_reply.frame.origin.x-30-sizeCai.width, cell.mBtn_reply.frame.origin.y, sizeCai.width+20, 30);
    [cell.mBtn_CaiCount setTitle:tempCai forState:UIControlStateNormal];
    cell.mBtn_CaiCount.restorationIdentifier = model.TabID;
    //cell.mBtn_CaiCount.hidden = YES;
    //顶按钮
    NSString *tempLike = [NSString stringWithFormat:@"赞(%@)",model.LikeCount];
    CGSize sizeLike = [tempLike sizeWithFont:[UIFont systemFontOfSize:12]];
    cell.mBtn_LikeCount.frame = CGRectMake(cell.mBtn_CaiCount.frame.origin.x-30-sizeLike.width, cell.mBtn_CaiCount.frame.origin.y, sizeLike.width+20, 30);
    [cell.mBtn_LikeCount setTitle:tempLike forState:UIControlStateNormal];
    cell.mBtn_LikeCount.restorationIdentifier = model.TabID;
    if(model.Likeselected == YES){
        cell.mBtn_LikeCount.enabled = NO;

        CGColorRef colorref = [UIColor grayColor].CGColor;
        [cell.mBtn_LikeCount.layer setBorderColor:colorref];//边框颜色
        [cell.mBtn_LikeCount setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
 
    }else{
        cell.mBtn_LikeCount.enabled = YES;

        CGColorRef colorref = [UIColor blueColor].CGColor;
        [cell.mBtn_LikeCount.layer setBorderColor:colorref];//边框颜色
        [cell.mBtn_LikeCount setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
    }
    
    if(model.Caiselected == YES){
        cell.mBtn_CaiCount.enabled = NO;
        CGColorRef colorref = [UIColor grayColor].CGColor;
        [cell.mBtn_CaiCount.layer setBorderColor:colorref];//边框颜色
        [cell.mBtn_CaiCount setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
    }else{
        cell.mBtn_CaiCount.enabled = YES;
        CGColorRef colorref = [UIColor blueColor].CGColor;
        [cell.mBtn_CaiCount.layer setBorderColor:colorref];//边框颜色
        [cell.mBtn_CaiCount setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
    }
    //cell.mBtn_LikeCount.hidden = YES;
    
    
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
    JoinUnit
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIActionSheet * action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"回复",@"举报",nil];
    action.tag = indexPath.row;
    [action showInView:self.view];
//    [self.mView_text setHidden:NO];
//    [self.mTextF_text becomeFirstResponder];
    self.cellmodel = [self.AllCommentListModel.mArr_CommentList objectAtIndex:indexPath.row];
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
        if (buttonIndex == 0){
            NoNickName

            [self.mView_text setHidden:NO];
            [self.mTextV_text becomeFirstResponder];

        }else if (buttonIndex == 1){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否举报" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
            alert.delegate = self;
            alert.tag = actionSheet.tag;

        }
//    else if(buttonIndex == 2)
//    {
//        commentListModel *model = [self.AllCommentListModel.mArr_CommentList objectAtIndex:actionSheet.tag];
//        [[KnowledgeHttp getInstance]AddScoreWithtabid:model.TabID tp:@"1"];
//        NSIndexPath *index =[NSIndexPath indexPathForRow:actionSheet.tag inSection:0];
//        AirthCommentsListCell *cell = (AirthCommentsListCell *)[self.tableView cellForRowAtIndexPath:index];
//        self.btn = cell.mBtn_LikeCount;
//        self.btn.tag = cell.tag;
//
//        //[[KnowledgeHttp getInstance]SetYesNoWithAId:model.TabID yesNoFlag:@"1"];
//    }
//    else if(buttonIndex == 3)
//    {
//        commentListModel *model = [self.AllCommentListModel.mArr_CommentList objectAtIndex:actionSheet.tag];
//        [[KnowledgeHttp getInstance]AddScoreWithtabid:model.TabID tp:@"0"];
//        NSIndexPath *index =[NSIndexPath indexPathForRow:actionSheet.tag inSection:0];
//        AirthCommentsListCell *cell = (AirthCommentsListCell *)[self.tableView cellForRowAtIndexPath:index];
//        self.btn = cell.mBtn_CaiCount;
//        self.btn.tag = cell.tag;
//
//    }

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 10000)
    {
        if(buttonIndex == 1)
        {
            if(self.answerModel)
            {
                //[[KnowledgeHttp getInstance]reportanswerWithAId:self.answerModel.TabID];
                [[KnowledgeHttp getInstance]ReportAnsWithAId:self.answerModel.TabID repType:@"0"];
                
            }
            else
            {
                //[[KnowledgeHttp getInstance]reportanswerWithAId:self.questionModel.answerModel.TabID];
                [[KnowledgeHttp getInstance]ReportAnsWithAId:self.questionModel.answerModel.TabID repType:@"0"];
                
            }
            
        }

    }
    else
    {
        if(buttonIndex == 1)
        {
            commentListModel *model = [self.AllCommentListModel.mArr_CommentList objectAtIndex:alertView.tag];
            [[KnowledgeHttp getInstance]ReportAnsWithAId:model.TabID repType:@"2"];
        }
    }
}

//点击点赞按钮
-(void)likeAction:(id)sender
{
    JoinUnit;
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
    cell.askImgV.hidden = NO;
    cell.delegate= self;
    cell.model = self.questionModel;
    cell.answerModel = self.answerModel;
    cell.AnswerDetailModel = self.AnswerDetailModel;
    [cell.LikeBtn addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];

    //详情
    //cell.mBtn_detail.hidden = YES;
    cell.mBtn_detail.frame = CGRectMake([dm getInstance].width-52, 3, 40, cell.mBtn_detail.frame.size.height);
    if(self.topButtonTag ==  1)
    {
        [cell.mBtn_detail setTitle:@"原文" forState:UIControlStateNormal];

        
    }
    else
    {
        [cell.mBtn_detail setTitle:@"详情" forState:UIControlStateNormal];

    }
    if(self.flag == NO)
    {
        cell.mBtn_detail.hidden = YES;
    }
//    NSString *string_title = cell.model.Title;
//    string_title = [string_title stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
//    CGSize size_title = [string_title sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(cell.mBtn_detail.frame.origin.x-5, 1000)];
//    if (size_title.height>20) {
//        size_title = CGSizeMake(size_title.width, size_title.height);
//    }
//    cell.mLab_title.lineBreakMode = NSLineBreakByWordWrapping;
//    cell.mLab_title.font = [UIFont systemFontOfSize:14];
//    cell.mLab_title.numberOfLines =0;
//    cell.mLab_title.text = cell.model.Title;
//    cell.mLab_title.frame = CGRectMake(9, 3, cell.mBtn_detail.frame.origin.x-5, size_title.height);
    NSString *string1 = cell.model.Title;
    string1 = [string1 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string1 = [string1 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    cell.askImgV.image = [UIImage imageNamed:@"ask"];
    cell.askImgV.frame = CGRectMake(9, 10, 19, 19);
    NSString *name = [NSString stringWithFormat:@"<font size=14 color='#2589D1'>%@</font>",string1];
    NSMutableDictionary *row1 = [NSMutableDictionary dictionary];
    [row1 setObject:name forKey:@"text"];
    cell.mLab_title.lineBreakMode = RTTextLineBreakModeCharWrapping;
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:[row1 objectForKey:@"text"]];
    cell.mLab_title.componentsAndPlainText = componentsDS;
    CGSize titleSize = [cell.mLab_title optimumSize];
   // cell.mLab_title.frame = CGRectMake(9, 3, cell.mBtn_detail.frame.origin.x-5, 23);
    cell.mLab_title.frame = CGRectMake(cell.askImgV.frame.origin.x+cell.askImgV.frame.size.width, cell.askImgV.frame.origin.y, [dm getInstance].width-9*2-40- cell.answerImgV.frame.size.width, titleSize.height);

    //话题
    cell.mLab_Category0.frame = CGRectMake(30, cell.mLab_title.frame.origin.y+cell.mLab_title.frame.size.height, cell.mLab_Category0.frame.size.width, cell.mLab_Category0.frame.size.height);
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
    
        //分割线
        cell.mLab_line.hidden = NO;
        cell.answerImgV.hidden = NO;//答
        cell.basisImagV.hidden = NO;//依据或内容
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
        cell.mCollectionV_pic.hidden = YES;
        //时间
        cell.mLab_RecDate.hidden = NO;
        //评论
        cell.mLab_commentCount.hidden = YES;
        cell.mLab_comment.hidden = YES;
        cell.mWebV_comment.hidden =NO;
        //分割线
        cell.mLab_line.frame = CGRectMake(20, cell.mLab_Category0.frame.origin.y+cell.mLab_Category0.frame.size.height+5, [dm getInstance].width-20, .5);
      if([self.AnswerDetailModel.TabID integerValue]==0)
      {
          return cell;
      }
        
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
        NSString *string2 = self.AnswerDetailModel.ATitle;
        string2 = [string2 stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        
        //NSString *str = [NSString stringWithFormat:@"依据 : %@",string1];
//        CGSize size1 = [str sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake([dm getInstance].width-18, 1000)];
//        if (size1.height>20) {
//            size1 = CGSizeMake(size1.width, size1.height);
//        }
        NSMutableDictionary *row2 = [NSMutableDictionary dictionary];
        cell.answerImgV.frame = CGRectMake(9, cell.mImgV_head.frame.origin.y+cell.mImgV_head.frame.size.height+15, 26, 16);
        NSString *name2 = [NSString stringWithFormat:@"<font size=12 color=black>%@</font>",string2];
    [row2 setObject:name2 forKey:@"text"];
    RTLabelComponentsStructure *componentsDS2 = [RCLabel extractTextStyle:[row2 objectForKey:@"text"]];
    cell.mLab_ATitle.componentsAndPlainText = componentsDS2;
    CGSize optimalSize2 = [cell.mLab_ATitle optimumSize];
    cell.mLab_ATitle.frame = CGRectMake(9+26, cell.mImgV_head.frame.origin.y+cell.mImgV_head.frame.size.height+15, [dm getInstance].width-10-cell.mImgV_head.frame.size.width, optimalSize2.height);
    
    
    //加载webview
    [cell.mWebV_comment.scrollView setScrollEnabled:NO];
    cell.mWebV_comment.tag = -1;
    cell.mWebV_comment.scalesPageToFit = YES;
    cell.mWebV_comment.delegate = self;
    cell.mWebV_comment.backgroundColor = [UIColor whiteColor];
    NSString *content = self.AnswerDetailModel.AContent;
    content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"width"] withString:@" "];
    content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"_width="] withString:@" "];
    content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"table"] withString:@"div"];
    content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"tbody"] withString:@"div"];
    content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"tr"] withString:@"p"];
    content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"td"] withString:@"div"];
    content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"\n"] withString:@"</br>"];
    content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<img"] withString:@"<img class=\"pic\""];
    content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"nowrap"] withString:@""];
    NSString *tempHtml = [NSString stringWithFormat:@"<meta name=\"viewport\" style=width:%dpx, content=\"width=%d,initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=no\" /><style>.pic{max-width:%dpx; max-height: auto; width: expression(this.width >%d && this.height < this.width ? %d: true); height: expression(this.height > auto ? auto: true);}</style>%@",[dm getInstance].width-18,[dm getInstance].width-18,[dm getInstance].width-18,[dm getInstance].width-18,[dm getInstance].width-18,content];
    [cell.mWebV_comment loadHTMLString:tempHtml baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
    //加载
    //[self webViewLoadFinish:0];
    
    
    
    cell.mLab_Abstracts.frame = CGRectMake(9, cell.mLab_ATitle.frame.origin.y+cell.mLab_ATitle.frame.size.height+10, [dm getInstance].width-18, 50);
    //    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, cell.mLab_Abstracts.frame.origin.y-15, 50, 30)];
    if([self.AnswerDetailModel.Flag integerValue]==1)
    {
        cell.basisImagV.image = [UIImage imageNamed:@"content"];
        cell.basisImagV.frame = CGRectMake(9, cell.mLab_Abstracts.frame.origin.y, 26, 16);

        
//        contentLabel.text = @"内容:";
//        contentLabel.textColor = [UIColor colorWithRed:3/255.0 green:170/255.0 blue:3/255.0 alpha:1];


    }
    else if([self.AnswerDetailModel.Flag integerValue]==2)
    {
        cell.basisImagV.image = [UIImage imageNamed:@"basis"];
        cell.basisImagV.frame = CGRectMake(9, cell.mLab_Abstracts.frame.origin.y, 29, 29);

//        contentLabel.text = @"依据:";
//        contentLabel.textColor = [UIColor redColor];
    }
    else
    {
        cell.basisImagV.image = [UIImage imageNamed:@"noContent"];
        cell.basisImagV.frame = CGRectMake(9, cell.mLab_Abstracts.frame.origin.y, 36, 16);
        
    }
//    contentLabel.font = [UIFont systemFontOfSize:13];
//    [cell.contentView addSubview:contentLabel];
//    contentLabel.textAlignment = NSTextAlignmentLeft;
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
            cell.mLab_line2.frame = CGRectMake(0, cell.mImgV_head.frame.origin.y+cell.mImgV_head.frame.size.height+5, [dm getInstance].width, 1);
//            cell.mLab_line2.frame = CGRectMake(0, cell.mLab_RecDate.frame.origin.y+cell.mLab_RecDate.frame.size.height+10, [dm getInstance].width, 1);
        }else{
            cell.mLab_line2.frame = CGRectMake(0, cell.mImgV_head.frame.origin.y+cell.mImgV_head.frame.size.height+5, [dm getInstance].width, 1);
        }
    cell.frame = CGRectMake(0, 10, [dm getInstance].width, cell.mLab_RecDate.frame.size.height+cell.mLab_RecDate.frame.origin.y+10);
    cell.userInteractionEnabled = YES;

    return cell;
}
-(void)webViewLoadFinish:(float)height{
    self.KnowledgeTableViewCell.mWebV_comment.frame = CGRectMake(0, self.KnowledgeTableViewCell.basisImagV.frame.size.height+self.KnowledgeTableViewCell.basisImagV.frame.origin.y, [dm getInstance].width, height);
   

    self.KnowledgeTableViewCell.frame = CGRectMake(0, 5, [dm getInstance].width, self.KnowledgeTableViewCell.mWebV_comment.frame.origin.y+self.KnowledgeTableViewCell.mWebV_comment.frame.size.height);
    self.tableHeadView = [[UIView alloc]init];
    [self.tableHeadView addSubview:self.KnowledgeTableViewCell];
    if(self.topButtonTag == 1)
    {
    self.tableHeadView.frame = CGRectMake(0, 0, [dm getInstance].width, self.KnowledgeTableViewCell.frame.origin.y+self.KnowledgeTableViewCell.frame.size.height);
        
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.mNav_navgationBar.frame.size.height, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height) style:UITableViewStylePlain];
        self.tableView.tableHeaderView = self.tableHeadView;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableFooterView = [[UIView alloc]init];


        [self.view addSubview:self.tableView];
        [self.view addSubview:self.mView_text];
        [MBProgressHUD hideHUDForView:self.view];
        return;
    }
    NSMutableArray *temp = [NSMutableArray array];
    if(!self.mBtnV_btn)
    {
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
    }
    else
    {
        ButtonViewCell *btnView101 = (ButtonViewCell*)[self.view viewWithTag:101];
        ButtonViewCell *btnView102 = (ButtonViewCell*)[self.view viewWithTag:102];
        btnView101.mLab_title.text = [NSString stringWithFormat:@"评论%@",self.AnswerDetailModel.CCount];
        btnView102.mLab_title.text = [NSString stringWithFormat:@"反对%@",self.AnswerDetailModel.CaiCount];
        
    }
    [self.tableHeadView addSubview:self.mBtnV_btn];


    self.tableHeadView.frame = CGRectMake(0, 0, [dm getInstance].width, self.mBtnV_btn.frame.origin.y+self.mBtnV_btn.frame.size.height);
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.mNav_navgationBar.frame.size.height, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height) style:UITableViewStylePlain];
    self.tableView.tableHeaderView = self.tableHeadView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.mView_text];
    [self.mView_text addSubview:self.mTextV_text];
    [self.mView_text addSubview:self.doneBtn];
    
    self.tableView.tableFooterView = [[UIView alloc]init];

        [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
        self.tableView.headerPullToRefreshText = @"下拉刷新";
        self.tableView.headerReleaseToRefreshText = @"松开后刷新";
        self.tableView.headerRefreshingText = @"正在刷新...";
        [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
        self.tableView.footerPullToRefreshText = @"上拉加载更多";
        self.tableView.footerReleaseToRefreshText = @"松开加载更多数据";
        self.tableView.footerRefreshingText = @"正在加载...";
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    [MBProgressHUD hideHUDForView:self.view];




    //self.tableView.footerHidden = YES;


}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%d, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", [dm getInstance].width-18];
//    NSString* js = @"document.getElementById(\"main\") ? document.getElementById(\"main\").offsetHeight : -1";
//    CGFloat webViewHeight = [[webView stringByEvaluatingJavaScriptFromString:js] floatValue];

    [webView stringByEvaluatingJavaScriptFromString:meta];
    CGFloat webViewHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"]floatValue];
    [self webViewLoadFinish:webViewHeight+10];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

//通知界面，更新答案数据
-(void)updataQuestionDetailModel:(NSNotification *)noti{
    
}


-(void)updataQuestionDetail:(NSNotification *)noti{
    QuestionDetailModel *model = noti.object;
    self.KnowledgeTableViewCell.mLab_ViewCount.text = [NSString stringWithFormat:@"%d",[model.ViewCount intValue]+1];
    self.KnowledgeTableViewCell.mLab_AnswersCount.text = model.AnswersCount;
    self.KnowledgeTableViewCell.mLab_AttCount.text = model.AttCount;

}
//cell的点击事件---详情
-(void)KnowledgeTableVIewCellDetailBtn:(KnowledgeTableViewCell *)knowledgeTableViewCell{
//    KnowledgeQuestionViewController *queston = [[KnowledgeQuestionViewController alloc] init];
//    QuestionModel *model = [[QuestionModel alloc] init];
//    model.TabID = self.questionModel.TabID;
//    model.ViewCount = self.questionModel.ViewCount;
//    model.AttCount = self.questionModel.AttCount;
//    model.AnswersCount = self.questionModel.AnswersCount;
//    model.Title = self.questionModel.Title;
//    model.CategorySuject = self.questionModel.CategorySuject;
//    queston.mModel_question = model;
//    [utils pushViewController:queston animated:YES];
    if(self.topButtonTag == 1)
    {
        KnowledgeQuestionViewController *queston = [[KnowledgeQuestionViewController alloc] init];

        queston.mModel_question = knowledgeTableViewCell.model;
        [utils pushViewController:queston animated:YES];
    }
    else{
        
        KnowledgeAddAnswerViewController *detail = [[KnowledgeAddAnswerViewController alloc] init];
        detail.mInt_view = 0;
        detail.mModel_question = knowledgeTableViewCell.model;
        [utils pushViewController:detail animated:YES];
        
    }

}

-(void)tapAction:(id)sender
{
    self.mView_text.hidden = YES;
    [self.mTextV_text resignFirstResponder];
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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if(touch.view != self.tableView){
        return NO;
    }else
        return YES;
}
-(void)doneAction:(id)sender
{
        [self.mTextV_text resignFirstResponder];
        self.mView_text.hidden = YES;
        if(self.mTextV_text.text.length>1000)
        {
            [MBProgressHUD showError:@"评论字数不能大于1000" toView:self.view];
            return ;
        }
        
        //若其有输入内容，则发送
        if (![utils isBlankString:self.mTextV_text.text]) {
            if ([dm getInstance].NickName1.length==0) {
                [MBProgressHUD showError:@"请去个人中心设置昵称" toView:self.view];
                return ;
            }
            if(self.cellmodel.TabIDStr == nil)
            {
                self.cellmodel = [[commentListModel alloc]init];
                self.cellmodel.TabID = @"";
            }
            if(self.answerModel)
            {
                [[KnowledgeHttp getInstance]AddCommentWithAId:self.answerModel.TabID comment:self.mTextV_text.text RefID:self.cellmodel.TabID];
            }
            else
            {
                [[KnowledgeHttp getInstance]AddCommentWithAId:self.questionModel.answerModel.TabID comment:self.mTextV_text.text RefID:self.cellmodel.TabID];
                
            }
            

    }
}
//键盘点击DO
#pragma mark - UITextView Delegate Methods
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if ([string isEqualToString:@"\n"]) {
//        [textField resignFirstResponder];
//        self.mView_text.hidden = YES;
//        if(textField.text.length>1000)
//        {
//            [MBProgressHUD showError:@"评论字数不能大于1000" toView:self.view];
//            return YES;
//        }
//
//        //若其有输入内容，则发送
//        if (![utils isBlankString:textField.text]) {
//            if ([dm getInstance].NickName1.length==0) {
//                [MBProgressHUD showError:@"请去个人中心设置昵称" toView:self.view];
//                return YES;
//            }
//            if(self.cellmodel.TabIDStr == nil)
//            {
//                self.cellmodel = [[commentListModel alloc]init];
//                self.cellmodel.TabID = @"";
//            }
//            if(self.answerModel)
//            {
//                    [[KnowledgeHttp getInstance]AddCommentWithAId:self.answerModel.TabID comment:textField.text RefID:self.cellmodel.TabID];
//            }
//            else
//            {
//                [[KnowledgeHttp getInstance]AddCommentWithAId:self.questionModel.answerModel.TabID comment:textField.text RefID:self.cellmodel.TabID];
//                
//            }
//
//        }
//        else
//        {
//        }
//        return NO;
//    }
    return YES;
}

-(void)tempViewBtnLike:(id)sender
{
    UIButton *likeBtn = sender;
    self.btn = sender;
    commentListModel *refModel = [self.AllCommentListModel.mArr_refcomments objectAtIndex:[self.btn.restorationIdentifier intValue]];

    [[KnowledgeHttp getInstance]AddScoreWithtabid:refModel.TabID tp:@"1"];

}
-(void)tempViewBtnCai:(id)sender
{
    UIButton *caiBtn = sender;
    self.btn = sender;
    commentListModel *refModel = [self.AllCommentListModel.mArr_refcomments objectAtIndex:[self.btn.restorationIdentifier intValue]];

    [[KnowledgeHttp getInstance]AddScoreWithtabid:refModel.TabID tp:@"0"];

}

//顶
- (void) mBtn_LikeCount:(AirthCommentsListCell *) airthCommentsListCell{
    self.btn = airthCommentsListCell.mBtn_LikeCount;
    self.btn.tag = airthCommentsListCell.tag;
    commentListModel *model = [self.AllCommentListModel.mArr_CommentList objectAtIndex:airthCommentsListCell.tag];
    [[KnowledgeHttp getInstance]AddScoreWithtabid:model.TabID tp:@"1"];

}
//踩
- (void) mBtn_CaiCount:(AirthCommentsListCell *) airthCommentsListCell{
    self.btn = airthCommentsListCell.mBtn_CaiCount;
    self.btn.tag = airthCommentsListCell.tag;

    commentListModel *model = [self.AllCommentListModel.mArr_CommentList objectAtIndex:airthCommentsListCell.tag];
    [[KnowledgeHttp getInstance]AddScoreWithtabid:model.TabID tp:@"0"];
}
-(void)myNavigationGoback{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    [utils popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
