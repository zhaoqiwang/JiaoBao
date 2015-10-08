//
//  MyAnswerViewController.m
//  JiaoBao
//
//  Created by Zqw on 15/9/17.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "MyAnswerViewController.h"
#import "KnowledgeQuestionViewController.h"

@interface MyAnswerViewController ()

@end

@implementation MyAnswerViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mArr_list = [NSMutableArray array];
    self.mInt_reloadData = 0;
    //获取我参与回答的问题列表
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MyAnswerIndexWithnumPerPage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MyAnswerIndexWithnumPerPage:) name:@"MyAnswerIndexWithnumPerPage" object:nil];
    
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"我回答的问题"];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    
    //
    self.mTalbeV_liset.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height-[dm getInstance].statusBar, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height+[dm getInstance].statusBar);
    self.mTalbeV_liset.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.mTalbeV_liset addHeaderWithTarget:self action:@selector(headerRereshing)];
    self.mTalbeV_liset.headerPullToRefreshText = @"下拉刷新";
    self.mTalbeV_liset.headerReleaseToRefreshText = @"松开后刷新";
    self.mTalbeV_liset.headerRefreshingText = @"正在刷新...";
    [self.mTalbeV_liset addFooterWithTarget:self action:@selector(footerRereshing)];
    self.mTalbeV_liset.footerPullToRefreshText = @"上拉加载更多";
    self.mTalbeV_liset.footerReleaseToRefreshText = @"松开加载更多数据";
    self.mTalbeV_liset.footerRefreshingText = @"正在加载...";
    
    //发送请求
    [[KnowledgeHttp getInstance] MyAnswerIndexWithnumPerPage:@"10" pageNum:@"1" RowCount:@"0"];
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
}

//获取我参与回答的问题列表
-(void)MyAnswerIndexWithnumPerPage:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    [self.mTalbeV_liset headerEndRefreshing];
    [self.mTalbeV_liset footerEndRefreshing];
    NSMutableDictionary *dic = noti.object;
    NSString *code = [dic objectForKey:@"ResultCode"];
    if ([code integerValue]==0) {
        NSMutableArray *array = [dic objectForKey:@"array"];
        if (self.mInt_reloadData ==0) {
            self.mArr_list = [NSMutableArray arrayWithArray:array];
        }else{
            [self.mArr_list addObjectsFromArray:array];
        }
    }else{
        NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
        [MBProgressHUD showSuccess:ResultDesc toView:self.view];
    }
    [self.mTalbeV_liset reloadData];
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mArr_list.count;
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
        [self.mTalbeV_liset registerNib:n forCellReuseIdentifier:indentifier];
    }
    QuestionModel *model = [self.mArr_list objectAtIndex:indexPath.row];
    cell.LikeBtn.hidden = YES;
    cell.mLab_title.hidden = YES;
    cell.mLab_Category0.hidden = YES;
    cell.mLab_Category1.hidden = YES;
    cell.mLab_AttCount.hidden = YES;
    cell.mLab_AnswersCount.hidden = YES;
    cell.mLab_View.hidden = YES;
    cell.mLab_ViewCount.hidden = YES;
    cell.mLab_IdFlag.hidden = YES;
    cell.mLab_RecDate.hidden = YES;
    cell.mLab_comment.hidden = YES;
    cell.mLab_commentCount.hidden = YES;
    cell.mView_background.hidden = YES;
    cell.mCollectionV_pic.hidden = YES;
    cell.mBtn_detail.hidden = YES;
    cell.mWebV_comment.hidden = YES;
    cell.mBtn_all.hidden = YES;
    cell.mBtn_evidence.hidden = YES;
    cell.mBtn_discuss.hidden = YES;
    cell.mLab_selectCategory.hidden = YES;
    cell.mLab_selectCategory1.hidden = YES;
    cell.mImgV_top.hidden = YES;
    cell.mLab_Att.hidden = YES;
    cell.mLab_Answers.hidden = YES;
    //问题名称
    NSString *string1 = model.Title;
    string1 = [string1 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string1 = [string1 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    NSString *name = [NSString stringWithFormat:@"<font size=14 color='#03AA03'>问 : </font> <font size=14 color=black>%@</font>",string1];
    NSMutableDictionary *row1 = [NSMutableDictionary dictionary];
    [row1 setObject:name forKey:@"text"];
    cell.mLab_ATitle.frame = CGRectMake(12, 9, [dm getInstance].width-18, 23);
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:[row1 objectForKey:@"text"]];
    cell.mLab_ATitle.componentsAndPlainText = componentsDS;
    cell.mLab_ATitle.lineBreakMode = RTTextLineBreakModeTruncatingTail;
    cell.mLab_ATitle.hidden = NO;
    //关注、答案个数
    //关注
    NSString *attStr = [NSString stringWithFormat:@"%@人关注",model.AttCount];
    CGSize AttSize = [attStr sizeWithFont:[UIFont systemFontOfSize:12]];
    cell.mLab_Att.text = attStr;
    cell.mLab_Att.font = [UIFont systemFontOfSize:12];
    cell.mLab_Att.frame = CGRectMake(17, cell.mLab_ATitle.frame.origin.y+23, AttSize.width, cell.mLab_Att.frame.size.height);
    cell.mLab_Att.hidden = NO;
    //回答
    NSString *answerStr = [NSString stringWithFormat:@"%@人回答",model.AnswersCount];
    CGSize AnswersSize = [answerStr sizeWithFont:[UIFont systemFontOfSize:12]];
    cell.mLab_Answers.text = answerStr;
    cell.mLab_Answers.font = [UIFont systemFontOfSize:12];
    cell.mLab_Answers.frame = CGRectMake(cell.mLab_Att.frame.origin.x+cell.mLab_Att.frame.size.width+20, cell.mLab_Att.frame.origin.y, AnswersSize.width, cell.mLab_Answers.frame.size.height);
    cell.mLab_Answers.hidden = NO;
    //
    cell.mLab_line.hidden = NO;
    cell.mLab_line.frame = CGRectMake(0, 59, [dm getInstance].width, .5);
//    cell.mLab_line.frame = CGRectMake(20, cell.mLab_ATitle.frame.origin.x+cell.mLab_ATitle.frame.size.height+5, [dm getInstance].width-20, .5);
//    //喜欢个数
//    cell.mLab_LikeCount.frame = CGRectMake(9, cell.mLab_line.frame.origin.y+10, 42, 22);
//    NSString *strLike = model.answerModel.LikeCount;
//    if ([model.answerModel.LikeCount integerValue]>99) {
//        strLike = @"99+";
//    }
//    cell.mLab_LikeCount.text = [NSString stringWithFormat:@"%@赞",strLike];
    cell.mLab_LikeCount.hidden = YES;
//    //头像
//    cell.mImgV_head.frame = CGRectMake(9, cell.mLab_LikeCount.frame.origin.y+22+10, 42, 42);
//    [cell.mImgV_head sd_setImageWithURL:(NSURL *)[NSString stringWithFormat:@"%@%@",AccIDImg,model.answerModel.JiaoBaoHao] placeholderImage:[UIImage  imageNamed:@"root_img"]];
    cell.mImgV_head.hidden = YES;
//    //回答内容
//    NSString *string2 = model.answerModel.Abstracts;
//    string2 = [string2 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    string2 = [string2 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//    NSString *name2 = @"";
//    if ([model.answerModel.Flag integerValue]==0) {//无内容
//        name2 = [NSString stringWithFormat:@"<font size=14 color='#03AA03'>无内容</font>"];
//    }else if ([model.answerModel.Flag integerValue]==1){//有内容
//        name2 = [NSString stringWithFormat:@"<font size=14 color='#03AA03'>有内容 : </font> <font>%@</font>", string2];
//    }else if ([model.answerModel.Flag integerValue]==2){//有证据
//        name2 = [NSString stringWithFormat:@"<font size=14 color='red'>依据 : </font> <font>%@</font>", string2];
//    }
//    
//    NSMutableDictionary *row2 = [NSMutableDictionary dictionary];
//    [row2 setObject:name2 forKey:@"text"];
//    RTLabelComponentsStructure *componentsDS2 = [RCLabel extractTextStyle:[row2 objectForKey:@"text"]];
//    cell.mLab_Abstracts.componentsAndPlainText = componentsDS2;
//    CGSize optimalSize2 = [cell.mLab_Abstracts optimumSize];
//    if (optimalSize2.height==23) {
//        optimalSize2 = CGSizeMake(optimalSize2.width, 25);
//    }else if (optimalSize2.height>20) {
//        optimalSize2 = CGSizeMake(optimalSize2.width, 35);
//    }
    cell.mLab_Abstracts.hidden = YES;
//    cell.mLab_Abstracts.frame = CGRectMake(63, cell.mImgV_head.frame.origin.y+2, [dm getInstance].width-75, optimalSize2.height);
//    cell.mLab_line2.frame = CGRectMake(0, cell.mImgV_head.frame.origin.y+cell.mImgV_head.frame.size.height+10, [dm getInstance].width, 10);
    cell.mLab_line2.hidden = YES;

    return cell;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
//    return 150;
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    QuestionModel *model = [self.mArr_list objectAtIndex:indexPath.row];
    KnowledgeQuestionViewController *queston = [[KnowledgeQuestionViewController alloc] init];
    queston.mModel_question = model;
    [utils pushViewController:queston animated:YES];
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
        NSMutableArray *array = self.mArr_list;
        if (array.count>=10&&array.count%10==0) {
            //检查当前网络是否可用
            if ([self checkNetWork]) {
                return;
            }
            page = [NSString stringWithFormat:@"%d",(int)array.count/10+1];
            [MBProgressHUD showMessage:@"加载中..." toView:self.view];
        } else {
            [self.mTalbeV_liset headerEndRefreshing];
            [self.mTalbeV_liset footerEndRefreshing];
            [MBProgressHUD showSuccess:@"没有更多了" toView:self.view];
            return;
        }
    }
    NSString *rowCount = @"0";
    if (self.mArr_list.count>0) {
        QuestionModel *model = [self.mArr_list objectAtIndex:self.mArr_list.count-1];
        rowCount = model.rowCount;
    }
    [[KnowledgeHttp getInstance] MyAnswerIndexWithnumPerPage:@"10" pageNum:page RowCount:rowCount];
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