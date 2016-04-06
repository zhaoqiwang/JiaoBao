//
//  SelectChapteridViewController.m
//  JiaoBao
//
//  Created by Zqw on 16/3/18.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "SelectChapteridViewController.h"

@interface SelectChapteridViewController ()

@end

@implementation SelectChapteridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //获取年级列表
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetGradeList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetGradeList:) name:@"GetGradeList" object:nil];
    //获取联动列表
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetUnionChapterList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetUnionChapterList:) name:@"GetUnionChapterList" object:nil];
    
    self.mArr_sumData = [NSMutableArray array];
    self.mArr_display = [NSMutableArray array];
    self.publishJobModel = [[PublishJobModel alloc] init];
    
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"筛选条件"];
    [self.mNav_navgationBar setGoBack];
    [self.mNav_navgationBar setRightBtnTitle:@"确定"];
    self.mNav_navgationBar.delegate = self;
    [self.view addSubview:self.mNav_navgationBar];
    
    self.mTableV_work.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height-[dm getInstance].statusBar, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height+[dm getInstance].statusBar);
    self.mTableV_work.separatorStyle = UITableViewCellSelectionStyleNone;
    //添加默认数据
    [self addDefaultData];
    [self reloadDataForDisplayArray];//初始化将要显示的数据
    //获取年级列表
    [[OnlineJobHttp getInstance]GetGradeList];
    [MBProgressHUD showMessage:@"" toView:self.view];
}

//添加默认数据
-(void)addDefaultData{
    //第0根节点
    NSMutableArray *tempArr = [NSMutableArray arrayWithObjects:@"题目年级",@"科目选择",@"教版选择",@"章节选择", nil];
    for (int i=0; i<tempArr.count; i++) {
        TreeJob_node *node0 = [[TreeJob_node alloc]init];
        node0.nodeLevel = 0;//节点所处层次
        node0.type = 0;//节点类型
        node0.flag = i;//标注当前是哪个节点
        node0.mInt_index = self.mInt_index;//全局索引标识
        self.mInt_index++;
        node0.isExpanded = FALSE;//节点是否展开
        TreeJob_level0_model *temp0 =[[TreeJob_level0_model alloc]init];
        temp0.mStr_name = [tempArr objectAtIndex:i];
        node0.nodeData = temp0;//当前节点数据
        
        [self.mArr_sumData addObject:node0];
    }
}

//获取年级列表
-(void)GetGradeList:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSMutableArray *array = noti.object;
    if (array.count==0) {
        [MBProgressHUD showError:@"年级列表为空"];
    }
    for (int i=0; i<self.mArr_sumData.count; i++) {
        TreeJob_node *node0 = [self.mArr_sumData objectAtIndex:i];
        if (node0.flag == 0) {
            for (int m=0; m<array.count; m++) {
                //第1根节点
                TreeJob_node *node1 = [[TreeJob_node alloc]init];
                node1.nodeLevel = 1;//节点所处层次
                node1.type = 1;//节点类型
                node1.flag = 001;//标注当前是哪个节点
                node1.faType = node0.flag;//父节点
                node1.isExpanded = FALSE;//节点是否展开
                node1.mInt_index = self.mInt_index;//全局索引标识
                self.mInt_index++;
                GradeModel *temp1 =[array objectAtIndex:m];
                if (m==0) {
                    TreeJob_level0_model *nodeData = node0.nodeData;
                    nodeData.mStr_title = temp1.GradeName;
                    nodeData.mStr_id = temp1.GradeCode;
                    self.publishJobModel.GradeCode = temp1.GradeCode;
                    self.publishJobModel.GradeName = temp1.GradeName;
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
                [self addChapterList:node0 array:array1 flag:101 type:1];
            }else if (node0.flag == 2) {//往教版选择中插入
                [self addChapterList:node0 array:array2 flag:201 type:2];
            }else if (node0.flag == 3) {//往章节选择中插入
                [self addChapterList:node0 array:array3 flag:301 type:3];
            }
        }
    }else if ([flag intValue]==1){//
        for (int i=0; i<self.mArr_sumData.count; i++) {
            TreeJob_node *node0 = [self.mArr_sumData objectAtIndex:i];
            if (node0.flag == 2) {//往教版选择中插入
                [self addChapterList:node0 array:array2 flag:201 type:2];
            }else if (node0.flag == 3) {//往章节选择中插入
                [self addChapterList:node0 array:array3 flag:301 type:3];
            }
        }
    }else if ([flag intValue]==2){//
        for (int i=0; i<self.mArr_sumData.count; i++) {
            TreeJob_node *node0 = [self.mArr_sumData objectAtIndex:i];
            if (node0.flag == 3) {//往章节选择中插入
                [self addChapterList:node0 array:array3 flag:301 type:3];
            }
        }
    }
    [self reloadDataForDisplayArray];
}

-(void)addChapterList:(TreeJob_node *)node0 array:(NSMutableArray *)array flag:(int)flag type:(int)type{
    [node0.sonNodes removeAllObjects];
    if (type==3) {
        TreeJob_level0_model *nodeData = node0.nodeData;
        if (array.count==0) {
            nodeData.mStr_title = @"没有章节";
        }
    }
    for (int m=0; m<array.count; m++) {
        //第1根节点
        TreeJob_node *node1 = [[TreeJob_node alloc]init];
        node1.nodeLevel = 1;//节点所处层次
        node1.type = 1;//节点类型
        node1.flag = flag;//标注当前是哪个节点
        node1.faType = node0.flag;//父节点
        node1.isExpanded = FALSE;//节点是否展开
        node1.mInt_index = self.mInt_index;//全局索引标识
        self.mInt_index++;
        if (type==1) {
            SubjectModel *temp1 =[array objectAtIndex:m];
            if (m==0) {
                TreeJob_level0_model *nodeData = node0.nodeData;
                nodeData.mStr_title = temp1.subjectName;
                nodeData.mStr_id = temp1.subjectCode;
                self.publishJobModel.subjectName = temp1.subjectName;
                self.publishJobModel.subjectCode = temp1.subjectCode;
                self.publishJobModel.VersionName = @"";
                self.publishJobModel.VersionCode = @"0";
                self.publishJobModel.chapterName = @"";
                self.publishJobModel.chapterID = @"0";
                temp1.mInt_select = 1;
            }else{
                temp1.mInt_select = 0;
            }
            node1.nodeData = temp1;
        }else if (type==2){
            VersionModel *temp1 =[array objectAtIndex:m];
            if (m==0) {
                TreeJob_level0_model *nodeData = node0.nodeData;
                nodeData.mStr_title = temp1.VersionName;
                nodeData.mStr_id = temp1.TabID;
                self.publishJobModel.VersionName = temp1.VersionName;
                self.publishJobModel.VersionCode = temp1.TabID;
                self.publishJobModel.chapterName = @"";
                self.publishJobModel.chapterID = @"0";
                temp1.mInt_select = 1;
            }else{
                temp1.mInt_select = 0;
            }
            node1.nodeData = temp1;
        }else if (type==3) {
            ChapterModel *temp1 =[array objectAtIndex:m];
            if (m==0) {
                TreeJob_level0_model *nodeData = node0.nodeData;
                nodeData.mStr_title = temp1.chapterName;
                nodeData.mStr_id = temp1.TabID;
                self.publishJobModel.chapterName = temp1.chapterName;
                self.publishJobModel.chapterID = temp1.TabID;
                temp1.mInt_select = 1;
            }else{
                temp1.mInt_select = 0;
            }
            node1.nodeData = temp1;
        }
        //塞入数据
        [node0.sonNodes addObject:node1];
    }
}

//初始化将要显示的数据
-(void)reloadDataForDisplayArray{
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    for (TreeJob_node *node in self.mArr_sumData) {
        [tmp addObject:node];
        if(node.isExpanded){
            for(TreeJob_node *node2 in node.sonNodes){
                [tmp addObject:node2];
                if (node2.flag == 301) {
                    ChapterModel *model = node2.nodeData;
                    [self addArrayChapter:model array:tmp];
                }
            }
        }
    }
    self.mArr_display = [NSArray arrayWithArray:tmp];
    [self.mTableV_work reloadData];
}
-(void)addArrayChapter:(ChapterModel *)model array:(NSMutableArray *)array{
    if (model.isExpanded) {
        for (ChapterModel *temp1 in model.array) {
            [array addObject:temp1];
            [self addArrayChapter:temp1 array:array];
        }
    }
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mArr_display.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"TreeJob_default_TableViewCell";
    static NSString *TreeJob_sigleSelect_indentifier = @"TreeJob_sigleSelect_TableViewCell";//年级、科目、教版、章节的单选cell
    
    //    static NSString *indentifier1 = @"TreeView_Level1_Cell";
    //    static NSString *indentifier2 = @"TreeView_Level2_Cell";
    id node1 = [self.mArr_display objectAtIndex:indexPath.row];
    if ([node1 isKindOfClass:[ChapterModel class]]) {
        ChapterModel *model = [self.mArr_display objectAtIndex:indexPath.row];
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
            [self.mTableV_work registerNib:n forCellReuseIdentifier:TreeJob_sigleSelect_indentifier];
        }
        cell.delegate = self;
        cell.model = model;
        [self loadDataForSigleSelectTreeViewCell1:cell with:model flag:301];//重新给cell装载数据
        [cell setNeedsDisplay]; //重新描绘cell
        
        return cell;
    }
    TreeJob_node *node = [self.mArr_display objectAtIndex:indexPath.row];
    if(node.type == 0){//类型为0的cell,一级列表
            TreeJob_default_TableViewCell *cell = (TreeJob_default_TableViewCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
            if (cell == nil) {
                cell = [[TreeJob_default_TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TreeJob_default_TableViewCell" owner:self options:nil];
                //这时myCell对象已经通过自定义xib文件生成了
                if ([nib count]>0) {
                    cell = (TreeJob_default_TableViewCell *)[nib objectAtIndex:0];
                    //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
                }
                
                //添加图片点击事件
                //若是需要重用，需要写上以下两句代码
                UINib * n= [UINib nibWithNibName:@"TreeJob_default_TableViewCell" bundle:[NSBundle mainBundle]];
                [self.mTableV_work registerNib:n forCellReuseIdentifier:indentifier];
            }
            
            [self loadDataForTreeViewCell:cell with:node];//重新给cell装载数据
            [cell setNeedsDisplay]; //重新描绘cell
            
            return cell;
    }else if(node.type == 1){//类型为1的cell,2级列表
        if (node.flag == 001||node.flag == 101||node.flag == 201||node.flag == 301) {//年级、科目、教版、章节的单选cell
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
                [self.mTableV_work registerNib:n forCellReuseIdentifier:TreeJob_sigleSelect_indentifier];
            }
            cell.delegate = self;
            cell.model = node;
            [self loadDataForSigleSelectTreeViewCell:cell with:node flag:node.flag];//重新给cell装载数据
            [cell setNeedsDisplay]; //重新描绘cell
            
            return cell;
        }
    }
    return nil;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
//    id node1 = [self.mArr_display objectAtIndex:indexPath.row];
//    if ([node1 isKindOfClass:[TreeJob_node class]]) {
//        TreeJob_node *node = [self.mArr_display objectAtIndex:indexPath.row];
//        if (node.type == 0) {
//            if (self.mInt_modeSelect==0||self.mInt_modeSelect==1||self.mInt_modeSelect == 2) {//个性作业,//统一作业、AB卷
//                if (node.flag==8) {//自定义作业
//                    return 0;
//                }
//                else if (node.flag == 11)
//                {
//                    return 150;
//                }
//            }else if (self.mInt_modeSelect==3){//自定义作业
//                if (node.flag==6||node.flag==7) {
//                    return 0;
//                }
//                else if (node.flag == 11)
//                {
//                    return 150;
//                }
//            }
//            return 44;
//        }else if (node.type == 1){
//            if (node.flag == 101) {
//                if (self.mInt_modeSelect == 0) {//个性作业
//                    return 65;
//                }else{//统一作业、自定义作业
//                    return 35;
//                }
//            }else if (node.flag == 9999){//
//                if (self.mInt_modeSelect == 1||self.mInt_modeSelect == 2) {//统一作业、AB卷
//                    return 35;
//                }
//                return 0;
//            }else if(node.flag == 300){
//                return 70;
//            }else{
//                return 35;
//            }
//        }
//    }else{
//        return 35;
//    }
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id node1 = [self.mArr_display objectAtIndex:indexPath.row];
    if ([node1 isKindOfClass:[TreeJob_node class]]) {
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
                if (node.flag==301) {
                    ChapterModel *model = node.nodeData;
                    [self reloadDataForDisplayArrayChangeAt1:model.TabID];//修改章节cell的状态(关闭或打开)
                }else{
                    [self reloadDataForDisplayArrayChangeAt:node.flag];//修改cell的状态(关闭或打开)
                }
            }
        }else{
            if (node.flag==301) {
                ChapterModel *model = node.nodeData;
                [self reloadDataForDisplayArrayChangeAt1:model.TabID];//修改章节cell的状态(关闭或打开)
            }else{
                [self reloadDataForDisplayArrayChangeAt:node.flag];//修改cell的状态(关闭或打开)
            }
        }
    }else{
        ChapterModel *model = [self.mArr_display objectAtIndex:indexPath.row];
        [self reloadDataForDisplayArrayChangeAt1:model.TabID];//修改章节cell的状态(关闭或打开)
    }
}

-(void) reloadDataForDisplayArrayChangeAt1:(NSString *)tableID{
    for (TreeJob_node *node in self.mArr_sumData) {
        if(node.flag == 3){
            for(TreeJob_node *node2 in node.sonNodes){
                ChapterModel *model = node2.nodeData;
                if ([model.TabID isEqualToString:tableID]) {
                    model.isExpanded = !model.isExpanded;
                    break;
                }else{
                    [self addArrayChapter1:[tableID intValue] array:model.array];
                }
            }
        }
    }
    [self reloadDataForDisplayArray];
}

-(void)addArrayChapter1:(NSInteger)tableID array:(NSMutableArray *)array{
    for (ChapterModel *temp1 in array) {
        if ([temp1.TabID intValue]==tableID) {
            temp1.isExpanded = !temp1.isExpanded;
            break;
        }else{
            [self addArrayChapter1:tableID array:temp1.array];
        }
    }
}

/*---------------------------------------
 为不同类型cell填充数据
 --------------------------------------- */
-(void) loadDataForTreeViewCell:(UITableViewCell*)cell with:(TreeJob_node*)node{
    if(node.type == 0){
        TreeJob_default_TableViewCell *cell0 = (TreeJob_default_TableViewCell*)cell;
        
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
    }else if (node.type == 1){
        TreeJob_default_TableViewCell *cell0 = (TreeJob_default_TableViewCell*)cell;
        TreeJob_level0_model *nodeData = node.nodeData;
        cell0.mLab_title.text = nodeData.mStr_name;
        cell0.mLab_title.frame = CGRectMake(20, 15, 80, 21);
    }
}

-(void)loadDataForSigleSelectTreeViewCell1:(UITableViewCell*)cell with:(ChapterModel*)model flag:(int)flag{
    TreeJob_sigleSelect_TableViewCell *cell0 = (TreeJob_sigleSelect_TableViewCell*)cell;
    NSString *name = @"";
//    if (flag==301){//章节
        //        ChapterModel *model = node.nodeData;
        cell0.sigleBtn.mLab_title.text = model.chapterName;
        cell0.sigleBtn.mInt_flag = model.mInt_select;//是否选择
        name = model.chapterName;
//    }
    
    if (cell0.sigleBtn.mInt_flag ==1) {
        [cell0.sigleBtn.mImg_head setImage:[UIImage imageNamed:@"sigleSelect1"]];
    }else{
        [cell0.sigleBtn.mImg_head setImage:[UIImage imageNamed:@"sigleSelect0"]];
    }
    cell0.mLab_line.frame = CGRectMake(20, 0, [dm getInstance].width-20, .5);
    CGSize titleSize = [name sizeWithFont:[UIFont systemFontOfSize:12]];
    if ([dm getInstance].width-40-(30+20*model.mInt_flag)<titleSize.width+16) {
        titleSize.width = [dm getInstance].width-40-(30+20*model.mInt_flag);
    }
    cell0.sigleBtn.mLab_title.frame = CGRectMake(16, 0, titleSize.width, cell0.sigleBtn.mLab_title.frame.size.height);
    if (flag==301) {//章节
        //        ChapterModel *model = node.nodeData;
        cell0.sigleBtn.frame = CGRectMake(30+20*model.mInt_flag, 8, cell0.sigleBtn.mLab_title.frame.origin.x+titleSize.width, cell0.sigleBtn.frame.size.height);
        
        if (model.array.count>0) {
            cell0.mImg_pic.hidden = NO;
            cell0.mImg_pic.frame = CGRectMake([dm getInstance].width-20, 10, 10, 10);
            [cell0.mImg_pic setImage:[UIImage imageNamed:@"homework_down0"]];
            if (model.isExpanded) {
                [cell0.mImg_pic setImage:[UIImage imageNamed:@"homework_down0"]];
            }else{
                [cell0.mImg_pic setImage:[UIImage imageNamed:@"homework_down1"]];
            }
        }else{
            cell0.mImg_pic.hidden = YES;
        }
    }else{
        cell0.mImg_pic.hidden = YES;
        cell0.sigleBtn.frame = CGRectMake(30, 8, cell0.sigleBtn.mLab_title.frame.origin.x+titleSize.width, cell0.sigleBtn.frame.size.height);
    }
}

-(void)loadDataForSigleSelectTreeViewCell:(UITableViewCell*)cell with:(TreeJob_node*)node flag:(int)flag{
    TreeJob_sigleSelect_TableViewCell *cell0 = (TreeJob_sigleSelect_TableViewCell*)cell;
    NSString *name = @"";
    if (flag==001) {//年级
        GradeModel *model = node.nodeData;
        cell0.sigleBtn.mLab_title.text = model.GradeName;
        cell0.sigleBtn.mInt_flag = model.mInt_select;//是否选择
        name = model.GradeName;
    }else if (flag==101){//科目
        SubjectModel *model = node.nodeData;
        cell0.sigleBtn.mLab_title.text = model.subjectName;
        cell0.sigleBtn.mInt_flag = model.mInt_select;//是否选择
        name = model.subjectName;
    }else if (flag==201){//教版
        VersionModel *model = node.nodeData;
        cell0.sigleBtn.mLab_title.text = model.VersionName;
        cell0.sigleBtn.mInt_flag = model.mInt_select;//是否选择
        name = model.VersionName;
    }else if (flag==301){//章节
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
    if (flag==301) {//章节
        ChapterModel *model = node.nodeData;
        cell0.sigleBtn.frame = CGRectMake(30+20*model.mInt_flag, 8, cell0.sigleBtn.mLab_title.frame.origin.x+titleSize.width, cell0.sigleBtn.frame.size.height);
        if (model.array.count>0) {
            cell0.mImg_pic.hidden = NO;
            cell0.mImg_pic.frame = CGRectMake([dm getInstance].width-20, 10, 10, 10);
            [cell0.mImg_pic setImage:[UIImage imageNamed:@"homework_down0"]];
            if (model.isExpanded) {
                [cell0.mImg_pic setImage:[UIImage imageNamed:@"homework_down0"]];
            }else{
                [cell0.mImg_pic setImage:[UIImage imageNamed:@"homework_down1"]];
            }
        }else{
            cell0.mImg_pic.hidden = YES;
        }
    }else{
        cell0.mImg_pic.hidden = YES;
        cell0.sigleBtn.frame = CGRectMake(30, 8, cell0.sigleBtn.mLab_title.frame.origin.x+titleSize.width, cell0.sigleBtn.frame.size.height);
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
        //        for(TreeJob_node *node2 in node.sonNodes){
        //            if(node2.flag == row){
        //                node2.isExpanded = !node2.isExpanded;
        //            }
        //        }
    }
    [self reloadDataForDisplayArray];
}

-(void) reloadDataForDisplayArrayChangeAt2:(NSString *)tableID{
    for (TreeJob_node *node in self.mArr_sumData) {
        if(node.flag == 3){
            for(TreeJob_node *node2 in node.sonNodes){
                ChapterModel *model1 = node2.nodeData;
                if ([model1.TabID isEqualToString:tableID]) {
                    model1.mInt_select = 1;
                    TreeJob_level0_model *nodeData = node.nodeData;
                    nodeData.mStr_title = model1.chapterName;
                    nodeData.mStr_id = model1.TabID;
                    self.publishJobModel.chapterName = model1.chapterName;
                    self.publishJobModel.chapterID = model1.TabID;
                    [self addArrayChapter2:[tableID intValue] array:model1.array node:node];
                }else{
                    model1.mInt_select = 0;
                    [self addArrayChapter2:[tableID intValue] array:model1.array node:node];
                }
            }
        }
    }
    //    [self reloadDataForDisplayArray];
}

-(void)addArrayChapter2:(NSInteger)tableID array:(NSMutableArray *)array node:(TreeJob_node *)node{
    for (ChapterModel *model1 in array) {
        if ([model1.TabID intValue]==tableID) {
            model1.mInt_select = 1;
            TreeJob_level0_model *nodeData = node.nodeData;
            nodeData.mStr_title = model1.chapterName;
            nodeData.mStr_id = model1.TabID;
            self.publishJobModel.chapterName = model1.chapterName;
            self.publishJobModel.chapterID = model1.TabID;
            [self addArrayChapter2:tableID array:model1.array node:node];
        }else{
            model1.mInt_select = 0;
            [self addArrayChapter2:tableID array:model1.array node:node];
        }
    }
}

//年级、科目、教版、章节的单选cell回调
-(void)TreeJob_sigleSelect_TableViewCellClick:(TreeJob_sigleSelect_TableViewCell *)treeJob_sigleSelect_TableViewCell{
    id temp = treeJob_sigleSelect_TableViewCell.model;
    if ([temp isKindOfClass:[ChapterModel class]]) {
        ChapterModel *model = treeJob_sigleSelect_TableViewCell.model;
        [self reloadDataForDisplayArrayChangeAt2:model.TabID];
    }else if ([temp isKindOfClass:[TreeJob_node class]]) {
        TreeJob_node *tempNode = treeJob_sigleSelect_TableViewCell.model;
        for (TreeJob_node *node in self.mArr_sumData) {
            if (node.flag == tempNode.faType&&node.flag==0)  {//年级
                for (TreeView_node *node1 in node.sonNodes) {
                    GradeModel *model = node1.nodeData;
                    GradeModel *model1 = tempNode.nodeData;
                    if ([model.GradeCode intValue]==[model1.GradeCode intValue]) {
                        model.mInt_select = 1;
                        TreeJob_level0_model *nodeData = node.nodeData;
                        nodeData.mStr_title = model1.GradeName;
                        nodeData.mStr_id = model1.GradeCode;
                        self.publishJobModel.GradeCode = model1.GradeCode;
                        self.publishJobModel.GradeName = model1.GradeName;
                        
                        [self reloadDataForDisplayArrayChangeAt:node.flag];//修改cell的状态(关闭或打开)
                        [[OnlineJobHttp getInstance]GetUnionChapterListWithgCode:model1.GradeCode subCode:@"0" uId:@"0" flag:@"0"];
                        [MBProgressHUD showMessage:@"" toView:self.view];
                        //给默认空值
                        TreeView_node *tempNode1 = [self.mArr_sumData objectAtIndex:1];
                        TreeJob_level0_model *tempModel1 = tempNode1.nodeData;
                        tempModel1.mStr_title = @"没有科目";
                        tempModel1.mStr_id = 0;
                        [tempNode1.sonNodes removeAllObjects];
                        TreeView_node *tempNode2 = [self.mArr_sumData objectAtIndex:2];
                        TreeJob_level0_model *tempModel2 = tempNode2.nodeData;
                        tempModel2.mStr_title = @"没有教版";
                        tempModel2.mStr_id = 0;
                        [tempNode2.sonNodes removeAllObjects];
                        TreeView_node *tempNode3 = [self.mArr_sumData objectAtIndex:3];
                        TreeJob_level0_model *tempModel3 = tempNode3.nodeData;
                        tempModel3.mStr_title = @"没有章节";
                        tempModel3.mStr_id = 0;
                        [tempNode3.sonNodes removeAllObjects];
                        self.publishJobModel.subjectName = tempModel1.mStr_title;
                        self.publishJobModel.subjectCode = tempModel1.mStr_id;
                        self.publishJobModel.VersionName = @"";
                        self.publishJobModel.VersionCode = @"0";
                        self.publishJobModel.chapterName = @"";
                        self.publishJobModel.chapterID = @"0";
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
                        self.publishJobModel.subjectName = model1.subjectName;
                        self.publishJobModel.subjectCode = model1.subjectCode;
                        [self reloadDataForDisplayArrayChangeAt:node.flag];//修改cell的状态(关闭或打开)
                        
                        TreeView_node *tempNode = [self.mArr_sumData objectAtIndex:0];
                        TreeJob_level0_model *tempModel = tempNode.nodeData;
                        [[OnlineJobHttp getInstance]GetUnionChapterListWithgCode:tempModel.mStr_id subCode:model1.subjectCode uId:@"0" flag:@"1"];
                        [MBProgressHUD showMessage:@"" toView:self.view];
                        //给默认空值
                        TreeView_node *tempNode2 = [self.mArr_sumData objectAtIndex:2];
                        TreeJob_level0_model *tempModel2 = tempNode2.nodeData;
                        tempModel2.mStr_title = @"没有教版";
                        tempModel2.mStr_id = 0;
                        [tempNode2.sonNodes removeAllObjects];
                        TreeView_node *tempNode3 = [self.mArr_sumData objectAtIndex:3];
                        TreeJob_level0_model *tempModel3 = tempNode3.nodeData;
                        tempModel3.mStr_title = @"没有章节";
                        tempModel3.mStr_id = 0;
                        [tempNode3.sonNodes removeAllObjects];
                        self.publishJobModel.VersionName = @"";
                        self.publishJobModel.VersionCode = @"0";
                        self.publishJobModel.chapterName = @"";
                        self.publishJobModel.chapterID = @"0";
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
                        self.publishJobModel.VersionName = model1.VersionName;
                        self.publishJobModel.VersionCode = model1.TabID;
                        [self reloadDataForDisplayArrayChangeAt:node.flag];//修改cell的状态(关闭或打开)
                        TreeView_node *tempNode = [self.mArr_sumData objectAtIndex:0];
                        TreeJob_level0_model *tempModel = tempNode.nodeData;
                        TreeView_node *tempNode1 = [self.mArr_sumData objectAtIndex:1];
                        TreeJob_level0_model *tempModel1 = tempNode1.nodeData;
                        [[OnlineJobHttp getInstance]GetUnionChapterListWithgCode:tempModel.mStr_id subCode:tempModel1.mStr_id uId:model1.TabID flag:@"2"];
                        [MBProgressHUD showMessage:@"" toView:self.view];
                        //给默认空值
                        TreeView_node *tempNode3 = [self.mArr_sumData objectAtIndex:3];
                        TreeJob_level0_model *tempModel3 = tempNode3.nodeData;
                        tempModel3.mStr_title = @"没有章节";
                        tempModel3.mStr_id = 0;
                        [tempNode3.sonNodes removeAllObjects];
                        self.publishJobModel.chapterName = @"";
                        self.publishJobModel.chapterID = @"0";
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
                        self.publishJobModel.chapterName = model1.chapterName;
                        self.publishJobModel.chapterID = model1.TabID;
                        [self reloadDataForDisplayArrayChangeAt2:model1.TabID];
                    }else{
                        model.mInt_select = 0;
                    }
                }
            }
        }
    }
    [self reloadDataForDisplayArray];
}

//导航条确定按钮
-(void)navigationRightAction:(UIButton *)sender{
    if ([self.publishJobModel.chapterID intValue]>0) {
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(SelectChapteridViewSure:)]) {
            [self.delegate SelectChapteridViewSure:self.publishJobModel];
            [self myNavigationGoback];
        }
    }else{
        [MBProgressHUD showError:@"请选择章节" toView:self.view];
    }
}

//导航条返回按钮回调
-(void)myNavigationGoback{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
