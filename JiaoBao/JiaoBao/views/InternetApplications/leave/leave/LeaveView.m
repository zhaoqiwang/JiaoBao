//
//  LeaveView.m
//  JiaoBao
//
//  Created by Zqw on 16/3/12.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "LeaveView.h"
#import "IQKeyboardManager.h"
#import "NSString+Extension.h"

@implementation LeaveView

- (id)initWithFrame1:(CGRect)frame flag:(int)flag flagID:(int)flagID{
    self = [super init];
    if (self){
        //使用NSNotificationCenter 鍵盤隐藏時
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"keyboardWillBeHidden" object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
        // Initialization code
        self.frame = frame;
        self.mInt_flag = flag;
        self.mInt_flagID = flagID;
        self.mArr_leave = [NSMutableArray array];
        if (self.mInt_flag == 1) {//自己请假
            
        }else{//班主任代请或者家长代假
            LeaveNowModel *model = [[LeaveNowModel alloc] init];
            model.mInt_flag = 0 ;//选择学生
            model.mStr_name = @"学生";
            [self.mArr_leave addObject:model];
            //当家长情况只有一个学生时，给默认值
            if (self.mInt_flagID == 3) {
                if ([dm getInstance].mArr_leaveStudent.count>0) {
                    self.mModel_student = [[dm getInstance].mArr_leaveStudent objectAtIndex:0];
                    LeaveNowModel *model = [self.mArr_leave objectAtIndex:0];
                    model.mStr_value = self.mModel_student.StdName;
                    self.mInt_select0 = 1;
                }
            }
        }
        for (int i=0; i<4; i++) {
            LeaveNowModel *model = [[LeaveNowModel alloc] init];
//            mInt_flag;//判断是哪个cell，0选人，1理由选择，2理由填写，3时间显示，4添加时间段，5提交
            if (i==0) {
                model.mInt_flag = 1 ;//1理由选择
                model.mStr_name = @"理由";
            }else if (i==1){
                model.mInt_flag = 2 ;//2理由填写
                model.mStr_name = @"理由";
            }else if (i==2){
                model.mInt_flag = 4 ;//4添加时间段
                model.mStr_name = @"添加时间段";
            }else if (i==3){
                model.mInt_flag = 5 ;//5提交
                model.mStr_name = @"学生";
            }
            [self.mArr_leave addObject:model];
        }
        //表格
        self.mTableV_leave = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, self.frame.size.height)];
        self.mTableV_leave.delegate = self;
        self.mTableV_leave.dataSource = self;
        //去掉底部多余的表格线
        self.mTableV_leave.tableFooterView = [[UIView alloc]init];
        self.mTableV_leave.separatorStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.mTableV_leave];
        [self.mTableV_leave reloadData];
        
        //输入框弹出键盘问题
        IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
        manager.enable = YES;//控制整个功能是否启用
        manager.shouldResignOnTouchOutside = YES;//控制点击背景是否收起键盘
        manager.shouldToolbarUsesTextFieldTintColor = NO;//控制键盘上的工具条文字颜色是否用户自定义
        manager.enableAutoToolbar = NO;//控制是否显示键盘上的工具条
    }
    return self;
}

//生成一条请假条记录
-(void)NewLeaveModel:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self];
    NSMutableDictionary *dic = noti.object;
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
    NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
    if ([ResultCode intValue]==0) {
        //清空选项
        for (int i=(int)self.mArr_leave.count-1;i>=0;i--) {
            LeaveNowModel *tempModel = [self.mArr_leave objectAtIndex:i];
            if (tempModel.mInt_flag==0||tempModel.mInt_flag==1||tempModel.mInt_flag==2) {
                tempModel.mStr_value = @"";
            }else if (tempModel.mInt_flag==3) {
                [self.mArr_leave removeObjectAtIndex:i];
            }
        }
        //当家长情况只有一个学生时，给默认值
        if (self.mInt_flagID == 3) {
            if ([dm getInstance].mArr_leaveStudent.count>0) {
                self.mModel_student = [[dm getInstance].mArr_leaveStudent objectAtIndex:0];
                LeaveNowModel *model = [self.mArr_leave objectAtIndex:0];
                model.mStr_value = self.mModel_student.StdName;
                self.mInt_select0 = 1;
            }
        }
        [self.mTableV_leave reloadData];
    }
    [MBProgressHUD showSuccess:ResultDesc toView:self];
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
        cell.mLab_startNow.frame = CGRectMake(cell.mLab_start.frame.origin.x+cell.mLab_start.frame.size.width+5, cell.mLab_start.frame.origin.y, cell.mLab_startNow.frame.size.width, cell.mLab_startNow.frame.size.height);
        cell.mLab_endNow.frame = CGRectMake(cell.mLab_startNow.frame.origin.x, cell.mLab_startNow.frame.origin.y+40, cell.mLab_startNow.frame.size.width, cell.mLab_startNow.frame.size.height);
        cell.mLab_startNow.text = model.mStr_startTime;
        cell.mLab_endNow.text = model.mStr_endTime;
        cell.mLab_line.frame = CGRectMake(8, 79, [dm getInstance].width, .5);
        cell.mLab_line.hidden = NO;
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
        cell.mLab_line.hidden = NO;
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
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.mLab_line.frame = CGRectMake(8, 43, [dm getInstance].width, .5);
            return cell;
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
            cell.mTextF_reason.frame = CGRectMake(cell.mLab_name.frame.origin.x+cell.mLab_name.frame.size.width+20, cell.mLab_name.frame.origin.y-5, [dm getInstance].width-cell.mLab_name.frame.origin.x-cell.mLab_name.frame.size.width-40, cell.mTextF_reason.frame.size.height);
            cell.mTextF_reason.text = model.mStr_value;
            cell.mTextF_reason.delegate = self;
            self.mTextF_reason = cell.mTextF_reason;
            self.mTextF_reason.delegate = self;
            [self.mTextF_reason addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
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
            cell.mLab_line.hidden = YES;
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.mLab_line.frame = CGRectMake(8, 43, [dm getInstance].width, .5);
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
    return 44;
}

/*---------------------------------------
 处理cell选中事件，需要自定义的部分
 --------------------------------------- */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LeaveNowModel *model = [self.mArr_leave objectAtIndex:indexPath.row];
    if (model.mInt_flag == 0) {//选择学生
        ChooseStudentViewController *chooseStu = [[ChooseStudentViewController alloc] init];
        chooseStu.delegate = self;
        if (self.mInt_flagID == 1) {//班主任
            chooseStu.mInt_flagID = 1;
        }else if (self.mInt_flagID == 3){//家长
            chooseStu.mInt_flagID = 0;
        }
        chooseStu.mInt_flag = 0;
        chooseStu.mStr_navName = @"选择学生";
        [utils pushViewController:chooseStu animated:YES];
    }else if (model.mInt_flag == 1){//理由选择
        ChooseStudentViewController *chooseStu = [[ChooseStudentViewController alloc] init];
        chooseStu.delegate = self;
        chooseStu.mInt_flag = 1;
        chooseStu.mInt_flagID = 2;
        chooseStu.mStr_navName = @"选择理由";
        [utils pushViewController:chooseStu animated:YES];
    }else if (model.mInt_flag == 2){//理由填写
        
    }else if (model.mInt_flag == 3){//时间段显示
        [self addDialog:0 row:(int)indexPath.row Model:model];
    }else if (model.mInt_flag == 4){//时间段添加
        //先判断当前有几个时间，不能大于5个
        int a=0;
        for (LeaveNowModel *tempModel in self.mArr_leave) {
            if (tempModel.mInt_flag==3) {
                a++;
            }
        }
        if (a>=5) {
            [MBProgressHUD showError:@"最多可以有5个时间段" toView:self];
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
    if (self.mInt_flag==0||self.mInt_flag==2) {
        if (self.mInt_select0==0) {//没有选择人员
            [MBProgressHUD showError:@"请选择请假人" toView:self];
            return;
        }
    }
    //请假理由
    if (self.mInt_select1==0) {
        [MBProgressHUD showError:@"请选择请假理由" toView:self];
        return;
    }
    //判断有没有添加时间段
    //循环计算添加的时间段
    NSMutableArray *tempArr = [NSMutableArray array];
    for (LeaveNowModel *tempModel in self.mArr_leave) {
        if (tempModel.mInt_flag==3) {
            [tempArr addObject:tempModel];
        }
    }
    if (tempArr.count==0) {
        [MBProgressHUD showError:@"请添加请假时间" toView:self];
        return;
    }

    NewLeaveModel *model = [[NewLeaveModel alloc] init];
    model.UnitId = [NSString stringWithFormat:@"%d",[dm getInstance].UID];
    NSString *flag = @"";
    //判断是否是家长或者班主任代请
    if (self.mInt_flag==0) {//班主任代请0
        model.manId = self.mModel_studentInfo.StudentID;
        model.manName = self.mModel_studentInfo.StdName;
        model.gradeStr = self.mModel_studentInfo.GradeName;
        model.classStr = self.mModel_studentInfo.ClassName;
        model.unitClassId = self.mModel_studentInfo.UnitClassID;
        model.manType = @"0";
        flag = @"1";
        model.writer = [dm getInstance].name;
    }else if (self.mInt_flag ==2){//家长代请2
        model.manId = self.mModel_student.TabID;
        model.manName = self.mModel_student.StdName;
        model.gradeStr = self.mModel_student.GradeName;
        model.classStr = self.mModel_student.ClsName;
        model.unitClassId = self.mModel_student.ClassId;
        model.writer = [dm getInstance].name;
        model.manType = @"0";
        flag = @"1";
    }else{//普通老师、班主任自己请假
        model.manId = [dm getInstance].userInfo.UserID;
        model.manType = @"1";
        model.manName = [dm getInstance].name;
        flag = @"0";
        model.writer = [dm getInstance].name;
    }
    model.writerId = [dm getInstance].jiaoBaoHao;
    
    for (LeaveNowModel *tempModel in self.mArr_leave) {
        if (tempModel.mInt_flag==1) {
            model.leaveType = tempModel.mStr_value;
        }else if (tempModel.mInt_flag==2){
            model.leaveReason = tempModel.mStr_value;
        }
    }
    
    //循环赋值时间段
    for (int i=0; i<tempArr.count; i++) {
        LeaveNowModel *tempNowModel = [tempArr objectAtIndex:i];
        if (i==0) {
            model.sDateTime = tempNowModel.mStr_startTime;
            model.eDateTime = tempNowModel.mStr_endTime;
        }else if (i==1){
            model.sDateTime1 = tempNowModel.mStr_startTime;
            model.eDateTime1 = tempNowModel.mStr_endTime;
        }else if (i==2){
            model.sDateTime2 = tempNowModel.mStr_startTime;
            model.eDateTime2 = tempNowModel.mStr_endTime;
        }else if (i==3){
            model.sDateTime3 = tempNowModel.mStr_startTime;
            model.eDateTime3 = tempNowModel.mStr_endTime;
        }else if (i==4){
            model.sDateTime4 = tempNowModel.mStr_startTime;
            model.eDateTime4 = tempNowModel.mStr_endTime;
        }
    }
    model.leaveReason = [model.leaveReason stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"@"] withString:@""];
    [[LeaveHttp getInstance] NewLeaveModel:model Flag:flag];
    [MBProgressHUD showMessage:@"" toView:self];
}

//弹出时间选择框
-(void)addDialog:(int)flag row:(int)row Model:(LeaveNowModel *)model{
    UIView* vwFullScreenView = [[UIView alloc]init];
    vwFullScreenView.tag=9999;
    vwFullScreenView.backgroundColor=[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:0.5];
    vwFullScreenView.frame=self.window.frame;
    [self.window addSubview:vwFullScreenView];
    
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
        customView.model.mStr_startTime = model.mStr_startTime;
        customView.model.mStr_endTime = model.mStr_endTime;
        [customView setUp];
        [vwFullScreenView addSubview:customView];
    }
}
- (IBAction)startAction:(id)sender {
    UIButton *btn = sender;
    ModelDialog *md = (ModelDialog*)[btn superview];
    [md.startDateTF becomeFirstResponder];
}

- (IBAction)endAction:(id)sender {
    UIButton *btn = sender;
    ModelDialog *md = (ModelDialog*)[btn superview];
    [md.endDateTF becomeFirstResponder];
    
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

//选择人员后的回调
-(void)ChooseStudentViewCSelect:(id)student flag:(int)flag flagID:(int)flagID{
    if (flag == 1) {//请假理由
        self.mInt_select1 = 1;
//        if (flagID == 0||flagID == 1) {//家长请假0，班主任代请1
            for (LeaveNowModel *model in self.mArr_leave) {
                if (model.mInt_flag==1) {
                    model.mStr_value = ((MyStdInfo *)student).StdName;
                }
            }
//        }else if (self.mInt_flagID == 1){//班主任、老师、门卫自己请假2
//            
//        }
    }else{//选择学生
        self.mInt_select0 = 1;
        if (self.mInt_flagID == 3) {//家长
            self.mModel_student = student;
            LeaveNowModel *model = [self.mArr_leave objectAtIndex:0];
            model.mStr_value = self.mModel_student.StdName;
        }else if (self.mInt_flagID == 1){//班主任
            self.mModel_studentInfo = student;
            LeaveNowModel *model = [self.mArr_leave objectAtIndex:0];
            model.mStr_value = self.mModel_studentInfo.StdName;
        }
    }
    [self.mTableV_leave reloadData];
}

//如果输入超过规定的字数100，就不再让输入
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    // Any new character added is passed in as the "text" parameter

    //输入删除时
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if ([string isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textField resignFirstResponder];
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    if (textField.text.length+string.length>100) {
        return NO;
    }
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (existedLength - selectedLength + replaceLength > 100) {
        return NO;
    }
    return TRUE;
}

//如果输入超过规定的字数100，就不再让输入
//如果输入超过规定的字数100，就不再让输入
- (void)textFieldDidChange:(UITextField *)textField{
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage]; // 键盘输入模式
    
    if([toBeString isContainsEmoji])
    {
        if (textField.text.length>100) {
            NSString *a = [textField.text substringFromIndex:textField.text.length-1];
            NSString *b = [textField.text substringFromIndex:textField.text.length-2];
            NSString *c = [textField.text substringFromIndex:textField.text.length-3];
            NSString *d = [textField.text substringFromIndex:textField.text.length-4];
            NSString *e = [textField.text substringFromIndex:textField.text.length-5];
            if([a isContainsEmoji]) {
                textField.text = [toBeString substringToIndex:textField.text.length - 1];
            }else if ([b isContainsEmoji]){
                textField.text = [toBeString substringToIndex:textField.text.length - 2];
            }else if ([c isContainsEmoji]){
                textField.text = [toBeString substringToIndex:textField.text.length - 3];
            }else if ([d isContainsEmoji]){
                textField.text = [toBeString substringToIndex:textField.text.length - 4];
            }else if ([e isContainsEmoji]){
                textField.text = [toBeString substringToIndex:textField.text.length - 5];
            }
            toBeString = textField.text;
        }
    }

    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            
            if (toBeString.length > 100) {
                
                textField.text = [toBeString substringToIndex:100];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        
        if (toBeString.length > 100) {
            textField.text = [toBeString substringToIndex:100];
        }
    }

    if (textField == self.mTextF_reason) {
        if(textField.text.length>99)
        {
            textField.text = [textField.text substringToIndex:100];
            for (LeaveNowModel *tempModel in self.mArr_leave) {
                if (tempModel.mInt_flag==2){
                    tempModel.mStr_value = textField.text;
                }
            }
        }else{
            for (LeaveNowModel *tempModel in self.mArr_leave) {
                if (tempModel.mInt_flag==2){
                    tempModel.mStr_value = textField.text;
                }
            }
        }
    }
}
//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    for (LeaveNowModel *tempModel in self.mArr_leave) {
        if (tempModel.mInt_flag==2){
            tempModel.mStr_value = self.mTextF_reason.text;
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
