//
//  ParentSearchViewController.m
//  JiaoBao
//
//  Created by Zqw on 15/11/2.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "ParentSearchViewController.h"
#import "OnlineJobHttp.h"
#import "StuInfoModel.h"
#import "DetailHWViewController.h"

@interface ParentSearchViewController ()

@end

@implementation ParentSearchViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //获取到学生id
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getGenInfoWithAccID" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getGenInfoWithAccID:) name:@"getGenInfoWithAccID" object:nil];
    //获取某学生各科作业完成情况
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetCompleteStatusHW" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetCompleteStatusHW:) name:@"GetCompleteStatusHW" object:nil];
    //学生获取当前作业列表
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetStuHWList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetStuHWList:) name:@"GetStuHWList" object:nil];
    //获取某学生学力值
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetStuEduLevel" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetStuEduLevel:) name:@"GetStuEduLevel" object:nil];
    
    self.mArr_nowHomework = [NSMutableArray array];
    self.mArr_overHomework = [NSMutableArray array];
    self.mArr_score = [NSMutableArray array];
    self.mArr_parent = [NSMutableArray array];
    self.mArr_disScore = [NSMutableArray array];
    self.mArr_practice = [NSMutableArray array];
    
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"家长查询"];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    
    //学生选择
    self.mLab_select.frame = CGRectMake(20, self.mNav_navgationBar.frame.size.height+10, self.mLab_select.frame.size.width, self.mLab_select.frame.size.height);
    self.mBtn_select.frame = CGRectMake(20+self.mLab_select.frame.size.width, self.mLab_select.frame.origin.y, self.mBtn_select.frame.size.width, self.mBtn_select.frame.size.height+5);
    [self.mBtn_select.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.mBtn_select.layer setBorderWidth:1];
    [self.mBtn_select.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    self.mTableV_name = [[TableViewWithBlock alloc]initWithFrame:CGRectMake(self.mBtn_select.frame.origin.x, self.mBtn_select.frame.origin.y+self.mBtn_select.frame.size.height, self.mBtn_select.frame.size.width, 0)];
    
    //三种状态
    NSMutableArray *temp = [NSMutableArray array];
    for (int i=0; i<5; i++) {
        ButtonViewModel *model = [[ButtonViewModel alloc] init];
        if (i==0) {
            model.mStr_title = @"当前作业";
            model.mStr_img = @"buttonView21";
            model.mStr_imgNow = @"buttonView11";
        }else if (i==1){
            model.mStr_title = @"完成情况";
            model.mStr_img = @"buttonView22";
            model.mStr_imgNow = @"buttonView12";
        }else if (i==2){
            model.mStr_title = @"学历查询";
            model.mStr_img = @"buttonView23";
            model.mStr_imgNow = @"buttonView13";
        }else if (i==3){
            model.mStr_title = @"练习查询";
            model.mStr_img = @"buttonView24";
            model.mStr_imgNow = @"buttonView14";
        }else if (i==4){
            model.mStr_title = @"错题本";
            model.mStr_img = @"buttonView24";
            model.mStr_imgNow = @"buttonView14";
        }
        
        [temp addObject:model];
    }
    self.mScrollV_all = [[ButtonView alloc] initFrame:CGRectMake(0, self.mLab_select.frame.origin.y+self.mLab_select.frame.size.height+10, [dm getInstance].width, 48) Array:temp Flag:1 index:0];
    self.mScrollV_all.delegate = self;
//    self.mScrollV_all = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.mLab_select.frame.origin.y+self.mLab_select.frame.size.height, [dm getInstance].width, 48)];
//    int tempWidth = [dm getInstance].width/3;
//    for (int i=0; i<3; i++) {
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setFrame:CGRectMake(tempWidth*i, 1, tempWidth, 47)];
//        [btn setTag:i];
//        if (i==0) {
//            btn.selected = YES;
//            self.mInt_index = 0;
//            [btn setTitle:@"当前作业" forState:UIControlStateNormal];
//        }else if (i==1){
//            [btn setTitle:@"作业完成情况" forState:UIControlStateNormal];
//        }else if (i==2){
//            [btn setTitle:@"学力" forState:UIControlStateNormal];
//        }
//        [btn setBackgroundColor:[UIColor colorWithRed:247/255.0 green:246/255.0 blue:246/255.0 alpha:1]];
//        btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
//        
//        [btn setTitleColor:[UIColor colorWithRed:3/255.0 green:170/255.0 blue:54/255.0 alpha:1] forState:UIControlStateSelected];
//        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//        [btn setBackgroundImage:[UIImage imageNamed:@"topBtnSelect0"] forState:UIControlStateSelected];
//        [btn addTarget:self action:@selector(selectScrollButton:) forControlEvents:UIControlEventTouchUpInside];
//        [self.mScrollV_all addSubview:btn];
//    }
//    self.mScrollV_all.contentSize = CGSizeMake(tempWidth*3, 48);
    [self.view addSubview:self.mScrollV_all];
    
    self.mView_head = [[ParentSearchHeadView alloc] initFrame1];
    //
    self.mTableV_list.frame = CGRectMake(0, self.mScrollV_all.frame.size.height+self.mScrollV_all.frame.origin.y-[dm getInstance].statusBar, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height-self.mLab_select.frame.size.height-20-self.mScrollV_all.frame.size.height+[dm getInstance].statusBar);
    self.mTableV_list.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.mTableV_list addHeaderWithTarget:self action:@selector(headerRereshing)];
    self.mTableV_list.headerPullToRefreshText = @"下拉刷新";
    self.mTableV_list.headerReleaseToRefreshText = @"松开后刷新";
    self.mTableV_list.headerRefreshingText = @"正在刷新...";
//    self.mTableV_list.tableHeaderView = self.mView_head;
    //根据角色信息，获取学生id信息
    for (int i=0; i<[dm getInstance].identity.count; i++) {
        Identity_model *idenModel = [[dm getInstance].identity objectAtIndex:i];
        if ([idenModel.RoleIdentity intValue]==3) {
            for (int m=0; m<idenModel.UserClasses.count; m++) {
                Identity_UserClasses_model *userUnitsModel = [idenModel.UserClasses objectAtIndex:m];
                D("sdrioghagilr;jae;l-====%@,%d",userUnitsModel.ClassID,[dm getInstance].UID);
                [[OnlineJobHttp getInstance] getGenInfoWithAccID:[dm getInstance].jiaoBaoHao UID:userUnitsModel.ClassID];
            }
        }
    }
    [self.view addSubview:self.mTableV_name];
}

//获取某学生学力值
-(void)GetStuEduLevel:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    [self.mTableV_list headerEndRefreshing];
    [self.mTableV_list footerEndRefreshing];
    NSMutableDictionary *dic = noti.object;
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
    if ([ResultCode intValue]==0) {
        NSMutableArray *array = [dic objectForKey:@"array"];
        if (array.count==0) {
            [MBProgressHUD showError:@"暂无章节" toView:self.view];
        }
        NSString *uId = [dic objectForKey:@"uId"];//教版
        NSString *chapterid = [dic objectForKey:@"chapterid"];//章
        NSString *StuId = [dic objectForKey:@"StuId"];//学生id
        NSString *flag = [dic objectForKey:@"flag"];//0学生id取值 1教版取值 2章取值
        if ([flag intValue]==0) {//取教版数据
            [self.mArr_score removeAllObjects];
            for (int i=0; i<array.count; i++) {
                TreeJob_node *node0 = [[TreeJob_node alloc]init];
                node0.nodeLevel = 0;//节点所处层次
                node0.type = 0;//节点类型
                node0.isExpanded = FALSE;//节点是否展开
                LevelModel *temp0 =[array objectAtIndex:i];
                temp0.StudentID = StuId;
                temp0.uId = temp0.ID;
                temp0.flag = 0;
                node0.nodeData = temp0;//当前节点数据
//                node0.flag = [temp0.ID intValue];//标注当前是哪个节点--给值教版
                [self.mArr_score addObject:node0];
            }
        }else if ([flag intValue]==1){//取教版下面的章数据
            for (TreeJob_node *node in self.mArr_score) {
                LevelModel *model = node.nodeData;
                if ([model.StudentID intValue]==[StuId intValue]) {
                    if ([uId intValue]==[model.uId intValue]) {//匹配教版
                        [node.sonNodes removeAllObjects];
                        for (int i=0; i<array.count; i++) {
                            TreeJob_node *node0 = [[TreeJob_node alloc]init];
                            node0.nodeLevel = 1;//节点所处层次
                            node0.type = 1;//节点类型
                            node0.isExpanded = FALSE;//节点是否展开
                            LevelModel *temp0 =[array objectAtIndex:i];
                            temp0.StudentID = StuId;
                            temp0.uId = uId;
                            temp0.chapterid = temp0.ID;
                            temp0.flag = 0;
                            node0.nodeData = temp0;//当前节点数据
//                        node0.flag = [temp0.ID intValue];//标注当前是哪个节点--给值章
                            [node.sonNodes addObject:node0];
                        }
                    }
                }
            }
        }else if ([flag intValue]==2){//取每章下面的节数据
            for (TreeJob_node *node in self.mArr_score) {
                LevelModel *model = node.nodeData;
                if ([model.StudentID intValue]==[StuId intValue]) {
                    if ([uId intValue]==[model.uId intValue]) {//匹配教版
                        [self addChapterRunloop:node Array:array chapterid:chapterid uId:uId StuId:StuId index:0];
                    }
                }
            }
        }
    }else{
        NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
        [MBProgressHUD showError:ResultDesc toView:self.view];
    }
    [self reloadDataForDisplayArray];
}

-(void)addChapterRunloop:(TreeJob_node *)node Array:(NSMutableArray *)array chapterid:(NSString *)chapterid uId:(NSString *)uId StuId:(NSString *)StuId index:(int)index{
    for (TreeJob_node *node1 in node.sonNodes) {
        LevelModel *model1 = node1.nodeData;
        if ([chapterid intValue]==[model1.chapterid intValue]) {//匹配章
            [node1.sonNodes removeAllObjects];
            for (int i=0; i<array.count; i++) {
                TreeJob_node *node0 = [[TreeJob_node alloc]init];
                node0.nodeLevel = 2;//节点所处层次
                node0.type = 2;//节点类型
                node0.isExpanded = FALSE;//节点是否展开
                LevelModel *temp0 =[array objectAtIndex:i];
                temp0.uId = uId;
//                if (index>0) {
                    temp0.index = model1.index+1;
//                }else{
//                    temp0.index = index;
//                }
                temp0.flag = 0;
                temp0.chapterid = temp0.ID;
                temp0.StudentID = StuId;
                node0.nodeData = temp0;//当前节点数据
                [node1.sonNodes addObject:node0];
            }
            break;
        }else{
//            index++;
            [self addChapterRunloop:node1 Array:array chapterid:chapterid uId:uId StuId:StuId index:index];
        }
    }
}

//点击学生下拉选择
- (IBAction)selectStuBtnAction:(id)sender{
    if (self.mTableV_name.frame.size.height>0) {
        self.mTableV_name.frame =  CGRectMake(self.mTableV_name.frame.origin.x, self.mTableV_name.frame.origin.y, self.mTableV_name.frame.size.width, 0);
    }else{
        self.mTableV_name.frame =  CGRectMake(self.mTableV_name.frame.origin.x, self.mTableV_name.frame.origin.y, self.mTableV_name.frame.size.width, 44*self.mArr_parent.count);
    }
    [self.mTableV_name reloadData];
}

//获取到学生id
-(void)getGenInfoWithAccID:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    [self.mTableV_list headerEndRefreshing];
    [self.mTableV_list footerEndRefreshing];
    NSMutableDictionary *dic = noti.object;
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
    if ([ResultCode intValue]==0) {
        GenInfo *model = [dic objectForKey:@"model"];
        [self.mArr_parent addObject:model];
        
        [self.mTableV_name initTableViewDataSourceAndDelegate:^NSInteger(UITableView *tableView,NSInteger section){
            return self.mArr_parent.count;
        } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
            UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
            if (!cell) {
                cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SelectionCell"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
            }
            GenInfo *model = [self.mArr_parent objectAtIndex:indexPath.row];
            cell.textLabel.text = model.StdName;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            return cell;
        } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
            [UIView animateWithDuration:0.3 animations:^{
                self.mTableV_name.frame =  CGRectMake(self.mTableV_name.frame.origin.x, self.mTableV_name.frame.origin.y, self.mTableV_name.frame.size.width, 0);
            } completion:^(BOOL finished){
                GenInfo *model = [self.mArr_parent objectAtIndex:indexPath.row];
                [self.mBtn_select setTitle:model.StdName forState:UIControlStateNormal];
                if ([self.mModel_gen.StudentID intValue] == [model.StudentID intValue]) {
                    
                }else{
                    self.mModel_gen = model;
                    [self.mArr_nowHomework removeAllObjects];
                    [self.mArr_overHomework removeAllObjects];
                    [self.mArr_score removeAllObjects];
                    //重新获取数据
                    [self sendRequst];
                }
            }];
        }];
        
        [self.mTableV_name.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [self.mTableV_name.layer setBorderWidth:.5];
        //发送请求
        if (self.mArr_parent.count==1) {
            GenInfo *tempModel = [self.mArr_parent objectAtIndex:0];
            self.mModel_gen = tempModel;
            [self.mBtn_select setTitle:tempModel.StdName forState:UIControlStateNormal];
            [[OnlineJobHttp getInstance] GetStuHWListWithStuId:tempModel.StudentID IsSelf:@"0"];
            [MBProgressHUD showMessage:@"" toView:self.view];
        }
    }else{
        NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
        [MBProgressHUD showError:ResultDesc toView:self.view];
    }
//    [self.mTableV_list reloadData];
}

//获取某学生各科作业完成情况
-(void)GetCompleteStatusHW:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    [self.mTableV_list headerEndRefreshing];
    [self.mTableV_list footerEndRefreshing];
    NSMutableDictionary *dic = noti.object;
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
    if ([ResultCode intValue]==0) {
        NSMutableArray *array = [dic objectForKey:@"array"];
        self.mArr_overHomework = array;
    }else{
        NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
        [MBProgressHUD showError:ResultDesc toView:self.view];
    }
    [self.mTableV_list reloadData];
}

//学生获取当前作业列表
-(void)GetStuHWList:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    [self.mTableV_list headerEndRefreshing];
    [self.mTableV_list footerEndRefreshing];
    NSMutableDictionary *dic = noti.object;
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
    if ([ResultCode intValue]==0) {
        NSMutableArray *array = [dic objectForKey:@"array"];
        NSString *IsSelf = [dic objectForKey:@"IsSelf"];
        if ([IsSelf intValue]==0) {//作业
            if (array.count>0) {
                self.mArr_nowHomework = array;
            }else{
                [MBProgressHUD showError:@"无数据" toView:self.view];
            }
        }else{//练习
            if (array.count>0) {
                self.mArr_practice = array;
            }else{
                [MBProgressHUD showError:@"无数据" toView:self.view];
            }
        }
        [self.mTableV_list reloadData];
    }else{
        [MBProgressHUD showError:@"服务器异常" toView:self.view];
    }
}

//点击切换查询
-(void)selectScrollButton:(UIButton *)btn{
    
}

-(void)ButtonViewTitleBtn:(ButtonViewCell *)view{
    if (self.mArr_parent.count==0) {
        [MBProgressHUD showError:@"暂时没有获取到学生信息" toView:self.view];
        return;
    }
    self.mTableV_list.hidden = NO;
    self.mInt_index = (int)view.tag-100;
    if (self.mInt_index==0) {
        self.mTableV_list.tableHeaderView = nil;
    } else if (self.mInt_index==1){
        self.mTableV_list.tableHeaderView = self.mView_head;
        self.mView_head.mLab_title1.text = @"完成/缺交/总数";
    }else if (self.mInt_index==2){
        self.mTableV_list.tableHeaderView = self.mView_head;
        self.mView_head.mLab_title1.text = @"学力";
    }else if (self.mInt_index==3){
        self.mTableV_list.tableHeaderView = nil;
    }else if (self.mInt_index==4){
        self.mTableV_list.hidden = YES;
    }
//    for (UIButton *btn1 in self.mScrollV_all.subviews) {
//        if ([btn1.class isSubclassOfClass:[UIButton class]]) {
//            if ((int)btn1.tag == self.mInt_index) {
//                btn1.selected = YES;
//            }else{
//                btn1.selected = NO;
//            }
//        }
//    }
    //发送请求
    [self sendRequst];
}

//发送请求
-(void)sendRequst{
    if (self.mInt_index==0) {//获取作业列表
        //判断是否有值
        if (self.mArr_nowHomework.count==0) {
            [[OnlineJobHttp getInstance] GetStuHWListWithStuId:self.mModel_gen.StudentID IsSelf:@"0"];
            [MBProgressHUD showMessage:@"" toView:self.view];
        }
    }else if (self.mInt_index==1) {//获取完成情况
        //判断是否有值
        if (self.mArr_overHomework.count==0) {
            [[OnlineJobHttp getInstance] GetCompleteStatusHWWithStuId:self.mModel_gen.StudentID];
            [MBProgressHUD showMessage:@"" toView:self.view];
        }
    }else if (self.mInt_index==2) {//获取学力
        //判断是否有值
        if (self.mArr_score.count==0) {
            [[OnlineJobHttp getInstance] GetStuEduLevelWithStuId:self.mModel_gen.StudentID uId:@"" chapterid:@"" flag:@"0"];
            [MBProgressHUD showMessage:@"" toView:self.view];
        }
    }else if (self.mInt_index==3) {//获取练习列表
        //判断是否有值
        if (self.mArr_practice.count==0) {
            [[OnlineJobHttp getInstance] GetStuHWListWithStuId:self.mModel_gen.StudentID IsSelf:@"1"];
            [MBProgressHUD showMessage:@"" toView:self.view];
        }
    }
    [self.mTableV_list reloadData];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing{
    if (self.mInt_index==0) {//获取作业列表
        [self.mArr_nowHomework removeAllObjects];
    }else if (self.mInt_index ==1){//获取练习列表
        [self.mArr_overHomework removeAllObjects];
    }else if (self.mInt_index ==2){//获取学力
        [self.mArr_score removeAllObjects];
    }else if (self.mInt_index==3) {//获取练习列表
        [self.mArr_practice removeAllObjects];
    }
    [self sendRequst];
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.mInt_index==0) {
        return self.mArr_nowHomework.count;
    } else if (self.mInt_index==1){
        return self.mArr_overHomework.count;
    }else if (self.mInt_index==2){//获取学力
        return self.mArr_disScore.count;
    }else if (self.mInt_index==3) {//获取练习列表
        return self.mArr_practice.count;
    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"StudentHomework_TableViewCell";
    StudentHomework_TableViewCell *cell = (StudentHomework_TableViewCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[StudentHomework_TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StudentHomework_TableViewCell" owner:self options:nil];
        //这时myCell对象已经通过自定义xib文件生成了
        if ([nib count]>0) {
            cell = (StudentHomework_TableViewCell *)[nib objectAtIndex:0];
            //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
        }
        //添加图片点击事件
        //若是需要重用，需要写上以下两句代码
        UINib * n= [UINib nibWithNibName:@"StudentHomework_TableViewCell" bundle:[NSBundle mainBundle]];
        [self.mTableV_list registerNib:n forCellReuseIdentifier:indentifier];
    }
    
    if (self.mInt_index == 0||self.mInt_index == 3) {
        StuHWModel *model;
        if (self.mInt_index == 0) {
            model = [self.mArr_nowHomework objectAtIndex:indexPath.row];
        }else{
            model = [self.mArr_practice objectAtIndex:indexPath.row];
        }
        
        if ([model.isHaveAdd intValue]==1) {//主观题
            cell.mImg_pic.frame = CGRectMake(8, 10, 14, 14);
            cell.mImg_pic.hidden = NO;
        }else{
            cell.mImg_pic.frame = CGRectMake(8, 10, 0, 0);
            cell.mImg_pic.hidden = YES;
        }
        //名称
        cell.mLab_title.text = model.homeworkName;
        cell.mLab_title.font = [UIFont systemFontOfSize:14];
        cell.mLab_title.textColor = [UIColor colorWithRed:37/255.0 green:137/255.0 blue:209/255.0 alpha:1];
        cell.mLab_title.frame  = CGRectMake(cell.mImg_pic.frame.origin.x+cell.mImg_pic.frame.size.width+5, 8, [dm getInstance].width-cell.mImg_pic.frame.origin.x-cell.mImg_pic.frame.size.width-10, cell.mLab_title.frame.size.height);
//        //题量
//        cell.mLab_numLab.text = @"选/填/总: ";
//        CGSize numSize0 = [cell.mLab_numLab.text sizeWithFont:[UIFont systemFontOfSize:10]];
//        cell.mLab_numLab.frame = CGRectMake(8, cell.mLab_title.frame.origin.y+cell.mLab_title.frame.size.height, numSize0.width, cell.mLab_numLab.frame.size.height);
//        cell.mLab_numLab.hidden = NO;
//        NSString *num0 = model.distribution;//选择题、填空题分布---1:10,2:10
//        num0 = [num0 stringByReplacingOccurrencesOfString:@"1:" withString:@""];
//        num0 = [num0 stringByReplacingOccurrencesOfString:@",2:" withString:@"/"];
//        num0 = [NSString stringWithFormat:@"%@/%@",num0,model.itemNumber];
//        cell.mLab_num.text = num0;
//        CGSize numSize = [num0 sizeWithFont:[UIFont systemFontOfSize:10]];
//        cell.mLab_num.frame = CGRectMake(cell.mLab_numLab.frame.origin.x+cell.mLab_numLab.frame.size.width, cell.mLab_numLab.frame.origin.y, numSize.width, cell.mLab_num.frame.size.height);
//        cell.mLab_num.hidden = NO;
//        //过期时间
//        cell.mLab_timeLab.hidden = YES;
//        cell.mLab_time.hidden = YES;
        //题量
        cell.mLab_numLab.frame = CGRectMake(8, cell.mLab_title.frame.origin.y+cell.mLab_title.frame.size.height, cell.mLab_numLab.frame.size.width, cell.mLab_numLab.frame.size.height);
        cell.mLab_num.text = model.itemNumber;
        CGSize numSize = [model.itemNumber sizeWithFont:[UIFont systemFontOfSize:10]];
        cell.mLab_num.frame = CGRectMake(cell.mLab_numLab.frame.origin.x+cell.mLab_numLab.frame.size.width, cell.mLab_numLab.frame.origin.y, numSize.width, cell.mLab_num.frame.size.height);
        cell.mLab_numLab.hidden = NO;
        cell.mLab_num.hidden = NO;
        //过期时间
        cell.mLab_timeLab.frame = CGRectMake(cell.mLab_num.frame.origin.x+cell.mLab_num.frame.size.width+6, cell.mLab_numLab.frame.origin.y, cell.mLab_timeLab.frame.size.width, cell.mLab_timeLab.frame.size.height);
        cell.mLab_time.text = model.EXPIRYDATE;
        CGSize timeSize = [model.EXPIRYDATE sizeWithFont:[UIFont systemFontOfSize:10]];
        cell.mLab_time.frame  = CGRectMake(cell.mLab_timeLab.frame.origin.x+cell.mLab_timeLab.frame.size.width, cell.mLab_numLab.frame.origin.y, timeSize.width, cell.mLab_time.frame.size.height);
        cell.mLab_timeLab.hidden = NO;
        cell.mLab_time.hidden = NO;
        //判断是否做完
        if ([model.isHWFinish intValue]==1) {//完成
            cell.mLab_goto.hidden = YES;
            cell.mLab_power.hidden = NO;
            cell.mLab_power.font = [UIFont systemFontOfSize:10];
            cell.mLab_powerLab.hidden = NO;
            cell.mLab_score.hidden = NO;
            cell.mLab_scoreLab.hidden = NO;
            //学力
            cell.mLab_power.text = model.EduLevel;
            CGSize EduLevelSize = [model.EduLevel sizeWithFont:[UIFont systemFontOfSize:10]];
            cell.mLab_power.frame = CGRectMake([dm getInstance].width-9-EduLevelSize.width, cell.mLab_numLab.frame.origin.y, EduLevelSize.width, cell.mLab_power.frame.size.height);
            cell.mLab_powerLab.frame = CGRectMake(cell.mLab_power.frame.origin.x-cell.mLab_powerLab.frame.size.width, cell.mLab_numLab.frame.origin.y, cell.mLab_powerLab.frame.size.width, cell.mLab_powerLab.frame.size.height);
            //得分
            cell.mLab_score.text = model.HWScore;
            CGSize HWScoreSize = [model.HWScore sizeWithFont:[UIFont systemFontOfSize:10]];
            cell.mLab_score.frame = CGRectMake(cell.mLab_powerLab.frame.origin.x-10-HWScoreSize.width, cell.mLab_numLab.frame.origin.y, HWScoreSize.width, cell.mLab_score.frame.size.height);
            cell.mLab_scoreLab.frame = CGRectMake(cell.mLab_score.frame.origin.x-cell.mLab_scoreLab.frame.size.width, cell.mLab_numLab.frame.origin.y, cell.mLab_scoreLab.frame.size.width, cell.mLab_scoreLab.frame.size.height);
        }else{
            cell.mLab_goto.hidden = NO;
            cell.mLab_power.hidden = YES;
            cell.mLab_powerLab.hidden = YES;
            cell.mLab_score.hidden = YES;
            cell.mLab_scoreLab.hidden = YES;
            cell.mLab_goto.text = @"未完成";
            cell.mLab_goto.frame = CGRectMake([dm getInstance].width-9-cell.mLab_goto.frame.size.width, cell.mLab_numLab.frame.origin.y, cell.mLab_goto.frame.size.width, cell.mLab_goto.frame.size.height);
        }
        cell.mImg_open.hidden = YES;
        //分割线
        cell.mLab_line.frame = CGRectMake(0, cell.mLab_numLab.frame.origin.y+cell.mLab_numLab.frame.size.height+5, [dm getInstance].width, .5);
        return cell;
    }else if (self.mInt_index == 1) {
        CompleteStatusModel *model = [self.mArr_overHomework objectAtIndex:indexPath.row];
        cell.mImg_pic.frame = CGRectMake(8, 10, 0, 0);
        cell.mImg_pic.hidden = YES;
        //名称
        cell.mLab_title.text = model.Name;
        CGSize titleSize = [model.Name sizeWithFont:[UIFont systemFontOfSize:14]];
        //学力文字长度
        NSString *temp = [NSString stringWithFormat:@"%@/%@/%@",model.IsF,model.UnF,model.Total];
        CGSize EduLevelSize = [temp sizeWithFont:[UIFont systemFontOfSize:12]];
        if (titleSize.width>[dm getInstance].width-30-EduLevelSize.width) {
            titleSize.width =[dm getInstance].width-30-EduLevelSize.width;
        }
        cell.mLab_title.frame  = CGRectMake(cell.mImg_pic.frame.origin.x+cell.mImg_pic.frame.size.width+5, 10, titleSize.width, cell.mLab_title.frame.size.height);
        cell.mLab_title.textColor = [UIColor colorWithRed:33/255.0 green:41/255.0 blue:43/255.0 alpha:1];
        //题量
        cell.mLab_numLab.hidden = YES;
        cell.mLab_num.hidden = YES;
        //过期时间
        cell.mLab_timeLab.hidden = YES;
        cell.mLab_time.hidden = YES;
        cell.mLab_goto.hidden = YES;
        cell.mLab_power.hidden = YES;
        cell.mLab_powerLab.hidden = YES;
        cell.mLab_score.hidden = YES;
        cell.mLab_scoreLab.hidden = YES;
        //学力
//        NSString *temp = [NSString stringWithFormat:@"%@/%@/%@",model.IsF,model.UnF,model.Total];
        cell.mLab_power.text = temp;
        cell.mLab_power.hidden = NO;
        cell.mLab_power.font = [UIFont systemFontOfSize:12];
//        CGSize EduLevelSize = [temp sizeWithFont:[UIFont systemFontOfSize:12]];
        cell.mLab_power.frame = CGRectMake([dm getInstance].width-9-EduLevelSize.width, cell.mLab_title.frame.origin.y, EduLevelSize.width, cell.mLab_power.frame.size.height);
        cell.mLab_powerLab.hidden = YES;
        //得分
        cell.mLab_score.hidden = YES;
        cell.mLab_scoreLab.hidden = YES;
        cell.mImg_open.hidden = YES;
        //分割线
        cell.mLab_line.frame = CGRectMake(0, 43, [dm getInstance].width, .5);
        
        return cell;
    }else if (self.mInt_index == 2) {
        TreeJob_node *node = [self.mArr_disScore objectAtIndex:indexPath.row];
        LevelModel *model = node.nodeData;
        cell.mImg_pic.frame = CGRectMake(8, 10, 0, 0);
        cell.mImg_pic.hidden = YES;
        //名称
        cell.mLab_title.text = model.Name;
        CGSize titleSize = [model.Name sizeWithFont:[UIFont systemFontOfSize:14]];
        if (node.type==0) {
            if (titleSize.width>[dm getInstance].width-80) {
                titleSize.width =[dm getInstance].width-80;
            }
            cell.mLab_line.frame = CGRectMake(0, 0, [dm getInstance].width, 5);
            cell.mLab_title.frame  = CGRectMake(cell.mImg_pic.frame.origin.x+cell.mImg_pic.frame.size.width+5, 14, titleSize.width, cell.mLab_title.frame.size.height);
            cell.mLab_title.font = [UIFont systemFontOfSize:14];
            cell.mLab_title.textColor = [UIColor colorWithRed:33/255.0 green:41/255.0 blue:43/255.0 alpha:1];
//            cell.mImg_open.hidden = NO;
        }else if (node.type==1){
            if (titleSize.width>[dm getInstance].width-100) {
                titleSize.width =[dm getInstance].width-100;
            }
            cell.mLab_line.frame = CGRectMake(0, 0, [dm getInstance].width, .5);
            cell.mLab_title.frame  = CGRectMake(cell.mImg_pic.frame.origin.x+cell.mImg_pic.frame.size.width+15, 8, titleSize.width, cell.mLab_title.frame.size.height);
            cell.mLab_title.font = [UIFont systemFontOfSize:12];
            cell.mLab_title.textColor = [UIColor colorWithRed:33/255.0 green:41/255.0 blue:43/255.0 alpha:1];
//            cell.mImg_open.hidden = NO;
        }else if (node.type == 2){
            if (titleSize.width>[dm getInstance].width-100-(model.index-1)*20) {
                titleSize.width =[dm getInstance].width-100-(model.index-1)*20;
            }
            cell.mLab_line.frame = CGRectMake(0, 0, [dm getInstance].width, .5);
//            D("model.index=-=====%d",model.index);
            cell.mLab_title.frame  = CGRectMake(cell.mImg_pic.frame.origin.x+cell.mImg_pic.frame.size.width+25+(model.index-1)*20, 8, titleSize.width, cell.mLab_title.frame.size.height);
            cell.mLab_title.font = [UIFont systemFontOfSize:12];
            cell.mLab_title.textColor = [UIColor colorWithRed:121/255.0 green:121/255.0 blue:121/255.0 alpha:1];
//            cell.mImg_open.hidden = YES;
        }
        //根据实际取到的值，来判断是否显示
        if (model.flag==1&&node.sonNodes.count==0) {
            cell.mImg_open.hidden = YES;
        }else{
            cell.mImg_open.hidden = NO;
        }
        //题量
        cell.mLab_numLab.hidden = YES;
        cell.mLab_num.hidden = YES;
        //过期时间
        cell.mLab_timeLab.hidden = YES;
        cell.mLab_time.hidden = YES;
        cell.mLab_goto.hidden = YES;
        cell.mLab_power.hidden = YES;
        cell.mLab_powerLab.hidden = YES;
        cell.mLab_score.hidden = YES;
        cell.mLab_scoreLab.hidden = YES;
        //学力
        NSString *temp = [NSString stringWithFormat:@"%@",model.Level];
        cell.mLab_power.text = temp;
        cell.mLab_power.hidden = NO;
        cell.mLab_power.font = [UIFont systemFontOfSize:12];
        CGSize EduLevelSize = [temp sizeWithFont:[UIFont systemFontOfSize:12]];
        cell.mLab_power.frame = CGRectMake([dm getInstance].width-29-EduLevelSize.width, cell.mLab_title.frame.origin.y, EduLevelSize.width, cell.mLab_power.frame.size.height);
        cell.mLab_powerLab.hidden = YES;
        //箭头
        cell.mImg_open.frame = CGRectMake([dm getInstance].width-10-10, cell.mLab_title.frame.origin.y+5, 10, 10);
        if (node.sonNodes.count>0&&node.isExpanded) {
            [cell.mImg_open setImage:[UIImage imageNamed:@"homework_down0"]];
        }else{
            [cell.mImg_open setImage:[UIImage imageNamed:@"homework_down1"]];
        }
        //得分
        cell.mLab_score.hidden = YES;
        cell.mLab_scoreLab.hidden = YES;
        //分割线
        
        return cell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    if (self.mInt_index == 0||self.mInt_index ==3) {
        return 56;
    }else if (self.mInt_index == 1){
        return 44;
    }else{
        TreeJob_node *node = [self.mArr_disScore objectAtIndex:indexPath.row];
        if (node.type==0) {
            return 44;
        }else if (node.type==1){
            return 35;
        }else if (node.type == 2){
            return 35;
        }
        return 44;
    }
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.mInt_index ==0||self.mInt_index ==3) {//当前作业查询、练习
        StuHWModel *model = [self.mArr_nowHomework objectAtIndex:indexPath.row];
            DetailHWViewController *detail;
            detail = [[DetailHWViewController alloc]initWithNibName:@"DetailHWVc" bundle:nil];
            detail.TabID = model.TabID;
            detail.isSubmit = [model.isHWFinish integerValue];
            detail.hwName = model.homeworkName;
        if (self.mInt_index==0) {
            detail.navBarName = @"做作业";
        }else{
            detail.navBarName = @"做练习";
        }
        
            detail.FlagStr = @"2";
            [self.navigationController pushViewController:detail animated:YES];
    }else if (self.mInt_index == 2){
        TreeJob_node *node = [self.mArr_disScore objectAtIndex:indexPath.row];
        LevelModel *model = node.nodeData;
        //判断是教版
        if (node.type == 0) {
            if (node.sonNodes.count==0) {//判断里面没有数据，然后请求
                [[OnlineJobHttp getInstance] GetStuEduLevelWithStuId:model.StudentID uId:model.ID chapterid:@"" flag:@"1"];
                [MBProgressHUD showMessage:@"" toView:self.view];
            }
            [self reloadDataForDisplayArrayChangeAt:node flag:@"0"];//修改cell的状态(关闭或打开)
        }else if (node.type == 1){//判断是章
            if (node.sonNodes.count==0) {//判断里面没有数据，然后请求
                [[OnlineJobHttp getInstance] GetStuEduLevelWithStuId:model.StudentID uId:model.uId chapterid:model.ID flag:@"2"];
                [MBProgressHUD showMessage:@"" toView:self.view];
            }
            [self reloadDataForDisplayArrayChangeAt:node flag:@"1"];//修改cell的状态(关闭或打开)
        }else{
            if (node.sonNodes.count==0) {//判断里面没有数据，然后请求
                [[OnlineJobHttp getInstance] GetStuEduLevelWithStuId:model.StudentID uId:model.uId chapterid:model.ID flag:@"2"];
                [MBProgressHUD showMessage:@"" toView:self.view];
            }
            [self reloadDataForDisplayArrayChangeAt:node flag:@"2"];//修改cell的状态(关闭或打开)
        }
    }
}

/*---------------------------------------
 修改cell的状态(关闭或打开)
 --------------------------------------- */
-(void) reloadDataForDisplayArrayChangeAt:(TreeJob_node *)node flag:(NSString *)flag{
    LevelModel *model = node.nodeData;
    if ([flag intValue]==0) {//取教版数据
        for (int i=0; i<self.mArr_score.count; i++) {
            TreeJob_node *node0 = [self.mArr_score objectAtIndex:i];
            LevelModel *model0 = node0.nodeData;
            if ([model.StudentID intValue]==[model0.StudentID intValue]) {
                if ([model.ID intValue]==[model0.ID intValue]) {
                    node0.isExpanded = !node0.isExpanded;
                    model0.flag = 1;
                }
            }
        }
    }else if ([flag intValue]==1){//取教版下面的章数据
        for (TreeJob_node *node0 in self.mArr_score) {
            LevelModel *model0 = node0.nodeData;
            if ([model.StudentID intValue]==[model0.StudentID intValue]) {
                if ([model.uId intValue]==[model0.uId intValue]) {
                    for (TreeJob_node *node1 in node0.sonNodes) {
                        LevelModel *model1 = node1.nodeData;
                        if ([model.ID intValue]==[model1.ID intValue]) {
                            node1.isExpanded = !node1.isExpanded;
                            model1.flag = 1;
                        }
                    }
                }
            }
        }
    }else{
        for (TreeJob_node *node0 in self.mArr_score) {
            LevelModel *model0 = node0.nodeData;
            if ([model.StudentID intValue]==[model0.StudentID intValue]) {
                if ([model.uId intValue]==[model0.uId intValue]) {
                    [self openOrClose:node0 Model:model];
                }
            }
        }
    }
    [self reloadDataForDisplayArray];
}

-(void)openOrClose:(TreeJob_node *)node0 Model:(LevelModel *)model{
    for (TreeJob_node *node1 in node0.sonNodes) {
        LevelModel *model1 = node1.nodeData;
//        D("2323232232323232323-=======%@,%@",model.ID,model1.ID);
        if ([model.ID intValue]==[model1.ID intValue]) {
            node1.isExpanded = !node1.isExpanded;
            model1.flag = 1;
            break;
        }else{
            [self openOrClose:node1 Model:model];
        }
    }
}

//初始化将要显示的数据
-(void)reloadDataForDisplayArray{
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    for (TreeJob_node *node in self.mArr_score) {
        [tmp addObject:node];
        if(node.isExpanded){
//            for(TreeJob_node *node2 in node.sonNodes){
//                [tmp addObject:node2];
//                if (node2.isExpanded) {
//                    for (TreeJob_node *node3 in node2.sonNodes) {
//                        [tmp addObject:node3];
//                    }
//                }
//            }
            [self addRunloop:node SumArr:tmp];
        }
    }
    self.mArr_disScore = [NSArray arrayWithArray:tmp];
    [self.mTableV_list reloadData];
}

-(void)addRunloop:(TreeJob_node *)node SumArr:(NSMutableArray *)tmp{
    for(TreeJob_node *node2 in node.sonNodes){
        [tmp addObject:node2];
        if (node2.isExpanded) {
//            for (TreeJob_node *node3 in node2.sonNodes) {
//                [tmp addObject:node3];
//                if (node3.isExpanded) {
                    [self addRunloop:node2 SumArr:tmp];
//                }
//            }
        }
//        else{
//            [self addRunloop:node2 SumArr:tmp];
//        }
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
