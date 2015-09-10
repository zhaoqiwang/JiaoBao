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
#import "CommentViewController.h"
#import "CategoryViewController.h"

@implementation ThemeView

- (id)initWithFrame1:(CGRect)frame{
    self = [super init];
    if (self) {
        // Initialization code
        self.frame = frame;
        //做bug服务器显示当前的哪个界面
        NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
        [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
        //刷新话题分类
        [self setBackgroundColor:[UIColor colorWithRed:247/255.0 green:246/255.0 blue:246/255.0 alpha:1]];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshCategory" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCategory:) name:@"refreshCategory" object:nil];
        //首页问题列表
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UserIndexQuestion" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CategoryIndexQuestion:) name:@"UserIndexQuestion" object:nil];
        //获取所有话题
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetAllCategory" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetAllCategory:) name:@"GetAllCategory" object:nil];
        //取回话题的话题列表
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CategoryIndexQuestion" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CategoryIndexQuestion:) name:@"CategoryIndexQuestion" object:nil];
        //推荐问题列表
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RecommentIndex" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RecommentIndex:) name:@"RecommentIndex" object:nil];
        //置顶问题
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetCategoryTop" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetCategoryTop:) name:@"GetCategoryTop" object:nil];
        //获取一个精选内容集
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetPickedById" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetPickedById:) name:@"GetPickedById" object:nil];
        //通知界面，更新访问量等数据
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updataQuestionDetail" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataQuestionDetail:) name:@"updataQuestionDetail" object:nil];

        self.mArr_AllCategory = [NSMutableArray array];
        self.mInt_index = 0;
        self.mInt_reloadData = 0;
        self.mModel_getPickdById = [[GetPickedByIdModel alloc] init];
        //首页精选等
        self.mScrollV_all = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 0, [dm getInstance].width-20-40, 48)];
        
        NSMutableArray *tempArray = [NSMutableArray arrayWithObjects:@"首页",@"推荐",@"精选", nil];
        for (int i=0; i<tempArray.count; i++) {
            AllCategoryModel *model = [[AllCategoryModel alloc] init];
            if (i==0) {
                model.flag = @"1";
            }
            model.item.Subject = [tempArray objectAtIndex:i];
            [self.mArr_AllCategory addObject:model];
        }
        [self addScrollViewBtn:0];
        
        [self addSubview:self.mScrollV_all];
        //下拉选择按钮
        self.mBtn_down = [UIButton buttonWithType:UIButtonTypeCustom];
        self.mBtn_down.frame = CGRectMake([dm getInstance].width-40, 8, 40, 40);
        [self.mBtn_down setImage:[UIImage imageNamed:@"topBtnDown0"] forState:UIControlStateNormal];
        [self.mBtn_down addTarget:self action:@selector(clickDownBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.mBtn_down];
        
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
        
//        CustomTextFieldView *temo = [[CustomTextFieldView alloc] initFrame:CGRectMake(0, 120, [dm getInstance].width, 50)];
//        [self addSubview:temo];

    }
    return self;
}
//选择话题二级列表后的回调
-(void)refreshCategory:(id)sender
{
    ItemModel *itemModel = [sender object];
    AllCategoryModel *model = [self.mArr_AllCategory objectAtIndex:self.mInt_index];
    if ([itemModel.TabID integerValue]!=[model.item_now.TabID integerValue]) {
        model.item_now = itemModel;
        [model.mArr_discuss removeAllObjects];
        [model.mArr_evidence removeAllObjects];
        [model.mArr_all removeAllObjects];
        [model.mArr_top removeAllObjects];
        [self sendRequest];
    }
    [self.mTableV_knowledge reloadData];
}
//下拉选择按钮
-(void)clickDownBtn:(UIButton *)btn{
    D("点击下拉选择按钮");
//    [[KnowledgeHttp getInstance] GetAllCategory];
    CategoryViewController *detailVC = [[CategoryViewController alloc]initWithNibName:@"CategoryViewController" bundle:nil];
    detailVC.modalPresentationStyle = UIModalPresentationFullScreen;
    detailVC.mArr_AllCategory = [[NSMutableArray alloc]initWithCapacity:0];
    detailVC.mArr_selectCategory = [[NSMutableArray alloc]initWithCapacity:0];
    self.mArr_selectCategory = detailVC.mArr_selectCategory;

    detailVC.classStr = [NSString stringWithUTF8String:object_getClassName(self)];
    for(int i=3;i<self.mArr_AllCategory.count;i++)
    {
        [detailVC.mArr_AllCategory addObject:[self.mArr_AllCategory objectAtIndex:i]];
    }
    
    for (UIView* next = [self superview]; next; next =
         next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController
                                          class]]) {
            UIViewController *vc = (UIViewController*)nextResponder;
            [vc.navigationController  presentViewController:detailVC animated:YES completion:^{
        //detailVC.view.superview.frame = CGRectMake(10, 44+30, [dm getInstance].width-20, [dm getInstance].height-84);
                
            }];
        }
    }
}

//加载一级话题列表
-(void)addScrollViewBtn:(int)index{
    for (UIButton *btn in self.mScrollV_all.subviews) {
        [btn removeFromSuperview];
    }
    int tempWidth = 50;
    for (int i=0; i<self.mArr_AllCategory.count; i++) {
        AllCategoryModel *model = [self.mArr_AllCategory objectAtIndex:i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(tempWidth*i, 1, tempWidth, 47)];
        [btn setTag:i];
        if (i==0) {
            btn.selected = YES;
        }
        [btn setBackgroundColor:[UIColor colorWithRed:247/255.0 green:246/255.0 blue:246/255.0 alpha:1]];
        
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
    if ([model.flag intValue]==-1&&model.mArr_all.count==0) {
        self.mInt_reloadData = 0;
        [self sendRequest];
    }else if ([model.flag intValue]==0&&model.mArr_discuss.count==0){
        self.mInt_reloadData = 0;
        [self sendRequest];
    }else if ([model.flag intValue]==1&&model.mArr_evidence.count==0){
        self.mInt_reloadData = 0;
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
    if (self.mArr_AllCategory.count==3) {
        [[KnowledgeHttp getInstance] GetAllCategory];
    }
    
    [self sendRequest];
//    [[KnowledgeHttp getInstance] GetPickedByIdWithTabID:@"0"];
}

//通知界面，更新访问量等数据
-(void)updataQuestionDetail:(NSNotification *)noti{
    QuestionDetailModel *model = noti.object;
    NSMutableArray *array = [self arrayDataSourceSum];
    for (int i=0; i<array.count; i++) {
        QuestionModel *tempModel = [array objectAtIndex:i];
        if ([tempModel.TabID intValue]==[model.TabID intValue]) {
            tempModel.ViewCount = [NSString stringWithFormat:@"%d",[model.ViewCount intValue]+1];
            tempModel.AnswersCount = model.AnswersCount;
            tempModel.AttCount = model.AttCount;
            break;
        }
    }
    [self.mTableV_knowledge reloadData];
}

//置顶问题
-(void)GetCategoryTop:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self];
    [self.mTableV_knowledge headerEndRefreshing];
    [self.mTableV_knowledge footerEndRefreshing];
    NSMutableDictionary *dic = noti.object;
    NSString *code = [dic objectForKey:@"ResultCode"];
    if ([code integerValue] ==0) {
        NSMutableArray *array = [dic objectForKey:@"array"];
        AllCategoryModel *model = [self.mArr_AllCategory objectAtIndex:self.mInt_index];
        model.mArr_top = array;
        for (QuestionModel *model1 in model.mArr_top) {
            model1.mInt_top = 1;
        }
    }
    [self.mTableV_knowledge reloadData];
}

//获取一个精选内容集
-(void)GetPickedById:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self];
    [self.mTableV_knowledge headerEndRefreshing];
    [self.mTableV_knowledge footerEndRefreshing];
    NSMutableDictionary *dic = noti.object;
    NSString *code = [dic objectForKey:@"ResultCode"];
    if ([code integerValue] ==0) {
        self.mModel_getPickdById = [dic objectForKey:@"model"];
    }
    [self.mTableV_knowledge reloadData];
}

//推荐问题列表
-(void)RecommentIndex:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self];
    [self.mTableV_knowledge headerEndRefreshing];
    [self.mTableV_knowledge footerEndRefreshing];
    NSMutableDictionary *dic = noti.object;
    NSString *code = [dic objectForKey:@"ResultCode"];
    if ([code integerValue] ==0) {
        NSMutableArray *array = [dic objectForKey:@"array"];
        AllCategoryModel *model = [self.mArr_AllCategory objectAtIndex:self.mInt_index];
        if (self.mInt_reloadData ==0) {
            model.mArr_all = [NSMutableArray arrayWithArray:array];
        }else{
            [model.mArr_all addObjectsFromArray:array];
        }
    }
    [self.mTableV_knowledge reloadData];
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
        NSString *flag = [dic objectForKey:@"flag"];
        AllCategoryModel *model = [self.mArr_AllCategory objectAtIndex:self.mInt_index];
        if ([flag integerValue]==-1) {
            if (self.mInt_reloadData ==0) {
                model.mArr_all = [NSMutableArray arrayWithArray:array];
            }else{
                [model.mArr_all addObjectsFromArray:array];
            }
        }else if ([flag integerValue]==0){
            if (self.mInt_reloadData ==0) {
                model.mArr_discuss = [NSMutableArray arrayWithArray:array];
            }else{
                [model.mArr_discuss addObjectsFromArray:array];
            }
        }else if ([flag integerValue]==1){
            if (self.mInt_reloadData ==0) {
                model.mArr_evidence = [NSMutableArray arrayWithArray:array];
            }else{
                [model.mArr_evidence addObjectsFromArray:array];
            }
        }
    }
    [self.mTableV_knowledge reloadData];
}

//获取所有话题
-(void)GetAllCategory:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self animated:YES];
    NSMutableDictionary *dic = noti.object;
    NSString *code = [dic objectForKey:@"code"];
    if ([code integerValue] ==0) {
        NSMutableArray *array = [dic objectForKey:@"array"];
        for (int i=0; i<array.count; i++) {
            AllCategoryModel *model = [array objectAtIndex:i];
            model.flag = @"-1";
            //给一个默认的话题，暂时为二级话题中的第一个
            if (model.mArr_subItem.count>0) {
                model.item_now = [model.mArr_subItem objectAtIndex:0];
            }else{
                model.item_now = model.item;
            }
            
            [self.mArr_AllCategory addObject:model];
        }
        [self addScrollViewBtn:(int)array.count];
    }
   
}

//首页问题列表
//-(void)UserIndexQuestion:(NSNotification *)noti{
//    [MBProgressHUD hideHUDForView:self];
//    [self.mTableV_knowledge headerEndRefreshing];
//    [self.mTableV_knowledge footerEndRefreshing];
//    NSMutableDictionary *dic = noti.object;
//    NSString *code = [dic objectForKey:@"code"];
//    if ([code integerValue] ==0) {
//        NSMutableArray *array = [dic objectForKey:@"array"];
//        AllCategoryModel *model = [self.mArr_AllCategory objectAtIndex:self.mInt_index];
//        if (self.mInt_reloadData ==0) {
//            model.mArr_all = [NSMutableArray arrayWithArray:array];
//        }else{
//            [model.mArr_all addObjectsFromArray:array];
//        }
//    }
//    [self.mTableV_knowledge reloadData];
//}

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

//显示用的所有数组
-(NSMutableArray *)arrayDataSourceSum{
    AllCategoryModel *model = [self.mArr_AllCategory objectAtIndex:self.mInt_index];
    
    if (self.mInt_index ==0) {//首页
        [model.mArr_sum removeAllObjects];
        QuestionModel *temp = [[QuestionModel alloc] init];
        temp.mInt_btn = 1;
        [model.mArr_sum addObject:temp];
        [model.mArr_sum addObjectsFromArray:[self arrayDataSourceTemp:model]];
    }else if (self.mInt_index ==1){//推荐
        return model.mArr_all;
    }else if (self.mInt_index ==2){//精选
        
    }else{//从服务器获取到的
        [model.mArr_sum removeAllObjects];
        QuestionModel *temp = [[QuestionModel alloc] init];
        temp.mInt_btn = 1;
        [model.mArr_sum addObject:temp];
        if (model.mArr_top.count>0) {
            NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,[model.mArr_sum count])];
            [model.mArr_sum insertObjects:model.mArr_top atIndexes:indexes];
        }
        [model.mArr_sum addObjectsFromArray:[self arrayDataSourceTemp:model]];
        //话题显示行
        QuestionModel *temp1 = [[QuestionModel alloc] init];
        temp1.mInt_btn = 2;
        [model.mArr_sum insertObject:temp1 atIndex:0];
    }
    return model.mArr_sum;
}

//申请数据时用到的当前数组
-(NSMutableArray *)arrayDataSourceRequest{
    AllCategoryModel *model = [self.mArr_AllCategory objectAtIndex:self.mInt_index];
    if ([model.flag integerValue]==-1) {
        return model.mArr_all;
    }else if ([model.flag intValue]==0){
        return model.mArr_discuss;
    }else if ([model.flag intValue]==1){
        return model.mArr_evidence;
    }
    return model.mArr_sum;
}

-(NSMutableArray *)arrayDataSourceTemp:(AllCategoryModel *)model{
    if ([model.flag integerValue]==-1) {
        return model.mArr_all;
    }else if ([model.flag integerValue]==0){
        return model.mArr_discuss;
    }else if ([model.flag integerValue]==1){
        return model.mArr_evidence;
    }
    return model.mArr_sum;
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.mInt_index ==2) {//精选
        if ([self.mModel_getPickdById.TabID integerValue]>0) {
            return self.mModel_getPickdById.PickContent.count+1;
        }
    }else{
        return [self arrayDataSourceSum].count;
    }
    return 0;
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
    
    
    //先判断是精选还是别的类型
    if (self.mInt_index ==2) {//精选
        cell.delegate = self;
        cell.backgroundColor = [UIColor whiteColor];
        cell.mImgV_top.hidden = YES;
        if (indexPath.row==0) {
            cell.LikeBtn.hidden = YES;
            cell.mLab_title.hidden = NO;
            CGSize titleSize2 = [[NSString stringWithFormat:@"%@",self.mModel_getPickdById.PTitle] sizeWithFont:[UIFont systemFontOfSize:14]];
            cell.mLab_title.frame = CGRectMake(9, 10, titleSize2.width, cell.mLab_title.frame.size.height);
            cell.mLab_title.text = self.mModel_getPickdById.PTitle;
            cell.mLab_Category0.hidden = YES;
            cell.mLab_Category1.hidden = YES;
            cell.mLab_Att.hidden = YES;
            cell.mLab_AttCount.hidden = YES;
            cell.mLab_Answers.hidden = YES;
            cell.mLab_AnswersCount.hidden = YES;
            cell.mLab_View.hidden = YES;
            cell.mLab_ViewCount.hidden = YES;
            cell.mLab_LikeCount.hidden = YES;
            cell.mLab_ATitle.hidden = YES;
            cell.mLab_Abstracts.hidden = YES;
            cell.mInt_flag = 3;
//            cell.pickContentModel = model;
            cell.mView_background.hidden = YES;
            cell.mLab_IdFlag.hidden = YES;
            cell.mLab_RecDate.hidden = NO;
            cell.mLab_RecDate.frame = CGRectMake(cell.mLab_title.frame.origin.x+cell.mLab_title.frame.size.width+5, 10, cell.mLab_RecDate.frame.size.width, cell.mLab_RecDate.frame.size.height);
            cell.mLab_RecDate.text = self.mModel_getPickdById.RecDate;
            //按钮
            cell.mBtn_detail.hidden = NO;
            [cell.mBtn_detail setTitle:@"往期精选" forState:UIControlStateNormal];
            cell.mBtn_detail.frame = CGRectMake([dm getInstance].width-56-10, 0, 56, cell.mBtn_detail.frame.size.height);
            cell.mScrollV_pic.hidden = NO;
            cell.mScrollV_pic.frame = CGRectMake(0, 30, [dm getInstance].width, 100);
            cell.mScrollV_pic.backgroundColor = [UIColor redColor];
            UIImageView *temp = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [dm getInstance].width, 100)];
            NSString *tempUrl;
            if (self.mModel_getPickdById.ImgContent.count>0) {
                tempUrl = [NSString stringWithFormat:@"%@%@%@",[dm getInstance].url,self.mModel_getPickdById.baseImgUrl,[self.mModel_getPickdById.ImgContent objectAtIndex:0]];
            }
            D("dghrdk;ljg;dklj-====%@",tempUrl);
            [temp sd_setImageWithURL:(NSURL *)tempUrl placeholderImage:[UIImage  imageNamed:@"root_img"]];
            [cell.mScrollV_pic addSubview:temp];
            cell.mLab_comment.hidden = YES;
            cell.mLab_commentCount.hidden = YES;
            cell.mLab_line.hidden = YES;
            cell.mImgV_head.hidden = YES;
            cell.mCollectionV_pic.hidden = YES;
            //图片
            [cell.mCollectionV_pic reloadData];
            cell.mCollectionV_pic.backgroundColor = [UIColor clearColor];
            cell.mLab_line2.hidden = YES;
            cell.mWebV_comment.hidden = YES;
            cell.mBtn_all.hidden = YES;
            cell.mBtn_evidence.hidden = YES;
            cell.mBtn_discuss.hidden = YES;
            cell.mLab_selectCategory.hidden = YES;
            cell.mLab_selectCategory1.hidden = YES;
        }else{
            PickContentModel *model = [self.mModel_getPickdById.PickContent objectAtIndex:indexPath.row-1];
            cell.LikeBtn.hidden = YES;
            cell.mLab_title.hidden = NO;
            cell.mLab_title.frame = CGRectMake(9, 10, [dm getInstance].width-9*2-40, cell.mLab_title.frame.size.height);
            cell.mLab_title.text = model.Title;
            cell.mLab_Category0.hidden = YES;
            cell.mLab_Category1.hidden = YES;
            cell.mLab_Att.hidden = YES;
            cell.mLab_AttCount.hidden = YES;
            cell.mLab_Answers.hidden = YES;
            cell.mLab_AnswersCount.hidden = YES;
            cell.mLab_View.hidden = YES;
            cell.mLab_ViewCount.hidden = YES;
            cell.mLab_LikeCount.hidden = YES;
            cell.mLab_ATitle.hidden = YES;
            cell.mLab_Abstracts.hidden = NO;
            cell.mInt_flag = 3;
            cell.pickContentModel = model;
            NSString *string2 = model.Abstracts;
            string2 = [string2 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            string2 = [string2 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            NSString *name2 = [NSString stringWithFormat:@"<font size=14 color=black>%@</font>",string2];
            
            NSMutableDictionary *row2 = [NSMutableDictionary dictionary];
            [row2 setObject:name2 forKey:@"text"];
            RTLabelComponentsStructure *componentsDS2 = [RCLabel extractTextStyle:[row2 objectForKey:@"text"]];
            cell.mLab_Abstracts.componentsAndPlainText = componentsDS2;
            CGSize optimalSize2 = [cell.mLab_Abstracts optimumSize];
            D("dfgjldkjflk-===%@,%f",model.Abstracts,optimalSize2.height);
            if (optimalSize2.height==23) {
                optimalSize2 = CGSizeMake(optimalSize2.width, 25);
            }else if (optimalSize2.height==14) {
                optimalSize2 = CGSizeMake(optimalSize2.width, 20);
            }else if (optimalSize2.height>20) {
                optimalSize2 = CGSizeMake(optimalSize2.width, 35);
            }
            cell.mLab_Abstracts.frame = CGRectMake(5, cell.mLab_title.frame.origin.y+cell.mLab_title.frame.size.height+7, [dm getInstance].width-10, optimalSize2.height);
            cell.mView_background.hidden = NO;
            cell.mView_background.frame = CGRectMake(cell.mLab_Abstracts.frame.origin.x-2, cell.mLab_Abstracts.frame.origin.y-5, [dm getInstance].width-6, cell.mLab_Abstracts.frame.size.height+4);
            cell.mLab_IdFlag.hidden = YES;
            cell.mLab_RecDate.hidden = YES;
            cell.mLab_comment.hidden = YES;
            cell.mLab_commentCount.hidden = YES;
            cell.mLab_line.hidden = NO;
            cell.mImgV_head.hidden = YES;
            cell.mCollectionV_pic.hidden = NO;
            //图片
            [cell.mCollectionV_pic reloadData];
            cell.mCollectionV_pic.backgroundColor = [UIColor clearColor];
            if (model.Thumbnail.count>0) {
                cell.mCollectionV_pic.frame = CGRectMake(5, cell.mView_background.frame.origin.y+cell.mView_background.frame.size.height+5, [dm getInstance].width-65, ([dm getInstance].width-65-30)/3);
            }else{
                cell.mCollectionV_pic.frame = cell.mView_background.frame;
            }
            //分割线
            cell.mLab_line.frame = CGRectMake(0, cell.mCollectionV_pic.frame.origin.y+cell.mCollectionV_pic.frame.size.height+5, [dm getInstance].width, .5);
            cell.mLab_line2.hidden = YES;
            cell.mBtn_detail.hidden = YES;
            cell.mWebV_comment.hidden = YES;
            cell.mBtn_all.hidden = YES;
            cell.mBtn_evidence.hidden = YES;
            cell.mBtn_discuss.hidden = YES;
            cell.mLab_selectCategory.hidden = YES;
            cell.mLab_selectCategory1.hidden = YES;
            cell.mScrollV_pic.hidden = YES;
        }
    }else{
        //添加点击事件
        cell.delegate = self;
        [cell addTapClick];
        cell.mScrollV_pic.hidden = YES;
        NSMutableArray *array = [self arrayDataSourceSum];
        QuestionModel *model = [array objectAtIndex:indexPath.row];
        cell.model = model;
        cell.mInt_flag = 0;
        [cell.mBtn_detail setTitle:@"详情" forState:UIControlStateNormal];
        cell.tag = indexPath.row;
        //判断显示内容
        if (model.mInt_btn==1) {//三个按钮
            cell.LikeBtn.hidden = YES;
            cell.mLab_title.hidden = YES;
            cell.mLab_Category0.hidden = YES;
            cell.mLab_Category1.hidden = YES;
            cell.mLab_Att.hidden = YES;
            cell.mLab_AttCount.hidden = YES;
            cell.mLab_Answers.hidden = YES;
            cell.mLab_AnswersCount.hidden = YES;
            cell.mLab_View.hidden = YES;
            cell.mLab_ViewCount.hidden = YES;
            cell.mLab_LikeCount.hidden = YES;
            cell.mLab_ATitle.hidden = YES;
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
            cell.mBtn_all.hidden = NO;
            cell.mBtn_evidence.hidden = NO;
            cell.mBtn_discuss.hidden = NO;
            cell.mLab_selectCategory.hidden = YES;
            cell.mLab_selectCategory1.hidden = YES;
            cell.mImgV_top.hidden = YES;
            cell.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
            cell.mBtn_all.frame = CGRectMake(30, 10, 50, 44-20);
            cell.mBtn_evidence.frame = CGRectMake(110, 10, 50, 44-20);
            cell.mBtn_discuss.frame = CGRectMake(190, 10, 50, 44-20);
            AllCategoryModel *allModel = [self.mArr_AllCategory objectAtIndex:self.mInt_index];
            if ([allModel.flag integerValue]==-1) {
                [cell.mBtn_all setTitleColor:[UIColor colorWithRed:3/255.0 green:170/255.0 blue:54/255.0 alpha:1] forState:UIControlStateNormal];
                [cell.mBtn_all.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
                [cell.mBtn_all.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
                [cell.mBtn_all.layer setBorderWidth:1.0]; //边框宽度
                CGColorRef colorref = [UIColor colorWithRed:3/255.0 green:170/255.0 blue:54/255.0 alpha:1].CGColor;
                
                [cell.mBtn_all.layer setBorderColor:colorref];//边框颜色
                [cell.mBtn_evidence setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [cell.mBtn_evidence.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
                [cell.mBtn_evidence.layer setBorderWidth:0]; //边框宽度
                [cell.mBtn_discuss setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [cell.mBtn_discuss.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
                [cell.mBtn_discuss.layer setBorderWidth:0]; //边框宽度
            }else if ([allModel.flag integerValue]==0){
                [cell.mBtn_all setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [cell.mBtn_all.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
                [cell.mBtn_all.layer setBorderWidth:0]; //边框宽度
                [cell.mBtn_evidence setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [cell.mBtn_evidence.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
                [cell.mBtn_evidence.layer setBorderWidth:0]; //边框宽度
                [cell.mBtn_discuss setTitleColor:[UIColor colorWithRed:3/255.0 green:170/255.0 blue:54/255.0 alpha:1] forState:UIControlStateNormal];
                [cell.mBtn_discuss.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
                [cell.mBtn_discuss.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
                [cell.mBtn_discuss.layer setBorderWidth:1.0]; //边框宽度
                CGColorRef colorref = [UIColor colorWithRed:3/255.0 green:170/255.0 blue:54/255.0 alpha:1].CGColor;
                
                [cell.mBtn_discuss.layer setBorderColor:colorref];//边框颜色
            }else if ([allModel.flag integerValue]==1){
                [cell.mBtn_all setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [cell.mBtn_all.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
                [cell.mBtn_all.layer setBorderWidth:0]; //边框宽度
                [cell.mBtn_evidence setTitleColor:[UIColor colorWithRed:3/255.0 green:170/255.0 blue:54/255.0 alpha:1] forState:UIControlStateNormal];
                [cell.mBtn_evidence.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
                [cell.mBtn_evidence.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
                [cell.mBtn_evidence.layer setBorderWidth:1.0]; //边框宽度
                CGColorRef colorref = [UIColor colorWithRed:3/255.0 green:170/255.0 blue:54/255.0 alpha:1].CGColor;
                
                [cell.mBtn_evidence.layer setBorderColor:colorref];//边框颜色
                [cell.mBtn_discuss setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [cell.mBtn_discuss.layer setMasksToBounds:YES];
                [cell.mBtn_discuss.layer setBorderWidth:0]; //边框宽度
            }
        }else if (model.mInt_btn ==2){//当前的话题id
            cell.backgroundColor = [UIColor whiteColor];
            cell.LikeBtn.hidden = YES;
            cell.mLab_title.hidden = YES;
            cell.mLab_Category0.hidden = YES;
            cell.mLab_Category1.hidden = YES;
            cell.mLab_Att.hidden = YES;
            cell.mLab_AttCount.hidden = YES;
            cell.mLab_selectCategory.hidden = NO;
            cell.mLab_selectCategory1.hidden = NO;
            cell.mLab_selectCategory.frame = CGRectMake(30, 0, cell.mLab_selectCategory.frame.size.width, 44);
            AllCategoryModel *allModel = [self.mArr_AllCategory objectAtIndex:self.mInt_index];
            NSString *temp2 = allModel.item_now.Subject;
            cell.mLab_selectCategory1.text = temp2;
            cell.mLab_selectCategory1.font = [UIFont systemFontOfSize:14];
            CGSize AttSize2 = [[NSString stringWithFormat:@"%@",temp2] sizeWithFont:[UIFont systemFontOfSize:14]];
            cell.mLab_selectCategory1.frame = CGRectMake(30+cell.mLab_selectCategory.frame.size.width+5, 0, AttSize2.width, 44);
            cell.mLab_Answers.hidden = YES;
            cell.mLab_AnswersCount.hidden = YES;
            cell.mLab_View.hidden = YES;
            cell.mLab_ViewCount.hidden = YES;
            cell.mLab_LikeCount.hidden = YES;
            cell.mLab_ATitle.hidden = YES;
            cell.mLab_Abstracts.hidden = YES;
            cell.mLab_IdFlag.hidden = YES;
            cell.mLab_RecDate.hidden = YES;
            cell.mLab_comment.hidden = YES;
            cell.mLab_commentCount.hidden = YES;
            cell.mLab_line.hidden = NO;
            cell.mView_background.hidden = YES;
            cell.mImgV_head.hidden = YES;
            cell.mCollectionV_pic.hidden = YES;
            cell.mLab_line2.hidden = YES;
            cell.mBtn_detail.hidden = YES;
            cell.mWebV_comment.hidden = YES;
            cell.mBtn_all.hidden = YES;
            cell.mBtn_evidence.hidden = YES;
            cell.mBtn_discuss.hidden = YES;
            cell.mImgV_top.hidden = YES;
            //分割线
            cell.mLab_line.frame = CGRectMake(0, 43, [dm getInstance].width, .5);
        }else{//正常显示内容
            cell.backgroundColor = [UIColor whiteColor];
            cell.mBtn_all.hidden = YES;
            cell.mBtn_evidence.hidden = YES;
            cell.mBtn_discuss.hidden = YES;
            cell.mWebV_comment.hidden = YES;
            cell.mLab_selectCategory.hidden = YES;
            cell.mLab_selectCategory1.hidden = YES;
            //标题
            cell.mLab_title.text = model.Title;
            cell.mLab_title.hidden = NO;
            //判断是否为置顶数据
            if (model.mInt_top ==1) {//置顶
                cell.mImgV_top.hidden = NO;
                CGSize titleSize = [[NSString stringWithFormat:@"%@",model.Title] sizeWithFont:[UIFont systemFontOfSize:14]];
                if (titleSize.width>[dm getInstance].width-9*2-40-33) {
                    cell.mLab_title.frame = CGRectMake(9, 10, [dm getInstance].width-9*2-40-33, cell.mLab_title.frame.size.height);
                }else{
                    cell.mLab_title.frame = CGRectMake(9, 10, titleSize.width, cell.mLab_title.frame.size.height);
                }
                cell.mImgV_top.frame = CGRectMake(cell.mLab_title.frame.origin.x+cell.mLab_title.frame.size.width, 12, 33, 12);
                [cell.mImgV_top setImage:[UIImage imageNamed:@"classViewTopCell"]];
            }else{
                cell.mLab_title.frame = CGRectMake(9, 10, [dm getInstance].width-9*2-40, cell.mLab_title.frame.size.height);
                cell.mImgV_top.hidden = YES;
            }
            
            //详情
            cell.mBtn_detail.frame = CGRectMake([dm getInstance].width-49, 3, 40, cell.mBtn_detail.frame.size.height);
            cell.mBtn_detail.hidden = NO;
            //话题
            cell.mLab_Category0.frame = CGRectMake(30, cell.mLab_title.frame.origin.y+cell.mLab_title.frame.size.height+5, cell.mLab_Category0.frame.size.width, cell.mLab_Category0.frame.size.height);
            cell.mLab_Category0.hidden = NO;
            CGSize CategorySize = [[NSString stringWithFormat:@"%@",model.CategorySuject] sizeWithFont:[UIFont systemFontOfSize:10]];
            cell.mLab_Category1.frame = CGRectMake(30+cell.mLab_Category0.frame.size.width+2, cell.mLab_Category0.frame.origin.y, CategorySize.width, cell.mLab_Category0.frame.size.height);
            cell.mLab_Category1.text = model.CategorySuject;
            cell.mLab_Category1.hidden = NO;
            //访问
            CGSize ViewSize = [[NSString stringWithFormat:@"%@",model.ViewCount] sizeWithFont:[UIFont systemFontOfSize:10]];
            cell.mLab_ViewCount.frame = CGRectMake([dm getInstance].width-9-ViewSize.width, cell.mLab_Category0.frame.origin.y, ViewSize.width, cell.mLab_Category0.frame.size.height);
            cell.mLab_ViewCount.hidden = NO;
            cell.mLab_ViewCount.text = model.ViewCount;
            cell.mLab_View.frame = CGRectMake(cell.mLab_ViewCount.frame.origin.x-2-cell.mLab_View.frame.size.width, cell.mLab_Category0.frame.origin.y, cell.mLab_View.frame.size.width, cell.mLab_View.frame.size.height);
            cell.mLab_View.hidden = NO;
            //回答
            CGSize AnswersSize = [[NSString stringWithFormat:@"%@",model.AnswersCount] sizeWithFont:[UIFont systemFontOfSize:10]];
            cell.mLab_AnswersCount.frame = CGRectMake(cell.mLab_View.frame.origin.x-5-AnswersSize.width, cell.mLab_Category0.frame.origin.y, AnswersSize.width, cell.mLab_Category0.frame.size.height);
            cell.mLab_AnswersCount.text = model.AnswersCount;
            cell.mLab_AnswersCount.hidden = NO;
            cell.mLab_Answers.frame = CGRectMake(cell.mLab_AnswersCount.frame.origin.x-2-cell.mLab_Answers.frame.size.width, cell.mLab_Category0.frame.origin.y, cell.mLab_Answers.frame.size.width, cell.mLab_Answers.frame.size.height);
            cell.mLab_Answers.hidden = NO;
            //关注
            CGSize AttSize = [[NSString stringWithFormat:@"%@",model.AttCount] sizeWithFont:[UIFont systemFontOfSize:10]];
            cell.mLab_AttCount.frame = CGRectMake(cell.mLab_Answers.frame.origin.x-5-AttSize.width, cell.mLab_Category0.frame.origin.y, AttSize.width, cell.mLab_Category0.frame.size.height);
            cell.mLab_AttCount.text = model.AttCount;
            cell.mLab_AttCount.hidden = NO;
            cell.mLab_Att.frame = CGRectMake(cell.mLab_AttCount.frame.origin.x-2-cell.mLab_Att.frame.size.width, cell.mLab_Category0.frame.origin.y, cell.mLab_Att.frame.size.width, cell.mLab_Att.frame.size.height);
            cell.mLab_Att.hidden = NO;
            //判断是否有回答
            if ([model.answerModel.TabID integerValue]>0) {
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
                if ([model.answerModel.LikeCount integerValue]>99) {
                    strLike = @"99+";
                }
                cell.mLab_LikeCount.text = [NSString stringWithFormat:@"%@赞",strLike];
                cell.mLab_LikeCount.hidden = NO;
                //头像
                cell.mImgV_head.frame = CGRectMake(9, cell.mLab_LikeCount.frame.origin.y+22+10, 42, 42);
                [cell.mImgV_head sd_setImageWithURL:(NSURL *)[NSString stringWithFormat:@"%@%@",AccIDImg,model.answerModel.JiaoBaoHao] placeholderImage:[UIImage  imageNamed:@"root_img"]];
                cell.mImgV_head.hidden = NO;
                //姓名
                cell.mLab_IdFlag.frame = CGRectMake(9, cell.mImgV_head.frame.origin.y+42+10, 42, cell.mLab_IdFlag.frame.size.height);
                cell.mLab_IdFlag.text = model.answerModel.IdFlag;
                //回答标题
                NSString *string1 = model.answerModel.ATitle;
                string1 = [string1 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                string1 = [string1 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                NSString *name = [NSString stringWithFormat:@"<font size=14 color='#03AA03'>答 : </font> <font size=14 color=black>%@</font>",string1];
                NSMutableDictionary *row1 = [NSMutableDictionary dictionary];
                [row1 setObject:name forKey:@"text"];
                RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:[row1 objectForKey:@"text"]];
                cell.mLab_ATitle.componentsAndPlainText = componentsDS;
                cell.mLab_ATitle.frame = CGRectMake(63, cell.mLab_LikeCount.frame.origin.y+3, [dm getInstance].width-65, 23);
                //回答内容
                NSString *string2 = model.answerModel.Abstracts;
                string2 = [string2 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                string2 = [string2 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                NSString *name2 = @"";
                if ([model.answerModel.Flag integerValue]==0) {//无内容
                    name2 = [NSString stringWithFormat:@"<font size=14 color='#03AA03'>无内容</font>"];
                }else if ([model.answerModel.Flag integerValue]==1){//有内容
                    name2 = [NSString stringWithFormat:@"<font size=14 color='#03AA03'>有内容 : </font> <font>%@</font>", string2];
                }else if ([model.answerModel.Flag integerValue]==2){//有证据
                    name2 = [NSString stringWithFormat:@"<font size=14 color='red'>依据 : </font> <font>%@</font>", string2];
                }
                
                NSMutableDictionary *row2 = [NSMutableDictionary dictionary];
                [row2 setObject:name2 forKey:@"text"];
                RTLabelComponentsStructure *componentsDS2 = [RCLabel extractTextStyle:[row2 objectForKey:@"text"]];
                cell.mLab_Abstracts.componentsAndPlainText = componentsDS2;
                CGSize optimalSize2 = [cell.mLab_Abstracts optimumSize];
                if (optimalSize2.height==23) {
                    optimalSize2 = CGSizeMake(optimalSize2.width, 25);
                }else if (optimalSize2.height>20) {
                    optimalSize2 = CGSizeMake(optimalSize2.width, 35);
                }
                cell.mLab_Abstracts.frame = CGRectMake(63, cell.mImgV_head.frame.origin.y+2, [dm getInstance].width-75, optimalSize2.height);
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
                CGSize commentSize = [[NSString stringWithFormat:@"%@",model.answerModel.CCount] sizeWithFont:[UIFont systemFontOfSize:10]];
                cell.mLab_commentCount.frame = CGRectMake([dm getInstance].width-9-commentSize.width, cell.mLab_RecDate.frame.origin.y, commentSize.width, cell.mLab_commentCount.frame.size.height);
                cell.mLab_commentCount.text = model.answerModel.CCount;
                cell.mLab_comment.frame = CGRectMake(cell.mLab_commentCount.frame.origin.x-2-cell.mLab_comment.frame.size.width, cell.mLab_RecDate.frame.origin.y, cell.mLab_View.frame.size.width, cell.mLab_comment.frame.size.height);
                if (model.mInt_top ==1) {
                    cell.mLab_line2.hidden = YES;
                }else{
                    if (model.answerModel.Thumbnail.count>0) {
                        cell.mLab_line2.frame = CGRectMake(0, cell.mLab_RecDate.frame.origin.y+cell.mLab_RecDate.frame.size.height+10, [dm getInstance].width, 10);
                    }else{
                        cell.mLab_line2.frame = CGRectMake(0, cell.mLab_IdFlag.frame.origin.y+cell.mLab_IdFlag.frame.size.height+10, [dm getInstance].width, 10);
                    }
                    cell.mLab_line2.hidden = NO;
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
                if (model.mInt_top ==1) {
                    cell.mLab_line2.hidden = YES;
                }else{
                    cell.mLab_line2.hidden = NO;
                    cell.mLab_line2.frame = CGRectMake(0, cell.mLab_Category0.frame.origin.y+cell.mLab_Category0.frame.size.height+10, [dm getInstance].width, 10);
                }
            }
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
//    AllCategoryModel *allModel = [self.mArr_AllCategory objectAtIndex:self.mInt_index];
    //先判断是精选还是别的类型
    if (self.mInt_index ==2) {//精选
        if (indexPath.row==0) {
            return 130;
        }else{
            return [self cellHeightPicked:indexPath];
        }
    }else{
        NSMutableArray *array = [self arrayDataSourceSum];
        QuestionModel *model = [array objectAtIndex:indexPath.row];
        if (model.mInt_btn==1||model.mInt_btn==2) {//三个按钮,话题显示行
            return 44;
        }else{//正常显示内容
            return [self cellHeight:indexPath];
        }
    }
    
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableArray *array = [self arrayDataSourceSum];
    if (self.mInt_index ==2) {//精选
        if (indexPath.row>0) {
            PickContentModel *model = [self.mModel_getPickdById.PickContent objectAtIndex:indexPath.row-1];
        }
    }else{
        QuestionModel *model = [array objectAtIndex:indexPath.row];
        if (model.mInt_btn==2) {//话题显示行
            AllCategoryModel *allModel = [self.mArr_AllCategory objectAtIndex:self.mInt_index];
            CategoryViewController *detailVC = [[CategoryViewController alloc]initWithNibName:@"CategoryViewController" bundle:nil];
            detailVC.modalPresentationStyle = UIModalPresentationFullScreen;
            detailVC.mArr_AllCategory = [[NSMutableArray alloc]initWithCapacity:0];
            detailVC.mArr_selectCategory = [[NSMutableArray alloc]initWithCapacity:0];
            
            detailVC.classStr = @"AddQuestionViewController";
            [detailVC.mArr_AllCategory addObject:allModel];
            detailVC.ItemModel = [[ItemModel alloc]init];
            self.ItemModel = detailVC.ItemModel;
            for (UIView* next = [self superview]; next; next =
                 next.superview) {
                UIResponder* nextResponder = [next nextResponder];
                if ([nextResponder isKindOfClass:[UIViewController
                                                  class]]) {
                    UIViewController *vc = (UIViewController*)nextResponder;
                    [vc.navigationController  presentViewController:detailVC animated:YES completion:^{
                        //detailVC.view.superview.frame = CGRectMake(10, 44+30, [dm getInstance].width-20, [dm getInstance].height-84);
                        
                    }];
                }
            }
            //
        }
    }
    
}

-(float)cellHeight:(NSIndexPath *)indexPath{
    float tempF = 0.0;
    NSMutableArray *array = [self arrayDataSourceSum];
    QuestionModel *model = [array objectAtIndex:indexPath.row];
    D("dpfoigjdo;igjp-====%@",model.TabID);
    if ([model.TabID intValue]>0) {
        //标题
        tempF = tempF+10+16;
        //话题
        tempF = tempF+5+21;
        //判断是否有回答
        //    if ([model.AnswersCount integerValue]>0) {
        if ([model.answerModel.TabID integerValue]>0) {
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
                if (model.mInt_top ==1) {
                    
                }else{
                    tempF = tempF+20;
                }
            }else{
                //赞
                tempF = tempF+15+22;
                //头像
                tempF = tempF+10+42;
                //姓名
                tempF = tempF+10+21;
                if (model.mInt_top ==1) {
                    
                }else{
                    tempF = tempF+20;
                }
            }
        }else{
            if (model.mInt_top ==1) {
                
            }else{
                tempF = tempF+20;
            }
        }
    }else{
        return 0;
    }
    return tempF;
}

-(float)cellHeightPicked:(NSIndexPath *)indexPath{
    float tempF = 0.0;
    PickContentModel *model = [self.mModel_getPickdById.PickContent objectAtIndex:indexPath.row-1];
    tempF = tempF+10+16;
    NSString *string2 = model.Abstracts;
    string2 = [string2 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string2 = [string2 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    NSString *name2 = [NSString stringWithFormat:@"<font size=14 color=black>%@</font>",string2];
    
    CGSize size = [name2 sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake([dm getInstance].width-10, 1000)];
    if (size.height>20) {
        size = CGSizeMake(size.width, 32);
    }
    
    if (size.height==23) {
        size = CGSizeMake(size.width, 25);
    }else if (size.height>20) {
        size = CGSizeMake(size.width, 35);
    }
    tempF = tempF+size.height;
    //图片
    if (model.Thumbnail.count>0) {
        tempF = tempF+5+([dm getInstance].width-65-30)/3;
    }
    tempF = tempF +13;
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
        NSMutableArray *array = [self arrayDataSourceRequest];
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
    NSMutableArray *array = [self arrayDataSourceRequest];
    if (array.count>0) {
        QuestionModel *model = [array objectAtIndex:array.count-1];
        rowCount = model.rowCount;
    }
    
    if (self.mInt_index ==0) {//首页
        AllCategoryModel *model = [self.mArr_AllCategory objectAtIndex:self.mInt_index];
        [[KnowledgeHttp getInstance]UserIndexQuestionWithNumPerPage:@"10" pageNum:page RowCount:rowCount flag:model.flag];
    }else if (self.mInt_index ==1){//推荐
        [[KnowledgeHttp getInstance] RecommentIndexWithNumPerPage:@"10" pageNum:page RowCount:rowCount];
    }else if (self.mInt_index ==2){//精选
        [[KnowledgeHttp getInstance] GetPickedByIdWithTabID:@"0"];
    }else{//从服务器获取到的
        AllCategoryModel *model = [self.mArr_AllCategory objectAtIndex:self.mInt_index];
        [[KnowledgeHttp getInstance] CategoryIndexQuestionWithNumPerPage:@"10" pageNum:page RowCount:rowCount flag:model.flag uid:model.item_now.TabID];
        [[KnowledgeHttp getInstance] GetCategoryTopQWithId:model.item_now.TabID];
    }
}

//cell的点击事件---答案
-(void)KnowledgeTableViewCellAnswers:(KnowledgeTableViewCell *)knowledgeTableViewCell{
    if (self.mInt_index ==2) {//精选
        PickContentModel *model = [self.mModel_getPickdById.PickContent objectAtIndex:knowledgeTableViewCell.tag-1];
    }else{
        CommentViewController *commentVC = [[CommentViewController alloc]init];
        commentVC.questionModel = knowledgeTableViewCell.model;
        [utils pushViewController:commentVC animated:YES];
    }
}

//cell的点击事件---标题
-(void)KnowledgeTableViewCellTitleBtn:(KnowledgeTableViewCell *)knowledgeTableViewCell{
    if (self.mInt_index ==2) {//精选
        PickContentModel *model = [self.mModel_getPickdById.PickContent objectAtIndex:knowledgeTableViewCell.tag-1];
    }else{
        KnowledgeQuestionViewController *queston = [[KnowledgeQuestionViewController alloc] init];
        queston.mModel_question = knowledgeTableViewCell.model;
        [utils pushViewController:queston animated:YES];
    }
}

//cell的点击事件---详情
-(void)KnowledgeTableVIewCellDetailBtn:(KnowledgeTableViewCell *)knowledgeTableViewCell{
    if (self.mInt_index ==2) {//精选
        OldChoiceViewController *oldView = [[OldChoiceViewController alloc] init];
        [utils pushViewController:oldView animated:YES];
    }else{
        //判断是否来自推荐
        if ([knowledgeTableViewCell.model.tabid integerValue]>0) {
            KnowledgeRecommentAddAnswerViewController *recomment = [[KnowledgeRecommentAddAnswerViewController alloc] init];
            recomment.mModel_question = knowledgeTableViewCell.model;
            [utils pushViewController:recomment animated:YES];
        }else{
            KnowledgeAddAnswerViewController *detail = [[KnowledgeAddAnswerViewController alloc] init];
            detail.mModel_question = knowledgeTableViewCell.model;
            [utils pushViewController:detail animated:YES];
        }
    }
}

//全部、有依据、在讨论按钮
-(void)KnowledgeTableVIewCellAllBtn:(KnowledgeTableViewCell *) knowledgeTableViewCell{
    AllCategoryModel *model = [self.mArr_AllCategory objectAtIndex:self.mInt_index];
    if ([model.flag integerValue]!=-1) {
        [model.mArr_discuss removeAllObjects];
        [model.mArr_evidence removeAllObjects];
        [model.mArr_all removeAllObjects];
        [model.mArr_top removeAllObjects];
        model.flag = @"-1";
        [self sendRequest];
    }
    [self.mTableV_knowledge reloadData];
}
-(void)KnowledgeTableVIewCellEvidenceBtn:(KnowledgeTableViewCell *) knowledgeTableViewCell{
    AllCategoryModel *model = [self.mArr_AllCategory objectAtIndex:self.mInt_index];
    if ([model.flag integerValue]!=1) {
        [model.mArr_discuss removeAllObjects];
        [model.mArr_evidence removeAllObjects];
        [model.mArr_all removeAllObjects];
        [model.mArr_top removeAllObjects];
        model.flag = @"1";
        [self sendRequest];
    }
    [self.mTableV_knowledge reloadData];
}
-(void)KnowledgeTableVIewCellDiscussBtn:(KnowledgeTableViewCell *) knowledgeTableViewCell{
    AllCategoryModel *model = [self.mArr_AllCategory objectAtIndex:self.mInt_index];
    if ([model.flag integerValue]!=0) {
        [model.mArr_discuss removeAllObjects];
        [model.mArr_evidence removeAllObjects];
        [model.mArr_all removeAllObjects];
        [model.mArr_top removeAllObjects];
        model.flag = @"0";
        [self sendRequest];
    }
    [self.mTableV_knowledge reloadData];
}

@end
