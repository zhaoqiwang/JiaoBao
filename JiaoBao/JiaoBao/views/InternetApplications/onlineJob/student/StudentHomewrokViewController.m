//
//  StudentHomewrokViewController.m
//  JiaoBao
//
//  Created by Zqw on 15/10/23.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "StudentHomewrokViewController.h"
#import "define_constant.h"
#import "DetailHWViewController.h"

@interface StudentHomewrokViewController ()

@end

@implementation StudentHomewrokViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //学生获取当前作业列表
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetStuHWList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetStuHWList:) name:@"GetStuHWList" object:nil];
    //获取到学生信息
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getStuInfo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getStuInfo:) name:@"getStuInfo" object:nil];
    //获取年级列表
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetGradeList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetGradeList:) name:@"GetGradeList" object:nil];
    //获取联动列表
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetUnionChapterList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetUnionChapterList:) name:@"GetUnionChapterList" object:nil];
    //学生发布练习
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"StuMakeSelf" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(StuMakeSelf:) name:@"StuMakeSelf" object:nil];
    
    self.mArr_homework = [NSMutableArray array];
    self.mArr_practice = [NSMutableArray array];
    self.mArr_sumData = [NSMutableArray array];
    self.mArr_display = [NSMutableArray array];
    self.mInt_index = 0;
    
    //输入框弹出键盘问题
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;//控制整个功能是否启用
    manager.shouldResignOnTouchOutside = YES;//控制点击背景是否收起键盘
    manager.shouldToolbarUsesTextFieldTintColor = YES;//控制键盘上的工具条文字颜色是否用户自定义
    manager.enableAutoToolbar = YES;//控制是否显示键盘上的工具条
    
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"作业"];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    
    self.mScrollV_all = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.mNav_navgationBar.frame.size.height, [dm getInstance].width, 48)];
    int tempWidth = [dm getInstance].width/2;
    for (int i=0; i<2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(tempWidth*i, 1, tempWidth, 47)];
        [btn setTag:i];
        if (i==0) {
            btn.selected = YES;
            self.mInt_index = 0;
            [btn setTitle:@"做作业" forState:UIControlStateNormal];
        }else{
            [btn setTitle:@"做练习" forState:UIControlStateNormal];
        }
        [btn setBackgroundColor:[UIColor colorWithRed:247/255.0 green:246/255.0 blue:246/255.0 alpha:1]];
        btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        
        [btn setTitleColor:[UIColor colorWithRed:3/255.0 green:170/255.0 blue:54/255.0 alpha:1] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"topBtnSelect0"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(selectScrollButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.mScrollV_all addSubview:btn];
    }
    self.mScrollV_all.contentSize = CGSizeMake(tempWidth*2, 48);
    [self.view addSubview:self.mScrollV_all];
    
    //
    self.mTableV_list.frame = CGRectMake(0, self.mScrollV_all.frame.size.height+self.mScrollV_all.frame.origin.y-[dm getInstance].statusBar, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height-48+[dm getInstance].statusBar);
    self.mTableV_list.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.mTableV_list addHeaderWithTarget:self action:@selector(headerRereshing)];
    self.mTableV_list.headerPullToRefreshText = @"下拉刷新";
    self.mTableV_list.headerReleaseToRefreshText = @"松开后刷新";
    self.mTableV_list.headerRefreshingText = @"正在刷新...";
//    [self.mTableV_list addFooterWithTarget:self action:@selector(footerRereshing)];
//    self.mTableV_list.footerPullToRefreshText = @"上拉加载更多";
//    self.mTableV_list.footerReleaseToRefreshText = @"松开加载更多数据";
//    self.mTableV_list.footerRefreshingText = @"正在加载...";
    
    //根据角色信息，获取学生id信息
    for (int i=0; i<[dm getInstance].identity.count; i++) {
        Identity_model *idenModel = [[dm getInstance].identity objectAtIndex:i];
        if ([idenModel.RoleIdentity intValue]==4) {
            for (int m=0; m<idenModel.UserClasses.count; m++) {
                Identity_UserClasses_model *userUnitsModel = [idenModel.UserClasses objectAtIndex:m];
                D("sdrioghagilr;jae;l-====%@,%d",userUnitsModel.ClassID,[dm getInstance].UID);
                //找到当前登录的班级，然后获取
//                if ([userUnitsModel.ClassID intValue] ==[dm getInstance].UID) {
                    D("douifghdoj-====%@",userUnitsModel.ClassID);
                    [[OnlineJobHttp getInstance] getStuInfoWithAccID:[dm getInstance].jiaoBaoHao UID:userUnitsModel.ClassID];
//                }
            }
        }
    }
    //添加默认数据
    [self addDefaultData];
}

//学生发布练习
-(void)StuMakeSelf:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSMutableDictionary *dic = noti.object;
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
    NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
    if ([ResultCode intValue]==0) {
        [[OnlineJobHttp getInstance] GetStuHWListWithStuId:self.mModel_stuInf.StudentID IsSelf:@"1"];
        [MBProgressHUD showMessage:@"" toView:self.view];
    }else{
        [MBProgressHUD showError:ResultDesc toView:self.view];
    }
}

//添加默认数据
-(void)addDefaultData{
    //第0根节点
    NSMutableArray *tempArr = [NSMutableArray arrayWithObjects:@"年级选择",@"科目选择",@"教版选择",@"章节选择",@"标题更改",@"发布练习", nil];
    for (int i=0; i<tempArr.count; i++) {
        TreeJob_node *node0 = [[TreeJob_node alloc]init];
        node0.nodeLevel = 0;//节点所处层次
        node0.type = 0;//节点类型
        node0.flag = i;//标注当前是哪个节点
        node0.isExpanded = FALSE;//节点是否展开
        TreeJob_level0_model *temp0 =[[TreeJob_level0_model alloc]init];
        temp0.mStr_name = [tempArr objectAtIndex:i];
        node0.nodeData = temp0;//当前节点数据
        
        [self.mArr_sumData addObject:node0];
    }
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
        if ([IsSelf intValue]==0) {
            if (array.count>0) {
                [self.mArr_homework addObjectsFromArray:array];
            }else{
                [MBProgressHUD showError:@"无数据" toView:self.view];
            }
        }else{
            if (array.count>0) {//显示练习列表
                [self.mArr_practice addObjectsFromArray:array];
            }else{//显示添加练习
                //获取年级列表
                [[OnlineJobHttp getInstance] GetGradeList];
            }
        }
        [self.mTableV_list reloadData];
    }else{
        [MBProgressHUD showError:@"服务器异常" toView:self.view];
    }
}

//获取到学生信息
-(void)getStuInfo:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    self.mModel_stuInf = noti.object;
    [[OnlineJobHttp getInstance] GetStuHWListWithStuId:self.mModel_stuInf.StudentID IsSelf:@"0"];
}

-(void)selectScrollButton:(UIButton *)btn{
    //如果点击练习，
    if (btn.tag==1) {
        //先判断作业列表，是否有没有完成的
        int a=0;
        for (int i=0; i<self.mArr_homework.count; i++) {
            StuHWModel *model = [self.mArr_homework objectAtIndex:i];
            if ([model.isHWFinish intValue]==0) {
                a++;
            }
        }
        if (a>0) {
            [MBProgressHUD showError:@"您还有作业未完成" toView:self.view];
            return;
        }
        //再发送获取练习列表，然后根据返回的数据，做界面显示
        
    }
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
    if (btn.tag==0) {//获取作业列表
        self.mInt_index = 0;
        //判断是否有值
        if (self.mArr_homework.count==0) {
            [[OnlineJobHttp getInstance] GetStuHWListWithStuId:self.mModel_stuInf.StudentID IsSelf:@"0"];
            [MBProgressHUD showMessage:@"" toView:self.view];
        }
    }else{//获取练习列表
        self.mInt_index = 1;
        //判断是否有值
        if (self.mArr_practice.count==0) {
            [[OnlineJobHttp getInstance] GetStuHWListWithStuId:self.mModel_stuInf.StudentID IsSelf:@"1"];
            [MBProgressHUD showMessage:@"" toView:self.view];
        }
    }
    [self.mTableV_list reloadData];
}

//获取年级列表
-(void)GetGradeList:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSMutableArray *array = noti.object;
    for (int i=0; i<self.mArr_sumData.count; i++) {
        TreeJob_node *node0 = [self.mArr_sumData objectAtIndex:i];
        if (node0.flag == 0) {
            [node0.sonNodes removeAllObjects];
            for (int m=0; m<array.count; m++) {
                //第1根节点
                TreeJob_node *node1 = [[TreeJob_node alloc]init];
                node1.nodeLevel = 1;//节点所处层次
                node1.type = 1;//节点类型
                node1.flag = 201;//标注当前是哪个节点
                node1.faType = node0.flag;//父节点
                node1.isExpanded = FALSE;//节点是否展开
                node1.mInt_index = self.mInt_index;//全局索引标识
                self.mInt_index++;
                GradeModel *temp1 =[array objectAtIndex:m];
                if (m==0) {
                    TreeJob_level0_model *nodeData = node0.nodeData;
                    nodeData.mStr_title = temp1.GradeName;
                    nodeData.mStr_id = temp1.GradeCode;
                    temp1.mInt_select = 1;
                    [[OnlineJobHttp getInstance]GetUnionChapterListWithgCode:temp1.GradeCode subCode:@"0" uId:@"0" flag:@"0"];
                }else{
                    temp1.mInt_select = 0;
                }
                node1.nodeData = temp1;
                //塞入数据
                [node0.sonNodes addObject:node1];
            }
        }
    }
    [self reloadDataForDisplayArray];
}

//获取联动列表
-(void)GetUnionChapterList:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSMutableDictionary *dic = noti.object;
    NSString *flag = [dic objectForKey:@"flag"];
    NSMutableArray *array1 = [dic objectForKey:@"args1"];//科目列表
    NSMutableArray *array2 = [dic objectForKey:@"args2"];//教版
    NSMutableArray *array3 = [dic objectForKey:@"args3"];//章节
    if ([flag intValue]==0) {//
        for (int i=0; i<self.mArr_sumData.count; i++) {
            TreeJob_node *node0 = [self.mArr_sumData objectAtIndex:i];
            if (node0.flag == 1) {//往科目选择中插入
                [node0.sonNodes removeAllObjects];
                for (int m=0; m<array1.count; m++) {
                    //第1根节点
                    TreeJob_node *node1 = [[TreeJob_node alloc]init];
                    node1.nodeLevel = 1;//节点所处层次
                    node1.type = 1;//节点类型
                    node1.flag = 301;//标注当前是哪个节点
                    node1.faType = node0.flag;//父节点
                    node1.isExpanded = FALSE;//节点是否展开
                    node1.mInt_index = self.mInt_index;//全局索引标识
                    self.mInt_index++;
                    SubjectModel *temp1 =[array1 objectAtIndex:m];
                    if (m==0) {
                        TreeJob_level0_model *nodeData = node0.nodeData;
                        nodeData.mStr_title = temp1.subjectName;
                        nodeData.mStr_id = temp1.subjectCode;
                        temp1.mInt_select = 1;
                    }else{
                        temp1.mInt_select = 0;
                    }
                    node1.nodeData = temp1;
                    //塞入数据
                    [node0.sonNodes addObject:node1];
                }
            }else if (node0.flag == 2) {//往教版选择中插入
                [node0.sonNodes removeAllObjects];
                for (int m=0; m<array2.count; m++) {
                    //第1根节点
                    TreeJob_node *node1 = [[TreeJob_node alloc]init];
                    node1.nodeLevel = 1;//节点所处层次
                    node1.type = 1;//节点类型
                    node1.flag = 401;//标注当前是哪个节点
                    node1.faType = node0.flag;//父节点
                    node1.isExpanded = FALSE;//节点是否展开
                    node1.mInt_index = self.mInt_index;//全局索引标识
                    self.mInt_index++;
                    VersionModel *temp1 =[array2 objectAtIndex:m];
                    if (m==0) {
                        TreeJob_level0_model *nodeData = node0.nodeData;
                        nodeData.mStr_title = temp1.VersionName;
                        nodeData.mStr_id = temp1.VersionCode;
                        temp1.mInt_select = 1;
                    }else{
                        temp1.mInt_select = 0;
                    }
                    node1.nodeData = temp1;
                    //塞入数据
                    [node0.sonNodes addObject:node1];
                }
            }else if (node0.flag == 3) {//往章节选择中插入
                [node0.sonNodes removeAllObjects];
                for (int m=0; m<array3.count; m++) {
                    //第1根节点
                    TreeJob_node *node1 = [[TreeJob_node alloc]init];
                    node1.nodeLevel = 1;//节点所处层次
                    node1.type = 1;//节点类型
                    node1.flag = 501;//标注当前是哪个节点
                    node1.faType = node0.flag;//父节点
                    node1.isExpanded = FALSE;//节点是否展开
                    node1.mInt_index = self.mInt_index;//全局索引标识
                    self.mInt_index++;
                    ChapterModel *temp1 =[array3 objectAtIndex:m];
                    if (m==0) {
                        TreeJob_level0_model *nodeData = node0.nodeData;
                        nodeData.mStr_title = temp1.chapterName;
                        nodeData.mStr_id = temp1.chapterCode;
                        temp1.mInt_select = 1;
                    }else{
                        temp1.mInt_select = 0;
                    }
                    node1.nodeData = temp1;
                    //塞入数据
                    [node0.sonNodes addObject:node1];
                }
            }
        }
    }else if ([flag intValue]==1){//
        for (int i=0; i<self.mArr_sumData.count; i++) {
            TreeJob_node *node0 = [self.mArr_sumData objectAtIndex:i];
            if (node0.flag == 2) {//往教版选择中插入
                [node0.sonNodes removeAllObjects];
                for (int m=0; m<array2.count; m++) {
                    //第1根节点
                    TreeJob_node *node1 = [[TreeJob_node alloc]init];
                    node1.nodeLevel = 1;//节点所处层次
                    node1.type = 1;//节点类型
                    node1.flag = 401;//标注当前是哪个节点
                    node1.faType = node0.flag;//父节点
                    node1.isExpanded = FALSE;//节点是否展开
                    node1.mInt_index = self.mInt_index;//全局索引标识
                    self.mInt_index++;
                    VersionModel *temp1 =[array2 objectAtIndex:m];
                    if (m==0) {
                        TreeJob_level0_model *nodeData = node0.nodeData;
                        nodeData.mStr_title = temp1.VersionName;
                        nodeData.mStr_id = temp1.VersionCode;
                        temp1.mInt_select = 1;
                    }else{
                        temp1.mInt_select = 0;
                    }
                    node1.nodeData = temp1;
                    //塞入数据
                    [node0.sonNodes addObject:node1];
                }
            }else if (node0.flag == 3) {//往章节选择中插入
                [node0.sonNodes removeAllObjects];
                for (int m=0; m<array3.count; m++) {
                    //第1根节点
                    TreeJob_node *node1 = [[TreeJob_node alloc]init];
                    node1.nodeLevel = 1;//节点所处层次
                    node1.type = 1;//节点类型
                    node1.flag = 501;//标注当前是哪个节点
                    node1.faType = node0.flag;//父节点
                    node1.isExpanded = FALSE;//节点是否展开
                    node1.mInt_index = self.mInt_index;//全局索引标识
                    self.mInt_index++;
                    ChapterModel *temp1 =[array3 objectAtIndex:m];
                    if (m==0) {
                        TreeJob_level0_model *nodeData = node0.nodeData;
                        nodeData.mStr_title = temp1.chapterName;
                        nodeData.mStr_id = temp1.chapterCode;
                        temp1.mInt_select = 1;
                    }else{
                        temp1.mInt_select = 0;
                    }
                    node1.nodeData = temp1;
                    //塞入数据
                    [node0.sonNodes addObject:node1];
                }
            }
        }
    }else if ([flag intValue]==2){//
        for (int i=0; i<self.mArr_sumData.count; i++) {
            TreeJob_node *node0 = [self.mArr_sumData objectAtIndex:i];
            if (node0.flag == 3) {//往章节选择中插入
                [node0.sonNodes removeAllObjects];
                for (int m=0; m<array3.count; m++) {
                    //第1根节点
                    TreeJob_node *node1 = [[TreeJob_node alloc]init];
                    node1.nodeLevel = 1;//节点所处层次
                    node1.type = 1;//节点类型
                    node1.flag = 501;//标注当前是哪个节点
                    node1.faType = node0.flag;//父节点
                    node1.isExpanded = FALSE;//节点是否展开
                    node1.mInt_index = self.mInt_index;//全局索引标识
                    self.mInt_index++;
                    ChapterModel *temp1 =[array3 objectAtIndex:m];
                    if (m==0) {
                        TreeJob_level0_model *nodeData = node0.nodeData;
                        nodeData.mStr_title = temp1.chapterName;
                        nodeData.mStr_id = temp1.TabID;
                        temp1.mInt_select = 1;
                    }else{
                        temp1.mInt_select = 0;
                    }
                    node1.nodeData = temp1;
                    //塞入数据
                    [node0.sonNodes addObject:node1];
                }
            }
        }
    }
    TreeView_node *tempNode0 = [self.mArr_sumData objectAtIndex:1];
    TreeJob_level0_model *tempModel0 = tempNode0.nodeData;
    if (tempModel0.mStr_id>0) {
        self.mStr_textName = tempModel0.mStr_title;
    }
    TreeView_node *tempNode1 = [self.mArr_sumData objectAtIndex:3];
    TreeJob_level0_model *tempModel1 = tempNode1.nodeData;
    if (tempModel1.mStr_id>0) {
        self.mStr_textName = [NSString stringWithFormat:@"%@%@",self.mStr_textName,tempModel1.mStr_title];
    }
    self.mStr_textName = [NSString stringWithFormat:@"%@练习",self.mStr_textName];
    [self reloadDataForDisplayArray];
}

//初始化将要显示的数据
-(void)reloadDataForDisplayArray{
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    for (TreeJob_node *node in self.mArr_sumData) {
        [tmp addObject:node];
        if(node.isExpanded){
            for(TreeJob_node *node2 in node.sonNodes){
                [tmp addObject:node2];
            }
        }
    }
    self.mArr_display = [NSArray arrayWithArray:tmp];
    [self.mTableV_list reloadData];
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.mInt_index==0) {
        return self.mArr_homework.count;
    } else {
        if (self.mArr_practice.count>0) {
            return self.mArr_practice.count;
        }
        return self.mArr_display.count;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"StudentHomework_TableViewCell";
    static NSString *TreeJob_default_indentifier = @"TreeJob_default_TableViewCell";
    static NSString *TreeJob_sigleSelect_indentifier = @"TreeJob_sigleSelect_TableViewCell";//年级、科目、教版、章节的单选cell
    static NSString *PublishJobIdentifier = @"PublishJobIdentifier";//作业发布cell
    static NSString *OtherItemIdentifer = @"OtherItemIdentifer";//其他项目cell重用标志
    if (self.mInt_index ==0||self.mArr_practice.count>0) {
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
        StuHWModel *model;
        if (self.mInt_index == 0) {
            model = [self.mArr_homework objectAtIndex:indexPath.row];
        }else{
            model = [self.mArr_practice objectAtIndex:indexPath.row];
        }
        if ([model.isHaveAdd intValue]==1) {//主观题
            cell.mImg_pic.frame = CGRectMake(8, 10, 14, 14);
        }else{
            cell.mImg_pic.frame = CGRectMake(8, 10, 0, 0);
        }
        //名称
        cell.mLab_title.text = model.homeworkName;
        cell.mLab_title.frame  = CGRectMake(cell.mImg_pic.frame.origin.x+cell.mImg_pic.frame.size.width+5, 10, [dm getInstance].width-cell.mImg_pic.frame.origin.x-cell.mImg_pic.frame.size.width-10, cell.mLab_title.frame.size.height);
        //题量
        cell.mLab_numLab.frame = CGRectMake(8, cell.mLab_title.frame.origin.y+cell.mLab_title.frame.size.height, cell.mLab_numLab.frame.size.width, cell.mLab_numLab.frame.size.height);
        cell.mLab_num.text = model.itemNumber;
        CGSize numSize = [model.itemNumber sizeWithFont:[UIFont systemFontOfSize:10]];
        cell.mLab_num.frame = CGRectMake(cell.mLab_numLab.frame.origin.x+cell.mLab_numLab.frame.size.width, cell.mLab_numLab.frame.origin.y, numSize.width, cell.mLab_num.frame.size.height);
        //过期时间
        cell.mLab_timeLab.frame = CGRectMake(cell.mLab_num.frame.origin.x+cell.mLab_num.frame.size.width+6, cell.mLab_numLab.frame.origin.y, cell.mLab_timeLab.frame.size.width, cell.mLab_timeLab.frame.size.height);
        cell.mLab_time.text = model.EXPIRYDATE;
        D("dfuhguhj-====%@,%@",model.EXPIRYDATE,model.isHWFinish);
        CGSize timeSize = [model.EXPIRYDATE sizeWithFont:[UIFont systemFontOfSize:10]];
        cell.mLab_time.frame  = CGRectMake(cell.mLab_timeLab.frame.origin.x+cell.mLab_timeLab.frame.size.width, cell.mLab_numLab.frame.origin.y, timeSize.width, cell.mLab_time.frame.size.height);
        //判断是否做完
        if ([model.isHWFinish intValue]==1) {//完成
            cell.mLab_goto.hidden = YES;
            cell.mLab_power.hidden = NO;
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
            cell.mLab_goto.frame = CGRectMake([dm getInstance].width-9-cell.mLab_goto.frame.size.width, cell.mLab_numLab.frame.origin.y, cell.mLab_goto.frame.size.width, cell.mLab_goto.frame.size.height);
        }
        //分割线
        cell.mLab_line.frame = CGRectMake(0, cell.mLab_numLab.frame.origin.y+cell.mLab_numLab.frame.size.height+5, [dm getInstance].width, cell.mLab_line.frame.size.height);
        
        return cell;
    }else{
        TreeJob_node *node = [self.mArr_display objectAtIndex:indexPath.row];
        if(node.type == 0){//类型为0的cell,一级列表
            if (node.flag == 5){//发布练习
                PublishJobCellTableViewCell *cell = (PublishJobCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:PublishJobIdentifier];
                if (cell == nil) {
                    cell = [[PublishJobCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PublishJobIdentifier];
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PublishJobCellTableViewCell" owner:self options:nil];
                    //这时myCell对象已经通过自定义xib文件生成了
                    if ([nib count]>0) {
                        cell = (PublishJobCellTableViewCell *)[nib objectAtIndex:0];
                        //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
                    }
                    
                    //添加图片点击事件
                    //若是需要重用，需要写上以下两句代码
                    UINib * n= [UINib nibWithNibName:@"PublishJobCellTableViewCell" bundle:[NSBundle mainBundle]];
                    [self.mTableV_list registerNib:n forCellReuseIdentifier:PublishJobIdentifier];
                }
                cell.delegate = self;
                [cell.mBtn_send setTitle:@"发布练习" forState:UIControlStateNormal];
                return cell;
            }else if(node.flag ==4){//标题更改
                OtherItemsCell *cell = (OtherItemsCell *)[tableView dequeueReusableCellWithIdentifier:OtherItemIdentifer];
                if (cell == nil) {
                    cell = [[OtherItemsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OtherItemIdentifer];
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OtherItemsCell" owner:self options:nil];
                    //这时myCell对象已经通过自定义xib文件生成了
                    if ([nib count]>0) {
                        cell = (OtherItemsCell *)[nib objectAtIndex:0];
                        //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
                    }
                    
                    //添加图片点击事件
                    //若是需要重用，需要写上以下两句代码
//                    UINib * n= [UINib nibWithNibName:@"OtherItemsCell" bundle:[NSBundle mainBundle]];
//                    [self.mTableV_list registerNib:n forCellReuseIdentifier:OtherItemIdentifer];
                }
                
                [self loadDataForTreeViewCell:cell with:node];//重新给cell装载数据
                [cell setNeedsDisplay]; //重新描绘cell
                
                return cell;
                
            }else{//其余下拉cell
                TreeJob_default_TableViewCell *cell = (TreeJob_default_TableViewCell *)[tableView dequeueReusableCellWithIdentifier:TreeJob_default_indentifier];
                if (cell == nil) {
                    cell = [[TreeJob_default_TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TreeJob_default_indentifier];
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TreeJob_default_TableViewCell" owner:self options:nil];
                    //这时myCell对象已经通过自定义xib文件生成了
                    if ([nib count]>0) {
                        cell = (TreeJob_default_TableViewCell *)[nib objectAtIndex:0];
                        //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
                    }
                    
                    //添加图片点击事件
                    //若是需要重用，需要写上以下两句代码
                    UINib * n= [UINib nibWithNibName:@"TreeJob_default_TableViewCell" bundle:[NSBundle mainBundle]];
                    [self.mTableV_list registerNib:n forCellReuseIdentifier:TreeJob_default_indentifier];
                }
                
                [self loadDataForTreeViewCell:cell with:node];//重新给cell装载数据
                [cell setNeedsDisplay]; //重新描绘cell
                
                return cell;
            }
        }else if(node.type == 1){//类型为1的cell,2级列表
            if (node.flag == 201||node.flag == 301||node.flag == 401||node.flag == 501||node.flag == 801) {//年级、科目、教版、章节的单选cell//自定义作业
                TreeJob_sigleSelect_TableViewCell *cell = (TreeJob_sigleSelect_TableViewCell *)[tableView dequeueReusableCellWithIdentifier:TreeJob_sigleSelect_indentifier];
                if (cell == nil) {
                    cell = [[TreeJob_sigleSelect_TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TreeJob_sigleSelect_indentifier];
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TreeJob_sigleSelect_TableViewCell" owner:self options:nil];
                    //这时myCell对象已经通过自定义xib文件生成了
                    if ([nib count]>0) {
                        cell = (TreeJob_sigleSelect_TableViewCell *)[nib objectAtIndex:0];
                        //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
                    }
                    
                    //添加图片点击事件
                    //若是需要重用，需要写上以下两句代码
                    UINib * n= [UINib nibWithNibName:@"TreeJob_sigleSelect_TableViewCell" bundle:[NSBundle mainBundle]];
                    [self.mTableV_list registerNib:n forCellReuseIdentifier:TreeJob_sigleSelect_indentifier];
                }
                cell.delegate = self;
                cell.model = node;
                [self loadDataForSigleSelectTreeViewCell:cell with:node flag:node.flag];//重新给cell装载数据
                [cell setNeedsDisplay]; //重新描绘cell
                
                return cell;
            }
            
        }
    }
    return nil;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
//    return 66;
    if (self.mInt_index==0) {
        return 66;
    } else {
        if (self.mArr_practice.count>0) {
            return 66;
        }else{
            TreeJob_node *node = [self.mArr_display objectAtIndex:indexPath.row];
            if (node.flag==5) {
                return 80;
            }
            if (node.type==0) {
                return 44;
            }
        }
        return 35;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.mInt_index==0) {
        StuHWModel *model = [self.mArr_homework objectAtIndex:indexPath.row];
        
        DetailHWViewController *detail = [[DetailHWViewController alloc]init];
        detail.TabID = model.TabID;
        detail.hwName = model.homeworkName;
        [self.navigationController pushViewController:detail animated:YES];
    }else{
        if (self.mArr_practice.count>0) {
            StuHWModel *model = [self.mArr_homework objectAtIndex:indexPath.row];
            
            DetailHWViewController *detail = [[DetailHWViewController alloc]init];
            detail.TabID = model.TabID;
            detail.hwName = model.homeworkName;
            [self.navigationController pushViewController:detail animated:YES];
        }else{
            TreeJob_node *node = [self.mArr_display objectAtIndex:indexPath.row];
            if(node.type == 0){
                TreeJob_node *node = [self.mArr_display objectAtIndex:indexPath.row];
                if (node.sonNodes.count== 0) {
                    if (node.flag ==0){
                        [MBProgressHUD showError:@"年级为空" toView:self.view];
                    }else if (node.flag ==1){
                        [MBProgressHUD showError:@"科目为空" toView:self.view];
                    }else if (node.flag ==2){
                        [MBProgressHUD showError:@"教版为空" toView:self.view];
                    }else if (node.flag ==3){
                        [MBProgressHUD showError:@"章节为空" toView:self.view];
                    }
                }else{
                    [self reloadDataForDisplayArrayChangeAt:node.flag];//修改cell的状态(关闭或打开)
                }
            }
        }
    }
}

/*---------------------------------------
 修改cell的状态(关闭或打开)
 --------------------------------------- */
-(void) reloadDataForDisplayArrayChangeAt:(NSInteger)row{
    for (TreeJob_node *node in self.mArr_sumData) {
        if(node.flag == row){
            node.isExpanded = !node.isExpanded;
        }
    }
    [self reloadDataForDisplayArray];
}

/*---------------------------------------
 为不同类型cell填充数据
 --------------------------------------- */
-(void) loadDataForTreeViewCell:(UITableViewCell*)cell with:(TreeJob_node*)node{
    if(node.type == 0){
        TreeJob_default_TableViewCell *cell0 = (TreeJob_default_TableViewCell*)cell;
        
        if(node.flag ==4){
            OtherItemsCell *cell0 = (OtherItemsCell*)cell;
            cell0.mLab_line.frame = CGRectMake(0, 0, [dm getInstance].width, 5);
            cell0.titleLabel.text = @"标题更改";
            cell0.titleLabel.font = [UIFont systemFontOfSize:14];
            cell0.titleLabel.textColor = [UIColor colorWithRed:33/255.0 green:41/255.0 blue:43/255.0 alpha:1];
            cell0.titleLabel.frame = CGRectMake(20, 15, 80, 21);
            cell0.textField.frame = CGRectMake(90, 8, [dm getInstance].width-110, 31);
            cell0.textField.text = self.mStr_textName;
        }else{
            cell0.mLab_title.hidden = NO;
            cell0.mLab_select.hidden = NO;
            cell0.mLab_line.hidden = NO;
            cell0.mImg_pic.hidden = NO;
            TreeJob_level0_model *nodeData = node.nodeData;
            cell0.mLab_title.text = nodeData.mStr_name;
            cell0.mLab_title.frame = CGRectMake(20, 15, 80, 21);
            cell0.mLab_select.text = nodeData.mStr_title;
            cell0.mLab_select.frame = CGRectMake(90, 15, [dm getInstance].width-110, 21);
            cell0.mImg_pic.frame = CGRectMake([dm getInstance].width-20, 20, 10, 10);
            if (node.isExpanded) {
                [cell0.mImg_pic setImage:[UIImage imageNamed:@"homework_down0"]];
            }else{
                [cell0.mImg_pic setImage:[UIImage imageNamed:@"homework_down1"]];
            }
        }
    }
}

-(void)loadDataForSigleSelectTreeViewCell:(UITableViewCell*)cell with:(TreeJob_node*)node flag:(int)flag{
    TreeJob_sigleSelect_TableViewCell *cell0 = (TreeJob_sigleSelect_TableViewCell*)cell;
    NSString *name = @"";
    if (flag==201) {//年级
        GradeModel *model = node.nodeData;
        cell0.sigleBtn.mLab_title.text = model.GradeName;
        cell0.sigleBtn.mInt_flag = model.mInt_select;//是否选择
        name = model.GradeName;
    }else if (flag==301){//科目
        SubjectModel *model = node.nodeData;
        cell0.sigleBtn.mLab_title.text = model.subjectName;
        cell0.sigleBtn.mInt_flag = model.mInt_select;//是否选择
        name = model.subjectName;
    }else if (flag==401){//教版
        VersionModel *model = node.nodeData;
        cell0.sigleBtn.mLab_title.text = model.VersionName;
        cell0.sigleBtn.mInt_flag = model.mInt_select;//是否选择
        name = model.VersionName;
    }else if (flag==501){//章节
        ChapterModel *model = node.nodeData;
        cell0.sigleBtn.mLab_title.text = model.chapterName;
        cell0.sigleBtn.mInt_flag = model.mInt_select;//是否选择
        name = model.chapterName;
    }
    
    if (cell0.sigleBtn.mInt_flag ==1) {
        [cell0.sigleBtn.mImg_head setImage:[UIImage imageNamed:@"sigleSelect1"]];
    }else{
        [cell0.sigleBtn.mImg_head setImage:[UIImage imageNamed:@"sigleSelect0"]];
    }
    cell0.mLab_line.frame = CGRectMake(20, 0, [dm getInstance].width-20, .5);
    CGSize titleSize = [name sizeWithFont:[UIFont systemFontOfSize:12]];
    if ([dm getInstance].width-40<titleSize.width+16) {
        titleSize.width = [dm getInstance].width-40-16;
    }
    cell0.sigleBtn.mLab_title.frame = CGRectMake(16, 0, titleSize.width, cell0.sigleBtn.mLab_title.frame.size.height);
    cell0.sigleBtn.frame = CGRectMake(30, 8, cell0.sigleBtn.mLab_title.frame.origin.x+titleSize.width, cell0.sigleBtn.frame.size.height);
}

//年级、科目、教版、章节的单选cell回调
-(void)TreeJob_sigleSelect_TableViewCellClick:(TreeJob_sigleSelect_TableViewCell *)treeJob_sigleSelect_TableViewCell{
    TreeJob_node *tempNode = treeJob_sigleSelect_TableViewCell.model;
    for (TreeJob_node *node in self.mArr_sumData) {
        if (node.flag == tempNode.faType&&node.flag==0) {//年级
            for (TreeView_node *node1 in node.sonNodes) {
                GradeModel *model = node1.nodeData;
                GradeModel *model1 = tempNode.nodeData;
                if ([model.GradeCode intValue]==[model1.GradeCode intValue]) {
                    model.mInt_select = 1;
                    TreeJob_level0_model *nodeData = node.nodeData;
                    nodeData.mStr_title = model1.GradeName;
                    nodeData.mStr_id = model1.GradeCode;
                    [self reloadDataForDisplayArrayChangeAt:node.flag];//修改cell的状态(关闭或打开)
                    [[OnlineJobHttp getInstance]GetUnionChapterListWithgCode:model1.GradeCode subCode:@"0" uId:@"0" flag:@"0"];
                    //给默认空值
                    TreeView_node *tempNode1 = [self.mArr_sumData objectAtIndex:1];
                    TreeJob_level0_model *tempModel1 = tempNode1.nodeData;
                    tempModel1.mStr_title = @"没有科目";
                    tempModel1.mStr_id = 0;
                    TreeView_node *tempNode2 = [self.mArr_sumData objectAtIndex:2];
                    TreeJob_level0_model *tempModel2 = tempNode2.nodeData;
                    tempModel2.mStr_title = @"没有教版";
                    tempModel2.mStr_id = 0;
                    TreeView_node *tempNode3 = [self.mArr_sumData objectAtIndex:3];
                    TreeJob_level0_model *tempModel3 = tempNode3.nodeData;
                    tempModel3.mStr_title = @"没有章节";
                    tempModel3.mStr_id = 0;
                }else{
                    model.mInt_select = 0;
                }
            }
        }else if (node.flag == tempNode.faType&&node.flag==1) {//科目
            for (TreeView_node *node1 in node.sonNodes) {
                SubjectModel *model = node1.nodeData;
                SubjectModel *model1 = tempNode.nodeData;
                if ([model.subjectCode intValue]==[model1.subjectCode intValue]) {
                    model.mInt_select = 1;
                    TreeJob_level0_model *nodeData = node.nodeData;
                    nodeData.mStr_title = model1.subjectName;
                    nodeData.mStr_id = model1.subjectCode;
                    [self reloadDataForDisplayArrayChangeAt:node.flag];//修改cell的状态(关闭或打开)
                    
                    TreeView_node *tempNode = [self.mArr_sumData objectAtIndex:0];
                    TreeJob_level0_model *tempModel = tempNode.nodeData;
                    [[OnlineJobHttp getInstance]GetUnionChapterListWithgCode:tempModel.mStr_id subCode:model1.subjectCode uId:@"0" flag:@"1"];
                    //给默认空值
                    TreeView_node *tempNode2 = [self.mArr_sumData objectAtIndex:2];
                    TreeJob_level0_model *tempModel2 = tempNode2.nodeData;
                    tempModel2.mStr_title = @"没有教版";
                    tempModel2.mStr_id = 0;
                    TreeView_node *tempNode3 = [self.mArr_sumData objectAtIndex:3];
                    TreeJob_level0_model *tempModel3 = tempNode3.nodeData;
                    tempModel3.mStr_title = @"没有章节";
                    tempModel3.mStr_id = 0;
                }else{
                    model.mInt_select = 0;
                }
            }
        }else if (node.flag == tempNode.faType&&node.flag==2) {//教版
            for (TreeView_node *node1 in node.sonNodes) {
                VersionModel *model = node1.nodeData;
                VersionModel *model1 = tempNode.nodeData;
                if ([model.TabID intValue]==[model1.TabID intValue]) {
                    model.mInt_select = 1;
                    TreeJob_level0_model *nodeData = node.nodeData;
                    nodeData.mStr_title = model1.VersionName;
                    nodeData.mStr_id = model1.TabID;
                    [self reloadDataForDisplayArrayChangeAt:node.flag];//修改cell的状态(关闭或打开)
                    
                    TreeView_node *tempNode = [self.mArr_sumData objectAtIndex:0];
                    TreeJob_level0_model *tempModel = tempNode.nodeData;
                    TreeView_node *tempNode1 = [self.mArr_sumData objectAtIndex:1];
                    TreeJob_level0_model *tempModel1 = tempNode1.nodeData;
                    [[OnlineJobHttp getInstance]GetUnionChapterListWithgCode:tempModel.mStr_id subCode:tempModel1.mStr_id uId:model1.TabID flag:@"2"];
                    //给默认空值
                    TreeView_node *tempNode3 = [self.mArr_sumData objectAtIndex:3];
                    TreeJob_level0_model *tempModel3 = tempNode3.nodeData;
                    tempModel3.mStr_title = @"没有章节";
                    tempModel3.mStr_id = 0;
                }else{
                    model.mInt_select = 0;
                }
            }
        }else if (node.flag == tempNode.faType&&node.flag==3) {//章节
            for (TreeView_node *node1 in node.sonNodes) {
                ChapterModel *model = node1.nodeData;
                ChapterModel *model1 = tempNode.nodeData;
                if ([model.TabID intValue]==[model1.TabID intValue]) {
                    model.mInt_select = 1;
                    TreeJob_level0_model *nodeData = node.nodeData;
                    nodeData.mStr_title = model1.chapterName;
                    nodeData.mStr_id = model1.TabID;
                    [self reloadDataForDisplayArrayChangeAt:node.flag];//修改cell的状态(关闭或打开)
                }else{
                    model.mInt_select = 0;
                }
            }
        }
    }
    TreeView_node *tempNode0 = [self.mArr_sumData objectAtIndex:1];
    TreeJob_level0_model *tempModel0 = tempNode0.nodeData;
    if (tempModel0.mStr_id>0) {
        self.mStr_textName = tempModel0.mStr_title;
    }
    TreeView_node *tempNode1 = [self.mArr_sumData objectAtIndex:3];
    TreeJob_level0_model *tempModel1 = tempNode1.nodeData;
    if (tempModel1.mStr_id>0) {
        self.mStr_textName = [NSString stringWithFormat:@"%@%@",self.mStr_textName,tempModel1.mStr_title];
    }
    self.mStr_textName = [NSString stringWithFormat:@"%@练习",self.mStr_textName];
    
    [self reloadDataForDisplayArray];
}

//发布练习按钮回调
-(void)PublishJob{
    //年级
    TreeView_node *tempNode0 = [self.mArr_sumData objectAtIndex:0];
    TreeJob_level0_model *tempModel0 = tempNode0.nodeData;
    if ([tempModel0.mStr_id intValue]==0) {
        [MBProgressHUD showError:@"请选择年级"];
        return ;
    }
    //科目
    TreeView_node *tempNode1 = [self.mArr_sumData objectAtIndex:1];
    TreeJob_level0_model *tempModel1 = tempNode1.nodeData;
    if ([tempModel1.mStr_id intValue]==0) {
        [MBProgressHUD showError:@"请选择科目"];
        return ;
    }
    //教版
    TreeView_node *tempNode2 = [self.mArr_sumData objectAtIndex:2];
    TreeJob_level0_model *tempModel2 = tempNode2.nodeData;
    if ([tempModel2.mStr_id intValue]==0) {
        [MBProgressHUD showError:@"请选择教版"];
        return ;
    }
    //章节
    TreeView_node *tempNode3 = [self.mArr_sumData objectAtIndex:3];
    TreeJob_level0_model *tempModel3 = tempNode3.nodeData;
    if ([tempModel3.mStr_id intValue]==0) {
        [MBProgressHUD showError:@"请选择章节"];
        return ;
    }
    if (self.mStr_textName.length<6||self.mStr_textName.length>49) {
        [MBProgressHUD showError:@"练习名称为6--49个字符"];
        return ;
    }
    //联合id
    NSString *tempId = [NSString stringWithFormat:@"%@%@%@",tempModel0.mStr_id,tempModel1.mStr_id,tempModel2.mStr_id];
    
    [[OnlineJobHttp getInstance] StuMakeSelfWithStuId:self.mModel_stuInf.StudentID classID:self.mModel_stuInf.ClassNo className:self.mModel_stuInf.ClassName Unid:tempId chapterID:tempModel3.mStr_id homeworkName:self.mStr_textName schoolName:@""];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.mStr_textName = textField.text;
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing{
    if (self.mInt_index==0) {//获取作业列表
        [self.mArr_homework removeAllObjects];
        //获取
        [[OnlineJobHttp getInstance] GetStuHWListWithStuId:self.mModel_stuInf.StudentID IsSelf:@"0"];
        [MBProgressHUD showMessage:@"" toView:self.view];
    }else{//获取练习列表
        //先判断是现实练习列表，还是布置练习
        if (self.mArr_practice.count>0) {
            [self.mArr_practice removeAllObjects];
            //获取
            [[OnlineJobHttp getInstance] GetStuHWListWithStuId:self.mModel_stuInf.StudentID IsSelf:@"1"];
            [MBProgressHUD showMessage:@"" toView:self.view];
        }else{
            //判断是否获取到了年级列表
            for (int i=0; i<self.mArr_sumData.count; i++) {
                TreeJob_node *node0 = [self.mArr_sumData objectAtIndex:i];
                if (node0.flag == 0) {
                    if (node0.sonNodes.count==0) {
                        //获取年级列表
                        [[OnlineJobHttp getInstance] GetGradeList];
                    }
                }
            }
            [self.mTableV_list headerEndRefreshing];
            [self.mTableV_list footerEndRefreshing];
        }
    }
    [self.mTableV_list reloadData];
}

- (void)footerRereshing{
    
}

//导航条返回按钮回调
-(void)myNavigationGoback{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //输入框弹出键盘问题
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;//控制整个功能是否启用
    manager.shouldResignOnTouchOutside = NO;//控制点击背景是否收起键盘
    manager.shouldToolbarUsesTextFieldTintColor = NO;//控制键盘上的工具条文字颜色是否用户自定义
    manager.enableAutoToolbar = NO;//控制是否显示键盘上的工具条
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
