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


@interface QueryViewController ()<ChooseStudentViewCDelegate>
@property(nonatomic,strong)NSArray *dataSource;
@property(nonatomic,strong)NSArray *myDataSource;
@property(nonatomic,strong)NSArray *stuDataSource;
@property(nonatomic,strong)leaveRecordModel *recordModel;
@property(nonatomic,strong)NSDate *currentDate;


@end

@implementation QueryViewController
-(void)GetMyLeaves:(id)sender
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSDictionary *dic = [sender object];
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
    NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
    if([ResultCode integerValue]==0){
        NSArray *arr = [dic objectForKey:@"data"];
        self.myDataSource = arr;
        self.dataSource = self.myDataSource;
        [self.tableView reloadData];

        
    }
    else
    {
        [MBProgressHUD showError:ResultDesc];
    }
}

-(void)GetClassLeaves:(id)sender
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSDictionary *dic = [sender object];
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
    NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
    if([ResultCode integerValue]==0){
        NSArray *arr = [dic objectForKey:@"data"];
        self.stuDataSource = arr;
        self.dataSource = self.stuDataSource;
        [self.tableView reloadData];
        
        
    }
    else
    {
        [MBProgressHUD showError:ResultDesc];
    }
}
-(void)GetMyStdInfo:(NSNotification*)sender{
    leaveRecordModel *recordModel = [[leaveRecordModel alloc]init];
    recordModel.numPerPage = @"20";
    recordModel.pageNum = @"1";
    recordModel.RowCount = @"0";
    recordModel.accId = [dm getInstance].jiaoBaoHao;
    recordModel.sDateTime = @"2016-03";
    recordModel.manType = @"1";
    recordModel.mName = @"";
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[LeaveHttp getInstance]GetMyLeaves:recordModel];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.recordModel = [[leaveRecordModel alloc]init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月"];
    self.currentDate = [NSDate date];
    self.recordModel.sDateTime = [formatter stringFromDate:self.currentDate];

    //获得我提出申请的请假记录
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"GetMyLeaves" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetMyLeaves:) name:@"GetMyLeaves" object:nil];
    //班主任取审批的记录
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"GetClassLeaves" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetMyLeaves:) name:@"GetClassLeaves" object:nil];
    //取得我的教宝号所关联的学生列表(家长身份
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"GetMyStdInfo" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetMyStdInfo:) name:@"GetMyStdInfo" object:nil];
    
    self.cellFlag = YES;
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
-(void)sendRequest{//mInt_leaveID:区分身份，门卫0，班主任1，普通老师2，家长3

    self.recordModel.numPerPage = @"20";
    self.recordModel.pageNum = @"1";
    self.recordModel.RowCount = @"0";
    self.recordModel.accId = [dm getInstance].jiaoBaoHao;
    if(self.mInt_leaveID == 3){
        self.recordModel.manType = @"0";
        self.recordModel.mName = self.mModel_student.StdName;
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
    leaveRecordModel *model = [self.dataSource objectAtIndex:indexPath.row];
    
}




/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/



- (IBAction)selectionBtnAction:(id)sender {
    UIButton *btn = sender;
    if([btn isEqual:self.myBtn]){
        self.myBtn.selected = YES;
        self.stdBtn.selected = NO;
        self.cellFlag = YES;
        leaveRecordModel *recordModel = [[leaveRecordModel alloc]init];
        recordModel.numPerPage = @"20";
        recordModel.pageNum = @"1";
        recordModel.RowCount = @"0";
        recordModel.accId = [dm getInstance].jiaoBaoHao;
        recordModel.sDateTime = @"2016-03";
        recordModel.manType = @"1";
        recordModel.mName = @"";
        [MBProgressHUD showMessage:@"" toView:self.view];
        [[LeaveHttp getInstance]GetMyLeaves:recordModel];
        [self.tableView reloadData];
    }else{
        self.myBtn.selected = NO;
        self.stdBtn.selected = YES;
        self.cellFlag = NO;
        leaveRecordModel *recordModel = [[leaveRecordModel alloc]init];
        recordModel.numPerPage = @"20";
        recordModel.pageNum = @"1";
        recordModel.RowCount = @"0";
        recordModel.sDateTime = @"2016-03";
        if ([dm getInstance].mArr_leaveClass.count>0) {
            MyAdminClass *model = [[dm getInstance].mArr_leaveClass objectAtIndex:0];
            recordModel.unitClassId = model.TabID;
        }
        recordModel.checkFlag = @"0";
        //[MBProgressHUD showMessage:@"" toView:self.view];
        [[LeaveHttp getInstance]GetClassLeaves:recordModel];
        [self.tableView reloadData];
        
    }
    
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
    [formatter setDateFormat:@"yyyy年MM月"];
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

@end
