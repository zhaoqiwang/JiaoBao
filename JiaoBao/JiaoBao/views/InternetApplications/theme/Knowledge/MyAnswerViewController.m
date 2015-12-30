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
    self.mInt_load = 1;
    self.mInt_list = 0;
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
            self.mInt_list = 0;
            self.mArr_list = [NSMutableArray arrayWithArray:array];
        }else{
            [self.mArr_list addObjectsFromArray:array];
        }
        if (self.mArr_list.count==0&&array.count==0) {
            [MBProgressHUD showSuccess:@"暂无内容" toView:self.view];
        }else{
            if (array.count>0) {
                QuestionModel *model = [array objectAtIndex:0];
                self.mInt_rowcount = [model.rowCount intValue];
                //当页面如果没有记录，刚返回一条TabID=-1的记录，该记录只为了返回rowcount，没有实际意义。
                if ([model.TabID intValue]==-1) {
                    [self.mArr_list removeObject:model];
                    self.mInt_list = self.mInt_list+(int)model.hiddenid.count;
                }else{
                    self.mInt_list = self.mInt_list+(int)array.count+(int)model.hiddenid.count;
                }
                //如果全部为空，重新获取
                if ([model.rowCount intValue]>self.mInt_list&&[model.TabID intValue]==-1) {
                    [self footerRereshing];
                }
            }
        }
        if (self.mInt_rowcount==self.mInt_list&&self.mArr_list.count==0) {
            [MBProgressHUD showSuccess:@"暂无内容" toView:self.view];
        }
    }else{
        NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
        [MBProgressHUD showSuccess:ResultDesc toView:self.view];
    }
    //判断是否提示隐藏数据数量
    if (self.mInt_list>self.mArr_list.count) {
        self.mTalbeV_liset.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height-[dm getInstance].statusBar, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height+[dm getInstance].statusBar-20);
        self.mLab_warn.hidden = NO;
        self.mLab_warn.frame = CGRectMake(0, [dm getInstance].height-20, [dm getInstance].width, 20);
        self.mLab_warn.text = [NSString stringWithFormat:@"有%d条数据被隐藏或删除",(int)self.mInt_list-(int)self.mArr_list.count];
    }else{
        self.mTalbeV_liset.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height-[dm getInstance].statusBar, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height+[dm getInstance].statusBar);
        self.mLab_warn.hidden = YES;
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
    cell.LikeBtn.hidden = YES;
    cell.mLab_title.hidden = YES;
    cell.mLab_Category0.hidden = YES;
    cell.mLab_Category1.hidden = YES;
    cell.mLab_AttCount.hidden = YES;
    cell.mLab_AnswersCount.hidden = YES;
    cell.mLab_View.hidden = YES;
    cell.mLab_ViewCount.hidden = YES;
    cell.mLab_LikeCount.hidden = YES;
    cell.mLab_Abstracts.hidden = YES;
    cell.mLab_IdFlag.hidden = YES;
    cell.mLab_RecDate.hidden = YES;
    cell.mLab_comment.hidden = YES;
    cell.mLab_commentCount.hidden = YES;
    cell.mLab_line.hidden = YES;
    cell.mView_background.hidden = YES;
    cell.mImgV_head.hidden = YES;
    cell.mCollectionV_pic.hidden = YES;
    cell.mLab_line2.hidden = YES;
    cell.mBtn_detail.hidden = YES;
    cell.mWebV_comment.hidden = YES;
    cell.mBtn_all.hidden = YES;
    cell.mBtn_evidence.hidden = YES;
    cell.mBtn_discuss.hidden = YES;
    cell.mLab_selectCategory.hidden = YES;
    cell.mLab_selectCategory1.hidden = YES;
    cell.mImgV_top.hidden = YES;
    QuestionModel *model = [self.mArr_list objectAtIndex:indexPath.row];
    if ([model.TabID intValue]>=0) {
        for (UIView *temp in cell.subviews) {
            temp.hidden = NO;
        }
    }else{
        for (UIView *temp in cell.subviews) {
            temp.hidden = YES;
        }
        return cell;
    }
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
    //话题
    CGSize CategorySize = [model.CategorySuject sizeWithFont:[UIFont systemFontOfSize:12]];
    cell.mLab_Category0.text = model.CategorySuject;
    cell.mLab_Category0.font = [UIFont systemFontOfSize:12];
    cell.mLab_Category0.hidden = NO;
    cell.mLab_Category0.frame = CGRectMake(cell.mLab_Answers.frame.origin.x+cell.mLab_Answers.frame.size.width+20, cell.mLab_Att.frame.origin.y, CategorySize.width, cell.mLab_Category0.frame.size.height);
    //浏览数
    NSString *ViewStr = [NSString stringWithFormat:@"%@人浏览",model.ViewCount];
    CGSize ViewSize = [ViewStr sizeWithFont:[UIFont systemFontOfSize:12]];
    cell.mLab_View.text = ViewStr;
    cell.mLab_View.hidden = NO;
    cell.mLab_View.font = [UIFont systemFontOfSize:12];
    cell.mLab_View.frame = CGRectMake(cell.mLab_Category0.frame.origin.x+cell.mLab_Category0.frame.size.width+20, cell.mLab_Att.frame.origin.y, ViewSize.width, cell.mLab_View.frame.size.height);
    //
    cell.mLab_line.hidden = NO;
    cell.mLab_line.frame = CGRectMake(0, 59, [dm getInstance].width, .5);
    cell.mLab_LikeCount.hidden = YES;
    cell.mImgV_head.hidden = YES;
    cell.mLab_Abstracts.hidden = YES;
    cell.mLab_line2.hidden = YES;

    return cell;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    QuestionModel *model = [self.mArr_list objectAtIndex:indexPath.row];
    if ([model.TabID intValue]==-1) {
        return 0;
    }
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    QuestionModel *model = [self.mArr_list objectAtIndex:indexPath.row];
    if ([model.TabID intValue]>0) {
        KnowledgeQuestionViewController *queston = [[KnowledgeQuestionViewController alloc] init];
        queston.mModel_question = model;
        [utils pushViewController:queston animated:YES];
    }
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing{
    self.mInt_reloadData = 0;
    self.mInt_load = 1;
    self.mInt_rowcount = 0;
    [self sendRequest];
}

- (void)footerRereshing{
    self.mInt_reloadData = 1;
    self.mInt_load++;
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
//    NSString *rowCount = @"0";
//    if (self.mArr_list.count>0) {
//        QuestionModel *model = [self.mArr_list objectAtIndex:self.mArr_list.count-1];
//        rowCount = model.rowCount;
//    }
    if (self.mInt_reloadData == 0) {
        [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    }else{
        if (self.mInt_list==self.mInt_rowcount) {
            [self.mTalbeV_liset headerEndRefreshing];
            [self.mTalbeV_liset footerEndRefreshing];
            [MBProgressHUD showSuccess:@"没有更多了" toView:self.view];
            return;
        }else{
            [MBProgressHUD showMessage:@"加载中..." toView:self.view];
        }
    }
    [[KnowledgeHttp getInstance] MyAnswerIndexWithnumPerPage:@"10" pageNum:[NSString stringWithFormat:@"%d",self.mInt_load] RowCount:[NSString stringWithFormat:@"%d",self.mInt_rowcount]];
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
