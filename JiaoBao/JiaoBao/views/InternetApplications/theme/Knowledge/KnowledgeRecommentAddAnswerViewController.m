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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //推荐问题详情
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ShowRecomment" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShowRecomment:) name:@"ShowRecomment" object:nil];
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
    [[KnowledgeHttp getInstance] ShowRecommentWithTable:self.mModel_question.tabid];
}

//推荐问题详情
-(void)ShowRecomment:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSMutableDictionary *dic = noti.object;
    NSString *code = [dic objectForKey:@"ResultCode"];
    if ([code integerValue] ==0) {
        self.mModel_recomment = [dic objectForKey:@"model"];
        [self.mTableV_answer reloadData];
        [self addDetailCell:self.mModel_recomment];
    }
}

-(void)addDetailCell:(RecommentAddAnswerModel *)model{
    self.mView_titlecell.hidden = NO;

    //标题
    self.mView_titlecell.mLab_title.frame = CGRectMake(9, 10, [dm getInstance].width-9*2, 16);
    self.mView_titlecell.mLab_title.text = model.questionModel.Title;
    self.mView_titlecell.mLab_title.hidden = NO;
    //详情
    self.mView_titlecell.mBtn_detail.hidden = YES;
    //话题
    self.mView_titlecell.mLab_Category0.frame = CGRectMake(30, self.mView_titlecell.mLab_title.frame.origin.y+16+5, self.mView_titlecell.mLab_Category0.frame.size.width, 21);
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
    self.mView_titlecell.mLab_Abstracts.hidden = NO;
    NSString *string2 = model.questionModel.KnContent;
    string2 = [string2 stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    string2 = [string2 stringByReplacingOccurrencesOfString:@"\r\r" withString:@""];
    NSString *name2 = [NSString stringWithFormat:@"<font size=14 color='red'>详情 : </font> <font>%@</font>", string2];
    NSString *string = [NSString stringWithFormat:@"详情 : %@",string2];
    CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake([dm getInstance].width-18, 1000)];
    self.mView_titlecell.mLab_Abstracts.frame = CGRectMake(9, self.mView_titlecell.mView_background.frame.origin.y+self.mView_titlecell.mView_background.frame.size.height+10, [dm getInstance].width-18, size.height);
    NSMutableDictionary *row2 = [NSMutableDictionary dictionary];
    [row2 setObject:name2 forKey:@"text"];
    RTLabelComponentsStructure *componentsDS2 = [RCLabel extractTextStyle:[row2 objectForKey:@"text"]];
    self.mView_titlecell.mLab_Abstracts.componentsAndPlainText = componentsDS2;
    //图片
    [self.mView_titlecell.mCollectionV_pic reloadData];
    self.mView_titlecell.mCollectionV_pic.hidden = NO;
//    if (model.questionModel.Thumbnail.count>0) {
//        self.mView_titlecell.mCollectionV_pic.frame = CGRectMake(9, self.mView_titlecell.mLab_Abstracts.frame.origin.y+self.mView_titlecell.mLab_Abstracts.frame.size.height+5, [dm getInstance].width-65, ([dm getInstance].width-65-30)/3);
//    }else{
        self.mView_titlecell.mCollectionV_pic.frame = self.mView_titlecell.mLab_Abstracts.frame;
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
    
    self.mTableV_answer.frame = CGRectMake(0, self.mView_titlecell.frame.origin.y+self.mView_titlecell.frame.size.height, [dm getInstance].width, self.mTableV_answer.contentSize.height);
    
    self.mScrollV_view.contentSize = CGSizeMake([dm getInstance].width, self.mTableV_answer.frame.origin.y+self.mTableV_answer.frame.size.height+20);
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
    [cell addTapClick];
    cell.mInt_flag = 1;
    NSMutableArray *array = self.mModel_recomment.answerArray;
    AnswerModel *model = [array objectAtIndex:indexPath.row];
//    AnswerByIdModel *model = [array objectAtIndex:indexPath.row];
    cell.RecommentAnswerModel = model;
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
    cell.mLab_ATitle.frame = CGRectMake(63, cell.mLab_LikeCount.frame.origin.y+3, [dm getInstance].width-65, cell.mLab_ATitle.frame.size.height);
    NSMutableDictionary *row1 = [NSMutableDictionary dictionary];
    [row1 setObject:name forKey:@"text"];
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:[row1 objectForKey:@"text"]];
    cell.mLab_ATitle.componentsAndPlainText = componentsDS;
    //回答内容
    NSString *string2 = model.Abstracts;
    string2 = [string2 stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    string2 = [string2 stringByReplacingOccurrencesOfString:@"\r\r" withString:@""];
    NSString *name2 = [NSString stringWithFormat:@"<font size=14 color='red'>依据 : </font> <font>%@</font>", string2];
    NSString *string = [NSString stringWithFormat:@"依据 : %@",string2];
    CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake([dm getInstance].width-75, MAXFLOAT)];
    if (size.height>20) {
        size = CGSizeMake(size.width, 32);
    }
    cell.mLab_Abstracts.frame = CGRectMake(63, cell.mImgV_head.frame.origin.y+2, [dm getInstance].width-75, size.height);
    NSMutableDictionary *row2 = [NSMutableDictionary dictionary];
    [row2 setObject:name2 forKey:@"text"];
    RTLabelComponentsStructure *componentsDS2 = [RCLabel extractTextStyle:[row2 objectForKey:@"text"]];
    cell.mLab_Abstracts.componentsAndPlainText = componentsDS2;
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
    NSMutableArray *array = self.mModel_recomment.answerArray;
    AnswerModel *model = [array objectAtIndex:indexPath.row];
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
        CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake([dm getInstance].width-75, MAXFLOAT)];
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
