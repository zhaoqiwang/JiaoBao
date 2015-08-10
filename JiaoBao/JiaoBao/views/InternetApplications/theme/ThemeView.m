//
//  ThemeView.m
//  JiaoBao
//
//  Created by Zqw on 14-12-16.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "ThemeView.h"
#import "Reachability.h"
#import "MobClick.h"

@implementation ThemeView

- (id)initWithFrame1:(CGRect)frame{
    self = [super init];
    if (self) {
        // Initialization code
        self.frame = frame;
        //做bug服务器显示当前的哪个界面
        NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
        [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
        [self setBackgroundColor:[UIColor colorWithRed:247/255.0 green:246/255.0 blue:246/255.0 alpha:1]];
        
        //首页问题列表
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UserIndexQuestion" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserIndexQuestion:) name:@"UserIndexQuestion" object:nil];
        //获取所有话题
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetAllCategory" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetAllCategory:) name:@"GetAllCategory" object:nil];
        //取回话题的话题列表
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CategoryIndexQuestion" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CategoryIndexQuestion:) name:@"CategoryIndexQuestion" object:nil];
        
        self.mArr_AllCategory = [NSMutableArray array];
        self.mInt_index = 0;
        self.mInt_reloadData = 0;
        //首页精选等
        self.mScrollV_all = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 0, [dm getInstance].width-20-40, 48)];
        
        NSMutableArray *tempArray = [NSMutableArray arrayWithObjects:@"首页",@"精选",@"推荐", nil];
        for (int i=0; i<tempArray.count; i++) {
            AllCategoryModel *model = [[AllCategoryModel alloc] init];
            model.item.Subject = [tempArray objectAtIndex:i];
            [self.mArr_AllCategory addObject:model];
        }
        [self addScrollViewBtn:0];
        
        [self addSubview:self.mScrollV_all];
        //表格
        self.mTableV_knowledge = [[UITableView alloc] initWithFrame:CGRectMake(0, 48, [dm getInstance].width, self.frame.size.height-48)];
        self.mTableV_knowledge.delegate = self;
        self.mTableV_knowledge.dataSource = self;
        self.mTableV_knowledge.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.mTableV_knowledge];
        [self.mTableV_knowledge addHeaderWithTarget:self action:@selector(headerRereshing)];
        self.mTableV_knowledge.headerPullToRefreshText = @"下拉刷新";
        self.mTableV_knowledge.headerReleaseToRefreshText = @"松开后刷新";
        self.mTableV_knowledge.headerRefreshingText = @"正在刷新...";
        [self.mTableV_knowledge addFooterWithTarget:self action:@selector(footerRereshing)];
        self.mTableV_knowledge.footerPullToRefreshText = @"上拉加载更多";
        self.mTableV_knowledge.footerReleaseToRefreshText = @"松开加载更多数据";
        self.mTableV_knowledge.footerRefreshingText = @"正在加载...";
    }
    return self;
}

//加载一级话题列表
-(void)addScrollViewBtn:(int)index{
    for (UIButton *btn in self.mScrollV_all.subviews) {
        [btn removeFromSuperview];
    }
    int tempWidth = 50;
    for (int i=0; i<self.mArr_AllCategory.count; i++) {
        AllCategoryModel *model = [self.mArr_AllCategory objectAtIndex:i];
        D("dlkjglk-===%@",model.item.Subject);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(tempWidth*i, 1, tempWidth, 47)];
        [btn setTag:i];
        if (i==0) {
            btn.selected = YES;
        }
        [btn setBackgroundColor:[UIColor colorWithRed:247/255.0 green:246/255.0 blue:246/255.0 alpha:1]];
        
        //设置button下划线
        //            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[tempArray objectAtIndex:i]];
        //            NSRange strRange = {0,[str length]};
        //            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:130/255.0 green:129/255.0 blue:130/255.0 alpha:1] range:strRange];//设置颜色
        //            [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
        
        [btn setTitle:model.item.Subject forState:UIControlStateNormal];
        [btn setTitle:model.item.Subject forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor colorWithRed:3/255.0 green:170/255.0 blue:54/255.0 alpha:1] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"topBtnSelect0"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(selectScrollButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.mScrollV_all addSubview:btn];
    }
    self.mScrollV_all.contentSize = CGSizeMake(50*self.mArr_AllCategory.count, 48);
}

-(void)selectScrollButton:(UIButton *)btn{
    self.mInt_index = (int)btn.tag;
    for (UIButton *btn1 in self.mScrollV_all.subviews) {
        if ([btn1.class isSubclassOfClass:[UIButton class]]) {
            if ((int)btn1.tag == self.mInt_index) {
                btn1.selected = YES;
            }else{
                btn1.selected = NO;
            }
        }
    }
    AllCategoryModel *model = [self.mArr_AllCategory objectAtIndex:self.mInt_index];
    if (model.mArr_Category.count==0) {
        [self sendRequest];
    }
    [self.mTableV_knowledge reloadData];
}

-(void)ProgressViewLoad{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    //取所有话题
    [[KnowledgeHttp getInstance] GetAllCategory];
    [self sendRequest];
//    [[KnowledgeHttp getInstance]GetCategoryWithParentId:@"" subject:@""];
   // [[KnowledgeHttp getInstance]CategoryIndexQuestionWithNumPerPage:@"20" pageNum:@"1" RowCount:@"0" flag:@"-1" uid:@"15"];
    //[[KnowledgeHttp getInstance]CommentsListWithNumPerPage:@"20" pageNum:@"1" AId:@"85"];
   // [[KnowledgeHttp getInstance]AddCommentWithAId:@"85" comment:@"very good" RefID:@""];
    //[[KnowledgeHttp getInstance]AnswerDetailWithAId:@"85"];
    //[[KnowledgeHttp getInstance]SetYesNoWithAId:@"85" yesNoFlag:@"1"];
//    [[KnowledgeHttp getInstance]UserIndexQuestionWithNumPerPage:@"10" pageNum:@"1" RowCount:@"0" flag:@"1"];
    //[[KnowledgeHttp getInstance]reportanswerWithAId:@"85"];//没有成功
//    [[KnowledgeHttp getInstance]GetAnswerByIdWithNumPerPage:@"20" pageNum:@"1" QId:@"15" flag:@"1"];
//    [[KnowledgeHttp getInstance]UpdateAnswerWithTabID:@"15" Title:@"" AContent:@"333333"];
//    [[KnowledgeHttp getInstance]AddAnswerWithQId:@"15" Title:@"" AContent:@"2" UserName:@""];
//    [[KnowledgeHttp getInstance]QuestionDetailWithQId:@"15"];
//    [[KnowledgeHttp getInstance] knowledgeHttpGetProvice];
//    [[KnowledgeHttp getInstance] knowledgeHttpGetCity:@"" level:@""];
//    [MBProgressHUD showMessage:@"加载中..." toView:self];
    
}

//取回话题的话题列表
-(void)CategoryIndexQuestion:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self];
    [self.mTableV_knowledge headerEndRefreshing];
    [self.mTableV_knowledge footerEndRefreshing];
    NSMutableDictionary *dic = noti.object;
    NSString *code = [dic objectForKey:@"code"];
    if ([code integerValue] ==0) {
        NSMutableArray *array = [dic objectForKey:@"array"];
        AllCategoryModel *model = [self.mArr_AllCategory objectAtIndex:self.mInt_index];
        if (self.mInt_reloadData ==0) {
            model.mArr_Category = [NSMutableArray arrayWithArray:array];
        }else{
            [model.mArr_Category addObjectsFromArray:array];
        }
    }
    [self.mTableV_knowledge reloadData];
}

//获取所有话题
-(void)GetAllCategory:(NSNotification *)noti{
    NSMutableDictionary *dic = noti.object;
    NSString *code = [dic objectForKey:@"code"];
    if ([code integerValue] ==0) {
        NSMutableArray *array = [dic objectForKey:@"array"];
        for (int i=0; i<array.count; i++) {
            AllCategoryModel *model = [array objectAtIndex:i];
            [self.mArr_AllCategory addObject:model];
        }
        [self addScrollViewBtn:(int)array.count];
    }
}

//首页问题列表
-(void)UserIndexQuestion:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self];
    [self.mTableV_knowledge headerEndRefreshing];
    [self.mTableV_knowledge footerEndRefreshing];
    NSMutableDictionary *dic = noti.object;
    NSString *code = [dic objectForKey:@"code"];
    if ([code integerValue] ==0) {
        NSMutableArray *array = [dic objectForKey:@"array"];
        AllCategoryModel *model = [self.mArr_AllCategory objectAtIndex:self.mInt_index];
        if (self.mInt_reloadData ==0) {
            model.mArr_Category = [NSMutableArray arrayWithArray:array];
        }else{
            [model.mArr_Category addObjectsFromArray:array];
        }
    }
    [self.mTableV_knowledge reloadData];
}

//检查当前网络是否可用
-(BOOL)checkNetWork{
    if([Reachability isEnableNetwork]==NO){
        [MBProgressHUD showError:NETWORKENABLE toView:self];
        return YES;
    }else{
        return NO;
    }
}

//切换账号时，更新数据
-(void)RegisterView:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self];
    [dm getInstance].mImt_showUnRead = 0;
    [dm getInstance].mImt_shareUnRead = 0;
}

-(NSMutableArray *)arrayDataSource{
    AllCategoryModel *model = [self.mArr_AllCategory objectAtIndex:self.mInt_index];
    return model.mArr_Category;
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return [self arrayDataSource].count;
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
        [self.mTableV_knowledge registerNib:n forCellReuseIdentifier:indentifier];
    }
    //添加点击事件
    cell.delegate = self;
    [cell addTapClick];
    NSMutableArray *array = [self arrayDataSource];
    QuestionModel *model = [array objectAtIndex:indexPath.row];
    cell.model = model;
    //标题
    cell.mLab_title.frame = CGRectMake(9, 10, [dm getInstance].width-9*2, cell.mLab_title.frame.size.height);
    cell.mLab_title.text = model.Title;
    //话题
    cell.mLab_Category0.frame = CGRectMake(30, cell.mLab_title.frame.origin.y+cell.mLab_title.frame.size.height+5, cell.mLab_Category0.frame.size.width, cell.mLab_Category0.frame.size.height);
    CGSize CategorySize = [[NSString stringWithFormat:@"%@",model.CategorySuject] sizeWithFont:[UIFont systemFontOfSize:10]];
    cell.mLab_Category1.frame = CGRectMake(30+cell.mLab_Category0.frame.size.width+2, cell.mLab_Category0.frame.origin.y, CategorySize.width, cell.mLab_Category0.frame.size.height);
    cell.mLab_Category1.text = model.CategorySuject;
    //访问
    CGSize ViewSize = [[NSString stringWithFormat:@"%@",model.ViewCount] sizeWithFont:[UIFont systemFontOfSize:10]];
    cell.mLab_ViewCount.frame = CGRectMake([dm getInstance].width-9-ViewSize.width, cell.mLab_Category0.frame.origin.y, ViewSize.width, cell.mLab_Category0.frame.size.height);
    cell.mLab_ViewCount.text = model.ViewCount;
    cell.mLab_View.frame = CGRectMake(cell.mLab_ViewCount.frame.origin.x-2-cell.mLab_View.frame.size.width, cell.mLab_Category0.frame.origin.y, cell.mLab_View.frame.size.width, cell.mLab_View.frame.size.height);
    //回答
    CGSize AnswersSize = [[NSString stringWithFormat:@"%@",model.AnswersCount] sizeWithFont:[UIFont systemFontOfSize:10]];
    cell.mLab_AnswersCount.frame = CGRectMake(cell.mLab_View.frame.origin.x-5-AnswersSize.width, cell.mLab_Category0.frame.origin.y, AnswersSize.width, cell.mLab_Category0.frame.size.height);
    cell.mLab_AnswersCount.text = model.AnswersCount;
    cell.mLab_Answers.frame = CGRectMake(cell.mLab_AnswersCount.frame.origin.x-2-cell.mLab_Answers.frame.size.width, cell.mLab_Category0.frame.origin.y, cell.mLab_Answers.frame.size.width, cell.mLab_Answers.frame.size.height);
    //关注
    CGSize AttSize = [[NSString stringWithFormat:@"%@",model.AttCount] sizeWithFont:[UIFont systemFontOfSize:10]];
    cell.mLab_AttCount.frame = CGRectMake(cell.mLab_Answers.frame.origin.x-5-AttSize.width, cell.mLab_Category0.frame.origin.y, AttSize.width, cell.mLab_Category0.frame.size.height);
    cell.mLab_AttCount.text = model.AttCount;
    cell.mLab_Att.frame = CGRectMake(cell.mLab_AttCount.frame.origin.x-2-cell.mLab_Att.frame.size.width, cell.mLab_Category0.frame.origin.y, cell.mLab_Att.frame.size.width, cell.mLab_Att.frame.size.height);
    //判断是否有回答
    if ([model.AnswersCount integerValue]>0) {
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
        //赞
        cell.mLab_LikeCount.frame = CGRectMake(9, cell.mLab_line.frame.origin.y+15, 42, 22);
        NSString *strLike = model.answerModel.LikeCount;
        if ([model.answerModel.LikeCount integerValue]>0) {
            strLike = @"99+";
        }
        cell.mLab_LikeCount.text = [NSString stringWithFormat:@"%@赞",strLike];
        //头像
        cell.mImgV_head.frame = CGRectMake(9, cell.mLab_LikeCount.frame.origin.y+22+10, 42, 42);
        [cell.mImgV_head sd_setImageWithURL:(NSURL *)[NSString stringWithFormat:@"%@%@",AccIDImg,model.answerModel.JiaoBaoHao] placeholderImage:[UIImage  imageNamed:@"root_img"]];
        //姓名
        cell.mLab_IdFlag.frame = CGRectMake(9, cell.mImgV_head.frame.origin.y+42+10, 42, cell.mLab_IdFlag.frame.size.height);
        cell.mLab_IdFlag.text = model.answerModel.IdFlag;
        //回答标题
        NSString *string1 = model.answerModel.ATitle;
        string1 = [string1 stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        NSString *name = [NSString stringWithFormat:@"<font size=14 color='#03AA36'>答 : </font> <font size=14 color=black>%@</font>",string1];
        cell.mLab_ATitle.frame = CGRectMake(63, cell.mLab_LikeCount.frame.origin.y+3, [dm getInstance].width-65, cell.mLab_ATitle.frame.size.height);
        NSMutableDictionary *row1 = [NSMutableDictionary dictionary];
        [row1 setObject:name forKey:@"text"];
        RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:[row1 objectForKey:@"text"]];
        cell.mLab_ATitle.componentsAndPlainText = componentsDS;
        //回答内容
        NSString *string2 = model.answerModel.Abstracts;
        string2 = [string2 stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        string2 = [string2 stringByReplacingOccurrencesOfString:@"\r\r" withString:@""];
        NSString *name2 = [NSString stringWithFormat:@"<font size=14 color='red'>依据 : </font> <font>%@</font>", string2];
        NSString *string = [NSString stringWithFormat:@"依据 : %@",string2];
        CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake([dm getInstance].width-75, 1000)];
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
        if (model.answerModel.Thumbnail.count>0) {
            cell.mCollectionV_pic.frame = CGRectMake(63, cell.mView_background.frame.origin.y+cell.mView_background.frame.size.height+5, [dm getInstance].width-65, ([dm getInstance].width-65-30)/3);
        }else{
            cell.mCollectionV_pic.frame = cell.mView_background.frame;
        }
        //时间
        cell.mLab_RecDate.frame = CGRectMake(cell.mLab_ATitle.frame.origin.x, cell.mCollectionV_pic.frame.origin.y+cell.mCollectionV_pic.frame.size.height+5, cell.mLab_RecDate.frame.size.width, cell.mLab_RecDate.frame.size.height);
        cell.mLab_RecDate.text = model.answerModel.RecDate;
        //评论
        CGSize commentSize = [[NSString stringWithFormat:@"%@",model.ViewCount] sizeWithFont:[UIFont systemFontOfSize:10]];
        cell.mLab_commentCount.frame = CGRectMake([dm getInstance].width-9-commentSize.width, cell.mLab_RecDate.frame.origin.y, commentSize.width, cell.mLab_commentCount.frame.size.height);
        cell.mLab_commentCount.text = model.ViewCount;
        cell.mLab_comment.frame = CGRectMake(cell.mLab_commentCount.frame.origin.x-2-cell.mLab_comment.frame.size.width, cell.mLab_RecDate.frame.origin.y, cell.mLab_View.frame.size.width, cell.mLab_comment.frame.size.height);
        if (model.answerModel.Thumbnail.count>0) {
            cell.mLab_line2.frame = CGRectMake(0, cell.mLab_RecDate.frame.origin.y+cell.mLab_RecDate.frame.size.height+10, [dm getInstance].width, 10);
        }else{
            cell.mLab_line2.frame = CGRectMake(0, cell.mLab_IdFlag.frame.origin.y+cell.mLab_IdFlag.frame.size.height+10, [dm getInstance].width, 10);
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
    NSMutableArray *array = [self arrayDataSource];
    QuestionModel *model = [array objectAtIndex:indexPath.row];
    //标题
    tempF = tempF+10+16;
    //话题
    tempF = tempF+5+21;
    //判断是否有回答
    if ([model.AnswersCount integerValue]>0) {
        //分割线
        tempF = tempF+5;
        if (model.answerModel.Thumbnail.count>0) {
            //回答标题
            tempF = tempF+15+22;
            //回答内容
            NSString *string2 = model.answerModel.Abstracts;
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
    }else{
        tempF = tempF+20;
    }
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

-(void)sendRequest{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    NSString *page = @"";
    if (self.mInt_reloadData == 0) {
        page = @"1";
        [MBProgressHUD showMessage:@"加载中..." toView:self];
    }else{
        NSMutableArray *array = [self arrayDataSource];
        if (array.count>=10&&array.count%10==0) {
            //检查当前网络是否可用
            if ([self checkNetWork]) {
                return;
            }
            page = [NSString stringWithFormat:@"%d",(int)array.count/10+1];
            [MBProgressHUD showMessage:@"加载中..." toView:self];
        } else {
            [self.mTableV_knowledge headerEndRefreshing];
            [self.mTableV_knowledge footerEndRefreshing];
            [MBProgressHUD showSuccess:@"没有更多了" toView:self];
            return;
        }
    }
    NSString *rowCount = @"0";
    NSMutableArray *array = [self arrayDataSource];
    if (array.count>0) {
        QuestionModel *model = [array objectAtIndex:array.count-1];
        rowCount = model.rowCount;
    }
    
    if (self.mInt_index ==0) {
        [[KnowledgeHttp getInstance]UserIndexQuestionWithNumPerPage:@"10" pageNum:page RowCount:rowCount flag:@"1"];
    }else if (self.mInt_index ==1){
        
    }else if (self.mInt_index ==2){
        
    }else{
        AllCategoryModel *model = [self.mArr_AllCategory objectAtIndex:self.mInt_index];
        [[KnowledgeHttp getInstance] QuestionIndexWithNumPerPage:@"3" pageNum:page CategoryId:model.item.TabID];
//        [[KnowledgeHttp getInstance] CategoryIndexQuestionWithNumPerPage:@"3" pageNum:page RowCount:rowCount flag:@"1" uid:[dm getInstance].jiaoBaoHao];
    }
}

//cell的点击事件---答案
-(void)KnowledgeTableViewCellAnswers:(KnowledgeTableViewCell *)knowledgeTableViewCell{
    D("234");
}

//cell的点击事件---标题
-(void)KnowledgeTableViewCellTitleBtn:(KnowledgeTableViewCell *)knowledgeTableViewCell{
    D("123");
}

@end
