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
#import "ChoicenessDetailViewController.h"
#import "LeaveHttp.h"
#import "NewLeaveModel.h"
#import "leaveRecordModel.h"
#import "OnlineJobHttp.h"


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
        //通知界面，更新答案数据
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updataQuestionDetailModel" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataQuestionDetailModel:) name:@"updataQuestionDetailModel" object:nil];
        //切换账号时，更新数据
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RegisterView" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RegisterView:) name:@"RegisterView" object:nil];
        //通知主页修改关注数量
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updataAddMyAttQ" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataAddMyAttQ:) name:@"updataAddMyAttQ" object:nil];

        self.mArr_AllCategory = [NSMutableArray array];
        self.mInt_index = 0;
        self.mInt_reloadData = 0;
        self.mModel_getPickdById = [[GetPickedByIdModel alloc] init];
        //有依据页面，有多少条数据被隐藏
        self.mLab_warn = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [dm getInstance].width, 20)];
        self.mLab_warn.backgroundColor = [UIColor grayColor];
        self.mLab_warn.textColor = [UIColor orangeColor];
        self.mLab_warn.font = [UIFont systemFontOfSize:12];
        self.mLab_warn.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.mLab_warn];
        self.mLab_warn.hidden = YES;
        //首页精选等
        self.mScrollV_all = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 0, [dm getInstance].width-20-40, 48)];
        
        [self init_mArr_AllCategory];
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
        //self.mTableV_knowledge.allowsSelection = NO;
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

//初始化话题数组
-(void)init_mArr_AllCategory{
    NSMutableArray *tempArray = [NSMutableArray arrayWithObjects:@"首页",@"推荐",@"精选", nil];
    for (int i=0; i<tempArray.count; i++) {
        AllCategoryModel *model = [[AllCategoryModel alloc] init];
        if (i==0) {
            model.flag = @"1";
        }
        model.item.Subject = [tempArray objectAtIndex:i];
        [self.mArr_AllCategory addObject:model];
    }
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
//    StuErrModel *model = [[StuErrModel alloc]init];
//    model.StuId = @"3851578";
//    model.IsSelf = @"1";
//    model.PageIndex = @"1";
//    model.PageSize = @"20";
//    
//    [[OnlineJobHttp getInstance]GetStuErr:model];
//    [[OnlineJobHttp getInstance]GetStuHWListPageWithStuId:@"3851578" IsSelf:@"1" PageIndex:@"1" PageSize:@"20"];
//    [[LeaveHttp getInstance]GetLeaveSettingWithUnitId:[NSString stringWithFormat:@"%d",[dm getInstance].UID]];
//    NewLeaveModel *model = [[NewLeaveModel alloc]init];
//    model.UnitId =[NSString stringWithFormat:@"%d",[dm getInstance].UID];
//    model.manId = @"3851578";
//    model.manName = @"001学生";
//    model.writerId = [dm getInstance].jiaoBaoHao;
//    model.writer = [dm getInstance].name;
//    model.unitClassId  =@"72202";
//    model.manType = @"0";
//    model.leaveType = @"病假";
//    model.leaveReason = @"感冒发烧";
//    model.sDateTime = @"2016-3-11 5:00:00";
//    model.eDateTime = @"2016-3-13 5:00:00";

    //[[LeaveHttp getInstance]NewLeaveModel:model];
//    leaveRecordModel *model = [[leaveRecordModel alloc]init];
//    model.numPerPage = @"20";
//    model.RowCount = @"0";
//    model.accId = [dm getInstance].jiaoBaoHao;
//    model.sDateTime = @"2016-3-1";
//    model.manType = @"0";
//    [[LeaveHttp getInstance]GetMyLeaves:model];
   // [[LeaveHttp getInstance]GetLeaveModel:@"4"];
    //[[LeaveHttp getInstance]GetMyStdInfo:[dm getInstance].jiaoBaoHao];
    //[[LeaveHttp getInstance]GetMyAdminClass:[dm getInstance].jiaoBaoHao];
    //[LeaveHttp getInstance]getClassStdInfoWithUID:<#(NSString *)#>
    //[LeaveHttp getInstance]getClassStdInfoWithUID:<#(NSString *)#>];
    //return;
//    [[KnowledgeHttp getInstance] GetAllCategory];
    if([[dm getInstance].jiaoBaoHao intValue]>0&&self.mArr_AllCategory.count>0){
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
    else
    {
        [MBProgressHUD showError:@"登录成功后方可操作" toView:self];
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
    if ([[dm getInstance].jiaoBaoHao intValue]>0&&self.mArr_AllCategory.count>0) {
        self.mInt_index = (int)btn.tag;
        if (self.mInt_index==2) {
            [self.mTableV_knowledge removeFooter];
        }else{
            [self.mTableV_knowledge addFooterWithTarget:self action:@selector(footerRereshing)];
            self.mTableV_knowledge.footerPullToRefreshText = @"上拉加载更多";
            self.mTableV_knowledge.footerReleaseToRefreshText = @"松开加载更多数据";
            self.mTableV_knowledge.footerRefreshingText = @"正在加载...";
        }
        for (UIButton *btn1 in self.mScrollV_all.subviews) {
            if ([btn1.class isSubclassOfClass:[UIButton class]]) {
                if ((int)btn1.tag == self.mInt_index) {
                    btn1.selected = YES;
                }else{
                    btn1.selected = NO;
                }
            }
        }
        //自动定位中心位置
        if (self.mInt_index<2) {
            [self.mScrollV_all setContentOffset:CGPointMake(0, 0) animated:YES];
        }else if (self.mInt_index>self.mArr_AllCategory.count-3) {
            [self.mScrollV_all setContentOffset:CGPointMake(self.mScrollV_all.contentSize.width-self.mScrollV_all.frame.size.width, 0) animated:YES];
        }else if (self.mInt_index<self.mArr_AllCategory.count-2) {
            [self.mScrollV_all setContentOffset:CGPointMake((self.mInt_index-2)*50, 0) animated:YES];
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
        }else{
            AllCategoryModel *model = [self.mArr_AllCategory objectAtIndex:self.mInt_index];
            model.item_now = model.item;
            [model.mArr_discuss removeAllObjects];
            [model.mArr_evidence removeAllObjects];
            [model.mArr_all removeAllObjects];
            [model.mArr_top removeAllObjects];
            [self sendRequest];
        }
        [self.mTableV_knowledge reloadData];
        
    }else{
        [MBProgressHUD showSuccess:@"登录成功后方可操作" toView:self];
    }
}

-(void)ProgressViewLoad{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    if (self.mArr_AllCategory.count<3) {
        [self init_mArr_AllCategory];
    }
    //取所有话题
    if (self.mArr_AllCategory.count==3) {
        [[KnowledgeHttp getInstance] GetAllCategory];
    }
    
    
    [self sendRequest];
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

//通知主页修改关注数量
-(void)updataAddMyAttQ:(NSNotification *)noti{
    QuestionModel *model = noti.object;
    NSMutableArray *array = [self arrayDataSourceSum];
    for (int i=0; i<array.count; i++) {
        QuestionModel *tempModel = [array objectAtIndex:i];
        if ([tempModel.TabID intValue]==[model.TabID intValue]) {
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
    }else{
        NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
        [MBProgressHUD showError:ResultDesc toView:self];
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
    }else{
        NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
        [MBProgressHUD showError:ResultDesc toView:self];
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
    }else{
        NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
        [MBProgressHUD showError:ResultDesc toView:self];
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
    }else{
        NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
        [MBProgressHUD showError:ResultDesc toView:self];
    }
    [self.mTableV_knowledge reloadData];
}

//获取所有话题
-(void)GetAllCategory:(NSNotification *)noti{
    if([dm getInstance].addQuestionNoti == NO)
    {
        [MBProgressHUD hideHUDForView:self animated:YES];
        NSMutableDictionary *dic = noti.object;
        NSString *code = [dic objectForKey:@"code"];
        if ([code integerValue] ==0) {
            //先移除，然后添加默认
//            [self.mArr_AllCategory removeAllObjects];
//            [self init_mArr_AllCategory];
            //有可能在获取到话题时，首页中的数据已经获得，所以不能清空
            if (self.mArr_AllCategory.count>3) {
                for (int i=3; i<self.mArr_AllCategory.count; i++) {
                    [self.mArr_AllCategory removeObjectAtIndex:i];
                }
            }
            NSMutableArray *array = [dic objectForKey:@"array"];
            for (int i=0; i<array.count; i++) {
                AllCategoryModel *model = [array objectAtIndex:i];
                model.flag = @"-1";
                //给一个默认的话题，暂时为二级话题中的第一个
//                if (model.mArr_subItem.count>0) {
//                    model.item_now = [model.mArr_subItem objectAtIndex:0];
//                }else{
                    model.item_now = model.item;
//                }
                
                [self.mArr_AllCategory addObject:model];
            }
            [self addScrollViewBtn:(int)array.count];
        }else{
            NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
            [MBProgressHUD showError:ResultDesc toView:self];
        }
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
    self.mInt_index = 0;
//    self.ItemModel = nil;
    self.mInt_reloadData = 0;
    [self.mArr_AllCategory removeAllObjects];
    [self.mArr_selectCategory removeAllObjects];
//    self.mModel_getPickdById = nil;
    [self.mTableV_knowledge reloadData];
}

//显示用的所有数组
-(NSMutableArray *)arrayDataSourceSum{
    if (self.mArr_AllCategory.count>self.mInt_index) {
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
//            if ([self arrayDataSourceTemp:model].count==0) {
//                [MBProgressHUD showError:@"暂无数据" toView:self];
//            }
            //话题显示行
            QuestionModel *temp1 = [[QuestionModel alloc] init];
            temp1.mInt_btn = 2;
            [model.mArr_sum insertObject:temp1 atIndex:0];
        }
        return model.mArr_sum;
    }
    return 0;
}

//申请数据时用到的当前数组
-(NSMutableArray *)arrayDataSourceRequest{
    AllCategoryModel *model = [self.mArr_AllCategory objectAtIndex:self.mInt_index];
    if (self.mInt_index == 1) {
        return model.mArr_all;
    }
//    回答标志,1求真回答，0普通回答，-1取全部
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
    return model.mArr_all;
}

//设置按钮样式
-(void)setValueForBtn:(UIButton *)btn1 btn2:(UIButton *)btn2 btn3:(UIButton *)btn3{
    [btn1 setTitleColor:[UIColor colorWithRed:3/255.0 green:170/255.0 blue:54/255.0 alpha:1] forState:UIControlStateNormal];
    [btn1.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [btn1.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [btn1.layer setBorderWidth:1.0]; //边框宽度
    CGColorRef colorref = [UIColor colorWithRed:3/255.0 green:170/255.0 blue:54/255.0 alpha:1].CGColor;
    [btn1.layer setBorderColor:colorref];//边框颜色
    
    [btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn2.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [btn2.layer setBorderWidth:0]; //边框宽度
    
    [btn3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn3.layer setMasksToBounds:YES];
    [btn3.layer setBorderWidth:0]; //边框宽度
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.mInt_index ==2) {//精选
        self.mTableV_knowledge.frame = CGRectMake(0, 48, [dm getInstance].width, self.frame.size.height-48);
        self.mLab_warn.hidden = YES;
        if ([self.mModel_getPickdById.TabID integerValue]>0) {
            return self.mModel_getPickdById.PickContent.count+1;
        }
    }else{
        NSMutableArray *array = [self arrayDataSourceSum];
        self.mLab_warn.hidden = YES;
        //先确认是有证据
        D("usdfhgdljgfflk-===%lu,%d",(unsigned long)self.mArr_AllCategory.count,self.mInt_index);
        if (self.mArr_AllCategory.count>self.mInt_index) {
            AllCategoryModel *model = [self.mArr_AllCategory objectAtIndex:self.mInt_index];
            if ([model.flag intValue]==1) {
                //计算是否有答案被删除的
                
                int m=0;
                for (int i=0; i<array.count; i++) {
                    QuestionModel *model = [array objectAtIndex:i];
                    if (model.mInt_btn==1||model.mInt_btn==2) {//三个按钮,话题显示行
                        
                    }else if ([model.answerModel.TabID intValue]==0) {//正常显示内容
                        m++;
                    }
                }
                if (m>0) {
                    self.mTableV_knowledge.frame = CGRectMake(0, 48, [dm getInstance].width, self.frame.size.height-48-20);
                    self.mLab_warn.hidden = NO;
                    self.mLab_warn.frame = CGRectMake(0, self.frame.size.height-20, [dm getInstance].width, 20);
                    self.mLab_warn.text = [NSString stringWithFormat:@"有%d条问题因答案被屏蔽或删除无法查看",m];
                }else{
                    self.mTableV_knowledge.frame = CGRectMake(0, 48, [dm getInstance].width, self.frame.size.height-48);
                    self.mLab_warn.hidden = YES;
                }
            }else{
                self.mTableV_knowledge.frame = CGRectMake(0, 48, [dm getInstance].width, self.frame.size.height-48);
                self.mLab_warn.hidden = YES;
            }
        }
        
        return array.count;
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
    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //先判断是精选还是别的类型
    if (self.mInt_index ==2) {//精选
        for (UIView *temp in cell.subviews) {
            temp.hidden = NO;
        }
        cell.delegate = self;
        cell.backgroundColor = [UIColor whiteColor];
        cell.mImgV_top.hidden = YES;
        cell.basisImagV.hidden = YES;
        cell.answerImgV.hidden = YES;
        if (indexPath.row==0) {
            cell.LikeBtn.hidden = YES;
            cell.mLab_title.hidden = NO;

            cell.askImgV.hidden = NO;
            NSString *string1 = self.mModel_getPickdById.PTitle;
            string1 = [string1 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            string1 = [string1 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            cell.askImgV.frame = CGRectZero;
            NSString *name = [NSString stringWithFormat:@"<font size=14 color=black>%@</font>",string1];
            NSMutableDictionary *row1 = [NSMutableDictionary dictionary];
            [row1 setObject:name forKey:@"text"];
            cell.mLab_title.lineBreakMode = RTTextLineBreakModeTruncatingTail;
            RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:[row1 objectForKey:@"text"]];
            cell.mLab_title.componentsAndPlainText = componentsDS;
//            CGSize optimalSize2 = [cell.mLab_title optimumSize];
            CGSize titleSize2 = [[NSString stringWithFormat:@" %@",self.mModel_getPickdById.PTitle] sizeWithFont:[UIFont systemFontOfSize:14]];
            if (titleSize2.width>[dm getInstance].width-(5+cell.askImgV.frame.size.width)-70) {
                titleSize2.width = [dm getInstance].width-(5+cell.askImgV.frame.size.width)-70;
            }
            
            cell.mLab_title.frame = CGRectMake(5+cell.askImgV.frame.size.width, 10, titleSize2.width, 23);
//            cell.mLab_title.frame = CGRectMake(9, 10, titleSize2.width, cell.mLab_title.frame.size.height);
//            cell.mLab_title.text = self.mModel_getPickdById.PTitle;
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
            cell.mLab_RecDate.hidden = YES;
            cell.mLab_RecDate.frame = CGRectMake(cell.mLab_title.frame.origin.x+cell.mLab_title.frame.size.width+5, 10, cell.mLab_RecDate.frame.size.width, cell.mLab_RecDate.frame.size.height);
            cell.mLab_RecDate.text = self.mModel_getPickdById.RecDate;
            //按钮
            cell.mBtn_detail.hidden = NO;
            [cell.mBtn_detail setTitle:@"往期精选" forState:UIControlStateNormal];
            cell.mBtn_detail.frame = CGRectMake([dm getInstance].width-56-10, 0, 56, cell.mBtn_detail.frame.size.height);
            cell.mScrollV_pic.hidden = NO;
//            cell.mScrollV_pic.frame = CGRectMake(0, 30, [dm getInstance].width, 100);
//            cell.mScrollV_pic.backgroundColor = [UIColor clearColor];
//            CGFloat width = [UIScreen mainScreen].bounds.size.width;
            NSMutableArray *tempA = [NSMutableArray array];
            for (int i=0; i<self.mModel_getPickdById.ImgContent.count; i++) {
                NSString *tempUrl = [NSString stringWithFormat:@"%@%@%@",MAINURL,self.mModel_getPickdById.baseImgUrl,[self.mModel_getPickdById.ImgContent objectAtIndex:i]];
                [tempA addObject:tempUrl];
            }
            
            //    是否需要支持定时循环滚动，默认为YES
//            if (tempA.count>1) {
//                cell.mScrollV_pic.isNeedCycleRoll = YES;
//                cell.mScrollV_pic.pageControl.hidden = NO;
//            }else{
//                cell.mScrollV_pic.isNeedCycleRoll = NO;
//                cell.mScrollV_pic.pageControl.hidden = YES;
//            }
            if (tempA.count>0) {
                cell.mScrollV_pic.isNeedCycleRoll = YES;
                cell.mScrollV_pic.pageControl.hidden = NO;
                [cell.mScrollV_pic setImageLinkURL:tempA];
            }else{
                cell.mScrollV_pic.isNeedCycleRoll = NO;
                [cell.mScrollV_pic setImageLinkURL:nil];
                cell.mScrollV_pic.pageControl.hidden = YES;
            }
            cell.mScrollV_pic.pageControl.hidden = NO;
            cell.mScrollV_pic.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
            cell.mScrollV_pic.pageControl.pageIndicatorTintColor = [UIColor grayColor];
            [cell.mScrollV_pic setImageLinkURL:tempA];
            [cell.mScrollV_pic setPlaceHoldImage:[UIImage imageNamed:@"root_img"]];
            [cell.mScrollV_pic setPageControlShowStyle:UIPageControlShowStyleLeft];
            cell.mScrollV_pic.frame = CGRectMake(0, 30, [dm getInstance].width, 120);
            //图片被点击后回调的方法
//            self.adView.callBack = ^(NSInteger index,NSString * imageURL)
//            {
//                
//            };
            
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
            return cell;
        }else{
            PickContentModel *model = [self.mModel_getPickdById.PickContent objectAtIndex:indexPath.row-1];
            cell.LikeBtn.hidden = YES;
            cell.askImgV.hidden = NO;
            cell.mLab_title.hidden = NO;
//            cell.mLab_title.frame = CGRectMake(9, 10, [dm getInstance].width-9*2-40, cell.mLab_title.frame.size.height);
//            cell.mLab_title.text = model.Title;
            cell.askImgV.frame = CGRectMake(9, 10, 19, 19);
            NSString *string1 = model.Title;
            string1 = [string1 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            string1 = [string1 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            NSString *name = [NSString stringWithFormat:@"<font size=14 color=#2589D1>%@</font>",string1];
            NSMutableDictionary *row1 = [NSMutableDictionary dictionary];
            [row1 setObject:name forKey:@"text"];
            cell.mLab_title.lineBreakMode = RTTextLineBreakModeTruncatingTail;
            RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:[row1 objectForKey:@"text"]];
            cell.mLab_title.componentsAndPlainText = componentsDS;
            cell.mLab_title.frame = CGRectMake(cell.askImgV.frame.origin.x+cell.askImgV.frame.size.width, cell.askImgV.frame.origin.y+2, [dm getInstance].width-9*2-cell.askImgV.frame.size.width-10, 23);
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
            //分页
            cell.pagControl.hidden = YES;
            cell.mInt_flag = 3;
            cell.pickContentModel = model;
            cell.tag = indexPath.row;
            NSString *string2 = model.Abstracts;
            if (string2.length==0) {
                cell.mLab_Abstracts.hidden = YES;
                cell.mView_background.hidden = YES;
                cell.mView_background.frame = cell.mLab_title.frame;
            }else{
                string2 = [string2 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                string2 = [string2 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                CGSize nameSize = [string2 sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake([dm getInstance].width-10, MAXFLOAT)];
//                NSString *name2 = [NSString stringWithFormat:@"<font size=14 color=black>%@</font>",string2];
                cell.mLab_Abstracts.hidden = YES;
                cell.mLab_AttCount.hidden = NO;
//                NSMutableDictionary *row2 = [NSMutableDictionary dictionary];
//                [row2 setObject:name2 forKey:@"text"];
//                RTLabelComponentsStructure *componentsDS2 = [RCLabel extractTextStyle:[row2 objectForKey:@"text"]];
//                cell.mLab_Abstracts.componentsAndPlainText = componentsDS2;
//                CGSize optimalSize2 = [cell.mLab_Abstracts optimumSize];
                cell.mLab_AttCount.text = string2;
                cell.mLab_AttCount.font = [UIFont systemFontOfSize:14];
                cell.mLab_AttCount.numberOfLines = 0;
                cell.mLab_AttCount.frame = CGRectMake(5, cell.mLab_title.frame.origin.y+cell.mLab_title.frame.size.height+7, [dm getInstance].width-10, nameSize.height);
                cell.mView_background.hidden = NO;
                cell.mView_background.frame = CGRectMake(cell.mLab_AttCount.frame.origin.x-2, cell.mLab_AttCount.frame.origin.y-4, [dm getInstance].width-6, cell.mLab_AttCount.frame.size.height+8);
            }
            
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
                cell.mCollectionV_pic.frame = CGRectMake(10, cell.mView_background.frame.origin.y+cell.mView_background.frame.size.height+5, [dm getInstance].width-65, ([dm getInstance].width-65-30)/3);
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
            return cell;
        }
    }else{
        NSMutableArray *array = [self arrayDataSourceSum];
//        D("iahrgiuaehli-===%lu,%ld",(unsigned long)array.count,(long)indexPath.row);
        QuestionModel *model = [array objectAtIndex:indexPath.row];
//        D("sdjhfaslkdfhalke;sjfa;lkj;-===%@,%@",model.TabID,model.tabid);
        cell.model = model;
        cell.mInt_flag = 0;
        [cell.mBtn_detail setTitle:@"详情" forState:UIControlStateNormal];
        cell.tag = indexPath.row;
        //当有的cell中的TableID为null时，显示问题
        if (model.mInt_btn==1||model.mInt_btn==2) {
            for (UIView *temp in cell.subviews) {
                temp.hidden = NO;
            }
        }else{
            if ([model.TabID intValue]>0) {
                AllCategoryModel *allModel = [self.mArr_AllCategory objectAtIndex:self.mInt_index];
                if ([allModel.flag integerValue]==1&&[model.answerModel.TabID intValue]==0) {
                    for (UIView *temp in cell.subviews) {
                        temp.hidden = YES;
                    }
                    return cell;
                }
                for (UIView *temp in cell.subviews) {
                    temp.hidden = NO;
                }
            }else{
                for (UIView *temp in cell.subviews) {
                    temp.hidden = YES;
                }
                return cell;
            }
        }
        
        //添加点击事件
        cell.delegate = self;
        [cell addTapClick];
        cell.mScrollV_pic.hidden = YES;
        //分页
        cell.pagControl.hidden = YES;
        //判断显示内容
        if (model.mInt_btn==1) {//三个按钮
            cell.askImgV.hidden = YES;
            cell.answerImgV.hidden = YES;
            cell.basisImagV.hidden = YES;
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
                [self setValueForBtn:cell.mBtn_all btn2:cell.mBtn_evidence btn3:cell.mBtn_discuss];
            }else if ([allModel.flag integerValue]==0){
                [self setValueForBtn:cell.mBtn_discuss btn2:cell.mBtn_evidence btn3:cell.mBtn_all];
            }else if ([allModel.flag integerValue]==1){
                [self setValueForBtn:cell.mBtn_evidence btn2:cell.mBtn_all btn3:cell.mBtn_discuss];
            }
        }else if (model.mInt_btn ==2){//当前的话题id
            cell.backgroundColor = [UIColor whiteColor];
            cell.basisImagV.hidden = YES;
            cell.askImgV.hidden = YES;
            cell.answerImgV.hidden = YES;
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
            cell.basisImagV.hidden = NO;
            cell.askImgV.hidden = NO;
            cell.answerImgV.hidden = NO;
            //标题
//            NSString *title1 = [model.Title stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//            title1 = [title1 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//            cell.mLab_title.text = title1;
            cell.mLab_title.hidden = NO;
//            CGSize titleSize = [[NSString stringWithFormat:@"%@",title1] sizeWithFont:[UIFont systemFontOfSize:14]];
            cell.askImgV.image = [UIImage imageNamed:@"ask"];
            cell.askImgV.frame = CGRectMake(9, 10, 19, 19);
            NSString *string1 = model.Title;
            string1 = [string1 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            string1 = [string1 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            NSString *name = [NSString stringWithFormat:@"<font size=14 color=#2589D1 >%@</font>",string1];
            NSMutableDictionary *row1 = [NSMutableDictionary dictionary];
            [row1 setObject:name forKey:@"text"];
            cell.mLab_title.textAlignment = RTTextAlignmentLeft;
            cell.mLab_title.lineBreakMode = RTTextLineBreakModeTruncatingTail;
            RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:[row1 objectForKey:@"text"]];
            cell.mLab_title.componentsAndPlainText = componentsDS;
            //cell.mLab_title.frame = CGRectMake(9, 10, [dm getInstance].width-9*2-40, 50);
//            CGSize titleSize = [cell.mLab_title optimumSize];
            CGSize titleSize = [[NSString stringWithFormat:@" %@",string1] sizeWithFont:[UIFont systemFontOfSize:14]];
            //判断是否为置顶数据
            if (model.mInt_top ==1) {//置顶
                cell.mImgV_top.hidden = NO;
                D("titleSize-======%f",titleSize.width);
                if (titleSize.width>[dm getInstance].width-9*2-40-33-cell.askImgV.frame.size.width) {
                    cell.mLab_title.frame = CGRectMake(cell.askImgV.frame.origin.x+cell.askImgV.frame.size.width, cell.askImgV.frame.origin.y, [dm getInstance].width-9*2-40-33- cell.answerImgV.frame.size.width, 25);
                }else{
                    cell.mLab_title.frame = CGRectMake(cell.askImgV.frame.origin.x+cell.askImgV.frame.size.width, 10, titleSize.width, cell.mLab_title.frame.size.height);
                }
                cell.mImgV_top.frame = CGRectMake(cell.mLab_title.frame.origin.x+cell.mLab_title.frame.size.width+5, 12, 33, 12);
                [cell.mImgV_top setImage:[UIImage imageNamed:@"classViewTopCell"]];
            }else{
//                if (titleSize.width>[dm getInstance].width-9*2-40-33) {
                cell.mLab_title.frame = CGRectMake(cell.askImgV.frame.origin.x+cell.askImgV.frame.size.width, cell.askImgV.frame.origin.y, [dm getInstance].width-9*2-40- cell.answerImgV.frame.size.width, 25);//                }else{
//                    cell.mLab_title.frame = CGRectMake(9, 10, titleSize.width, cell.mLab_title.frame.size.height);
//                }
                cell.mImgV_top.hidden = YES;
            }
            
            //详情
            cell.mBtn_detail.frame = CGRectMake([dm getInstance].width-49, 3, 40, cell.mBtn_detail.frame.size.height);
            [cell.mBtn_detail setTitleColor:[UIColor colorWithRed:230/255.0 green:114/255.0 blue:21/255.0 alpha:1] forState:UIControlStateNormal ];
            cell.mBtn_detail.hidden = NO;
            //话题
            cell.mLab_Category0.frame = CGRectMake(30, cell.mLab_title.frame.origin.y+cell.mLab_title.frame.size.height, cell.mLab_Category0.frame.size.width, cell.mLab_Category0.frame.size.height);
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
            cell.mLab_AttCount.font = [UIFont systemFontOfSize:10];
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
                cell.mLab_LikeCount.frame = CGRectMake(9, cell.mLab_line.frame.origin.y+15, 42, 16);
                NSString *strLike = model.answerModel.LikeCount;
                if ([model.answerModel.LikeCount integerValue]>99) {
                    strLike = @"99+";
                }
                cell.mLab_LikeCount.text = [NSString stringWithFormat:@"%@赞",strLike];

                cell.mLab_LikeCount.hidden = NO;
                //头像
                cell.mImgV_head.frame = CGRectMake(9, cell.mLab_LikeCount.frame.origin.y+16+10, 42, 42);
                [cell.mImgV_head sd_setImageWithURL:(NSURL *)[NSString stringWithFormat:@"%@%@",AccIDImg,model.answerModel.JiaoBaoHao] placeholderImage:[UIImage  imageNamed:@"root_img"]];

//                D("dsrgijodfpgj'p-=====%@",model.answerModel.JiaoBaoHao);
//                D("dsrgijodfpgj'p-222=====%@",[NSString stringWithFormat:@"%@%@",AccIDImg,model.answerModel.JiaoBaoHao]);
                cell.mImgV_head.hidden = NO;
                //姓名
                CGSize nameSize = [model.answerModel.IdFlag sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(42, MAXFLOAT)];
                if (nameSize.height>20) {
                    nameSize = CGSizeMake(nameSize.width, 35);
                    cell.mLab_IdFlag.numberOfLines = 2;
                }else{
                    cell.mLab_IdFlag.numberOfLines = 1;
                }
                cell.mLab_IdFlag.frame = CGRectMake(9, cell.mImgV_head.frame.origin.y+42+10, 42, nameSize.height);
                cell.mLab_IdFlag.text = model.answerModel.IdFlag;
                //回答标题
                NSString *string1 = model.answerModel.ATitle;
                string1 = [string1 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                string1 = [string1 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                cell.answerImgV.frame = CGRectMake(60, cell.mLab_LikeCount.frame.origin.y, 26, 16);
                NSString *name = [NSString stringWithFormat:@"<font size=12 color=black>%@</font>",string1];
                NSMutableDictionary *row1 = [NSMutableDictionary dictionary];
                [row1 setObject:name forKey:@"text"];
                cell.mLab_ATitle.lineBreakMode = RTTextLineBreakModeTruncatingTail;
                RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:[row1 objectForKey:@"text"]];
                cell.mLab_ATitle.componentsAndPlainText = componentsDS;
                cell.mLab_ATitle.frame = CGRectMake(60+cell.answerImgV.frame.size.width+5, cell.mLab_LikeCount.frame.origin.y+2, [dm getInstance].width-9-10-cell.answerImgV.frame.size.width-cell.answerImgV.frame.origin.x, 23);
                //回答内容
                NSString *string2 = model.answerModel.Abstracts;
                string2 = [string2 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                string2 = [string2 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                NSString *name2 = @"";
                if ([model.answerModel.Flag integerValue]==0) {//无内容
                    cell.mView_background.hidden = YES;
                    cell.basisImagV.image = [UIImage imageNamed:@"noContent"];
                    cell.basisImagV.frame = CGRectMake(cell.mImgV_head.frame.origin.x+cell.mImgV_head.frame.size.width+10, cell.mImgV_head.frame.origin.y, 36, 16);
                    cell.basisImagV.hidden = NO;
                    //cell.answerImgV.hidden = YES;
                    //name2 = [NSString stringWithFormat:@"<font size=12 color='#03AA03'>无内容</font>"];
                }else if ([model.answerModel.Flag integerValue]==1){//有内容
                    cell.mView_background.hidden = YES;
                    //cell.mView_background.frame = cell.mImgV_head.frame;
                    cell.basisImagV.image = [UIImage imageNamed:@"content"];
                    cell.basisImagV.frame = CGRectMake(cell.mImgV_head.frame.origin.x+cell.mImgV_head.frame.size.width+10, cell.mImgV_head.frame.origin.y, 26, 16);
                    name2 = [NSString stringWithFormat:@"<font ont size=12 color=black>%@</font>", string2];
                }else if ([model.answerModel.Flag integerValue]==2){//有证据
                    cell.basisImagV.image = [UIImage imageNamed:@"basis"];
                    cell.basisImagV.frame = CGRectMake(cell.mImgV_head.frame.origin.x+cell.mImgV_head.frame.size.width+10, cell.mImgV_head.frame.origin.y, 29, 29);
                    if (model.answerModel.Thumbnail.count==0&&string2.length==0) {
                        string2 = @"此答案已被修改";
                    }
                    name2 = [NSString stringWithFormat:@"<font size=12 color='#E67215'>%@</font>", string2];
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
                

                cell.mLab_Abstracts.frame = CGRectMake(cell.basisImagV.frame.origin.x+cell.basisImagV.frame.size.width, cell.basisImagV.frame.origin.y+5, [dm getInstance].width-9- cell.basisImagV.frame.origin.x-cell.basisImagV.frame.size.width, optimalSize2.height);
                cell.mLab_Abstracts.textAlignment = RTTextAlignmentLeft;
                //背景色
//                cell.mView_background.frame = CGRectMake(cell.basisImagV.frame.origin.x, cell.basisImagV.frame.origin.y, [dm getInstance].width-9- cell.basisImagV.frame.origin.x, 39+3);
                cell.mView_background.frame = CGRectMake(cell.basisImagV.frame.origin.x, cell.basisImagV.frame.origin.y, [dm getInstance].width-9- cell.basisImagV.frame.origin.x, 39+3);
                //图片
                [cell.mCollectionV_pic reloadData];
                cell.mCollectionV_pic.backgroundColor = [UIColor clearColor];
                if (model.answerModel.Thumbnail.count>0) {
                    cell.mCollectionV_pic.frame = CGRectMake(63, cell.mView_background.frame.origin.y+cell.mView_background.frame.size.height+5, [dm getInstance].width-65, ([dm getInstance].width-65-30)/3);
                }else{
                    cell.mCollectionV_pic.frame = cell.mView_background.frame;
                }
                //时间
                if (model.answerModel.Thumbnail.count>0)
                {
                    cell.mLab_RecDate.frame = CGRectMake(cell.mLab_ATitle.frame.origin.x, cell.mCollectionV_pic.frame.origin.y +cell.mCollectionV_pic.frame.size.height, cell.mLab_RecDate.frame.size.width, cell.mLab_RecDate.frame.size.height);
                    
                }
                else
                {
                    cell.mLab_RecDate.frame = CGRectMake(cell.mLab_ATitle.frame.origin.x, cell.mLab_IdFlag.frame.origin.y, cell.mLab_RecDate.frame.size.width, cell.mLab_RecDate.frame.size.height);
                }

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
                cell.basisImagV.hidden = YES;
                cell.answerImgV.hidden = YES;
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
            return 150;
        }else{
            return [self cellHeightPicked:indexPath];
        }
    }else{
        NSMutableArray *array = [self arrayDataSourceSum];
        QuestionModel *model = [array objectAtIndex:indexPath.row];
        if (model.mInt_btn==1||model.mInt_btn==2) {//三个按钮,话题显示行
            return 44;
        }else{//正常显示内容
            if ([model.TabID intValue]>0) {
                AllCategoryModel *allModel = [self.mArr_AllCategory objectAtIndex:self.mInt_index];
                if ([allModel.flag integerValue]==1&&[model.answerModel.TabID intValue]==0) {
                    return 0;
                }
            }
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
            ChoicenessDetailViewController *detail = [[ChoicenessDetailViewController alloc]init];
            detail.pickContentModel = model;
            [utils pushViewController:detail animated:YES];
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
    
    //提问
    tempF = tempF+10+19;
    //话题
    tempF = tempF+21;
    //判断是否有回答
    if ([model.answerModel.TabID integerValue]>0) {
        //是否有图片
        if (model.answerModel.Thumbnail.count>0) {
            //分割线
            tempF = tempF+5;
            //回答标题
            //            tempF = tempF+15+23;
            //和头像的y值齐平
            tempF = tempF+15+16+10;
            //回答内容
            //背景色
            tempF = tempF+39+3;
            //图片
            tempF = tempF + 5+([dm getInstance].width-65-30)/3+10;
            //时间
            tempF =tempF+21;
        }else{
            //分割线
            tempF = tempF+5;
            //赞
            tempF = tempF+15+16;
            //头像
            tempF = tempF+10+42;
            //姓名
            CGSize nameSize = [model.answerModel.IdFlag sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(42, MAXFLOAT)];
            if (nameSize.height>20) {
                nameSize = CGSizeMake(nameSize.width, 35);
            }
            tempF =tempF+10+nameSize.height;
            tempF =tempF+10;
        }
    }else{
        tempF = tempF+10;
    }
    tempF =tempF+10+5;
    return tempF;
}


-(float)cellHeightPicked:(NSIndexPath *)indexPath{
    float tempF = 0.0;
    PickContentModel *model = [self.mModel_getPickdById.PickContent objectAtIndex:indexPath.row-1];
    //标题
    tempF = tempF+10+2+23;
    //简介
    NSString *string2 = model.Abstracts;
    if (string2.length==0) {
        
    }else{
        string2 = [string2 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        string2 = [string2 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        CGSize size = [string2 sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake([dm getInstance].width-10, MAXFLOAT)];
        tempF = tempF+7+size.height+4;
    }
    
    //图片
    if (model.Thumbnail.count>0) {
        tempF = tempF+5+([dm getInstance].width-65-30)/3;
    }else{
        
    }
    //分割线
    tempF = tempF+6;
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
        }else if(array.count==0){
            page = @"1";
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
        [[KnowledgeHttp getInstance] GetPickedByIdWithTabID:@"0" flag:@"0"];
    }else{//从服务器获取到的
        AllCategoryModel *model = [self.mArr_AllCategory objectAtIndex:self.mInt_index];
        [[KnowledgeHttp getInstance] CategoryIndexQuestionWithNumPerPage:@"10" pageNum:page RowCount:rowCount flag:model.flag uid:model.item_now.TabID];
        [[KnowledgeHttp getInstance] GetCategoryTopQWithId:model.item_now.TabID];
    }
}

//通知界面，更新答案数据
-(void)updataQuestionDetailModel:(NSNotification *)noti{
    [self headerRereshing];
}

//cell的点击事件---答案
-(void)KnowledgeTableViewCellAnswers:(KnowledgeTableViewCell *)knowledgeTableViewCell{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    if (self.mInt_index ==2) {//精选
        if ([knowledgeTableViewCell.pickContentModel.TabID intValue]>0) {
            PickContentModel *model = knowledgeTableViewCell.pickContentModel;
            ChoicenessDetailViewController *detail = [[ChoicenessDetailViewController alloc]init];
            detail.pickContentModel = model;
            [utils pushViewController:detail animated:YES];
        }
    }else{
        CommentViewController *commentVC = [[CommentViewController alloc]init];
        commentVC.questionModel = knowledgeTableViewCell.model;
        commentVC.topButtonTag = self.mInt_index;
        commentVC.flag = YES;
        [utils pushViewController:commentVC animated:YES];
    }
}

//cell的点击事件---标题
-(void)KnowledgeTableViewCellTitleBtn:(KnowledgeTableViewCell *)knowledgeTableViewCell{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    if (self.mInt_index ==2) {//精选
        if ([knowledgeTableViewCell.pickContentModel.TabID intValue]>0) {
            ChoicenessDetailViewController *detail = [[ChoicenessDetailViewController alloc]init];
            detail.pickContentModel = knowledgeTableViewCell.pickContentModel;
            [utils pushViewController:detail animated:YES];
        }
    }else{
        //判断是否来自推荐
        if ([knowledgeTableViewCell.model.tabid integerValue]>0) {//推荐
            KnowledgeRecommentAddAnswerViewController *recomment = [[KnowledgeRecommentAddAnswerViewController alloc] init];
            recomment.mModel_question = knowledgeTableViewCell.model;
            [utils pushViewController:recomment animated:YES];
        }else{//普通
            KnowledgeQuestionViewController *queston = [[KnowledgeQuestionViewController alloc] init];
            queston.mModel_question = knowledgeTableViewCell.model;
            [utils pushViewController:queston animated:YES];
        }
    }
}

//cell的点击事件---详情
-(void)KnowledgeTableVIewCellDetailBtn:(KnowledgeTableViewCell *)knowledgeTableViewCell{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
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
            detail.mInt_view = 0;
            detail.mModel_question = knowledgeTableViewCell.model;
            [utils pushViewController:detail animated:YES];
        }
    }
}

//全部、有依据、在讨论按钮
-(void)KnowledgeTableVIewCellAllBtn:(KnowledgeTableViewCell *) knowledgeTableViewCell{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
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
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
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
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
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
