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
#import "CustomDatePicker.h"




@interface QueryViewController ()<ChooseStudentViewCDelegate>
@property(nonatomic,strong)NSMutableArray *dataSource;//列表数据
@property(nonatomic,strong)leaveRecordModel *recordModel;//获得我提出申请的请假记录model
@property(nonatomic,strong)NSDate *currentDate;//当前日期
@property(nonatomic,assign)int mInt_reloadData;//0：下拉刷新 1：下拉加载更多 2：替换一条数据 3：添加一条数据
@property(nonatomic,strong)CustomDatePicker *customPicker;//自定义日期控件


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
//获得我提出申请的请假记录
-(void)GetMyLeaves:(id)sender
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSDictionary *dic = [sender object];
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
    NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
    NSString *manType = [dic objectForKey:@"manType"];
    BOOL notiFlag = NO;//区别通知（个人查询和班级查询都用到此通知 此回调走4次）
    if((self.mInt_flag==2&&[manType isEqualToString:@"1"])){//个人查询
        notiFlag = YES;
    }
    if((self.mInt_flag==3&&[manType isEqualToString:@"0"])){//班级查询
        notiFlag = YES;
    }
    if([ResultCode integerValue]==0&&notiFlag == YES){
        NSArray *arr = [dic objectForKey:@"data"];
        if(self.mInt_reloadData==0){//上拉刷新
            self.dataSource = [NSMutableArray arrayWithArray:arr];
            if(self.dataSource.count == 0){
                [MBProgressHUD showError:@"暂无内容" toView:self.view];
            }
            
            [self.tableView headerEndRefreshing];
            [self.tableView footerEndRefreshing];
            [self.tableView reloadData];
            
        }else if(self.mInt_reloadData == 1){//下拉加载更多
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
        else if(self.mInt_reloadData==3){//添加一条数据
            if(arr.count==0){
                //[MBProgressHUD showSuccess:@"没有更多了" toView:self.view];
            }
            else{
                    [self.dataSource insertObject:[arr objectAtIndex:0] atIndex:[self.recordModel.pageNum intValue]-1 ];
                    [self.tableView reloadData];

            }
            self.mInt_reloadData=0;
        }else{//替换一条数据
            {
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


        
    }
    else if([ResultCode integerValue]!=0)
    {
        [MBProgressHUD showError:ResultDesc];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化http请求model
    self.recordModel = [[leaveRecordModel alloc]init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM"];
    self.currentDate = [NSDate date];
    self.recordModel.sDateTime = [formatter stringFromDate:self.currentDate];
    //tableview加下拉刷新和上拉加载更多
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
    //tableHeadView
    UIView *headView = [[UIView alloc]init ];
    
    //自定义日期控件
    self.customPicker = [[CustomDatePicker alloc]init];
    
    //设置老师或家长的tableHeaderView
    if(self.mInt_leaveID ==1||self.mInt_leaveID ==2||self.mInt_leaveID ==0){//区分身份，门卫0，班主任1，普通老师2
        headView.frame = CGRectMake(0, 0, [dm getInstance].width, CGRectGetHeight(self.teaHeadView.frame));
        [headView addSubview:self.teaHeadView];
        
        self.teaDateTF.inputAccessoryView = self.toolBar;
        self.teaDateTF.inputView = self.customPicker;
        self.dateTf = self.teaDateTF;
        [self.dateBtn setTitle:self.recordModel.sDateTime forState:UIControlStateNormal];

    }else if (self.mInt_leaveID == 3){//家长3
        headView.frame = CGRectMake(0, 0, [dm getInstance].width, CGRectGetHeight(self.ParentsHeadView.frame));
        [headView addSubview:self.ParentsHeadView];
        
        self.dateTF.inputAccessoryView = self.toolBar;
        self.dateTF.inputView = self.customPicker;
        self.dateTf = self.dateTF;
        [self.parentDateBtn setTitle:self.recordModel.sDateTime forState:UIControlStateNormal];
    }

    self.tableView.tableHeaderView = headView;
    //家长身份设置学生默认值
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
    if(self.mInt_leaveID == 3){//家长
        self.recordModel.manType = @"0";
        self.recordModel.mName = self.mModel_student.StdName;
    }else if(self.mInt_leaveID == 1){//班主任
        if(self.mInt_flag == 2){//个人查询
            self.recordModel.manType = @"1";
            self.recordModel.mName = @"";
        }
        else{//学生查询
            self.recordModel.manType = @"0";
            self.recordModel.mName = @"";
        }
        
        
    }else{//老师或门卫
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
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.cellFlag == NO){//个人查询
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
    else{//学生查询
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
    if(self.cellFlag == YES){//学生查询
        return self.stuSection;
    }
    else{//个人查询
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
    selectVC.mInt_falg = self.mInt_flagID;
    selectVC.delegate = self;
    LeaveViewController *parentVC =(LeaveViewController*)self.parentViewController;
    selectVC.mStr_navName = parentVC.mStr_navName;
    [self.navigationController pushViewController:selectVC animated:YES];
    
}



//选择学生
- (IBAction)Stu_SelectionAction:(id)sender {
    [self.view endEditing:YES];
    ChooseStudentViewController *chooseStu = [[ChooseStudentViewController alloc] init];
    chooseStu.delegate = self;
    chooseStu.mInt_flagID = 0;
    chooseStu.mInt_flag = 0;
    chooseStu.mStr_navName = @"选择学生";
    [self.navigationController pushViewController:chooseStu animated:YES];


}
//选择日期
- (IBAction)datePickAction:(id)sender {
    [self.dateTf becomeFirstResponder];


}
//取消
- (IBAction)cancelToolAction:(id)sender {
    [self.dateTf resignFirstResponder];

}
//确定
- (IBAction)doneToolAction:(id)sender {
    [self.dateTf resignFirstResponder];

    [self.parentDateBtn setTitle:[self.customPicker getDateString] forState:UIControlStateNormal];
    [self.dateBtn setTitle:[self.customPicker getDateString] forState:UIControlStateNormal];
    self.recordModel.sDateTime = [self.customPicker getDateString2];
    [self sendRequest];
    

    
}
//选择学生回调
- (void) ChooseStudentViewCSelect:(id) student flag:(int)flag flagID:(int)flagID{

    self.mModel_student = student;
    [self.stuBtn setTitle:self.mModel_student.StdName forState:UIControlStateNormal];
    [self sendRequest];
    
}
//点击确定后，返回              表格数组中的索引    0撤回，1修改，2老师审核，3门卫审核
- (void) LeaveDetailViewCDeleteLeave:(int)index action:(int)action{
    //获得我提出申请的请假记录
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"GetMyLeaves" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetMyLeaves:) name:@"GetMyLeaves" object:nil];
    if(action == 0){//撤回
        NSIndexPath *indexP = [NSIndexPath indexPathForRow:index inSection:0];
        NSArray *indexP_arr = [NSArray arrayWithObject:indexP];
        [self.dataSource removeObjectAtIndex:index];
        [self.tableView deleteRowsAtIndexPaths:indexP_arr withRowAnimation:NO];
        self.recordModel.numPerPage = @"1";
        self.recordModel.pageNum = [NSString stringWithFormat:@"%lu",(unsigned long)self.dataSource.count+1];
        self.mInt_reloadData = 3;
        [[LeaveHttp getInstance]GetMyLeaves:self.recordModel];
    }
    else if (action == 1){//修改
        self.recordModel.numPerPage = @"1";
        self.recordModel.pageNum = [NSString stringWithFormat:@"%lu",(unsigned long)(index+1)];
        self.mInt_reloadData = 4;
        [[LeaveHttp getInstance]GetMyLeaves:self.recordModel];
        
    }
    else if (action == 2){//老师审核
        
    }
    else{//门卫审核
        
    }
    
    
    
}
-(void)dealloc{
    
}

@end
