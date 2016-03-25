//
//  CheckLeaveViewController.m
//  JiaoBao
//
//  Created by Zqw on 16/3/16.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "CheckLeaveViewController.h"


@interface CheckLeaveViewController ()
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)leaveRecordModel *recordModel;

@property(nonatomic,assign)BOOL cellFlag;//0：有学生cell 1：没有学生cell
@end

@implementation CheckLeaveViewController
-(void)GetUnitLeaves:(NSNotification*)sender{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.dataSource = [sender object];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //审核人员取单位的请假记录
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"GetUnitLeaves" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetUnitLeaves:) name:@"GetUnitLeaves" object:nil];
    self.dataSource = [NSMutableArray array];
    self.recordModel = [[leaveRecordModel alloc]init];
    self.recordModel.checkFlag = @"0";
    [self sendRequest];

    // Do any additional setup after loading the view from its nib.
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:self.mStr_navName];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    self.cellFlag = YES;
    //4种状态
    NSMutableArray *temp = [NSMutableArray array];
    for (int i=0; i<4; i++) {
        ButtonViewModel *model = [[ButtonViewModel alloc] init];
        if (i==0) {
            model.mStr_title = @"已提交";
        }else if (i==1){
            model.mStr_title = @"待审核";
        }else if (i==2){
            model.mStr_title = @"已审核";
        }else if (i==3){
            model.mStr_title = @"统计查询";
        }
        [temp addObject:model];
    }
    self.mScrollV_all = [[LeaveTopScrollView alloc] initFrame:CGRectMake(0, self.mNav_navgationBar.frame.size.height, [dm getInstance].width, 48) Array:temp Flag:1 index:0];
    self.mScrollV_all.delegate = self;
    [self.view addSubview:self.mScrollV_all];
}
-(void)sendRequest{//mInt_leaveID:区分身份，门卫0，班主任1，普通老师2，家长3
    self.recordModel.numPerPage = @"20";
    self.recordModel.pageNum = @"1";
    self.recordModel.RowCount = @"0";
    self.recordModel.manType = @"1";
    self.recordModel.unitId = [NSString stringWithFormat:@"%d",[dm getInstance].UID ];
    self.recordModel.sDateTime = @"2016-03";
    self.recordModel.level = @"1";
    [[LeaveHttp getInstance]GetUnitLeaves:self.recordModel];
    [MBProgressHUD showMessage:@"" toView:self.view];
    
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
        [cell setStatisticsData:[self.dataSource objectAtIndex:indexPath.row]];
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

//分类状态的回调
-(void)LeaveViewCellTitleBtn:(LeaveViewCell *)view{
    self.mInt_flag = (int)view.tag -100;
    if(self.mInt_flag ==2){
        self.recordModel.checkFlag = @"1";
    }
    else{
        self.recordModel.checkFlag = @"0";
    }
    if(self.mInt_flag == 3){
        self.cellFlag = NO;
    }else{
        self.cellFlag = YES;
    }
    [self sendRequest];
}
- (IBAction)conditionAction:(id)sender{
    
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
