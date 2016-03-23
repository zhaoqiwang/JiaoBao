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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //获取假条明细
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetLeaveModel" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetLeaveModel:) name:@"GetLeaveModel" object:nil];
    
    self.mArr_list = [NSMutableArray array];
    self.mModel_detail = [[LeaveDetailModel alloc] init];
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:self.mStr_navName];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    
    //表格
    self.mTableV_leave.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height-[dm getInstance].statusBar, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height+[dm getInstance].statusBar);
    
    //获取假条明细
    [[LeaveHttp getInstance] GetLeaveModel:@"6"];
    
}

//获取假条明细
-(void)GetLeaveModel:(NSNotification *)noti{
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
        if (i==0) {
            model5.mStr_name = @"一审:";
            model5.mStr_status = self.mModel_detail.ApproveStatus;
            model5.mStr_node = self.mModel_detail.ApproveNote;
        }else if (i==1){
            model5.mStr_name = @"二审:";
            model5.mStr_status = self.mModel_detail.ApproveStatus1;
            model5.mStr_node = self.mModel_detail.ApproveNote1;
        }else if (i==2){
            model5.mStr_name = @"三审:";
            model5.mStr_status = self.mModel_detail.ApproveStatus2;
            model5.mStr_node = self.mModel_detail.ApproveNote2;
        }else if (i==3){
            model5.mStr_name = @"四审:";
            model5.mStr_status = self.mModel_detail.ApproveStatus3;
            model5.mStr_node = self.mModel_detail.ApproveNote3;
        }else if (i==4){
            model5.mStr_name = @"五审:";
            model5.mStr_status = self.mModel_detail.ApproveStatus4;
            model5.mStr_node = self.mModel_detail.ApproveNote4;
        }
        [self.mArr_list addObject:model5];
    }
    //撤回、修改，先判断假条发起人是否是当前账户
    if ([self.mModel_detail.Writer isEqual:[dm getInstance].TrueName]) {
        //判断是否有审核状态
        if (self.mModel_detail.ApproveStatus==0) {//待审核，可以撤回
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
    cell.mBtn_delete.hidden = YES;
    cell.mBtn_update.hidden = YES;
    if (model.mInt_flag == 0||model.mInt_flag==1||model.mInt_flag==2||model.mInt_flag==3) {//请假人、发起人、发起时间，理由
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
        CGSize valueSize = [model.mStr_value sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake([dm getInstance].width-10-14*2, MAXFLOAT)];
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
        //            0等待中;//1通过;//2拒绝
        if ([model.mStr_status intValue]==1) {
            tempValue = @"同意。";
        }else if ([model.mStr_status intValue]==2){
            tempValue = @"拒绝";
        }
        tempValue = [NSString stringWithFormat:@"%@%@",tempValue,model.mStr_node];
        if ([tempValue isKindOfClass:[NSNull class]]||[tempValue isEqual:@"null"]||[tempValue isEqual:@"<null>"]) {
            tempValue = @"";
        }else{
            
        }
        CGSize valueSize = [tempValue sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake([dm getInstance].width-10-14*2, MAXFLOAT)];
        cell.mLab_leaveValue.frame = CGRectMake(cell.mLab_leave.frame.origin.x+cell.mLab_leave.frame.size.width+10, cell.mLab_leave.frame.origin.y, valueSize.width, valueSize.height);
        cell.mLab_leaveValue.numberOfLines = 0;
        cell.mLab_leaveValue.text = tempValue;
    }else if (model.mInt_flag == 5){//审核
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
    if (model.mInt_flag == 0||model.mInt_flag==1||model.mInt_flag==2||model.mInt_flag==3||model.mInt_flag==5) {//请假人、发起人、发起时间，理由
        return 44;
    }else if (model.mInt_flag == 4){//开始结束时间
        return 190;
    }
    return 50;
}

/*---------------------------------------
 处理cell选中事件，需要自定义的部分
 --------------------------------------- */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
