//
//  KnowledgeQuestionViewController.m
//  JiaoBao
//
//  Created by Zqw on 15/8/10.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "KnowledgeQuestionViewController.h"
#import "HtmlString.h"

@interface KnowledgeQuestionViewController ()

@end

@implementation KnowledgeQuestionViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    // Do any additional setup after loading the view from its nib.
    //获取问题的答案列表
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetAnswerById" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetAnswerById:) name:@"GetAnswerById" object:nil];
    
    self.mArr_answers = [NSMutableArray array];
    self.mInt_reloadData = 0;
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:[NSString stringWithFormat:@"%@",self.mModel_question.Title]];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    
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
    self.mView_titlecell.delegate = self;
    //设置布局
    [self setTitleCell:self.mModel_question];
    [self.view addSubview:self.mView_titlecell];
    
    //
    NSMutableArray *temp = [NSMutableArray array];
    for (int i=0; i<3; i++) {
        ButtonViewModel *model = [[ButtonViewModel alloc] init];
        if (i==0) {
            model.mStr_title = @"回答问题";
            model.mStr_img = @"buttonView1";
        }else if (i==1){
            model.mStr_title = @"邀请问题";
            model.mStr_img = @"buttonView4";
        }else if (i==2){
            model.mStr_title = @"关注问题";
            model.mStr_img = @"buttonView3";
        }
        
        [temp addObject:model];
    }
    self.mBtnV_btn = [[ButtonView alloc] initFrame:CGRectMake(0, self.mView_titlecell.frame.origin.y+self.mView_titlecell.frame.size.height, [dm getInstance].width, 50) Array:temp];
    self.mBtnV_btn.delegate = self;
    [self.view addSubview:self.mBtnV_btn];
    
    [[KnowledgeHttp getInstance] GetAnswerByIdWithNumPerPage:@"10" pageNum:@"1" QId:self.mModel_question.TabID flag:@"-1"];
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    
    self.mTableV_answers = [[UITableView alloc] init];
    self.mTableV_answers.frame = CGRectMake(0, self.mBtnV_btn.frame.origin.y+self.mBtnV_btn.frame.size.height+10, [dm getInstance].width, [dm getInstance].height-(self.mBtnV_btn.frame.origin.y+self.mBtnV_btn.frame.size.height));
    self.mTableV_answers.delegate = self;
    self.mTableV_answers.dataSource = self;
    self.mTableV_answers.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.mTableV_answers addHeaderWithTarget:self action:@selector(headerRereshing)];
    self.mTableV_answers.headerPullToRefreshText = @"下拉刷新";
    self.mTableV_answers.headerReleaseToRefreshText = @"松开后刷新";
    self.mTableV_answers.headerRefreshingText = @"正在刷新...";
    [self.mTableV_answers addFooterWithTarget:self action:@selector(footerRereshing)];
    self.mTableV_answers.footerPullToRefreshText = @"上拉加载更多";
    self.mTableV_answers.footerReleaseToRefreshText = @"松开加载更多数据";
    self.mTableV_answers.footerRefreshingText = @"正在加载...";
    [self.view addSubview:self.mTableV_answers];
}

//获取问题的答案列表
-(void)GetAnswerById:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    [self.mTableV_answers headerEndRefreshing];
    [self.mTableV_answers footerEndRefreshing];
    NSMutableDictionary *dic = noti.object;
    NSString *code = [dic objectForKey:@"code"];
    if ([code integerValue] ==0) {
        NSMutableArray *array = [dic objectForKey:@"array"];
        if (self.mInt_reloadData ==0) {
            self.mArr_answers = [NSMutableArray arrayWithArray:array];
        }else{
            [self.mArr_answers addObjectsFromArray:array];
        }
    }
    [self.mTableV_answers reloadData];
}

//设置标题栏布局
-(void)setTitleCell:(QuestionModel *)model{
    //标题
    self.mView_titlecell.mLab_title.frame = CGRectMake(9, 10, [dm getInstance].width-9*2-40, 16);
    self.mView_titlecell.mLab_title.text = model.Title;
    self.mView_titlecell.mLab_title.hidden = NO;
    //详情
    self.mView_titlecell.mBtn_detail.frame = CGRectMake([dm getInstance].width-49, 0, 40, self.mView_titlecell.mBtn_detail.frame.size.height);
    //话题
    self.mView_titlecell.mLab_Category0.frame = CGRectMake(30, self.mView_titlecell.mLab_title.frame.origin.y+16+5, self.mView_titlecell.mLab_Category0.frame.size.width, 21);
    CGSize CategorySize = [[NSString stringWithFormat:@"%@",model.CategorySuject] sizeWithFont:[UIFont systemFontOfSize:10]];
    self.mView_titlecell.mLab_Category1.frame = CGRectMake(30+self.mView_titlecell.mLab_Category0.frame.size.width+2, self.mView_titlecell.mLab_Category0.frame.origin.y, CategorySize.width, 21);
    self.mView_titlecell.mLab_Category1.text = model.CategorySuject;
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
    self.mView_titlecell.mLab_AnswersCount.frame = CGRectMake(self.mView_titlecell.mLab_View.frame.origin.x-5-AnswersSize.width, self.mView_titlecell.mLab_Category0.frame.origin.y, AnswersSize.width, 21);
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
    //分割线
    self.mView_titlecell.mLab_line.hidden = YES;
    //赞
    self.mView_titlecell.mLab_LikeCount.hidden = YES;
    //头像
    self.mView_titlecell.mImgV_head.hidden = YES;
    //姓名
    self.mView_titlecell.mLab_IdFlag.hidden = YES;
    //回答标题
    self.mView_titlecell.mLab_ATitle.hidden = YES;
    //回答内容
    self.mView_titlecell.mLab_Abstracts.hidden = YES;
    //背景色
    self.mView_titlecell.mView_background.hidden = YES;
    //图片
    [self.mView_titlecell.mCollectionV_pic reloadData];
    self.mView_titlecell.mCollectionV_pic.hidden = YES;
    //时间
    self.mView_titlecell.mLab_RecDate.hidden = YES;
    //评论
    self.mView_titlecell.mLab_commentCount.hidden = YES;
    self.mView_titlecell.mLab_comment.hidden = YES;
    self.mView_titlecell.mLab_line2.hidden = YES;
    self.mView_titlecell.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height, [dm getInstance].width, self.mView_titlecell.mLab_Category0.frame.origin.y+21);
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mArr_answers.count;
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
        [self.mTableV_answers registerNib:n forCellReuseIdentifier:indentifier];
    }
    //添加点击事件
    cell.delegate = self;
    [cell addTapClick];
    cell.mInt_flag = 1;
    NSMutableArray *array = self.mArr_answers;
    AnswerByIdModel *model = [array objectAtIndex:indexPath.row];
    cell.answerModel = model;
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
    cell.mLab_commentCount.hidden = NO;
    cell.mLab_comment.hidden = NO;
    //分割线
    cell.mLab_line.hidden = YES;
    cell.mLab_line.frame = CGRectMake(20, 5, [dm getInstance].width-20, .5);
    //赞
    cell.mLab_LikeCount.frame = CGRectMake(9, cell.mLab_line.frame.origin.y+15, 42, 22);
    NSString *strLike = model.LikeCount;
    if ([model.LikeCount integerValue]>0) {
        strLike = @"99+";
    }
    cell.mLab_LikeCount.text = [NSString stringWithFormat:@"%@赞",strLike];
    //头像
    cell.mImgV_head.frame = CGRectMake(9, cell.mLab_LikeCount.frame.origin.y+22+10, 42, 42);
    [cell.mImgV_head sd_setImageWithURL:(NSURL *)[NSString stringWithFormat:@"%@%@",AccIDImg,model.JiaoBaoHao] placeholderImage:[UIImage  imageNamed:@"root_img"]];
    //姓名
    cell.mLab_IdFlag.frame = CGRectMake(9, cell.mImgV_head.frame.origin.y+42+10, 42, cell.mLab_IdFlag.frame.size.height);
    cell.mLab_IdFlag.text = model.IdFlag;
    //回答标题
    NSString *string1 = model.ATitle;
    string1 = [string1 stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    NSString *name = [NSString stringWithFormat:@"<font size=14 color='#03AA36'>答 : </font> <font size=14 color=black>%@</font>",string1];
    NSString *str = [HtmlString transformString:name];
    cell.mLab_ATitle.frame = CGRectMake(63, cell.mLab_LikeCount.frame.origin.y+3, [dm getInstance].width-65,5);
    [cell.mLab_ATitle setFont:[UIFont fontWithName:str size:14]];
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:str];
    cell.mLab_ATitle.componentsAndPlainText = componentsDS;
    cell.mLab_ATitle.frame = CGRectMake(63, cell.mLab_LikeCount.frame.origin.y+3, [dm getInstance].width-65, 23);
    cell.mLab_ATitle.lineBreakMode =NSLineBreakByCharWrapping;
    cell.mLab_ATitle.backgroundColor = [UIColor clearColor];
    cell.mLab_ATitle.textColor = [UIColor colorWithRed:33.0/255 green:33.0/255 blue:33.0/255 alpha:1];
    //回答内容
    NSString *string2 = model.Abstracts;
    string2 = [string2 stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    string2 = [string2 stringByReplacingOccurrencesOfString:@"\r\r" withString:@""];
    NSString *name2 = [NSString stringWithFormat:@"<font size=14 color='red'>依据 : </font> <font>%@</font>", string2];
    NSString *str2 = [HtmlString transformString:name2];
    cell.mLab_Abstracts.frame = CGRectMake(63, cell.mImgV_head.frame.origin.y+2, [dm getInstance].width-75, 5);
    [cell.mLab_Abstracts setFont:[UIFont fontWithName:str2 size:14]];
    RTLabelComponentsStructure *componentsDS2 = [RCLabel extractTextStyle:str2];
    cell.mLab_Abstracts.componentsAndPlainText = componentsDS2;
    CGSize optimalSize2 = [cell.mLab_Abstracts optimumSize];//计算图文混排后的高度
    if (optimalSize2.height==23) {
        optimalSize2 = CGSizeMake(optimalSize2.width, 25);
    }else if (optimalSize2.height>20) {
        optimalSize2 = CGSizeMake(optimalSize2.width, 35);
    }
    cell.mLab_Abstracts.frame = CGRectMake(63, cell.mImgV_head.frame.origin.y+2, [dm getInstance].width-75, optimalSize2.height);
    cell.mLab_Abstracts.lineBreakMode =NSLineBreakByCharWrapping;
    cell.mLab_Abstracts.backgroundColor = [UIColor clearColor];
    cell.mLab_Abstracts.textColor = [UIColor colorWithRed:33.0/255 green:33.0/255 blue:33.0/255 alpha:1];
    //背景色
    cell.mView_background.frame = CGRectMake(cell.mLab_Abstracts.frame.origin.x-2, cell.mLab_Abstracts.frame.origin.y-3, [dm getInstance].width-70, cell.mLab_Abstracts.frame.size.height+4);
    //图片
    [cell.mCollectionV_pic reloadData];
    cell.mCollectionV_pic.backgroundColor = [UIColor clearColor];
    if (model.Thumbnail.count>0) {
        cell.mCollectionV_pic.frame = CGRectMake(63, cell.mView_background.frame.origin.y+cell.mView_background.frame.size.height+5, [dm getInstance].width-65, ([dm getInstance].width-65-30)/3);
    }else{
        cell.mCollectionV_pic.frame = cell.mView_background.frame;
    }
    //时间
    cell.mLab_RecDate.frame = CGRectMake(cell.mLab_ATitle.frame.origin.x, cell.mCollectionV_pic.frame.origin.y+cell.mCollectionV_pic.frame.size.height+5, cell.mLab_RecDate.frame.size.width, cell.mLab_RecDate.frame.size.height);
    cell.mLab_RecDate.text = model.RecDate;
    //评论
    CGSize commentSize = [[NSString stringWithFormat:@"%@",model.CCount] sizeWithFont:[UIFont systemFontOfSize:10]];
    cell.mLab_commentCount.frame = CGRectMake([dm getInstance].width-9-commentSize.width, cell.mLab_RecDate.frame.origin.y, commentSize.width, cell.mLab_commentCount.frame.size.height);
    cell.mLab_commentCount.text = model.CCount;
    cell.mLab_comment.frame = CGRectMake(cell.mLab_commentCount.frame.origin.x-2-cell.mLab_comment.frame.size.width, cell.mLab_RecDate.frame.origin.y, cell.mLab_View.frame.size.width, cell.mLab_comment.frame.size.height);
    if (model.Thumbnail.count>0) {
        cell.mLab_line2.frame = CGRectMake(0, cell.mLab_RecDate.frame.origin.y+cell.mLab_RecDate.frame.size.height+10, [dm getInstance].width, 10);
    }else{
        cell.mLab_line2.frame = CGRectMake(0, cell.mLab_IdFlag.frame.origin.y+cell.mLab_IdFlag.frame.size.height+10, [dm getInstance].width, 10);
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
    NSMutableArray *array = self.mArr_answers;
    AnswerByIdModel *model = [array objectAtIndex:indexPath.row];
    //标题
//    tempF = tempF+10+16;
//    //话题
//    tempF = tempF+5+21;
    //判断是否有回答
//    if ([model.AnswersCount integerValue]>0) {
        //分割线
//        tempF = tempF+5;
    tempF = 5;
        if (model.Thumbnail.count>0) {
            //回答标题
            tempF = tempF+15+22;
            //回答内容
            NSString *string2 = model.Abstracts;
            NSString *string = [NSString stringWithFormat:@"依据 : %@",string2];
            CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake([dm getInstance].width-75, 1000)];
            if (size.height>20) {
                size = CGSizeMake(size.width, 32);
            }
            tempF = tempF+5+size.height;
            //背景色
            tempF = tempF+3;
            //图片
            tempF = tempF+5+([dm getInstance].width-65-30)/3;
            //时间
            tempF = tempF+10+21;
            tempF = tempF+20;
        }else{
            //赞
            tempF = tempF+15+22;
            //头像
            tempF = tempF+10+42;
            //姓名
            tempF = tempF+10+21;
            tempF = tempF+20;
        }
//    }else{
//        tempF = tempF+20;
//    }
    return tempF;
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

//检查当前网络是否可用
-(BOOL)checkNetWork{
    if([Reachability isEnableNetwork]==NO){
        [MBProgressHUD showError:NETWORKENABLE toView:self.view];
        return YES;
    }else{
        return NO;
    }
}

-(void)sendRequest{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    NSString *page = @"";
    if (self.mInt_reloadData == 0) {
        page = @"1";
        [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    }else{
        NSMutableArray *array = self.mArr_answers;
        if (array.count>=10&&array.count%10==0) {
            //检查当前网络是否可用
            if ([self checkNetWork]) {
                return;
            }
            page = [NSString stringWithFormat:@"%d",(int)array.count/10+1];
            [MBProgressHUD showMessage:@"加载中..." toView:self.view];
        } else {
            [self.mTableV_answers headerEndRefreshing];
            [self.mTableV_answers footerEndRefreshing];
            [MBProgressHUD showSuccess:@"没有更多了" toView:self.view];
            return;
        }
    }
    [[KnowledgeHttp getInstance] GetAnswerByIdWithNumPerPage:@"10" pageNum:page QId:self.mModel_question.TabID flag:@"-1"];
}

//详情按钮
-(void)KnowledgeTableVIewCellDetailBtn:(KnowledgeTableViewCell *)knowledgeTableViewCell{
    [self gotoAddAnswerVC];
}

//跳转到回答问题界面
-(void)gotoAddAnswerVC{
    KnowledgeAddAnswerViewController *detail = [[KnowledgeAddAnswerViewController alloc] init];
    detail.mModel_question = self.mModel_question;
    [utils pushViewController:detail animated:YES];
}

//cell的点击事件---答案
-(void)KnowledgeTableViewCellAnswers:(KnowledgeTableViewCell *)knowledgeTableViewCell{
    CommentViewController *commentVC = [[CommentViewController alloc]init];
    
    commentVC.questionModel = self.mModel_question;
    commentVC.answerModel = knowledgeTableViewCell.answerModel;
    [utils pushViewController:commentVC animated:YES];
}

//ButtonView回调
-(void)ButtonViewTitleBtn:(ButtonViewCell *)view{
    D("view.tag-=====%ld",(long)view.tag);
//    view.mLab_title.text = @"取消关注";
    if (view.tag ==100) {
        [self gotoAddAnswerVC];
    }
}

//导航条返回按钮回调
-(void)myNavigationGoback{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
