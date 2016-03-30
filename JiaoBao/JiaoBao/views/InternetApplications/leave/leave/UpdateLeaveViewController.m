//
//  UpdateLeaveViewController.m
//  JiaoBao
//
//  Created by Zqw on 16/3/30.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "UpdateLeaveViewController.h"

@interface UpdateLeaveViewController ()

@end

@implementation UpdateLeaveViewController

-(instancetype)init{
    self = [super init];
    self.mArr_leave = [NSMutableArray array];
    self.mModel_detail = [[LeaveDetailModel alloc] init];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:self.mStr_navName];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    
    self.mTableV_leave.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height-[dm getInstance].statusBar, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height+[dm getInstance].statusBar);
    self.mTableV_leave.tableFooterView = [[UIView alloc]init];
    //初始化数据
    [self initDetailLeave];
}

//初始化数据
-(void)initDetailLeave{
    if (self.mInt_flag == 1) {//自己请假
        
    }else{//班主任代请或者家长代假
        LeaveNowModel *model = [[LeaveNowModel alloc] init];
        model.mInt_flag = 0 ;//选择学生
        model.mStr_name = @"学生";
        model.mStr_value = self.mModel_detail.ManName;
        [self.mArr_leave addObject:model];
    }
    for (int i=0; i<4; i++) {
        LeaveNowModel *model = [[LeaveNowModel alloc] init];
//          mInt_flag;//判断是哪个cell，0选人，1理由选择，2理由填写，3时间显示，4添加时间段，5提交
        if (i==0) {
            model.mInt_flag = 1 ;//1理由选择
            model.mStr_name = @"理由";
            model.mStr_value = self.mModel_detail.LeaveType;
        }else if (i==1){
            model.mInt_flag = 2 ;//2理由填写
            model.mStr_name = @"理由";
            if ([self.mModel_detail.LeaveReason isEqual:@"<null>"]||[self.mModel_detail.LeaveReason isKindOfClass:[NSNull class]]) {
                model.mStr_value = @"";
            }else{
                model.mStr_value = self.mModel_detail.LeaveReason;
            }
        }else if (i==2){
            model.mInt_flag = 4 ;//4添加时间段
            model.mStr_name = @"添加时间段";
        }else if (i==3){
            model.mInt_flag = 5 ;//5提交
            model.mStr_name = @"学生";
        }
        [self.mArr_leave addObject:model];
    }
    for (int i=0; i<self.mModel_detail.TimeList.count; i++) {
        TimeListModel *tempModel = [self.mModel_detail.TimeList objectAtIndex:i];
        LeaveNowModel *model = [[LeaveNowModel alloc] init];
        model.mInt_flag = 3 ;//3具体时间段
        model.mStr_startTime = tempModel.Sdate;
        model.mStr_startTime = tempModel.Edate;
        [self.mArr_leave insertObject:model atIndex:self.mArr_leave.count-2];
    }
    [self.mTableV_leave reloadData];
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mArr_leave.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *LeaveNow_indentifier = @"LeaveNowTableViewCell";
    static NSString *addDateCell_indentifier = @"addDateCell";
    LeaveNowModel *model = [self.mArr_leave objectAtIndex:indexPath.row];
    if (model.mInt_flag==3) {
        addDateCell *cell = (addDateCell *)[tableView dequeueReusableCellWithIdentifier:addDateCell_indentifier];
        if (cell == nil) {
            cell = [[addDateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addDateCell_indentifier];
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"addDateCell" owner:self options:nil];
            //这时myCell对象已经通过自定义xib文件生成了
            if ([nib count]>0) {
                cell = (addDateCell *)[nib objectAtIndex:0];
                //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
            }
            
            //添加图片点击事件
            //若是需要重用，需要写上以下两句代码
            UINib * n= [UINib nibWithNibName:@"addDateCell" bundle:[NSBundle mainBundle]];
            [self.mTableV_leave registerNib:n forCellReuseIdentifier:addDateCell_indentifier];
        }
        cell.tag = indexPath.row;
        cell.delegate = self;
        //删除按钮
        cell.mBtn_delete.frame = CGRectMake(14, (80-cell.mBtn_delete.frame.size.height)/2, cell.mBtn_delete.frame.size.width, cell.mBtn_delete.frame.size.height);
        //时间显示
        cell.mLab_start.frame = CGRectMake(cell.mBtn_delete.frame.origin.x+cell.mBtn_delete.frame.size.width+10, 10, cell.mLab_start.frame.size.width, cell.mLab_start.frame.size.height);
        cell.mLab_end.frame = CGRectMake(cell.mLab_start.frame.origin.x, cell.mLab_start.frame.origin.y+40, cell.mLab_start.frame.size.width, cell.mLab_start.frame.size.height);
        cell.mLab_startNow.frame = CGRectMake(cell.mLab_start.frame.origin.x+cell.mLab_start.frame.size.width+10, cell.mLab_start.frame.origin.y, cell.mLab_startNow.frame.size.width, cell.mLab_startNow.frame.size.height);
        cell.mLab_endNow.frame = CGRectMake(cell.mLab_startNow.frame.origin.x, cell.mLab_startNow.frame.origin.y+40, cell.mLab_startNow.frame.size.width, cell.mLab_startNow.frame.size.height);
        cell.mLab_startNow.text = model.mStr_startTime;
        cell.mLab_endNow.text = model.mStr_endTime;
        return cell;
    }else{
        LeaveNowTableViewCell *cell = (LeaveNowTableViewCell *)[tableView dequeueReusableCellWithIdentifier:LeaveNow_indentifier];
        if (cell == nil) {
            cell = [[LeaveNowTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LeaveNow_indentifier];
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LeaveNowTableViewCell" owner:self options:nil];
            //这时myCell对象已经通过自定义xib文件生成了
            if ([nib count]>0) {
                cell = (LeaveNowTableViewCell *)[nib objectAtIndex:0];
                //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
            }
            
            //添加图片点击事件
            //若是需要重用，需要写上以下两句代码
            UINib * n= [UINib nibWithNibName:@"LeaveNowTableViewCell" bundle:[NSBundle mainBundle]];
            [self.mTableV_leave registerNib:n forCellReuseIdentifier:LeaveNow_indentifier];
        }
        if (model.mInt_flag == 0||model.mInt_flag==1) {//选择学生,理由选择
            cell.mLab_name.hidden = NO;
            cell.mLab_value.hidden = NO;
            cell.mLab_add.hidden = YES;
            cell.mBtn_add.hidden = YES;
            cell.mBtn_submit.hidden = YES;
            cell.mTextF_reason.hidden = YES;
            //标题
            cell.mLab_name.frame = CGRectMake(14, (44-cell.mLab_name.frame.size.height)/2, cell.mLab_name.frame.size.width, cell.mLab_name.frame.size.height);
            cell.mLab_name.text = model.mStr_name;
            //内容显示
            if (model.mStr_value.length>0) {
                cell.mLab_value.text = model.mStr_value;
            }else{
                if (model.mInt_flag==0) {
                    cell.mLab_value.text = @"请选择学生";
                }else{
                    cell.mLab_value.text = @"请选择理由";
                }
            }
            CGSize valueSize = [cell.mLab_value.text sizeWithFont:[UIFont systemFontOfSize:14]];
            cell.mLab_value.frame = CGRectMake(cell.mLab_name.frame.origin.x+cell.mLab_name.frame.size.width+20, cell.mLab_name.frame.origin.y, valueSize.width, cell.mLab_name.frame.size.height);
        }else if (model.mInt_flag == 1){//理由选择
            cell.mLab_name.hidden = NO;
            cell.mLab_value.hidden = NO;
            cell.mLab_add.hidden = YES;
            cell.mBtn_add.hidden = YES;
            cell.mBtn_submit.hidden = YES;
            cell.mTextF_reason.hidden = YES;
        }else if (model.mInt_flag == 2){//理由填写
            cell.mLab_name.hidden = NO;
            cell.mLab_value.hidden = YES;
            cell.mLab_add.hidden = YES;
            cell.mBtn_add.hidden = YES;
            cell.mBtn_submit.hidden = YES;
            cell.mTextF_reason.hidden = NO;
            //标题
            cell.mLab_name.frame = CGRectMake(14, (44-cell.mLab_name.frame.size.height)/2, cell.mLab_name.frame.size.width, cell.mLab_name.frame.size.height);
            cell.mLab_name.text = model.mStr_name;
            //内容显示
            cell.mTextF_reason.frame = CGRectMake(cell.mLab_name.frame.origin.x+cell.mLab_name.frame.size.width+20, cell.mLab_name.frame.origin.y, [dm getInstance].width-cell.mLab_name.frame.origin.x-cell.mLab_name.frame.size.width-40, cell.mTextF_reason.frame.size.height);
            cell.mTextF_reason.text = model.mStr_value;
        }else if (model.mInt_flag == 4){//添加时间段
            cell.mLab_name.hidden = YES;
            cell.mLab_value.hidden = YES;
            cell.mLab_add.hidden = NO;
            cell.mBtn_add.hidden = NO;
            cell.mBtn_submit.hidden = YES;
            cell.mTextF_reason.hidden = YES;
            //添加按钮
            cell.mBtn_add.frame = CGRectMake(14, (44-cell.mBtn_add.frame.size.height)/2, cell.mBtn_add.frame.size.width, cell.mBtn_add.frame.size.height);
            cell.mLab_add.frame = CGRectMake(cell.mBtn_add.frame.origin.x+cell.mBtn_add.frame.size.width+20, cell.mBtn_add.frame.origin.y, cell.mLab_add.frame.size.width, cell.mLab_add.frame.size.height);
        }else if (model.mInt_flag == 5){//提交
            cell.mLab_name.hidden = YES;
            cell.mLab_value.hidden = YES;
            cell.mLab_add.hidden = YES;
            cell.mBtn_add.hidden = YES;
            cell.mBtn_submit.hidden = NO;
            cell.mTextF_reason.hidden = YES;
            cell.mBtn_submit.frame = CGRectMake(([dm getInstance].width-cell.mBtn_submit.frame.size.width)/2, 10, cell.mBtn_submit.frame.size.width, cell.mBtn_submit.frame.size.height);
        }
        return cell;
    }
    
    return 0;
}

/*---------------------------------------
 cell高度默认为50
 --------------------------------------- */
-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    LeaveNowModel *model = [self.mArr_leave objectAtIndex:indexPath.row];
    if (model.mInt_flag == 0||model.mInt_flag==1) {//选择学生,理由选择
        return 44;
    }else if (model.mInt_flag == 3){//时间段显示
        return 80;
    }else if (model.mInt_flag == 5){//提交
        return 50;
    }
    return 50;
}

/*---------------------------------------
 处理cell选中事件，需要自定义的部分
 --------------------------------------- */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LeaveNowModel *model = [self.mArr_leave objectAtIndex:indexPath.row];
    if (model.mInt_flag == 0) {//选择学生
        
    }else if (model.mInt_flag == 1){//理由选择
        ChooseStudentViewController *chooseStu = [[ChooseStudentViewController alloc] init];
        chooseStu.delegate = self;
        chooseStu.mInt_flag = 1;
        chooseStu.mStr_navName = @"选择理由";
        [utils pushViewController:chooseStu animated:YES];
    }else if (model.mInt_flag == 2){//理由填写
        
    }else if (model.mInt_flag == 3){//时间段显示
        [self addDialog:1 row:(int)indexPath.row Model:model];
    }else if (model.mInt_flag == 4){//时间段添加
        //先判断当前有几个时间，不能大于5个
        int a=0;
        for (LeaveNowModel *tempModel in self.mArr_leave) {
            if (tempModel.mInt_flag==3) {
                a++;
            }
        }
        if (a>=5) {
            [MBProgressHUD showError:@"最多可以有5个时间段" toView:self.view];
        }else{
            LeaveNowModel *model1 = [[LeaveNowModel alloc] init];
            [self addDialog:1 row:0 Model:model1];
        }
    }else if (model.mInt_flag == 5){//提交
        [self addLeave];
    }
}

//提交按钮事件
-(void)addLeave{
    //先判断是否是家长或者班主任代请
//    if (self.mInt_flag==0||self.mInt_flag==2) {
//        if (self.mInt_select0==0) {//没有选择人员
//            [MBProgressHUD showError:@"请选择请假人" toView:self];
//            return;
//        }
//    }
//    //请假理由
//    if (self.mInt_select1==0) {
//        [MBProgressHUD showError:@"请选择请假理由" toView:self];
//        return;
//    }
//    //判断有没有添加时间段
//    //循环计算添加的时间段
//    NSMutableArray *tempArr = [NSMutableArray array];
//    for (LeaveNowModel *tempModel in self.mArr_leave) {
//        if (tempModel.mInt_flag==3) {
//            [tempArr addObject:tempModel];
//        }
//    }
//    if (tempArr.count==0) {
//        [MBProgressHUD showError:@"请添加请假时间" toView:self];
//        return;
//    }
//    
//    NewLeaveModel *model = [[NewLeaveModel alloc] init];
//    model.UnitId = [NSString stringWithFormat:@"%d",[dm getInstance].UID];
//    //判断是否是家长或者班主任代请
//    if (self.mInt_flag==0) {//班主任代请0
//        model.manId = self.mModel_studentInfo.StudentID;
//        model.manName = self.mModel_studentInfo.StdName;
//        model.gradeStr = self.mModel_studentInfo.GradeName;
//        model.classStr = self.mModel_studentInfo.ClassName;
//        model.unitClassId = self.mModel_studentInfo.UnitClassID;
//        model.manType = @"0";
//    }else if (self.mInt_flag ==2){//家长代请2
//        model.manId = self.mModel_student.TabID;
//        model.manName = self.mModel_student.StdName;
//        model.gradeStr = self.mModel_student.GradeName;
//        model.classStr = self.mModel_student.ClsName;
//        model.unitClassId = self.mModel_student.ClassId;
//        model.manType = @"0";
//    }else{//普通老师、班主任自己请假
//        model.manId = [dm getInstance].userInfo.UserID;
//        model.manType = @"1";
//        model.manName = [dm getInstance].userInfo.UserName;
//    }
//    model.writerId = [dm getInstance].jiaoBaoHao;
//    model.writer = [dm getInstance].TrueName;
//    for (LeaveNowModel *tempModel in self.mArr_leave) {
//        if (tempModel.mInt_flag==1) {
//            model.leaveType = tempModel.mStr_value;
//        }else if (tempModel.mInt_flag ==2){
//            model.leaveReason = tempModel.mStr_value;
//        }
//    }
//    
//    //循环赋值时间段
//    for (int i=0; i<tempArr.count; i++) {
//        LeaveNowModel *tempNowModel = [tempArr objectAtIndex:i];
//        if (i==0) {
//            model.sDateTime = tempNowModel.mStr_startTime;
//            model.eDateTime = tempNowModel.mStr_endTime;
//        }else if (i==1){
//            model.sDateTime1 = tempNowModel.mStr_startTime;
//            model.eDateTime1 = tempNowModel.mStr_endTime;
//        }else if (i==2){
//            model.sDateTime2 = tempNowModel.mStr_startTime;
//            model.eDateTime2 = tempNowModel.mStr_endTime;
//        }else if (i==3){
//            model.sDateTime3 = tempNowModel.mStr_startTime;
//            model.eDateTime3 = tempNowModel.mStr_endTime;
//        }else if (i==4){
//            model.sDateTime4 = tempNowModel.mStr_startTime;
//            model.eDateTime4 = tempNowModel.mStr_endTime;
//        }
//    }
//    [[LeaveHttp getInstance] NewLeaveModel:model];
    [MBProgressHUD showMessage:@"" toView:self.view];
}

//弹出时间选择框
-(void)addDialog:(int)flag row:(int)row Model:(LeaveNowModel *)model{
    UIView* vwFullScreenView = [[UIView alloc]init];
    vwFullScreenView.tag=9999;
    vwFullScreenView.backgroundColor=[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:0.5];
    vwFullScreenView.frame=self.view.frame;
    [self.view addSubview:vwFullScreenView];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ModelDialog" owner:self options:nil];
    //这时myCell对象已经通过自定义xib文件生成了
    if ([nib count]>0) {
        ModelDialog *customView = [nib objectAtIndex:0];
        
        customView.frame=CGRectMake(10, 0, [dm getInstance].width-20, 135);
        customView.center=vwFullScreenView.center;
        customView.layer.borderWidth=0.6;
        customView.layer.cornerRadius=6;
        customView.layer.borderColor = [UIColor clearColor].CGColor;
        customView.delegate = self;
        customView.flag = flag;//0是修改 1是添加
        customView.row = row;
        customView.model = model;
        [customView setUp];
        [vwFullScreenView addSubview:customView];
    }
}

//时间dialog点击确定后的回调
-(void)LeaveNowModel:(LeaveNowModel *)model flag:(int)flag row:(NSInteger)row{
    //判断是新增的1，还是修改的0
    if (flag == 0) {
        [self.mArr_leave replaceObjectAtIndex:row withObject:model];
    }else{
        [self.mArr_leave insertObject:model atIndex:self.mArr_leave.count-2];
    }
    [self.mTableV_leave reloadData];
}

//删除时间段按钮的回调
-(void)addDateCellDeleteBtn:(addDateCell *)view{
    [self.mArr_leave removeObjectAtIndex:view.tag];
    [self.mTableV_leave reloadData];
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
