//
//  MakeJobViewController.m
//  JiaoBao
//
//  Created by Zqw on 15/10/14.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "MakeJobViewController.h"
#import "Loger.h"
#import "Reachability.h"
#import "MobClick.h"
#import "define_constant.h"
#import "OnlineJobHttp.h"
#import "AppDelegate.h"
#import "Grade+CoreDataProperties.h"

@interface MakeJobViewController ()

@property(nonatomic,strong)Grade *GradeModel;
@property(nonatomic,strong)AppDelegate *appDelegate;//用于获取数据库

@end

@implementation MakeJobViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[OnlineJobHttp getInstance]GetGradeList];
    [[OnlineJobHttp getInstance]GetUnionChapterListWithgCode:@"1" subCode:@"1" uId:@"418" flag:@"0"];
    [[OnlineJobHttp getInstance]GetDesHWListWithChapterID:@"1" teacherJiaobaohao:@"5150001"];
    NSError* error;
    //添加 删除 获取数据库的标志
    //从appdelegate获取数据数据库上下文
    self.appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    //通过查询语句获取数据列表
    
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* GradeDataList=[NSEntityDescription entityForName:@"Grade" inManagedObjectContext:self.appDelegate.managedObjectContext];
        [request setEntity:GradeDataList];
        NSMutableArray* mutableFetchResult=[[self.appDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    Grade *grade0 = [mutableFetchResult objectAtIndex:0];
    NSLog(@"fdijenfne = %@",grade0.gradeName);
    
    //数据库添加数据
        self.GradeModel = (Grade*)[NSEntityDescription insertNewObjectForEntityForName:@"Grade" inManagedObjectContext:self.appDelegate.managedObjectContext];

    self.GradeModel.gradeName = @"一年级";
    self.GradeModel.gradeCode = @"1";
        
        //修改上下文后要记得保存 不保存不会存到磁盘中 只会在内存中改变
        BOOL isSaveSuccess=[self.appDelegate.managedObjectContext save:&error];
        if (!isSaveSuccess)
        {
            NSLog(@"Error:%@",error);
        }else{
            NSLog(@"Save successful!");
        }
    
    // Do any additional setup after loading the view from its nib.
    self.mArr_sumData = [NSMutableArray array];
    self.mArr_display = [NSMutableArray array];
    self.mInt_index = 0;
    
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"布置作业"];
    [self.mNav_navgationBar setGoBack];
    self.mNav_navgationBar.delegate = self;
    [self.view addSubview:self.mNav_navgationBar];
    
    self.mTableV_work.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height-[dm getInstance].statusBar, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height+[dm getInstance].statusBar);
    
    //统一作业，插入单独的难度行
    [self sigleDifficulty];
    
    //添加默认数据
    [self addDefaultData];
    [self reloadDataForDisplayArray];//初始化将要显示的数据
}

//添加默认数据
-(void)addDefaultData{
    //第0根节点
    NSMutableArray *tempArr = [NSMutableArray arrayWithObjects:@"模式选择",@"班级选择",@"年级选择",@"科目选择",@"教版选择",@"章节选择",@"其他项目",@"短信勾选",@"作业发布", nil];
    for (int i=0; i<tempArr.count; i++) {
        if(i==0)
        {
            
        }
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
    [self insertGrade];
    [self insertClass];
}

//在年级选择中，插入数据
-(void)insertGrade{
    for (int i=0; i<self.mArr_sumData.count; i++) {
        TreeJob_node *node0 = [self.mArr_sumData objectAtIndex:i];
        if (node0.flag == 2) {
            for (int m=0; m<5; m++) {
                //第1根节点
                TreeJob_node *node1 = [[TreeJob_node alloc]init];
                node1.nodeLevel = 1;//节点所处层次
                node1.type = 1;//节点类型
                node1.faType = node0.flag;//父节点
                node1.isExpanded = FALSE;//节点是否展开
                node1.mInt_index = self.mInt_index;//全局索引标识
                self.mInt_index++;
                TreeJob_level0_model *temp1 =[[TreeJob_level0_model alloc]init];
                temp1.mStr_name = @"年级1111";
                node1.nodeData = temp1;
                //塞入数据
                [node0.sonNodes addObject:node1];
            }
        }
    }
}

//在班级选择中，插入数据
-(void)insertClass{
    for (int i=0; i<self.mArr_sumData.count; i++) {
        TreeJob_node *node0 = [self.mArr_sumData objectAtIndex:i];
        if (node0.flag == 1) {
            for (int m=0; m<3; m++) {
                //第1根节点
                TreeJob_node *node1 = [[TreeJob_node alloc]init];
                node1.nodeLevel = 1;//节点所处层次
                node1.type = 1;//节点类型
                node1.flag = 11;//标注当前是哪个节点
                node1.faType = node0.flag;//父节点
                node1.isExpanded = FALSE;//节点是否展开
                node1.mInt_index = self.mInt_index;//全局索引标识
                self.mInt_index++;
                TreeJob_class_model *temp1 =[[TreeJob_class_model alloc]init];
                temp1.mStr_className = @"一年级2班";
                temp1.mInt_difficulty = 1;
                temp1.mInt_class = 0;
                node1.nodeData = temp1;
                //插入数据
                [node0.sonNodes addObject:node1];
            }
            //统一作业，插入单独的难度行
            [node0.sonNodes addObject:self.sigleClassNode];
        }
    }
}

//统一作业，插入单独的难度行
-(void)sigleDifficulty{
    //第1根节点
    self.sigleClassNode = [[TreeJob_node alloc]init];
    self.sigleClassNode.nodeLevel = 1;//节点所处层次
    self.sigleClassNode.type = 1;//节点类型
    self.sigleClassNode.flag = 9999;//标注当前是哪个节点
    self.sigleClassNode.faType = 1;//父节点
    self.sigleClassNode.isExpanded = FALSE;//节点是否展开
    self.sigleClassNode.mInt_index = self.mInt_index;//全局索引标识
    self.mInt_index++;
    TreeJob_class_model *temp1 =[[TreeJob_class_model alloc]init];
    temp1.mStr_className = @"一年级2班";
    temp1.mInt_difficulty = 1;
    temp1.mInt_class = 0;
    self.sigleClassNode.nodeData = temp1;
}

//初始化将要显示的数据
-(void)reloadDataForDisplayArray{
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    for (TreeJob_node *node in self.mArr_sumData) {
        [tmp addObject:node];
        if(node.isExpanded){
            for(TreeJob_node *node2 in node.sonNodes){
//                TreeJob_level0_model *temp1 =node2.nodeData;
                [tmp addObject:node2];
//                if(node2.isExpanded){
//                    for(TreeJob_node *node3 in node2.sonNodes){
//                        [tmp addObject:node3];
//                    }
//                }
            }
        }
    }
    self.mArr_display = [NSArray arrayWithArray:tmp];
    [self.mTableV_work reloadData];
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mArr_display.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"TreeJob_default_TableViewCell";
    static NSString *indentifier2 = @"TreeJob_class_TableViewCell";
    static NSString *ModeSelectionIndentifier = @"ModeSelectionIndentifier";//模式选择cell重用标志
    static NSString *MessageSelectionIndentifier = @"MessageSelectionIndentifier";//短信勾选cell重用标志

    
//    static NSString *indentifier1 = @"TreeView_Level1_Cell";
//    static NSString *indentifier2 = @"TreeView_Level2_Cell";
    TreeJob_node *node = [self.mArr_display objectAtIndex:indexPath.row];
    if(node.type == 0){//类型为0的cell,一级列表
        if (node.flag == 0) {//模式选择
            Mode_Selection_Cell *cell = (Mode_Selection_Cell *)[tableView dequeueReusableCellWithIdentifier:ModeSelectionIndentifier];
            if (cell == nil) {
                cell = [[Mode_Selection_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ModeSelectionIndentifier];
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Mode_Selection_Cell" owner:self options:nil];
                //这时myCell对象已经通过自定义xib文件生成了
                if ([nib count]>0) {
                    cell = (Mode_Selection_Cell *)[nib objectAtIndex:0];
                    //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
                }
                
                //添加图片点击事件
                //若是需要重用，需要写上以下两句代码
                UINib * n= [UINib nibWithNibName:@"Mode_Selection_Cell" bundle:[NSBundle mainBundle]];
                [self.mTableV_work registerNib:n forCellReuseIdentifier:ModeSelectionIndentifier];
            }
            
            [self loadDataForTreeViewCell:cell with:node];//重新给cell装载数据
            [cell setNeedsDisplay]; //重新描绘cell
            
            return cell;
        }else if (node.flag == 7){//短信勾选
            MessageSelectionCell *cell = (MessageSelectionCell *)[tableView dequeueReusableCellWithIdentifier:MessageSelectionIndentifier];
            if (cell == nil) {
                cell = [[MessageSelectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MessageSelectionIndentifier];
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageSelectionCell" owner:self options:nil];
                //这时myCell对象已经通过自定义xib文件生成了
                if ([nib count]>0) {
                    cell = (MessageSelectionCell *)[nib objectAtIndex:0];
                    //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
                }
                
                //添加图片点击事件
                //若是需要重用，需要写上以下两句代码
                UINib * n= [UINib nibWithNibName:@"MessageSelectionCell" bundle:[NSBundle mainBundle]];
                [self.mTableV_work registerNib:n forCellReuseIdentifier:MessageSelectionIndentifier];
            }
            
            [self loadDataForTreeViewCell:cell with:node];//重新给cell装载数据
            [cell setNeedsDisplay]; //重新描绘cell
            
            return cell;
        }else if (node.flag == 8){//作业发布
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
        }else{//其余下拉cell
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
        }
    }else if(node.type == 1){//类型为1的cell,2级列表
        if (node.flag == 11||node.flag ==9999) {//班级选择cell
            TreeJob_class_TableViewCell *cell = (TreeJob_class_TableViewCell *)[tableView dequeueReusableCellWithIdentifier:indentifier2];
            if (cell == nil) {
                cell = [[TreeJob_class_TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier2];
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TreeJob_class_TableViewCell" owner:self options:nil];
                //这时myCell对象已经通过自定义xib文件生成了
                if ([nib count]>0) {
                    cell = (TreeJob_class_TableViewCell *)[nib objectAtIndex:0];
                    //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
                }
                
                //添加图片点击事件
                //若是需要重用，需要写上以下两句代码
                UINib * n= [UINib nibWithNibName:@"TreeJob_class_TableViewCell" bundle:[NSBundle mainBundle]];
                [self.mTableV_work registerNib:n forCellReuseIdentifier:indentifier2];
            }
            cell.delegate = self;
            cell.node = node;
            [self loadDataForClassTreeViewCell:cell with:node];//重新给cell装载数据
            [cell setNeedsDisplay]; //重新描绘cell
            
            return cell;
        }
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
    }
    return nil;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    TreeJob_node *node = [self.mArr_display objectAtIndex:indexPath.row];
    if (node.type == 0) {
        return 44;
    }else if (node.type == 1){
        if (node.flag == 11) {
            if (self.mInt_modeSelect == 0) {//个性作业
                return 60;
            }else{//统一作业、自定义作业
                return 44;
            }
        }else if (node.flag == 9999){//
            D("sldhgldsjg");
            return 0;
        }
    }
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TreeJob_node *node = [self.mArr_display objectAtIndex:indexPath.row];
    if(node.type == 0){
        TreeJob_node *node = [self.mArr_display objectAtIndex:indexPath.row];
        [self reloadDataForDisplayArrayChangeAt:node.flag];//修改cell的状态(关闭或打开)
    }
}

/*---------------------------------------
 为不同类型cell填充数据
 --------------------------------------- */
-(void) loadDataForTreeViewCell:(UITableViewCell*)cell with:(TreeJob_node*)node{
    if(node.type == 0){
        if(node.flag == 0)
        {
            
        }
        else if (node.flag == 7)
        {
            
        }
        else
        {
//            TreeJob_default_TableViewCell *cell0 = (TreeJob_default_TableViewCell*)cell;
//            TreeJob_level0_model *nodeData = node.nodeData;
//            cell0.mLab_title.text = nodeData.mStr_name;
//            cell0.mLab_title.frame = CGRectMake(10, (44-21)/2, 80, 21);
        }

    }else if (node.type == 1){
        TreeJob_default_TableViewCell *cell0 = (TreeJob_default_TableViewCell*)cell;
        TreeJob_level0_model *nodeData = node.nodeData;
        cell0.mLab_title.text = nodeData.mStr_name;
        cell0.mLab_title.frame = CGRectMake(20, (44-21)/2, 80, 21);
    }
}

-(void) loadDataForClassTreeViewCell:(UITableViewCell*)cell with:(TreeJob_node*)node{
    TreeJob_class_TableViewCell *cell0 = (TreeJob_class_TableViewCell*)cell;
    TreeJob_class_model *nodeData = node.nodeData;
    cell0.sigleClassBtn.mLab_title.text = nodeData.mStr_className;
    cell0.sigleClassBtn.mInt_flag = nodeData.mInt_class;//班级是否选择
    cell0.mInt_diff = nodeData.mInt_difficulty;//难度
    if (self.mInt_modeSelect == 0) {//个性作业
        if (node.flag == 9999) {//专门的难度行
            cell0.sigleClassBtn.hidden = YES;
            cell0.mLab_nanDu.hidden = YES;
            cell0.sigleBtn1.hidden = YES;
            cell0.sigleBtn2.hidden = YES;
            cell0.sigleBtn3.hidden = YES;
            cell0.sigleBtn4.hidden = YES;
            cell0.sigleBtn5.hidden = YES;
        }else{//所有显示
            cell0.sigleClassBtn.hidden = NO;
            cell0.mLab_nanDu.hidden = NO;
            cell0.sigleBtn1.hidden = NO;
            cell0.sigleBtn2.hidden = NO;
            cell0.sigleBtn3.hidden = NO;
            cell0.sigleBtn4.hidden = NO;
            cell0.sigleBtn5.hidden = NO;
            
            cell0.sigleClassBtn.frame = CGRectMake(20, 10, cell0.sigleClassBtn.frame.size.width, 21);
            //难度
            cell0.mLab_nanDu.frame = CGRectMake(20, 35, cell0.mLab_nanDu.frame.size.width, 21);
            cell0.sigleBtn1.frame = CGRectMake(20+cell0.mLab_nanDu.frame.size.width, 35, cell0.sigleBtn1.frame.size.width, 21);
            cell0.sigleBtn2.frame = CGRectMake(cell0.sigleBtn1.frame.origin.x+cell0.sigleBtn2.frame.size.width+20, 35, cell0.sigleBtn2.frame.size.width, 21);
            cell0.sigleBtn3.frame = CGRectMake(cell0.sigleBtn2.frame.origin.x+cell0.sigleBtn3.frame.size.width+20, 35, cell0.sigleBtn3.frame.size.width, 21);
            cell0.sigleBtn4.frame = CGRectMake(cell0.sigleBtn3.frame.origin.x+cell0.sigleBtn4.frame.size.width+20, 35, cell0.sigleBtn4.frame.size.width, 21);
            cell0.sigleBtn5.frame = CGRectMake(cell0.sigleBtn4.frame.origin.x+cell0.sigleBtn5.frame.size.width+20, 35, cell0.sigleBtn5.frame.size.width, 21);
        }
    }else if (self.mInt_modeSelect == 1) {//统一作业
        if (node.flag == 9999) {//专门的难度行
            cell0.sigleClassBtn.hidden = YES;
            cell0.mLab_nanDu.hidden = NO;
            cell0.sigleBtn1.hidden = NO;
            cell0.sigleBtn2.hidden = NO;
            cell0.sigleBtn3.hidden = NO;
            cell0.sigleBtn4.hidden = NO;
            cell0.sigleBtn5.hidden = NO;
            //难度
            cell0.mLab_nanDu.frame = CGRectMake(20, 10, cell0.mLab_nanDu.frame.size.width, 21);
            cell0.sigleBtn1.frame = CGRectMake(20+cell0.mLab_nanDu.frame.size.width, 35, cell0.sigleBtn1.frame.size.width, 21);
            cell0.sigleBtn2.frame = CGRectMake(cell0.sigleBtn1.frame.origin.x+cell0.sigleBtn2.frame.size.width+20, 35, cell0.sigleBtn2.frame.size.width, 21);
            cell0.sigleBtn3.frame = CGRectMake(cell0.sigleBtn2.frame.origin.x+cell0.sigleBtn3.frame.size.width+20, 35, cell0.sigleBtn3.frame.size.width, 21);
            cell0.sigleBtn4.frame = CGRectMake(cell0.sigleBtn3.frame.origin.x+cell0.sigleBtn4.frame.size.width+20, 35, cell0.sigleBtn4.frame.size.width, 21);
            cell0.sigleBtn5.frame = CGRectMake(cell0.sigleBtn4.frame.origin.x+cell0.sigleBtn5.frame.size.width+20, 35, cell0.sigleBtn5.frame.size.width, 21);
        }else{//光班级行
            cell0.sigleClassBtn.hidden = NO;
            cell0.mLab_nanDu.hidden = YES;
            cell0.sigleBtn1.hidden = YES;
            cell0.sigleBtn2.hidden = YES;
            cell0.sigleBtn3.hidden = YES;
            cell0.sigleBtn4.hidden = YES;
            cell0.sigleBtn5.hidden = YES;
            cell0.sigleClassBtn.frame = CGRectMake(20, 10, cell0.sigleClassBtn.frame.size.width, 21);
        }
    }else{//自定义作业
        cell0.sigleClassBtn.hidden = NO;
        cell0.mLab_nanDu.hidden = YES;
        cell0.sigleBtn1.hidden = YES;
        cell0.sigleBtn2.hidden = YES;
        cell0.sigleBtn3.hidden = YES;
        cell0.sigleBtn4.hidden = YES;
        cell0.sigleBtn5.hidden = YES;
        cell0.sigleClassBtn.frame = CGRectMake(20, 10, cell0.sigleClassBtn.frame.size.width, 21);
    }
    //班级
    if (cell0.sigleClassBtn.mInt_flag ==1) {
        [cell0.sigleClassBtn.mImg_head setImage:[UIImage imageNamed:@"selected"]];
    }else{
        [cell0.sigleClassBtn.mImg_head setImage:[UIImage imageNamed:@"blank"]];
    }
    //难度
    for (SigleBtnView *view in cell0.subviews) {
        if ([view.class isSubclassOfClass:SigleBtnView.class]) {
            if (view.tag == cell0.mInt_diff) {
                [view.mImg_head setImage:[UIImage imageNamed:@"selected"]];
            }else{
                [view.mImg_head setImage:[UIImage imageNamed:@"blank"]];
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
//        for(TreeJob_node *node2 in node.sonNodes){
//            if(node2.flag == row){
//                node2.isExpanded = !node2.isExpanded;
//            }
//        }
    }
    [self reloadDataForDisplayArray];
}
-(void)modeSelectionActionWithButtonTag:(NSUInteger)tag//0个性 1统一 2自定义
{
    self.mInt_modeSelect = (int)tag;
}

-(void)MessageSelectionActionWithButtonTag0:(NSUInteger)tag0 tag1:(NSUInteger)tag1//tag0家长通知 tag1反馈（0是没选中 1是选中）
{
    self.mInt_parent = (int)tag0;
    self.mInt_feedback = (int)tag1;
}

//班级cell的回调
-(void)TreeJob_class_TableViewCellClick:(TreeJob_class_TableViewCell *)treeJob_class_TableViewCell{
    for (int i=0; i<self.mArr_sumData.count; i++) {
        TreeJob_node *node = [self.mArr_sumData objectAtIndex:i];
        if (node.flag == 1) {
            for (TreeJob_node *node1 in node.sonNodes) {
                if (node1.mInt_index == treeJob_class_TableViewCell.node.mInt_index) {
                    TreeJob_class_model *nodeData = node1.nodeData;
                    nodeData.mInt_class = treeJob_class_TableViewCell.sigleClassBtn.mInt_flag;
                    nodeData.mInt_difficulty = treeJob_class_TableViewCell.mInt_diff;
                }
            }
        }
    }
    [self reloadDataForDisplayArray];
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
