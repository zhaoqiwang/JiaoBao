//
//  QueryViewController.m
//  JiaoBao
//
//  Created by SongYanming on 16/3/15.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "QueryViewController.h"
#import "QueryCell.h"
#import "CustomQueryCell.h"
#import "dm.h"
#import "LeaveHttp.h"
#import "MBProgressHUD+AD.h"
#import "MyAdminClass.h"
#import "ChooseStudentViewController.h"
#import "MJRefresh.h"//上拉下拉刷新
#import "ClassLeavesModel.h"
#import "LeaveDetailViewController.h"
#import "LeaveViewController.h"



@interface QueryViewController ()<ChooseStudentViewCDelegate>
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)NSMutableArray *myDataSource;
@property(nonatomic,strong)NSMutableArray *stuDataSource;
@property(nonatomic,strong)leaveRecordModel *recordModel;
@property(nonatomic,strong)NSDate *currentDate;
@property(nonatomic,assign)int mInt_reloadData;


@end

@implementation QueryViewController
-(void)viewWillAppear:(BOOL)animated{
    //获得我提出申请的请假记录
        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"GetMyLeaves" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetMyLeaves:) name:@"GetMyLeaves" object:nil];



}
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}
-(void)GetMyLeaves:(id)sender
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSDictionary *dic = [sender object];
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
    NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
    NSString *manType = [dic objectForKey:@"manType"];
    BOOL notiFlag = NO;
    if((self.mInt_flag==2&&[manType isEqualToString:@"1"])){
        notiFlag = YES;
    }
    if((self.mInt_flag==3&&[manType isEqualToString:@"0"])){
        notiFlag = YES;
    }
    if([ResultCode integerValue]==0&&notiFlag == YES){
        NSArray *arr = [dic objectForKey:@"data"];
        if(self.mInt_reloadData==0){
            self.dataSource = [NSMutableArray arrayWithArray:arr];
            [self.tableView headerEndRefreshing];
            [self.tableView footerEndRefreshing];
            [self.tableView reloadData];
            
        }else if(self.mInt_reloadData == 1){
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
                [self.dataSource replaceObjectAtIndex:[self.recordModel.pageNum intValue]-1 withObject:[arr objectAtIndex:0]];
                [self.tableView reloadData];
                
            }
            self.mInt_reloadData=0;
        }


        
    }
    else if([ResultCode integerValue]!=0)
    {
        [MBProgressHUD showError:ResultDesc];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.recordModel = [[leaveRecordModel alloc]init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM"];
    self.currentDate = [NSDate date];
    self.recordModel.sDateTime = [formatter stringFromDate:self.currentDate];
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


    
    
    self.datePicker.backgroundColor =[UIColor whiteColor];
    UIView *headView = [[UIView alloc]init ];
    if(self.mInt_leaveID ==1||self.mInt_leaveID ==2||self.mInt_leaveID ==0){//区分身份，门卫0，班主任1，普通老师2，家长3
        headView.frame = CGRectMake(0, 0, [dm getInstance].width, CGRectGetHeight(self.teaHeadView.frame));
        [headView addSubview:self.teaHeadView];
        self.teaDateTF.inputAccessoryView = self.toolBar;
        self.teaDateTF.inputView = self.datePicker;
        self.dateTf = self.teaDateTF;
        [self.dateBtn setTitle:self.recordModel.sDateTime forState:UIControlStateNormal];

    }else if (self.mInt_leaveID == 3){
        headView.frame = CGRectMake(0, 0, [dm getInstance].width, CGRectGetHeight(self.ParentsHeadView.frame));
        [headView addSubview:self.ParentsHeadView];
        self.dateTF.inputAccessoryView = self.toolBar;
        self.dateTF.inputView = self.datePicker;
        self.dateTf = self.dateTF;
        [self.parentDateBtn setTitle:self.recordModel.sDateTime forState:UIControlStateNormal];
    }

    self.tableView.tableHeaderView = headView;
    if([dm getInstance].mArr_leaveStudent.count>0){
        self.mModel_student = [[dm getInstance].mArr_leaveStudent objectAtIndex:0];
        [self.stuBtn setTitle:self.mModel_student.StdName forState:UIControlStateNormal];

    }
    [self sendRequest];


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

    self.recordModel.numPerPage = @"20";
    self.recordModel.pageNum = page;
    self.recordModel.RowCount = @"0";
    self.recordModel.accId = [dm getInstance].jiaoBaoHao;
    if(self.mInt_leaveID == 3){
        self.recordModel.manType = @"0";
        self.recordModel.mName = self.mModel_student.StdName;
    }else if(self.mInt_leaveID == 1){
        if(self.mInt_flag == 2){
            self.recordModel.manType = @"1";
            self.recordModel.mName = @"";
        }
        else{
            self.recordModel.manType = @"0";
            self.recordModel.mName = @"";
        }
        
        
    }else{
        self.recordModel.manType = @"1";
        self.recordModel.mName = @"";
    }
    [MBProgressHUD showMessage:@"" toView:self.view];
        [[LeaveHttp getInstance]GetMyLeaves:self.recordModel];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.cellFlag == NO){
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
    return nil;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(self.cellFlag == YES){
        return self.stuSection;
    }
    else{
        return self.sectionView;
        
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return 32;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     ClassLeavesModel*model = [self.dataSource objectAtIndex:indexPath.row];
    LeaveDetailViewController *selectVC = [[LeaveDetailViewController alloc]init];
    selectVC.mModel_classLeaves = model;
    selectVC.mInt_from = 0;
    selectVC.mInt_check = model.mInt_check;
    selectVC.mInt_index = (int)indexPath.row;
    selectVC.delegate = self;
    LeaveViewController *parentVC =(LeaveViewController*)self.parentViewController;
    selectVC.mStr_navName = parentVC.mStr_navName;
    [self.navigationController pushViewController:selectVC animated:YES];
    
}




- (IBAction)Stu_SelectionAction:(id)sender {
    ChooseStudentViewController *chooseStu = [[ChooseStudentViewController alloc] init];
    chooseStu.delegate = self;
    chooseStu.mInt_flagID = 0;
    chooseStu.mInt_flag = 0;
    chooseStu.mStr_navName = @"选择学生";
    [self.navigationController pushViewController:chooseStu animated:YES];


}
- (IBAction)datePickAction:(id)sender {
    [self.dateTf becomeFirstResponder];


}
- (IBAction)cancelToolAction:(id)sender {
    [self.dateTf resignFirstResponder];

}

- (IBAction)doneToolAction:(id)sender {
    [self.dateTf resignFirstResponder];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM"];
    [self.parentDateBtn setTitle:[formatter stringFromDate:self.datePicker.date] forState:UIControlStateNormal];
    [self.dateBtn setTitle:[formatter stringFromDate:self.datePicker.date] forState:UIControlStateNormal];
    self.recordModel.sDateTime = [formatter stringFromDate:self.datePicker.date];
    [self sendRequest];
    

    
}
- (void) ChooseStudentViewCSelect:(id) student flag:(int)flag flagID:(int)flagID{

    self.mModel_student = student;
    [self.stuBtn setTitle:self.mModel_student.StdName forState:UIControlStateNormal];
    [self sendRequest];
    
}
- (void) LeaveDetailViewCDeleteLeave:(int)index action:(int)action{
    if(action == 0){
        NSIndexPath *indexP = [NSIndexPath indexPathForRow:index inSection:0];
        NSArray *indexP_arr = [NSArray arrayWithObject:indexP];
        [self.dataSource removeObjectAtIndex:index];
        [self.tableView deleteRowsAtIndexPaths:indexP_arr withRowAnimation:NO];
        self.recordModel.numPerPage = @"1";
        self.recordModel.pageNum = [NSString stringWithFormat:@"%lu",(unsigned long)self.dataSource.count+1];
        self.mInt_reloadData = 3;
        [[LeaveHttp getInstance]GetMyLeaves:self.recordModel];
    }
    else if (action == 1){
        self.recordModel.numPerPage = @"1";
        self.recordModel.pageNum = [NSString stringWithFormat:@"%lu",(unsigned long)(index+1)];
        self.mInt_reloadData = 3;
        [[LeaveHttp getInstance]GetMyLeaves:self.recordModel];
        
    }
    else if (action == 2){
        
    }
    else{
        
    }
    
    
    
}
-(void)dealloc{
    
}

@end
