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

@interface CommentViewController ()
@property(nonatomic,strong)MyNavigationBar *mNav_navgationBar;
@property(nonatomic,strong)AllCommentListModel *AllCommentListModel;

@end

@implementation CommentViewController
-(void)CommentsListWithNumPerPage:(id)sender
{
    self.AllCommentListModel = [sender object];
    self.tableView.frame = CGRectMake(0, self.mBtnV_btn.frame.size.height+self.mBtnV_btn.frame.origin.y, [dm  getInstance].width, [self tableViewCellHeight]);
    D("tableViewFrame = %@",NSStringFromCGRect(self.tableView.frame));
    self.mainScrollView.contentSize = CGSizeMake([dm getInstance].width, self.tableView.frame.origin.y+self.tableView.frame.size.height+10);
    D("mainScrollViewFrame = %@",NSStringFromCGRect(self.mainScrollView.frame));
    self.tableView.scrollEnabled = NO;
    [self.tableView reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"CommentsListWithNumPerPage" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(CommentsListWithNumPerPage:) name:@"CommentsListWithNumPerPage" object:nil];
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"评论"];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    [[KnowledgeHttp getInstance]CommentsListWithNumPerPage:@"20" pageNum:@"1" AId:self.questionModel.answerModel.TabID];
    KnowledgeTableViewCell *cell = [[KnowledgeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"KnowledgeTableViewCell" owner:self options:nil];
    if ([nib count]>0) {
        cell = (KnowledgeTableViewCell *)[nib objectAtIndex:0];
        //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
    }
    self.mainScrollView.frame = CGRectMake(0, 44+10, [dm getInstance].width, [dm getInstance].height-44-10);
    self.mainScrollView.contentSize = CGSizeMake([dm getInstance].width, 1000);
    [self.mainScrollView addSubview:cell];
    cell.model = self.questionModel;
    cell.mLab_title.frame = CGRectMake(9, 10, [dm getInstance].width-9*2, cell.mLab_title.frame.size.height);
    cell.mLab_title.text = cell.model.Title;
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
        cell.mLab_commentCount.hidden = NO;
        cell.mLab_comment.hidden = NO;
        //分割线
        cell.mLab_line.frame = CGRectMake(20, cell.mLab_Category0.frame.origin.y+cell.mLab_Category0.frame.size.height+5, [dm getInstance].width-20, .5);

        //头像
        cell.mImgV_head.frame = CGRectMake(9, cell.mLab_line.frame.origin.y+15, 42, 42);
        [cell.mImgV_head sd_setImageWithURL:(NSURL *)[NSString stringWithFormat:@"%@%@",AccIDImg,cell.model.answerModel.JiaoBaoHao] placeholderImage:[UIImage  imageNamed:@"root_img"]];
        //姓名
        cell.mLab_IdFlag.frame = CGRectMake(cell.mImgV_head.frame.size.width+9+5, cell.mLab_line.frame.origin.y+15, 42, cell.mLab_IdFlag.frame.size.height);
        cell.mLab_IdFlag.text = cell.model.answerModel.IdFlag;
        //赞
        cell.mLab_LikeCount.frame = CGRectMake([dm getInstance].width-42-5, cell.mLab_line.frame.origin.y+15+5, 42, 22);
        NSString *strLike = cell.model.answerModel.LikeCount;
        if ([cell.model.answerModel.LikeCount integerValue]>0) {
            strLike = @"99+";
        }
        cell.mLab_LikeCount.text = [NSString stringWithFormat:@"%@赞",strLike];
        //回答标题
        NSString *string1 = cell.model.answerModel.ATitle;
        string1 = [string1 stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        NSString *name = [NSString stringWithFormat:@"<font size=14 color='#03AA36'>答 : </font> <font size=14 color=black>%@</font>",string1];
        cell.mLab_ATitle.frame = CGRectMake(9, cell.mImgV_head.frame.origin.y+cell.mImgV_head.frame.size.height+15, [dm getInstance].width-9-2, cell.mLab_ATitle.frame.size.height);
        NSMutableDictionary *row1 = [NSMutableDictionary dictionary];
        [row1 setObject:name forKey:@"text"];
        RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:[row1 objectForKey:@"text"]];
        cell.mLab_ATitle.componentsAndPlainText = componentsDS;
        //回答内容
        NSString *string2 = cell.model.answerModel.Abstracts;
        string2 = [string2 stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        string2 = [string2 stringByReplacingOccurrencesOfString:@"\r\r" withString:@""];
        NSString *name2 = [NSString stringWithFormat:@"<font size=14 color='red'>依据 : </font> <font>%@</font>", string2];
        NSString *string = [NSString stringWithFormat:@"依据 : %@",string2];
        CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake([dm getInstance].width-75, 1000)];
        if (size.height>20) {
            size = CGSizeMake(size.width, 32);
        }
        cell.mLab_Abstracts.frame = CGRectMake(9, cell.mLab_ATitle.frame.origin.y+cell.mLab_ATitle.frame.size.height+10, [dm getInstance].width-9-12, size.height);
        NSMutableDictionary *row2 = [NSMutableDictionary dictionary];
        [row2 setObject:name2 forKey:@"text"];
        RTLabelComponentsStructure *componentsDS2 = [RCLabel extractTextStyle:[row2 objectForKey:@"text"]];
        cell.mLab_Abstracts.componentsAndPlainText = componentsDS2;
        //背景色
        cell.mView_background.frame = CGRectMake(cell.mLab_Abstracts.frame.origin.x-2, cell.mLab_Abstracts.frame.origin.y-3, [dm getInstance].width-10, cell.mLab_Abstracts.frame.size.height+4);
        //图片
        [cell.mCollectionV_pic reloadData];
        cell.mCollectionV_pic.backgroundColor = [UIColor clearColor];
        if (cell.model.answerModel.Thumbnail.count>0) {
            cell.mCollectionV_pic.frame = CGRectMake(9, cell.mView_background.frame.origin.y+cell.mView_background.frame.size.height+5, [dm getInstance].width-9-2, ([dm getInstance].width-65-30)/3);
        }else{
            cell.mCollectionV_pic.frame = cell.mView_background.frame;
        }
        //时间
        cell.mLab_RecDate.frame = CGRectMake(cell.mLab_ATitle.frame.origin.x, cell.mCollectionV_pic.frame.origin.y+cell.mCollectionV_pic.frame.size.height+5, cell.mLab_RecDate.frame.size.width, cell.mLab_RecDate.frame.size.height);
        cell.mLab_RecDate.text = cell.model.answerModel.RecDate;
        //评论
        CGSize commentSize = [[NSString stringWithFormat:@"%@",cell.model.ViewCount] sizeWithFont:[UIFont systemFontOfSize:10]];
        cell.mLab_commentCount.frame = CGRectMake([dm getInstance].width-9-commentSize.width, cell.mLab_RecDate.frame.origin.y, commentSize.width, cell.mLab_commentCount.frame.size.height);
        cell.mLab_commentCount.text = cell.model.ViewCount;
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
    NSMutableArray *temp = [NSMutableArray array];
    for (int i=0; i<3; i++) {
        ButtonViewModel *model = [[ButtonViewModel alloc] init];
        if(i == 0)
        {
            model.mStr_title = @"举报";

        }
        if(i == 1)
        {
            model.mStr_title = @"评论";
            
        }
        if(i == 2)
        {
            model.mStr_title = @"反对";
            
        }
        model.mStr_img = @"buttonView1";
        [temp addObject:model];
    }
    self.mBtnV_btn = [[ButtonView alloc] initFrame:CGRectMake(0, cell.frame.origin.y+cell.frame.size.height, [dm getInstance].width, 50) Array:temp];
    self.mBtnV_btn.delegate = self;
    [self.mainScrollView addSubview:self.mBtnV_btn];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.mBtnV_btn.frame.size.height+self.mBtnV_btn.frame.origin.y, [dm  getInstance].width, [self tableViewCellHeight]) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.mainScrollView addSubview:self.tableView];
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
