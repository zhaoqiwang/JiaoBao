//
//  LeaveDetailViewController.m
//  JiaoBao
//
//  Created by Zqw on 16/3/21.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "LeaveDetailViewController.h"

@interface LeaveDetailViewController ()

@end

@implementation LeaveDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;//控制整个功能是否启用
    manager.shouldResignOnTouchOutside = NO;//控制点击背景是否收起键盘
    manager.shouldToolbarUsesTextFieldTintColor = NO;//控制键盘上的工具条文字颜色是否用户自定义
    manager.enableAutoToolbar = NO;//控制是否显示键盘上的工具条
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //获取假条明细
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetLeaveModel" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetLeaveModel:) name:@"GetLeaveModel" object:nil];
    //删除假条
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DeleteLeaveModel" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DeleteLeaveModel:) name:@"DeleteLeaveModel" object:nil];
    //门卫登记离校返校时间
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UpdateGateInfo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateGateInfo:) name:@"UpdateGateInfo" object:nil];
    // Do any additional setup after loading the view from its nib.
    self.mArr_list = [NSMutableArray array];
    self.mModel_detail = [[LeaveDetailModel alloc] init];
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:self.mStr_navName];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    
    //表格
    self.mTableV_leave.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height-[dm getInstance].statusBar, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height+[dm getInstance].statusBar);
    self.mTableV_leave.tableFooterView = [[UIView alloc]init];
    //普通审核
    if (self.mInt_checkOver ==0) {
        //获取假条明细
        [[LeaveHttp getInstance] GetLeaveModel:self.mModel_classLeaves.TabID];
        [MBProgressHUD showMessage:@"" toView:self.view];
    }else if (self.mInt_checkOver == 1){//门卫审核
        [self loadClassLeaveDoor];
    }
}
//门卫登记离校返校时间
-(void)UpdateGateInfo:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSMutableDictionary *dic = noti.object;
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
    NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
    if ([ResultCode intValue]==0) {
        //重新获取假条明细
        [MBProgressHUD showSuccess:ResultDesc toView:self.view];
        NSString *flag = [dic objectForKey:@"flag"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
        if ([flag intValue]==0) {//离校
            self.mModel_classLeaves.LeaveTime = dateStr;
            self.mModel_classLeaves.LWriterName = [dm getInstance].name;
        }else{//返校
            self.mModel_classLeaves.ComeTime = dateStr;
            self.mModel_classLeaves.CWriterName = [dm getInstance].name;
        }
        [self loadClassLeaveDoor];
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(doorCheckSuccess)]) {
            [self.delegate doorCheckSuccess];
        }
    }else{
        [MBProgressHUD showSuccess:ResultDesc toView:self.view];
    }
}
//删除假条
-(void)DeleteLeaveModel:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSMutableDictionary *dic = noti.object;
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
    NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
    [MBProgressHUD showSuccess:ResultDesc toView:self.view];
    if ([ResultCode intValue]==0) {
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(LeaveDetailViewCDeleteLeave:action:)]) {
            [self.delegate LeaveDetailViewCDeleteLeave:self.mInt_index action:0];
        }
        //延迟执行
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5/*延迟执行时间*/ * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [self myNavigationGoback];
        });
    }
}

//获取假条明细
-(void)GetLeaveModel:(NSNotification *)noti{
    [self.mArr_list removeAllObjects];
    [MBProgressHUD hideHUDForView:self.view];
    NSMutableDictionary *dic = noti.object;
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
    NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
    LeaveDetailModel *model = [dic objectForKey:@"model"];
    if ([ResultCode intValue]==0) {
        self.mModel_detail = model;
        [self loadLeaveDetail];
    }else{
        [MBProgressHUD showSuccess:ResultDesc toView:self.view];
    }
    [self.mTableV_leave reloadData];
}

//加载门卫审核数据
-(void)loadClassLeaveDoor{
    [self.mArr_list removeAllObjects];
    //请假人
    LeaveDetailShowModel *model = [[LeaveDetailShowModel alloc] init];
    model.mInt_flag = 0;
    model.mStr_name = @"请假人:";
    model.mStr_value = self.mModel_classLeaves.ManName;
    [self.mArr_list addObject:model];
    //发起时间
    LeaveDetailShowModel *model2 = [[LeaveDetailShowModel alloc] init];
    model2.mInt_flag = 2;
    model2.mStr_name = @"发起时间:";
    model2.mStr_value = self.mModel_classLeaves.WriteDate;
    [self.mArr_list addObject:model2];
    //理由
    LeaveDetailShowModel *model3 = [[LeaveDetailShowModel alloc] init];
    model3.mInt_flag = 3;
    model3.mStr_name = @"理由:";
    model3.mStr_value = self.mModel_classLeaves.LeaveType;
    [self.mArr_list addObject:model3];
    //开始结束时间
    LeaveDetailShowModel *model4 = [[LeaveDetailShowModel alloc] init];
    model4.mInt_flag = 4;
    model4.mStr_startTime = @"开始时间:";
    model4.mStr_startTimeValue = self.mModel_classLeaves.Sdate;
    model4.mStr_goTime = @"离校时间:";
    model4.mStr_goTimeValue = self.mModel_classLeaves.LeaveTime;
    model4.mStr_door = @"值班门卫:";
    model4.mStr_doorValue = self.mModel_classLeaves.LWriterName;
    model4.mStr_endTime = @"结束时间:";
    model4.mStr_endTimeValue = self.mModel_classLeaves.Edate;
    model4.mStr_comeTime = @"回校时间:";
    model4.mStr_comeTimeValue = self.mModel_classLeaves.ComeTime;
    model4.mStr_door2 = @"值班门卫:";
    model4.mStr_door2Value = self.mModel_classLeaves.CWriterName;
    [self.mArr_list addObject:model4];
    [self.mTableV_leave reloadData];
}

//加载假条详情数组
-(void)loadLeaveDetail{
    //请假人
    LeaveDetailShowModel *model = [[LeaveDetailShowModel alloc] init];
    model.mInt_flag = 0;
    model.mStr_name = @"请假人:";
    model.mStr_value = self.mModel_detail.ManName;
    [self.mArr_list addObject:model];
    //发起人
    LeaveDetailShowModel *model1 = [[LeaveDetailShowModel alloc] init];
    model1.mInt_flag = 1;
    model1.mStr_name = @"发起人:";
    model1.mStr_value = self.mModel_detail.Writer;
    [self.mArr_list addObject:model1];
    //发起时间
    LeaveDetailShowModel *model2 = [[LeaveDetailShowModel alloc] init];
    model2.mInt_flag = 2;
    model2.mStr_name = @"发起时间:";
    model2.mStr_value = self.mModel_detail.WriteDate;
    [self.mArr_list addObject:model2];
    //请假类型
    LeaveDetailShowModel *model7 = [[LeaveDetailShowModel alloc] init];
    model7.mInt_flag = 7;
    model7.mStr_name = @"请假类型:";
    model7.mStr_value = self.mModel_detail.LeaveType;
    [self.mArr_list addObject:model7];
    //理由
    LeaveDetailShowModel *model3 = [[LeaveDetailShowModel alloc] init];
    model3.mInt_flag = 3;
    model3.mStr_name = @"理由:";
    model3.mStr_value = self.mModel_detail.LeaveReason;
    [self.mArr_list addObject:model3];
    //开始结束时间
    for (int i=0; i<self.mModel_detail.TimeList.count; i++) {
        LeaveDetailShowModel *model4 = [[LeaveDetailShowModel alloc] init];
        TimeListModel *tempModle = [self.mModel_detail.TimeList objectAtIndex:i];
        model4.mInt_flag = 4;
        model4.mStr_startTime = @"开始时间:";
        model4.mStr_startTimeValue = tempModle.Sdate;
        model4.mStr_goTime = @"离校时间:";
        model4.mStr_goTimeValue = tempModle.LeaveTime;
        model4.mStr_door = @"值班门卫:";
        model4.mStr_doorValue = tempModle.LWriterName;
        model4.mStr_endTime = @"结束时间:";
        model4.mStr_endTimeValue = tempModle.Edate;
        model4.mStr_comeTime = @"回校时间:";
        model4.mStr_comeTimeValue = tempModle.ComeTime;
        model4.mStr_door2 = @"值班门卫:";
        model4.mStr_door2Value = tempModle.CWriterName;
        [self.mArr_list addObject:model4];
    }
    //审核
    int a=0;
    if (self.mInt_falg == 0) {//学生
        a = [[dm getInstance].leaveModel.ApproveLevelStd intValue];
    }else if (self.mInt_falg == 1){//老师
        a = [[dm getInstance].leaveModel.ApproveLevelTea intValue];
    }
    for (int i=0; i<a; i++) {
        LeaveDetailShowModel *model5 = [[LeaveDetailShowModel alloc] init];
        model5.mInt_flag = 5;
        model5.mInt_check = i;
        if (i==0) {
            if (self.mInt_falg == 0) {//学生
                model5.mStr_name = [dm getInstance].leaveModel.LevelNoteStd.A;
            }else if (self.mInt_falg == 1){//老师
                model5.mStr_name = [dm getInstance].leaveModel.LevelNoteTea.A;
            }
            model5.mStr_status = self.mModel_detail.ApproveStatus;
            model5.mStr_node = self.mModel_detail.ApproveNote;
        }else if (i==1){
            if (self.mInt_falg == 0) {//学生
                model5.mStr_name = [dm getInstance].leaveModel.LevelNoteStd.B;
            }else if (self.mInt_falg == 1){//老师
                model5.mStr_name = [dm getInstance].leaveModel.LevelNoteTea.B;
            }
            model5.mStr_status = self.mModel_detail.ApproveStatus1;
            model5.mStr_node = self.mModel_detail.ApproveNote1;
        }else if (i==2){
            if (self.mInt_falg == 0) {//学生
                model5.mStr_name = [dm getInstance].leaveModel.LevelNoteStd.C;
            }else if (self.mInt_falg == 1){//老师
                model5.mStr_name = [dm getInstance].leaveModel.LevelNoteTea.C;
            }
            model5.mStr_status = self.mModel_detail.ApproveStatus2;
            model5.mStr_node = self.mModel_detail.ApproveNote2;
        }else if (i==3){
            if (self.mInt_falg == 0) {//学生
                model5.mStr_name = [dm getInstance].leaveModel.LevelNoteStd.D;
            }else if (self.mInt_falg == 1){//老师
                model5.mStr_name = [dm getInstance].leaveModel.LevelNoteTea.D;
            }
            model5.mStr_status = self.mModel_detail.ApproveStatus3;
            model5.mStr_node = self.mModel_detail.ApproveNote3;
        }else if (i==4){
            if (self.mInt_falg == 0) {//学生
                model5.mStr_name = [dm getInstance].leaveModel.LevelNoteStd.E;
            }else if (self.mInt_falg == 1){//老师                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        WriterIdWriterId
                model5.mStr_name = [dm getInstance].leaveModel.LevelNoteTea.E;
            }
            model5.mStr_status = self.mModel_detail.ApproveStatus4;
            model5.mStr_node = self.mModel_detail.ApproveNote4;
        }
        [self.mArr_list addObject:model5];
    }
    //撤回、修改，先判断假条发起人是否是当前账户
    if ([self.mModel_detail.WriterId intValue] == [[dm getInstance].jiaoBaoHao intValue]&&self.mInt_from==0) {
        //判断是否有审核状态
        if ([self.mModel_detail.ApproveStatus intValue]==0) {//待审核，可以撤回
            LeaveDetailShowModel *model6 = [[LeaveDetailShowModel alloc] init];
            model6.mInt_flag = 6;
            [self.mArr_list addObject:model6];
        }
    }
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mArr_list.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *LeaveDetailTableViewCell_indentifier = @"LeaveDetailTableViewCell";
    LeaveDetailShowModel *model = [self.mArr_list objectAtIndex:indexPath.row];
    
    LeaveDetailTableViewCell *cell = (LeaveDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:LeaveDetailTableViewCell_indentifier];
    if (cell == nil) {
        cell = [[LeaveDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LeaveDetailTableViewCell_indentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LeaveDetailTableViewCell" owner:self options:nil];
        //这时myCell对象已经通过自定义xib文件生成了
        if ([nib count]>0) {
            cell = (LeaveDetailTableViewCell *)[nib objectAtIndex:0];
            //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
        }
        
        //添加图片点击事件
        //若是需要重用，需要写上以下两句代码
        UINib * n= [UINib nibWithNibName:@"LeaveDetailTableViewCell" bundle:[NSBundle mainBundle]];
        [self.mTableV_leave registerNib:n forCellReuseIdentifier:LeaveDetailTableViewCell_indentifier];
    }
    cell.tag = indexPath.row;
    cell.mBtn_delete.hidden = YES;
    cell.mBtn_update.hidden = YES;
    cell.mBtn_checkDoor.hidden = YES;
    cell.mBtn_checkDoor2.hidden = YES;
    if (model.mInt_flag == 0||model.mInt_flag==1||model.mInt_flag==2||model.mInt_flag==3||model.mInt_flag==7) {//请假人、发起人、发起时间，理由
        cell.mLab_leave.hidden = NO;
        cell.mLab_leaveValue.hidden = NO;
        cell.mLab_go.hidden = YES;
        cell.mLab_goValue.hidden = YES;
        cell.mLab_door.hidden = YES;
        cell.mLab_doorValue.hidden = YES;
        cell.mLab_endTime.hidden = YES;
        cell.mLab_endTimeValue.hidden = YES;
        cell.mLab_comeTime.hidden = YES;
        cell.mLab_comeTimeValue.hidden = YES;
        cell.mLab_door2.hidden = YES;
        cell.mLab_door2Value.hidden = YES;
        cell.mBtn_check.hidden = YES;
        //标题
        CGSize nameSize = [model.mStr_name sizeWithFont:[UIFont systemFontOfSize:14]];
        cell.mLab_leave.frame = CGRectMake(14, (44-cell.mLab_leave.frame.size.height)/2, nameSize.width, cell.mLab_leave.frame.size.height);
        cell.mLab_leave.text = model.mStr_name;
        //内容显示
        CGSize valueSize = [model.mStr_value sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake([dm getInstance].width-nameSize.width-14*2, MAXFLOAT)];
        cell.mLab_leaveValue.frame = CGRectMake(cell.mLab_leave.frame.origin.x+cell.mLab_leave.frame.size.width+10, cell.mLab_leave.frame.origin.y, valueSize.width, valueSize.height);
        cell.mLab_leaveValue.numberOfLines = 0;
        cell.mLab_leaveValue.text = model.mStr_value;
    }else if (model.mInt_flag == 4){//开始结束时间
        cell.mLab_leave.hidden = NO;
        cell.mLab_leaveValue.hidden = NO;
        cell.mLab_go.hidden = NO;
        cell.mLab_goValue.hidden = NO;
        cell.mLab_door.hidden = NO;
        cell.mLab_doorValue.hidden = NO;
        cell.mLab_endTime.hidden = NO;
        cell.mLab_endTimeValue.hidden = NO;
        cell.mLab_comeTime.hidden = NO;
        cell.mLab_comeTimeValue.hidden = NO;
        cell.mLab_door2.hidden = NO;
        cell.mLab_door2Value.hidden = NO;
        cell.mBtn_check.hidden = YES;
        //标题，开始时间
        CGSize nameSize = [model.mStr_startTime sizeWithFont:[UIFont systemFontOfSize:14]];
        cell.mLab_leave.frame = CGRectMake(14, 10, nameSize.width, cell.mLab_leave.frame.size.height);
        cell.mLab_leave.text = model.mStr_startTime;
        CGSize nameSizeValue = [model.mStr_startTimeValue sizeWithFont:[UIFont systemFontOfSize:14]];
        cell.mLab_leaveValue.frame = CGRectMake(cell.mLab_leave.frame.origin.x+nameSize.width+10, 10, nameSizeValue.width, cell.mLab_leave.frame.size.height);
        cell.mLab_leaveValue.text = model.mStr_startTimeValue;
        //离校时间
        cell.mLab_go.frame = CGRectMake(cell.mLab_leave.frame.origin.x, cell.mLab_leave.frame.origin.y+cell.mLab_leave.frame.size.height+10, nameSize.width, cell.mLab_leave.frame.size.height);
        cell.mLab_go.text = model.mStr_goTime;
        CGSize goSizeValue = [model.mStr_goTimeValue sizeWithFont:[UIFont systemFontOfSize:14]];
        cell.mLab_goValue.frame = CGRectMake(cell.mLab_leave.frame.origin.x+nameSize.width+10, cell.mLab_go.frame.origin.y, goSizeValue.width, cell.mLab_leave.frame.size.height);
        cell.mLab_goValue.text = model.mStr_goTimeValue;
        //值班门卫
        cell.mLab_door.frame = CGRectMake(cell.mLab_leave.frame.origin.x, cell.mLab_go.frame.origin.y+cell.mLab_go.frame.size.height+10, nameSize.width, cell.mLab_leave.frame.size.height);
        cell.mLab_door.text = model.mStr_door;
        CGSize doorSizeValue = [model.mStr_doorValue sizeWithFont:[UIFont systemFontOfSize:14]];
        cell.mLab_doorValue.frame = CGRectMake(cell.mLab_leave.frame.origin.x+nameSize.width+10, cell.mLab_door.frame.origin.y, doorSizeValue.width, cell.mLab_leave.frame.size.height);
        cell.mLab_doorValue.text = model.mStr_doorValue;
        //结束时间
        cell.mLab_endTime.frame = CGRectMake(cell.mLab_leave.frame.origin.x, cell.mLab_door.frame.origin.y+cell.mLab_door.frame.size.height+10, nameSize.width, cell.mLab_leave.frame.size.height);
        cell.mLab_endTime.text = model.mStr_endTime;
        CGSize endSizeValue = [model.mStr_endTimeValue sizeWithFont:[UIFont systemFontOfSize:14]];
        cell.mLab_endTimeValue.frame = CGRectMake(cell.mLab_leave.frame.origin.x+nameSize.width+10, cell.mLab_endTime.frame.origin.y, endSizeValue.width, cell.mLab_leave.frame.size.height);
        cell.mLab_endTimeValue.text = model.mStr_endTimeValue;
        //回校时间
        cell.mLab_comeTime.frame = CGRectMake(cell.mLab_leave.frame.origin.x, cell.mLab_endTime.frame.origin.y+cell.mLab_endTime.frame.size.height+10, nameSize.width, cell.mLab_leave.frame.size.height);
        cell.mLab_comeTime.text = model.mStr_comeTime;
        CGSize comeSizeValue = [model.mStr_comeTimeValue sizeWithFont:[UIFont systemFontOfSize:14]];
        cell.mLab_comeTimeValue.frame = CGRectMake(cell.mLab_leave.frame.origin.x+nameSize.width+10, cell.mLab_comeTime.frame.origin.y, comeSizeValue.width, cell.mLab_leave.frame.size.height);
        cell.mLab_comeTimeValue.text = model.mStr_comeTimeValue;
        //值班门卫
        cell.mLab_door2.frame = CGRectMake(cell.mLab_leave.frame.origin.x, cell.mLab_comeTime.frame.origin.y+cell.mLab_comeTime.frame.size.height+10, nameSize.width, cell.mLab_leave.frame.size.height);
        cell.mLab_door2.text = model.mStr_door2;
        CGSize door2SizeValue = [model.mStr_door2Value sizeWithFont:[UIFont systemFontOfSize:14]];
        cell.mLab_door2Value.frame = CGRectMake(cell.mLab_leave.frame.origin.x+nameSize.width+10, cell.mLab_door2.frame.origin.y, door2SizeValue.width, cell.mLab_leave.frame.size.height);
        cell.mLab_door2Value.text = model.mStr_door2Value;
        //根据整个假条是否通过审核，然后有门卫权限，来做判断
        if (self.mInt_checkOver == 1) {//有门卫权限，并且来自门卫审核数组
            if (model.mStr_doorValue.length==0) {//没有签字过
                cell.mBtn_checkDoor.frame = CGRectMake(cell.mLab_door.frame.origin.x+cell.mLab_door.frame.size.width+10, cell.mLab_door.frame.origin.y-5, cell.mBtn_checkDoor.frame.size.width, cell.mBtn_checkDoor.frame.size.height);
                cell.mBtn_checkDoor.hidden = NO;
            }
            if (model.mStr_door2Value.length==0) {//没有签字过
                cell.mBtn_checkDoor2.frame = CGRectMake(cell.mLab_door2.frame.origin.x+cell.mLab_door2.frame.size.width+10, cell.mLab_door2.frame.origin.y-5, cell.mBtn_checkDoor2.frame.size.width, cell.mBtn_checkDoor2.frame.size.height);
                cell.mBtn_checkDoor2.hidden = NO;
            }
            cell.delegate = self;
        }
    }else if (model.mInt_flag == 5){//审核
        cell.mLab_leave.hidden = NO;
        cell.mLab_leaveValue.hidden = NO;
        cell.mLab_go.hidden = YES;
        cell.mLab_goValue.hidden = YES;
        cell.mLab_door.hidden = YES;
        cell.mLab_doorValue.hidden = YES;
        cell.mLab_endTime.hidden = YES;
        cell.mLab_endTimeValue.hidden = YES;
        cell.mLab_comeTime.hidden = YES;
        cell.mLab_comeTimeValue.hidden = YES;
        cell.mLab_door2.hidden = YES;
        cell.mLab_door2Value.hidden = YES;
        cell.mBtn_check.hidden = YES;
        //标题
        CGSize nameSize = [model.mStr_name sizeWithFont:[UIFont systemFontOfSize:14]];
        cell.mLab_leave.frame = CGRectMake(14, (44-cell.mLab_leave.frame.size.height)/2, nameSize.width, cell.mLab_leave.frame.size.height);
        cell.mLab_leave.text = model.mStr_name;
        //内容显示
        NSString *tempValue = @"";
        //0等待中;//1通过;//2拒绝
        if ([model.mStr_status intValue]==0) {
            cell.mLab_leaveValue.hidden = YES;
            cell.mBtn_check.hidden = YES;
            cell.mBtn_check.tag = indexPath.row;
            cell.delegate = self;
            if (self.mInt_falg == 0) {//学生
                if (model.mInt_check ==0) {
                    if (([[dm getInstance].userInfo.isAdmin intValue]==2||[[dm getInstance].userInfo.isAdmin intValue]==3)&&self.mInt_check ==1){//是否是班主任，班主任必有1审
                        cell.mBtn_check.frame = CGRectMake(cell.mLab_leave.frame.origin.x+cell.mLab_leave.frame.size.width+10, 10, cell.mBtn_check.frame.size.width, cell.mBtn_check.frame.size.height);
                        cell.mBtn_check.hidden = NO;
                    }
                }else if (model.mInt_check == 1&&self.mInt_check ==2){
                    //二审
                    if ([[dm getInstance].leaveModel.ApproveListStd.B isEqual:@"True"]) {
                        cell.mBtn_check.frame = CGRectMake(cell.mLab_leave.frame.origin.x+cell.mLab_leave.frame.size.width+10, 10, cell.mBtn_check.frame.size.width, cell.mBtn_check.frame.size.height);
                        cell.mBtn_check.hidden = NO;
                    }
                }else if (model.mInt_check == 2&&self.mInt_check ==3){
                    //三审
                    if ([[dm getInstance].leaveModel.ApproveListStd.C isEqual:@"True"]) {
                        cell.mBtn_check.frame = CGRectMake(cell.mLab_leave.frame.origin.x+cell.mLab_leave.frame.size.width+10, 10, cell.mBtn_check.frame.size.width, cell.mBtn_check.frame.size.height);
                        cell.mBtn_check.hidden = NO;
                    }
                }else if (model.mInt_check == 3&&self.mInt_check ==4){
                    //四审
                    if ([[dm getInstance].leaveModel.ApproveListStd.D isEqual:@"True"]) {
                        cell.mBtn_check.frame = CGRectMake(cell.mLab_leave.frame.origin.x+cell.mLab_leave.frame.size.width+10, 10, cell.mBtn_check.frame.size.width, cell.mBtn_check.frame.size.height);
                        cell.mBtn_check.hidden = NO;
                    }
                }else if (model.mInt_check == 4&&self.mInt_check ==5){
                    //五审
                    if ([[dm getInstance].leaveModel.ApproveListStd.E isEqual:@"True"]) {
                        cell.mBtn_check.frame = CGRectMake(cell.mLab_leave.frame.origin.x+cell.mLab_leave.frame.size.width+10, 10, cell.mBtn_check.frame.size.width, cell.mBtn_check.frame.size.height);
                        cell.mBtn_check.hidden = NO;
                    }
                }
            }else{//老师
                if (model.mInt_check ==0) {
                    //一审
                    if ([[dm getInstance].leaveModel.ApproveListTea.A isEqual:@"True"]&&self.mInt_check ==1) {
                        cell.mBtn_check.frame = CGRectMake(cell.mLab_leave.frame.origin.x+cell.mLab_leave.frame.size.width+10, 10, cell.mBtn_check.frame.size.width, cell.mBtn_check.frame.size.height);
                        cell.mBtn_check.hidden = NO;
                    }
                }else if (model.mInt_check == 1){
                    //二审
                    if ([[dm getInstance].leaveModel.ApproveListTea.B isEqual:@"True"]&&self.mInt_check ==2) {
                        cell.mBtn_check.frame = CGRectMake(cell.mLab_leave.frame.origin.x+cell.mLab_leave.frame.size.width+10, 10, cell.mBtn_check.frame.size.width, cell.mBtn_check.frame.size.height);
                        cell.mBtn_check.hidden = NO;
                    }
                }else if (model.mInt_check == 2){
                    //三审
                    if ([[dm getInstance].leaveModel.ApproveListTea.C isEqual:@"True"]&&self.mInt_check ==3) {
                        cell.mBtn_check.frame = CGRectMake(cell.mLab_leave.frame.origin.x+cell.mLab_leave.frame.size.width+10, 10, cell.mBtn_check.frame.size.width, cell.mBtn_check.frame.size.height);
                        cell.mBtn_check.hidden = NO;
                    }
                }else if (model.mInt_check == 3){
                    //四审
                    if ([[dm getInstance].leaveModel.ApproveListTea.D isEqual:@"True"]&&self.mInt_check ==4) {
                        cell.mBtn_check.frame = CGRectMake(cell.mLab_leave.frame.origin.x+cell.mLab_leave.frame.size.width+10, 10, cell.mBtn_check.frame.size.width, cell.mBtn_check.frame.size.height);
                        cell.mBtn_check.hidden = NO;
                    }
                }else if (model.mInt_check == 4){
                    //五审
                    if ([[dm getInstance].leaveModel.ApproveListTea.E isEqual:@"True"]&&self.mInt_check ==5) {
                        cell.mBtn_check.frame = CGRectMake(cell.mLab_leave.frame.origin.x+cell.mLab_leave.frame.size.width+10, 10, cell.mBtn_check.frame.size.width, cell.mBtn_check.frame.size.height);
                        cell.mBtn_check.hidden = NO;
                    }
                }
            }
        }else {
            if ([model.mStr_status intValue]==1) {
                tempValue = @"同意。";
            }else if ([model.mStr_status intValue]==2){
                tempValue = @"拒绝。";
            }
            tempValue = [NSString stringWithFormat:@"%@%@",tempValue,model.mStr_node];
            if ([tempValue isKindOfClass:[NSNull class]]||[tempValue isEqual:@"null"]||[tempValue isEqual:@"<null>"]) {
                tempValue = @"";
            }else{
                
            }
            CGSize valueSize = [tempValue sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake([dm getInstance].width-nameSize.width-14*2, MAXFLOAT)];
            cell.mLab_leaveValue.frame = CGRectMake(cell.mLab_leave.frame.origin.x+cell.mLab_leave.frame.size.width+10, cell.mLab_leave.frame.origin.y, valueSize.width, valueSize.height);
            cell.mLab_leaveValue.numberOfLines = 0;
            cell.mLab_leaveValue.text = tempValue;
        }
    }else if (model.mInt_flag == 6){//撤销，修改
        cell.mLab_leave.hidden = YES;
        cell.mLab_leaveValue.hidden = YES;
        cell.mLab_go.hidden = YES;
        cell.mLab_goValue.hidden = YES;
        cell.mLab_door.hidden = YES;
        cell.mLab_doorValue.hidden = YES;
        cell.mLab_endTime.hidden = YES;
        cell.mLab_endTimeValue.hidden = YES;
        cell.mLab_comeTime.hidden = YES;
        cell.mLab_comeTimeValue.hidden = YES;
        cell.mLab_door2.hidden = YES;
        cell.mLab_door2Value.hidden = YES;
        cell.mBtn_check.hidden = YES;
        cell.mBtn_delete.hidden = NO;
        cell.mBtn_update.hidden = NO;
        cell.delegate = self;
        float tempF = ([dm getInstance].width-cell.mBtn_delete.frame.size.width*2)/3;
        cell.mBtn_delete.frame = CGRectMake(tempF, 10, cell.mBtn_delete.frame.size.width, cell.mBtn_delete.frame.size.height);
        cell.mBtn_update.frame = CGRectMake(tempF*2+cell.mBtn_delete.frame.size.width, 10, cell.mBtn_update.frame.size.width, cell.mBtn_update.frame.size.height);
    }
    return cell;
}

/*---------------------------------------
 cell高度默认为50
 --------------------------------------- */
-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    LeaveDetailShowModel *model = [self.mArr_list objectAtIndex:indexPath.row];
    if (model.mInt_flag == 0||model.mInt_flag==1||model.mInt_flag==2) {//请假人、发起人、发起时间，
        return 44;
    }else if (model.mInt_flag == 3){//理由
        //标题
        CGSize nameSize = [model.mStr_name sizeWithFont:[UIFont systemFontOfSize:14]];
        //内容显示
        CGSize valueSize = [model.mStr_value sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake([dm getInstance].width-nameSize.width-14*2, MAXFLOAT)];
        valueSize.height = valueSize.height+20;
        if (valueSize.height>44) {
            return valueSize.height;
        }else{
            return 44;
        }
    }else if (model.mInt_flag == 5){//审核
        //标题
        CGSize nameSize = [model.mStr_name sizeWithFont:[UIFont systemFontOfSize:14]];
        //内容显示
        NSString *tempValue = @"";
        if ([model.mStr_status intValue]==1) {
            tempValue = @"同意。";
        }else if ([model.mStr_status intValue]==2){
            tempValue = @"拒绝。";
        }
        tempValue = [NSString stringWithFormat:@"%@%@",tempValue,model.mStr_node];
        if ([tempValue isKindOfClass:[NSNull class]]||[tempValue isEqual:@"null"]||[tempValue isEqual:@"<null>"]) {
            tempValue = @"";
        }else{
            
        }
        CGSize valueSize = [tempValue sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake([dm getInstance].width-nameSize.width-14*2, MAXFLOAT)];
        valueSize.height = valueSize.height+20;
        if (valueSize.height>44) {
            return valueSize.height;
        }else{
            return 44;
        }
    }else if (model.mInt_flag == 4){//开始结束时间
        return 195;
    }
    return 50;
}

/*---------------------------------------
 处理cell选中事件，需要自定义的部分
 --------------------------------------- */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//cell的回调
//审核
-(void)LeaveDetailTableViewCellCheckBtn:(LeaveDetailTableViewCell *)cell{
    CheckSubViewController *check = [[CheckSubViewController alloc] init];
    self.mModel_detail.cellFlag = self.mInt_index;
    self.mModel_detail.level = [NSString stringWithFormat:@"%d",self.mInt_check];
    check.mModel_LeaveDetail = self.mModel_detail;
    [utils pushViewController:check animated:YES];
}
//删除
-(void)LeaveDetailTableViewCellDeleteBtn:(LeaveDetailTableViewCell *)cell{
    UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:@"确定删除？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles: nil];
    sheet.tag = 2;
    [sheet showInView:self.view];
}
//修改
-(void)LeaveDetailTableViewCellUpdateBtn:(LeaveDetailTableViewCell *)cell{
    UpdateLeaveViewController *update = [[UpdateLeaveViewController alloc] init];
    update.mStr_navName = @"修改假条";
    self.mModel_detail.cellFlag = self.mInt_index;
    update.mModel_detail = self.mModel_detail;
    update.mInt_flag = self.mInt_falg;
    [utils pushViewController:update animated:YES];
}
//门卫离校签字
-(void)LeaveDetailTableViewCellCheckDoorBtn:(LeaveDetailTableViewCell *)cell{
    UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:@"确定签字？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles: nil];
    sheet.tag = 0;
    [sheet showInView:self.view];
}
//门卫回校签字
-(void)LeaveDetailTableViewCellCheckDoor2Btn:(LeaveDetailTableViewCell *)cell{
    UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:@"确定签字？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles: nil];
    sheet.tag = 1;
    [sheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //该方法由UIActionSheetDelegate协议定义，在点击ActionSheet的按钮后自动执行
    if (buttonIndex == 0) {//确定,删除假条
        if (actionSheet.tag == 2) {//删除
            [[LeaveHttp getInstance] DeleteLeaveModel:self.mModel_detail.TabID];
        }else if (actionSheet.tag == 0){//门卫离校签字
            [[LeaveHttp getInstance] UpdateGateInfo:self.mModel_classLeaves.TabID userName:[dm getInstance].name flag:@"0"];
        }else if (actionSheet.tag == 1){//门卫回校签字
             [[LeaveHttp getInstance] UpdateGateInfo:self.mModel_classLeaves.TabID userName:[dm getInstance].name flag:@"1"];
        }
        [MBProgressHUD showMessage:@"" toView:self.view];
    }else if (buttonIndex == 1) {//取消
        
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
