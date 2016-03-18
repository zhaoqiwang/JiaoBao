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


@interface QueryViewController ()
@property(nonatomic,strong)NSArray *dataSource;
@property(nonatomic,strong)NSArray *myDataSource;
@property(nonatomic,strong)NSArray *stuDataSource;


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
        self.dataSource = self.myDataSource;
        [self.tableView reloadData];
        
        
    }
    else
    {
        [MBProgressHUD showError:ResultDesc];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"GetMyLeaves" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetMyLeaves:) name:@"GetMyLeaves" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"GetClassLeaves" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetMyLeaves:) name:@"GetClassLeaves" object:nil];
    self.dateTF.inputAccessoryView = self.toolBar;
    self.dateTF.inputView = self.datePicker;
    self.cellFlag = YES;
    UIView *headView = [[UIView alloc]init ];
    if(self.mInt_leaveID ==1){
        headView.frame = CGRectMake(0, 0, [dm getInstance].width, CGRectGetHeight(self.tableHeadView.frame));
        [headView addSubview:self.tableHeadView];

    }
    else if (self.mInt_leaveID ==2){
        headView.frame = CGRectMake(0, 0, [dm getInstance].width, CGRectGetHeight(self.teaHeadView.frame));
        [headView addSubview:self.teaHeadView];

    }
    else if (self.mInt_leaveID == 3){
        headView.frame = CGRectMake(0, 0, [dm getInstance].width, CGRectGetHeight(self.ParentsHeadView.frame));
        [headView addSubview:self.ParentsHeadView];

    }
    else{
        headView.frame = CGRectMake(0, 0, [dm getInstance].width, CGRectGetHeight(self.teaHeadView.frame));
        [headView addSubview:self.teaHeadView];
        
    }

    self.tableView.tableHeaderView = headView;
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
- (IBAction)datePickAction:(id)sender {
    [self.dateTF becomeFirstResponder];


}
- (IBAction)cancelToolAction:(id)sender {
    [self.dateTF resignFirstResponder];

}

- (IBAction)doneToolAction:(id)sender {
    [self.dateTF resignFirstResponder];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月"];
    [self.dateBtn setTitle:[formatter stringFromDate:self.datePicker.date] forState:UIControlStateNormal];
    

    
}
@end
