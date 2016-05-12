//
//  CheckLeaveViewController.m
//  JiaoBao
//
//  Created by Zqw on 16/3/16.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "CheckLeaveViewController.h"
#import "LeaveDetailViewController.h"
#import "CheckSelectViewController.h"
#import "ClassLeavesModel.h"
#import "MyAdminClass.h"
#import "MJRefresh.h"//上拉下拉刷新
#import "StudentSumViewController.h"
#import "CustomDatePicker.h"

@interface CheckLeaveViewController ()
@property(nonatomic,strong)NSMutableArray *dataSource;//当前审核列表的数据源
@property(nonatomic,strong)NSMutableArray *mArr1;//待审核数组
@property(nonatomic,strong)NSMutableArray *mArr2;//已审核数组
@property(nonatomic,strong)NSMutableArray *mArr3;//统计查询数组
@property(nonatomic,strong)NSMutableArray *mArr4;//门卫查询数组
@property(nonatomic,assign)int mInt_reloadData;//标志下拉刷新或上拉加载更多
@property(nonatomic,strong)CustomDatePicker *customPicker;//自定义日期控件
@property(nonatomic,strong)leaveRecordModel *recordModel1;//http请求model（未审核）
@property(nonatomic,strong)leaveRecordModel *recordModel2;//http请求model(已审核)
@property(nonatomic,strong)leaveRecordModel *recordModel3;//http请求model（统计查询）
@property(nonatomic,strong)leaveRecordModel *recordModel4;//http请求model（门卫审核）
@property(nonatomic,strong)leaveRecordModel *recordModel;//http请求model（当前http请求model）
@property(nonatomic,assign)int refreshFlag;



@property(nonatomic,assign)BOOL cellFlag;//0：有学生cell 1：没有学生cell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property(nonatomic,strong)NSMutableArray *conditionArr;
@end

@implementation CheckLeaveViewController
//动态改变高度
-(void)updateViewConstraints
{
    [super updateViewConstraints];
    if(self.mInt_flag==3)
    {
        self.topConstraint.constant =CGRectGetMaxY(self.mNav_navgationBar.frame);
        self.conditionLayoutHeight.constant = 0;
        self.height.constant = 0;
        
    }
    else
    {
        self.conditionLayoutHeight.constant = 34;
        self.height.constant = 30;
        
    }
    
}

//审核完成之后刷新审核列表的通知
-(void)updateCheckCell:(NSNotification*)sender{
    CheckLeaveModel *model = [sender object];
    NSIndexPath *indexP = [NSIndexPath indexPathForRow:model.cellFlag inSection:0];
    NSArray *indexP_arr = [NSArray arrayWithObject:indexP];
    [self.dataSource removeObjectAtIndex:model.cellFlag];
    [self.tableView deleteRowsAtIndexPaths:indexP_arr withRowAnimation:NO];
    self.recordModel.numPerPage = @"1";
    self.recordModel.pageNum = [NSString stringWithFormat:@"%lu",(unsigned long)self.dataSource.count+1];
    self.mInt_reloadData = 3;
    [[LeaveHttp getInstance]GetUnitLeaves:self.recordModel];
    if(self.mInt_flag == 0){
        self.refreshFlag = 1;
    }
    //[self.tableView reloadRowsAtIndexPaths:indexP_arr withRowAnimation:NO];
    
    
}
//门卫取请假记录
-(void)GetGateLeaves:(NSNotification*)sender{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.dataSource = [sender object];
    if(self.dataSource.count==0){
        [MBProgressHUD showError:@"暂无内容" toView:self.view];
    }
    self.mArr4 = self.dataSource;
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
    [self.tableView reloadData];
    
}
//审核人员取单位的请假记录
-(void)GetUnitLeaves:(NSNotification*)sender{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSArray *arr = [sender object];
    if(self.mInt_reloadData == 0){
        self.dataSource = [NSMutableArray arrayWithArray:arr];
        if(self.dataSource.count==0){
            [MBProgressHUD showError:@"暂无内容" toView:self.view];
        }
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        [self.tableView reloadData];
        
    }
    else if(self.mInt_reloadData == 1){
        if(arr.count==0){
            [MBProgressHUD showSuccess:@"没有更多了" toView:self.view];
        }
        else{
            [self.dataSource addObjectsFromArray:arr];
            
            [self.tableView reloadData];
            
        }
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        self.mInt_reloadData=0;
    }
    else{
        if(arr.count==0){
            //[MBProgressHUD showSuccess:@"没有更多了" toView:self.view];
        }
        else{
            [self.dataSource addObjectsFromArray:arr];
            [self.tableView reloadData];
            
        }
        self.recordModel.numPerPage = @"20";
        self.mInt_reloadData=0;
    }
    if(self.mInt_flag == 0){
        self.mArr1 = self.dataSource;
    }
    else if (self.mInt_flag == 1){
        self.mArr2 = self.dataSource;
        
    }
    else{
        self.mArr3 = self.dataSource;
    }
    [self.tableView reloadData];
}
//学校班级请假查询统计
-(void)GetClassSumLeaves:(NSNotification*)sender{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.dataSource = [sender object];
    if(self.dataSource.count==0){
        [MBProgressHUD showError:@"暂无内容" toView:self.view];
    }
    self.mArr3 = self.dataSource;
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
    [self.tableView reloadData];
    
}
//教职工统计查询后的通知
-(void)GetManSumLeaves:(NSNotification*)sender{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.dataSource = [sender object];
    if(self.dataSource.count==0){
        [MBProgressHUD showError:@"暂无内容" toView:self.view];
    }
    if(self.mInt_flag == 0){
        self.mArr1 = self.dataSource;
    }
    else if (self.mInt_flag == 1){
        self.mArr2 = self.dataSource;
        
    }
    else{
        self.mArr3 = self.dataSource;
    }
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
    [self.tableView reloadData];
    
}
-(void)setUpRecordModel{
    //初始化http请求model
    //    self.recordModel = [[leaveRecordModel alloc]init];
    //    self.recordModel.checkFlag = @"0";////0待审记录，1已审记录
    //    self.recordModel.numPerPage = @"20";
    //    self.recordModel.pageNum = @"1";
    //    self.recordModel.RowCount = @"0";
    //    self.recordModel.unitId = [NSString stringWithFormat:@"%d",[dm getInstance].UID ];
    //未审核
    self.recordModel1 = [[leaveRecordModel alloc]init];
    self.recordModel1.checkFlag = @"0";////0待审记录，1已审记录
    self.recordModel1.numPerPage = @"20";
    self.recordModel1.pageNum = @"1";
    self.recordModel1.RowCount = @"0";
    self.recordModel1.unitId = [NSString stringWithFormat:@"%d",[dm getInstance].UID ];
    //已审核
    self.recordModel2 = [[leaveRecordModel alloc]init];
    self.recordModel2.numPerPage = @"20";
    self.recordModel2.checkFlag = @"1";////0待审记录，1已审记录
    
    self.recordModel2.pageNum = @"1";
    self.recordModel2.RowCount = @"0";
    self.recordModel2.unitId = [NSString stringWithFormat:@"%d",[dm getInstance].UID ];
    //统计查询
    self.recordModel3 = [[leaveRecordModel alloc]init];
    self.recordModel3.numPerPage = @"20";
    self.recordModel3.pageNum = @"1";
    self.recordModel3.RowCount = @"0";
    self.recordModel3.unitId = [NSString stringWithFormat:@"%d",[dm getInstance].UID ];
    //门卫审核
    self.recordModel4 = [[leaveRecordModel alloc]init];
    self.recordModel4.checkFlag = nil;
    self.recordModel4.numPerPage = @"20";
    self.recordModel4.pageNum = @"1";
    self.recordModel4.RowCount = @"0";
    self.recordModel4.unitId = [NSString stringWithFormat:@"%d",[dm getInstance].UID ];
    self.recordModel = self.recordModel1;
    
    //self.recordModel.level = @"0";
    //self.recordModel.manType = @"1";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化可变数组
    self.dataSource = [NSMutableArray array];
    self.mArr1 = [NSMutableArray array];
    self.mArr2 = [NSMutableArray array];
    self.mArr3 = [NSMutableArray array];
    self.mArr4 = [NSMutableArray array];
    self.conditionArr = [NSMutableArray arrayWithObjects:@"请选择筛选条件",@"请选择筛选条件",@"请选择筛选条件",@"", nil];
    self.conditionContent.text = [self.conditionArr objectAtIndex:0];
    //TableView上面有部分空白时用到
    self.automaticallyAdjustsScrollViewInsets = NO;
    //门卫取请假记录
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"GetGateLeaves" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetGateLeaves:) name:@"GetGateLeaves" object:nil];
    //审核人员取单位的请假记录
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"GetUnitLeaves" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetUnitLeaves:) name:@"GetUnitLeaves" object:nil];
    //审核完毕后的通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"updateCheckCell" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateCheckCell:) name:@"updateCheckCell" object:nil];
    //学校班级请假查询统计
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"GetClassSumLeaves" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetClassSumLeaves:) name:@"GetClassSumLeaves" object:nil];
    
    //教职工统计查询后的通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"GetManSumLeaves" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetManSumLeaves:) name:@"GetManSumLeaves" object:nil];
    
    self.tableView.tableFooterView = [[UIView alloc]init];//把tableFooterView设置成空白view
    //列表加上拉加载更多和下拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    self.tableView.headerPullToRefreshText = @"下拉刷新";
    self.tableView.headerReleaseToRefreshText = @"松开后刷新";
    self.tableView.headerRefreshingText = @"正在刷新...";
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    self.tableView.footerPullToRefreshText = @"上拉加载更多";
    self.tableView.footerReleaseToRefreshText = @"松开加载更多数据";
    self.tableView.footerRefreshingText = @"正在加载...";
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
    [self setUpRecordModel];//初始化http请求Model
    
    //把门卫审核日期设置成当前日期
    //设置门卫审核日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM"];
    NSDate *currentDate =[NSDate date];
    [self.conditionBtn setTitle:[NSString stringWithFormat:@"日期:%@",[formatter stringFromDate:currentDate]] forState:UIControlStateSelected];
    self.conditionBtn.tintColor = [UIColor whiteColor];
    self.recordModel.sDateTime = [NSString stringWithFormat:@"%@-01",[formatter stringFromDate:currentDate]];
    //[self sendRequest];
    
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:self.mStr_navName];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    self.cellFlag = YES;
    //先判断有没有审核权限
    int a = [self selectCount];
    if (a>0) {
        [MBProgressHUD showError:@"请选择筛选条件" toView:self.view];
        
        //4种状态
        NSMutableArray *temp = [NSMutableArray array];
        for (int i=0; i<3; i++) {
            ButtonViewModel *model = [[ButtonViewModel alloc] init];
            if (i==0){
                model.mStr_title = @"待审核";
            }else if (i==1){
                model.mStr_title = @"已审核";
            }else if (i==2){
                model.mStr_title = @"统计查询";
            }
            [temp addObject:model];
        }
        //是否有门卫权限
        if ([[dm getInstance].leaveModel.GateGuardList intValue]==1) {
            ButtonViewModel *model = [[ButtonViewModel alloc] init];
            model.mStr_title = @"门卫审核";
            [temp addObject:model];
            
        }
        self.mScrollV_all = [[LeaveTopScrollView alloc] initFrame:CGRectMake(0, self.mNav_navgationBar.frame.size.height, [dm getInstance].width, 48) Array:temp Flag:1 index:0];
        self.mScrollV_all.delegate = self;
        [self.view addSubview:self.mScrollV_all];
    }else{//光有门卫审核
        self.mNav_navgationBar.label_Title.text = @"门卫审核";
        LeaveViewCell *cell = [[LeaveViewCell alloc]init];
        cell.tag = 103;
        ButtonViewModel *model = [[ButtonViewModel alloc] init];
        model.mStr_title = @"门卫审核";
        
        [self LeaveViewCellTitleBtn:cell];
    }
    
    self.dateTF = [[UITextField alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.dateTF];
    self.customPicker = [[CustomDatePicker alloc]init];
    self.dateTF.inputAccessoryView = self.toolBar;
    self.dateTF.inputView = self.customPicker;
}
-(void)sendRequest{//mInt_leaveID:区分身份，门卫0，班主任1，普通老师2，家长3
    NSString *page = @"";
    if (self.mInt_reloadData == 0) {//下拉刷新或请求第一页数据
        page = @"1";
    }else{//下拉加载更多
        NSMutableArray *array = self.dataSource;
        if (array.count>=20&&array.count%20==0) {
            page = [NSString stringWithFormat:@"%d",(int)array.count/20+1];
        } else {
            self.mInt_reloadData = 0;
            [MBProgressHUD showSuccess:@"没有更多了" ];
            [self.tableView headerEndRefreshing];
            [self.tableView footerEndRefreshing];
            return;
        }
    }
    [MBProgressHUD showMessage:@"" toView:self.view];
    if(self.mInt_flag==0||self.mInt_flag==1){//未审核或已审核
        self.recordModel.pageNum = page;
        [[LeaveHttp getInstance]GetUnitLeaves:self.recordModel];
    }else if(self.mInt_flag == 2){//统计查询
        if(self.mInt_reloadData == 0){//下拉刷新或请求第一页数据
            if([self.recordModel.manType isEqualToString:@"0"])//班级查询
            {
                [[LeaveHttp getInstance]GetClassSumLeavesWithUnitId:[NSString stringWithFormat:@"%d",[dm getInstance].UID ] sDateTime:self.recordModel.sDateTime gradeStr:self.recordModel.gradeStr];
                
            }else{//教职工查询
                [[LeaveHttp getInstance]GetManSumLeavesWithUnitId:[NSString stringWithFormat:@"%d",[dm getInstance].UID ] sDateTime:self.recordModel.sDateTime];
            }
        }
        else{//下拉加载更多
            self.mInt_reloadData = 0;
            [MBProgressHUD showSuccess:@"没有更多了" ];
            [self.tableView headerEndRefreshing];
            [self.tableView footerEndRefreshing];
        }
        
        
    }else if(self.mInt_flag == 3){//门卫审核
        [[LeaveHttp getInstance]GetGateLeaves:self.recordModel];
        
    }
    
    
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.cellFlag == YES){//未审核或已审核cell
        static NSString *indentifier = @"QueryCell";
        QueryCell *cell = (QueryCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
        if (cell == nil) {
            cell = [[QueryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"QueryCell" owner:self options:nil];
            //这时myCell对象已经通过自定义xib文件生成了
            if ([nib count]>0) {
                cell = (QueryCell *)[nib objectAtIndex:0];
                //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
            }
            //添加图片点击事件
            //若是需要重用，需要写上以下两句代码
            UINib * n= [UINib nibWithNibName:@"QueryCell" bundle:[NSBundle mainBundle]];
            [self.tableView registerNib:n forCellReuseIdentifier:indentifier];
        }
        [cell setCellData:[self.dataSource objectAtIndex:indexPath.row]];
        
        return cell;
        
    }
    else{//统计查询或门卫审核cell
        if(self.mInt_flag == 2){//统计查询
            static NSString *indentifier = @"CustomQueryCell";
            CustomQueryCell *cell = (CustomQueryCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
            
            if (cell == nil) {
                cell = [[CustomQueryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomQueryCell" owner:self options:nil];
                //这时myCell对象已经通过自定义xib文件生成了
                if ([nib count]>0) {
                    cell = (CustomQueryCell *)[nib objectAtIndex:0];
                    //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
                }
                //添加图片点击事件
                //若是需要重用，需要写上以下两句代码
                UINib * n= [UINib nibWithNibName:@"CustomQueryCell" bundle:[NSBundle mainBundle]];
                [self.tableView registerNib:n forCellReuseIdentifier:indentifier];
            }
            if([self.ManOrClassLabel.text isEqualToString:@"教职工"]){//教职工查询
                [cell setStatisticsData:[self.dataSource objectAtIndex:indexPath.row]];
                
            }else{//班级查询
                [cell setStatisticsClassData:[self.dataSource objectAtIndex:indexPath.row]];
            }
            return cell;
        }
        else{//门卫审核
            {
                static NSString *indentifier = @"CustomQueryCell";
                CustomQueryCell *cell = (CustomQueryCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
                
                if (cell == nil) {
                    cell = [[CustomQueryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomQueryCell" owner:self options:nil];
                    //这时myCell对象已经通过自定义xib文件生成了
                    if ([nib count]>0) {
                        cell = (CustomQueryCell *)[nib objectAtIndex:0];
                        //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
                    }
                    //添加图片点击事件
                    //若是需要重用，需要写上以下两句代码
                    UINib * n= [UINib nibWithNibName:@"CustomQueryCell" bundle:[NSBundle mainBundle]];
                    [self.tableView registerNib:n forCellReuseIdentifier:indentifier];
                }
                [cell setCellData2:[self.dataSource objectAtIndex:indexPath.row]];
                return cell;
            }
            
        }
    }
    
    return nil;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(self.mInt_flag == 0||self.mInt_flag==1){//未审核或已审核csection
        return self.stuSection;
    }
    else if(self.mInt_flag == 2){//统计查询section
        return self.sectionView;
        
    }else{//门卫审核section
        return self.manSection;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return 32;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.mInt_flag ==2) {//统计查询
        if([self.ManOrClassLabel.text isEqualToString:@"班级"]){
            SumLeavesModel *model = [self.dataSource objectAtIndex:indexPath.row];
            
            StudentSumViewController *detail = [[StudentSumViewController alloc]init];
            detail.ClassSumModel = model;
            detail.sDateTime = self.recordModel.sDateTime;
            [self.navigationController pushViewController:detail animated:YES];
        }
        
    }else{
        ClassLeavesModel *model = [self.dataSource objectAtIndex:indexPath.row];
        LeaveDetailViewController *selectVC = [[LeaveDetailViewController alloc]init];
        if (self.mInt_flag ==0) {//待审核
            selectVC.mInt_from = 1;
            selectVC.mInt_checkOver = 0;
        }else if (self.mInt_flag == 1){//已审核
            selectVC.mInt_from = 2;
            selectVC.mInt_checkOver = 0;
        }else if (self.mInt_flag == 3)//门卫审核
        {
            selectVC.mInt_checkOver = 1;
        }
        selectVC.mInt_check = model.mInt_check;
        selectVC.mInt_falg = [model.manType intValue];
        selectVC.mInt_index = (int)indexPath.row;
        selectVC.mModel_classLeaves = model;
        selectVC.mStr_navName = @"审核";
        selectVC.delegate = self;
        [self.navigationController pushViewController:selectVC animated:YES];
    }
}

//分类状态的回调
-(void)LeaveViewCellTitleBtn:(LeaveViewCell *)view{
    
    self.mInt_flag = (int)view.tag -100;
    [self updateViewConstraints];
    if(self.mInt_flag==0){
        self.recordModel = self.recordModel1;
    }else if (self.mInt_flag==1){
        self.recordModel = self.recordModel2;
    }else if (self.mInt_flag==2){
        self.recordModel = self.recordModel3;
    }else if (self.mInt_flag==3){
        self.recordModel = self.recordModel4;
    }
    //筛选条件或门卫审核日期按钮
    //self.conditionBtn.selected = NO;
    //    [self.conditionBtn setTitle:@"筛选条件      " forState:UIControlStateNormal];
    //    [self.conditionBtn setImage:[UIImage imageNamed:@"kal_right_arrow"] forState:UIControlStateNormal];
    self.conditionBtn.hidden = NO;
    NSMutableArray *tempMArr;
    self.conditionContent.text = [self.conditionArr objectAtIndex:self.mInt_flag];
    if(self.mInt_flag ==0){//未审核
        self.recordModel.checkFlag = @"0";
        self.cellFlag = YES;
        tempMArr = self.mArr1;
    }
    else if(self.mInt_flag ==1){//已审核
        if(self.refreshFlag == 1&&[[self.conditionArr objectAtIndex:0]isEqualToString:[self.conditionArr objectAtIndex:1]]){
            self.recordModel.checkFlag = @"1";
            self.cellFlag = YES;
            [self.mArr2 removeAllObjects];
            tempMArr = self.mArr2;
            self.refreshFlag = 0;
        }else{
            self.recordModel.checkFlag = @"1";
            self.cellFlag = YES;
            tempMArr = self.mArr2;
        }
    }
    else if(self.mInt_flag ==2){//统计查询
        self.cellFlag = NO;
        tempMArr = self.mArr3;
    }else{//门卫审核
        self.recordModel.checkFlag = nil;
        self.cellFlag = NO;
        self.conditionBtn.hidden = YES;
        //        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        //        [formatter setDateFormat:@"yyyy-MM"];
        //        NSDate *currentDate =[NSDate date];
        //        [self.conditionBtn setTitle:[NSString stringWithFormat:@"日期:%@",[formatter stringFromDate:currentDate]] forState:UIControlStateNormal];
        //        [self.conditionBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        //self.conditionBtn.selected = YES;
        
        tempMArr = self.mArr4;
        //return;
        
    }
    //    if(!self.recordModel.level){
    //        if(self.mInt_flag != 3){
    //            [MBProgressHUD showError:@"请选择筛选条件" toView:self.view];
    //            self.dataSource = tempMArr;
    //            [self.tableView reloadData];
    //            return;
    //        }
    //
    //    }
    if([self.conditionContent.text isEqualToString:@"请选择筛选条件"]){
        self.dataSource = tempMArr;
        [self.tableView reloadData];
        return;
    }
    if(tempMArr.count==0){//数据源为空则发送请求
        [self sendRequest];
    }
    else{//存在数据源则刷新数据
        self.dataSource = tempMArr;
        if(self.mInt_flag == 0||self.mInt_flag == 1){
            ClassLeavesModel *model = [self.dataSource objectAtIndex:0];
            if([model.manType isEqualToString: @"0"]){
                self.stuOrTeaLabel.text = @"学生";
                
            }else{
                self.stuOrTeaLabel.text = @"教职工";
            }
        }
        [self.tableView reloadData];
    }
    
}
//点击筛选条件
- (IBAction)conditionAction:(id)sender{
    if(self.mInt_flag==3){//如果是门卫审核日期按钮
        [self.dateTF becomeFirstResponder];
    }
    else{//如果是筛选条件
        //先判断有没有审核权限
        int a = [self selectCount];
        if (a>0) {
            CheckSelectViewController *selectVC = [[CheckSelectViewController alloc]init];
            if(self.mInt_flag==0||self.mInt_flag==1){//已审核和未审核
                selectVC.mInt_flag = 0;
            }
            
            else{//统计查询
                selectVC.mInt_flag = 1;
            }
            selectVC.delegate = self;
            [self.navigationController pushViewController:selectVC animated:YES];
        }else{
            [MBProgressHUD showError:@"当前账号没有审核权限" toView:self.view];
        }
    }
}

//判断有没有审核权限
-(int)selectCount{
    int a = 0;
    if ([[dm getInstance].userInfo.isAdmin intValue]==2||[[dm getInstance].userInfo.isAdmin intValue]==3){//是否是班主任，班主任必有1审
        a++;
    }
    //二审
    if ([[dm getInstance].leaveModel.ApproveListStd.B isEqual:@"True"]) {
        a++;
    }
    //三审
    if ([[dm getInstance].leaveModel.ApproveListStd.C isEqual:@"True"]) {
        a++;
    }
    //四审
    if ([[dm getInstance].leaveModel.ApproveListStd.D isEqual:@"True"]) {
        a++;
    }
    //五审
    if ([[dm getInstance].leaveModel.ApproveListStd.E isEqual:@"True"]) {
        a++;
    }
    //一审
    if ([[dm getInstance].leaveModel.ApproveListTea.A isEqual:@"True"]) {
        a++;
    }
    //二审
    if ([[dm getInstance].leaveModel.ApproveListTea.B isEqual:@"True"]) {
        a++;
    }
    //三审
    if ([[dm getInstance].leaveModel.ApproveListTea.C isEqual:@"True"]) {
        a++;
    }
    //四审
    if ([[dm getInstance].leaveModel.ApproveListTea.D isEqual:@"True"]) {
        a++;
    }
    //五审
    if ([[dm getInstance].leaveModel.ApproveListTea.E isEqual:@"True"]) {
        a++;
    }
    return a;
}
//toolBar取消按钮
- (IBAction)cancelAction:(id)sender {
    [self.dateTF resignFirstResponder];
}
//toolBar确定按钮
- (IBAction)doneAction:(id)sender {
    [self.dateTF resignFirstResponder];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM"];
    NSString *dateStr = [self.customPicker getDateString];
    [self.conditionBtn setTitle:[NSString stringWithFormat:@"日期:%@",dateStr] forState:UIControlStateNormal];
    self.recordModel.sDateTime = [self.customPicker getDateString2];
    [self sendRequest];
}
//筛选条件的回调
-(void)CheckSelectViewCSelect:(leaveRecordModel *)model flag:(int)flag  CheckName:(NSString *)name{
    //检查当前网络是否可用
    CheckNetWorkSelfView
    NSArray *arr = [model.sDateTime componentsSeparatedByString:@"-"];
    NSString *currentYear = [arr objectAtIndex:0];
    NSString *currentMonth = [arr objectAtIndex:1];
    NSString *currentDate = [NSString stringWithFormat:@"%@年%@月",currentYear,currentMonth];
    if(self.mInt_flag==0){
        self.recordModel = self.recordModel1;
    }else if (self.mInt_flag==1){
        self.recordModel = self.recordModel2;
    }else if (self.mInt_flag==2){
        self.recordModel = self.recordModel3;
    }else if (self.mInt_flag==3){
        self.recordModel = self.recordModel4;
    }
    self.recordModel.manType = model.manType;//人员类型，0学生1老师
    
    
    //设置不同的section
    if(self.mInt_flag==0||self.mInt_flag==1){
        if([model.manType isEqualToString:@"0"]){
            self.stuOrTeaLabel.text = @"学生";
            self.conditionLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",self.stuOrTeaLabel.text,currentDate,model.gradeStr,model.classStr,name];
        }else{
            self.stuOrTeaLabel.text = @"教职工";
            self.conditionLabel.text = [NSString stringWithFormat:@"%@ %@ %@",self.stuOrTeaLabel.text,currentDate,name];
        }
        
    }else if(self.mInt_flag==2){
        if([model.manType isEqualToString:@"0"]){
            self.ManOrClassLabel.text = @"班级";
            self.conditionLabel.text = [NSString stringWithFormat:@"%@ %@ %@",self.ManOrClassLabel.text,currentDate,model.gradeStr];
            
        }else{
            self.ManOrClassLabel.text = @"教职工";
            self.conditionLabel.text = [NSString stringWithFormat:@"%@ %@",self.ManOrClassLabel.text,currentDate];
            
        }
    }else{
        
    }
    //设置http请求model
    self.recordModel.level = model.level;
    self.recordModel.sDateTime = [model.sDateTime stringByAppendingString:@"-1"];
    if ([model.gradeStr isEqual:@"全部"]) {
        self.recordModel.gradeStr = @"";
    }else{
        self.recordModel.gradeStr = model.gradeStr;
    }
    if ([model.classStr isEqual:@"全部"]) {
        self.recordModel.classStr = @"";
    }else{
        self.recordModel.classStr = model.classStr;
    }
    [self.conditionArr replaceObjectAtIndex:self.mInt_flag withObject:self.conditionLabel.text];
    [self sendRequest];
    
}
//点击确定后，返回              表格数组中的索引    0撤回，1修改，2老师审核，3门卫审核
- (void) LeaveDetailViewCDeleteLeave:(int)index action:(int)action{
    if(action == 0){
        NSIndexPath *indexP = [NSIndexPath indexPathForRow:index inSection:0];
        NSArray *indexP_arr = [NSArray arrayWithObject:indexP];
        [self.tableView deleteRowsAtIndexPaths:indexP_arr withRowAnimation:NO];
        [self.dataSource removeObjectAtIndex:0];
        self.recordModel.numPerPage = @"1";
        self.recordModel.pageNum = [NSString stringWithFormat:@"%lu",(unsigned long)self.dataSource.count];
        self.mInt_reloadData = 3;
        [[LeaveHttp getInstance]GetUnitLeaves:self.recordModel];
    }
    else if (action == 1){
        
    }
    else if (action == 2){
        
    }
    else{
        
    }
}

//门卫审核成功后，列表界面重新获取值
-(void)doorCheckSuccess{
    [self headerRereshing];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing{
    if([self.conditionContent.text isEqualToString:@"请选择筛选条件"]){
        [self.tableView headerEndRefreshing];
        return;
    }
    self.mInt_reloadData = 0;
    [self sendRequest];
}

- (void)footerRereshing{
    self.mInt_reloadData = 1;
    [self sendRequest];
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

- (IBAction)dateBtnAction:(id)sender {
    [self.dateTF becomeFirstResponder];
}
@end
