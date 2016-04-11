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

@interface CheckLeaveViewController ()
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)NSMutableArray *mArr1;//待审核数组
@property(nonatomic,strong)NSMutableArray *mArr2;//已审核数组
@property(nonatomic,strong)NSMutableArray *mArr3;//统计查询数组
@property(nonatomic,strong)NSMutableArray *mArr4;//门卫查询数组
@property(nonatomic,assign)int mInt_reloadData;

@property(nonatomic,strong)leaveRecordModel *recordModel;

@property(nonatomic,assign)BOOL cellFlag;//0：有学生cell 1：没有学生cell
@end

@implementation CheckLeaveViewController
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
    //[self.tableView reloadRowsAtIndexPaths:indexP_arr withRowAnimation:NO];
    
    
}
-(void)GetGateLeaves:(NSNotification*)sender{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.dataSource = [sender object];
    self.mArr4 = self.dataSource;
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
    [self.tableView reloadData];

}
-(void)GetUnitLeaves:(NSNotification*)sender{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSArray *arr = [sender object];
    if(self.mInt_reloadData == 0){
        self.dataSource = [NSMutableArray arrayWithArray:arr];
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
-(void)GetClassSumLeaves:(NSNotification*)sender{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.dataSource = [sender object];
    self.mArr3 = self.dataSource;
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
    [self.tableView reloadData];

}
-(void)GetManSumLeaves:(NSNotification*)sender{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.dataSource = [sender object];
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
-(void)GetStudentSumLeaves:(NSNotification*)sender{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.dataSource = [sender object];
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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.mArr1 = [NSMutableArray array];
    self.mArr2 = [NSMutableArray array];
    self.mArr3 = [NSMutableArray array];
    self.mArr4 = [NSMutableArray array];
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
//    //学生统计查询后的通知
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"GetStudentSumLeaves" object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetStudentSumLeaves:) name:@"GetStudentSumLeaves" object:nil];
    //教职工统计查询后的通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"GetManSumLeaves" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetManSumLeaves:) name:@"GetManSumLeaves" object:nil];
    self.dataSource = [NSMutableArray array];

    self.tableView.tableFooterView = [[UIView alloc]init];
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
    
    self.recordModel = [[leaveRecordModel alloc]init];
    self.recordModel.checkFlag = @"0";
    self.recordModel.numPerPage = @"20";
    self.recordModel.pageNum = @"1";
    self.recordModel.RowCount = @"0";
    //self.recordModel.manType = @"0";
    self.recordModel.unitId = [NSString stringWithFormat:@"%d",[dm getInstance].UID ];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM"];
    NSDate *currentDate =[NSDate date];
    self.recordModel.sDateTime = [formatter stringFromDate:currentDate];
    //self.recordModel.level = @"1";
    [MBProgressHUD showError:@"请选择筛选条件" toView:self.view];
    // Do any additional setup after loading the view from its nib.
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:self.mStr_navName];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    self.cellFlag = YES;
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
//    if ([[dm getInstance].leaveModel.GateGuardList intValue]==1) {
        ButtonViewModel *model = [[ButtonViewModel alloc] init];
        model.mStr_title = @"门卫审核";
        [temp addObject:model];
//    }
    self.mScrollV_all = [[LeaveTopScrollView alloc] initFrame:CGRectMake(0, self.mNav_navgationBar.frame.size.height, [dm getInstance].width, 48) Array:temp Flag:1 index:0];
    self.mScrollV_all.delegate = self;
    [self.view addSubview:self.mScrollV_all];
    self.dateTF = [[UITextField alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.dateTF];
    self.dateTF.inputAccessoryView = self.toolBar;
    self.dateTF.inputView = self.datePicker;
}
-(void)sendRequest{//mInt_leaveID:区分身份，门卫0，班主任1，普通老师2，家长3
    NSString *page = @"";
    if (self.mInt_reloadData == 0) {
        page = @"1";
    }else{
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
    if(self.mInt_flag==0||self.mInt_flag==1){
        self.recordModel.pageNum = page;
        [[LeaveHttp getInstance]GetUnitLeaves:self.recordModel];
    }else if(self.mInt_flag == 2){
        if(self.mInt_reloadData == 0){
            if([self.recordModel.manType isEqualToString:@"0"])
            {
                    [[LeaveHttp getInstance]GetClassSumLeavesWithUnitId:[NSString stringWithFormat:@"%d",[dm getInstance].UID ] sDateTime:self.recordModel.sDateTime gradeStr:self.recordModel.gradeStr];

                
            }else{
                [[LeaveHttp getInstance]GetManSumLeavesWithUnitId:[NSString stringWithFormat:@"%d",[dm getInstance].UID ] sDateTime:self.recordModel.sDateTime];
            }
        }
        else{
            self.mInt_reloadData = 0;
            [MBProgressHUD showSuccess:@"没有更多了" ];
            [self.tableView headerEndRefreshing];
            [self.tableView footerEndRefreshing];
        }

        
    }else if(self.mInt_flag == 3){
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
    if(self.cellFlag == YES){
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
    else{
        if(self.mInt_flag == 2){
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
            if([self.ManOrClassLabel.text isEqualToString:@"教职工"]){
                [cell setStatisticsData:[self.dataSource objectAtIndex:indexPath.row]];

            }else{
                [cell setStatisticsClassData:[self.dataSource objectAtIndex:indexPath.row]];
            }
            return cell;
        }
        else{
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
                [cell setCellData:[self.dataSource objectAtIndex:indexPath.row]];
                return cell;
            }
            
        }
        }

    return nil;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(self.mInt_flag == 0||self.mInt_flag==1){
        return self.stuSection;
    }
    else if(self.mInt_flag == 2){
        return self.sectionView;
        
    }else{
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
        SumLeavesModel *model = [self.dataSource objectAtIndex:indexPath.row];

        StudentSumViewController *detail = [[StudentSumViewController alloc]init];
        detail.ClassSumModel = model;
        detail.sDateTime = self.recordModel.sDateTime;
        [self.navigationController pushViewController:detail animated:YES];
    }else{
        ClassLeavesModel *model = [self.dataSource objectAtIndex:indexPath.row];
        LeaveDetailViewController *selectVC = [[LeaveDetailViewController alloc]init];
        if (self.mInt_flag ==0) {
            selectVC.mInt_from = 1;
            selectVC.mInt_checkOver = 0;
        }else if (self.mInt_flag == 1){
            selectVC.mInt_from = 2;
            selectVC.mInt_checkOver = 0;
        }else if (self.mInt_flag == 3)
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

    NSMutableArray *tempMArr;
    self.conditionBtn.selected = NO;
    self.conditionBtn.tintColor = [UIColor lightGrayColor];
    if(self.mInt_flag ==0){
        self.recordModel.checkFlag = @"0";
        self.cellFlag = YES;
        tempMArr = self.mArr1;
    }
    else if(self.mInt_flag ==1){
        self.recordModel.checkFlag = @"1";
        self.cellFlag = YES;
        tempMArr = self.mArr2;
    }
    else if(self.mInt_flag ==2){
        self.cellFlag = NO;
        tempMArr = self.mArr3;
    }else{
        self.cellFlag = NO;
        self.conditionBtn.selected = YES;
        self.conditionBtn.tintColor = [UIColor whiteColor];
        tempMArr = self.mArr4;
        //return;

    }
    if(!self.recordModel.level){
        if(self.mInt_flag != 3){
            [MBProgressHUD showError:@"请选择筛选条件" toView:self.view];
            self.dataSource = tempMArr;
            [self.tableView reloadData];
            return;
        }
        
    }
    if(tempMArr.count==0){
        [self sendRequest];
    }
    else{
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
- (IBAction)conditionAction:(id)sender{
    if(self.conditionBtn.selected == YES){
        [self.dateTF becomeFirstResponder];
    }
    else{
        CheckSelectViewController *selectVC = [[CheckSelectViewController alloc]init];
        if(self.mInt_flag==0||self.mInt_flag==1){
            selectVC.mInt_flag = 0;
        }
        
        else{
            selectVC.mInt_flag = 1;
        }
        selectVC.delegate = self;
        [self.navigationController pushViewController:selectVC animated:YES];
    }

    
}

- (IBAction)cancelAction:(id)sender {
    [self.dateTF resignFirstResponder];
}

- (IBAction)doneAction:(id)sender {
    [self.dateTF resignFirstResponder];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM"];
    [self.conditionBtn setTitle:[NSString stringWithFormat:@"日期:%@",[formatter stringFromDate:self.datePicker.date]] forState:UIControlStateSelected];
    self.recordModel.sDateTime = [formatter stringFromDate:self.datePicker.date];
    [self sendRequest];
}

-(void)CheckSelectViewCSelect:(leaveRecordModel *)model flag:(int)flag{
        self.recordModel.manType = model.manType;
    if(self.mInt_flag==0||self.mInt_flag==1){
        if([model.manType isEqualToString:@"0"]){
            self.stuOrTeaLabel.text = @"学生";
        }else{
            self.stuOrTeaLabel.text = @"教职工";
        }
    }
    if(self.mInt_flag==2){
        if([model.manType isEqualToString:@"0"]){
            self.ManOrClassLabel.text = @"班级";
        }else{
            self.ManOrClassLabel.text = @"教职工";
        }
    }

        self.recordModel.level = model.level;
        self.recordModel.sDateTime = model.sDateTime;
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
#pragma mark 开始进入刷新状态
- (void)headerRereshing{
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
