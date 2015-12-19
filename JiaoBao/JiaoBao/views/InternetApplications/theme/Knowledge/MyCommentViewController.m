//
//  MyCommentViewController.m
//  JiaoBao
//
//  Created by songyanming on 15/12/18.
//  Copyright © 2015年 JSY. All rights reserved.
//

#import "MyCommentViewController.h"
#import "KnowledgeQuestionViewController.h"
#import "CommsModel.h"
#import "MyComentCell.h"
#import "CommentViewController.h"


@interface MyCommentViewController ()
@property(nonatomic,strong)NSMutableArray *answerArr;
@property(nonatomic,assign)NSUInteger indexTag;

@end

@implementation MyCommentViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
}
-(void)QuestionDetail:(id)sender
{
    [MBProgressHUD hideHUDForView:self.view];
    NSMutableDictionary *dic = [sender object];
    NSString *code = [dic objectForKey:@"code"];
    NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
    if ([code integerValue] ==0) {
        QuestionDetailModel *detailModel = [dic objectForKey:@"model"];
        CommsModel *commsModel = [self.mArr_list objectAtIndex:self.indexTag];

        QuestionModel *model = [[QuestionModel alloc]init];
        AnswerModel *answerModel = [[AnswerModel alloc]init];
        answerModel.TabID = commsModel.AId;
        model.CategoryId = detailModel.CategoryId;
        model.CategorySuject = detailModel.Category;
        model.Title = detailModel.Title;
        model.TabID = detailModel.TabID;
        model.AttCount = detailModel.AttCount;
        model.AnswersCount = detailModel.AnswersCount;
        model.ViewCount = detailModel.ViewCount;
        model.answerModel = answerModel;
        CommentViewController *commentVC = [[CommentViewController alloc]init];
        
        commentVC.questionModel = model;
        commentVC.topButtonTag = 2;
        commentVC.flag = YES;
        [utils pushViewController:commentVC animated:YES];
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.answerArr = [[NSMutableArray alloc]initWithCapacity:0];
    // Do any additional setup after loading the view from its nib.
    self.mArr_list = [NSMutableArray array];
    self.mInt_reloadData = 0;
    self.mInt_load = 1;
    //获取我提出的问题列表
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetMyCommsWithNumPerPage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetMyCommsWithNumPerPage:) name:@"GetMyCommsWithNumPerPage" object:nil];
    //获取答案详情
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AnswerDetailWithAId" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AnswerDetailWithAId:) name:@"AnswerDetailWithAId" object:nil];
    
    //获取提问详情
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"QuestionDetail" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QuestionDetail:) name:@"QuestionDetail" object:nil];
    
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"我做出的评论"];
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
    [[KnowledgeHttp getInstance]GetMyCommsWithNumPerPage:@"10" pageNum:@"0"];
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
}

//获取我做的评论列表
-(void)GetMyCommsWithNumPerPage:(NSNotification *)noti{
    [self.mTalbeV_liset headerEndRefreshing];
    [self.mTalbeV_liset footerEndRefreshing];
    NSMutableDictionary *dic = noti.object;
    NSString *code = [dic objectForKey:@"ResultCode"];
    if ([code integerValue]==0) {
        NSMutableArray *array = [dic objectForKey:@"array"];
        for(int i=0;i<array.count;i++)
        {
            CommsModel *model = [array objectAtIndex:i];
            [[KnowledgeHttp getInstance]AnswerDetailWithAId:model.AId];
        }
        if (self.mInt_reloadData ==0) {
            self.mArr_list = [NSMutableArray arrayWithArray:array];
        }else{
            [self.mArr_list addObjectsFromArray:array];
        }
        if (self.mArr_list.count==0&&array.count==0) {
            [MBProgressHUD showSuccess:@"暂无内容" toView:self.view];
        }
    }else{
        NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
        [MBProgressHUD showSuccess:ResultDesc toView:self.view];
    }
}

//答案详情回调
-(void)AnswerDetailWithAId:(id)sender
{
    
        NSDictionary *dic = [sender object];
        NSString *ResultCode = [dic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
        if([ResultCode integerValue]!=0)
        {
            [MBProgressHUD showError:ResultDesc];
        }
        else
        {
            AnswerDetailModel *model = [dic objectForKey:@"model"];
            [self.answerArr addObject:model];
            if(self.answerArr.count == self.mArr_list.count )
            {

                NSArray *arr = [self.answerArr sortedArrayUsingComparator:^NSComparisonResult(CommsModel *p1, CommsModel *p2){
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
                    NSDate *date1 = [dateFormatter dateFromString:p1.RecDate];
                    NSDate *date2 = [dateFormatter dateFromString:p2.RecDate];
                    return [date1 compare:date2];
                }];
                self.answerArr =[NSMutableArray arrayWithArray:arr];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

                [self.mTalbeV_liset reloadData];
//            if([self.AnswerDetailModel.TabID integerValue]==0)
//            {
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
//                self.hideHUDTag = @"1";
//                [MBProgressHUD showError:@"该条回答已被屏蔽或删除"];
//            }

        }
    }
}


-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mArr_list.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"MyComentCell";
    MyComentCell *cell = (MyComentCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[MyComentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyComentCell" owner:self options:nil];
        //这时myCell对象已经通过自定义xib文件生成了
        if ([nib count]>0) {
            cell = (MyComentCell *)[nib objectAtIndex:0];
            //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
        }
        //添加图片点击事件
        //若是需要重用，需要写上以下两句代码
        UINib * n= [UINib nibWithNibName:@"MyComentCell" bundle:[NSBundle mainBundle]];
        [self.mTalbeV_liset registerNib:n forCellReuseIdentifier:indentifier];
    }
    CommsModel *model = [self.mArr_list objectAtIndex:indexPath.row];
    AnswerDetailModel *answerModel = [self.answerArr objectAtIndex:indexPath.row];
    cell.answerLabel.text = answerModel.ATitle;
    cell.commentLabel.text = model.WContent;
    return cell;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CommsModel *model = [self.mArr_list objectAtIndex:indexPath.row];
    
    self.indexTag = indexPath.row;

    [[KnowledgeHttp getInstance]QuestionDetailWithQId:model.QId];


//    QuestionModel *model = [self.mArr_list objectAtIndex:indexPath.row];
//    KnowledgeQuestionViewController *queston = [[KnowledgeQuestionViewController alloc] init];
//    queston.mModel_question = model;
//    [utils pushViewController:queston animated:YES];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing{
    self.mInt_reloadData = 0;
    self.mInt_load = 1;
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
    NSString *rowCount = @"0";
    if (self.mArr_list.count>0) {
        QuestionModel *model = [self.mArr_list objectAtIndex:self.mArr_list.count-1];
        rowCount = model.rowCount;
    }
    if (self.mInt_reloadData == 0) {
        //[MBProgressHUD showMessage:@"加载中..." toView:self.view];
    }else{
        if (self.mArr_list.count==[rowCount intValue]) {
            [self.mTalbeV_liset headerEndRefreshing];
            [self.mTalbeV_liset footerEndRefreshing];
            [MBProgressHUD showSuccess:@"没有更多了" toView:self.view];
            return;
        }else{
            //[MBProgressHUD showMessage:@"加载中..." toView:self.view];
        }
    }
    [[KnowledgeHttp getInstance]GetMyCommsWithNumPerPage:@"10" pageNum:[NSString stringWithFormat:@"%d",self.mInt_load]];

    //[[KnowledgeHttp getInstance] MyQuestionIndexWithnumPerPage:@"10" pageNum:[NSString stringWithFormat:@"%d",self.mInt_load] RowCount:rowCount];
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
