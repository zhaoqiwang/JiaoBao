//
//  CheckSelectViewController.m
//  JiaoBao
//
//  Created by Zqw on 16/3/24.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "CheckSelectViewController.h"
#import "CustomDatePicker.h"

@interface CheckSelectViewController ()
@property(nonatomic,strong)CustomDatePicker *customPicker;
@end

@implementation CheckSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customPicker = [[CustomDatePicker alloc]init];

    self.dateTF.inputAccessoryView = self.toolBar;
    self.dateTF.inputView = self.customPicker;
    // Do any additional setup after loading the view from its nib.
    self.mArr_list = [NSMutableArray array];
    self.mArr_dispaly = [NSMutableArray array];
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"筛选条件"];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.mNav_navgationBar setRightBtnTitle:@"确定"];
    [self.view addSubview:self.mNav_navgationBar];
    
    //表格
    self.mTableV_select.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height-[dm getInstance].statusBar, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height+[dm getInstance].statusBar);
    self.mTableV_select.tableFooterView = [[UIView alloc]init];
    //默认数组
    [self addValueToArray];
    [self setCheckValue];
    //给显示的分类数组
    [self setValueDisplayArray];
}

//默认数组
-(void)addValueToArray{
    for (int i=0; i<5; i++) {
        CheckSelectModel *model = [[CheckSelectModel alloc] init];
        if (i==0) {//教职工，学生
            model.mInt_flag = 0;
            //判断是否有权限,老师审核
            if ([[dm getInstance].leaveModel.ApproveListTea.A isEqual:@"True"]||[[dm getInstance].leaveModel.ApproveListTea.B isEqual:@"True"]||[[dm getInstance].leaveModel.ApproveListTea.C isEqual:@"True"]||[[dm getInstance].leaveModel.ApproveListTea.D isEqual:@"True"]||[[dm getInstance].leaveModel.ApproveListTea.E isEqual:@"True"]) {
                model.mInt_id = 0;
            }else{
                model.mInt_id = 1;
            }
            model.mInt_checkTeacher = 1;
            model.mInt_allStudent = 1;
            model.mInt_allTeacher = 1;
        }else if (i==1){//一审、二审等
            model.mInt_flag = 1;
            model.mInt_id = 0;
            model.mInt_checkTeacher = 1;
        }else if (i==2){//时间
            model.mInt_flag = 2;
            model.mStr_name = @"时间";
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM"];
            NSDate *currentDate =[NSDate date];
            model.mStr_value = [formatter stringFromDate:currentDate];
            model.mInt_checkTeacher = 1;
            model.mInt_allTeacher = 1;
            model.mInt_allStudent = 1;
        }else if (i==3){//年级
            model.mInt_flag = 3;
            model.mStr_name = @"年级";
            model.mStr_value = @"全部";
            model.mInt_allStudent = 1;
        }else if (i==4){//班级
            model.mInt_flag = 4;
            model.mStr_name = @"班级";
            model.mStr_value = @"全部";
        }
        [self.mArr_list addObject:model];
    }
}

//给显示的分类数组
-(void)setValueDisplayArray{
    [self.mArr_dispaly removeAllObjects];
    CheckSelectModel *model = [self.mArr_list objectAtIndex:0];
    if (self.mInt_flag ==0) {//审核
        if (model.mInt_id == 0) {//老师
            for (CheckSelectModel *model1 in self.mArr_list) {
                if (model1.mInt_checkTeacher==1) {
                    [self.mArr_dispaly addObject:model1];
                }
            }
        }else{//学生
            CheckSelectModel *model1 = [self.mArr_list objectAtIndex:1];
            //如果是班主任，不显示年级班级，直接给默认值
            if (model1.mInt_check==0) {//班主任级别审核查询
                for (CheckSelectModel *model1 in self.mArr_list) {
                    if (model1.mInt_checkTeacher==1) {
                        [self.mArr_dispaly addObject:model1];
                    }
                }
            }else{
                for (CheckSelectModel *model1 in self.mArr_list) {
                    [self.mArr_dispaly addObject:model1];
                }
            }
        }
    }else{//统计查询
        if (model.mInt_id == 0) {//老师
            for (CheckSelectModel *model1 in self.mArr_list) {
                if (model1.mInt_allTeacher==1) {
                    [self.mArr_dispaly addObject:model1];
                }
            }
        }else{//学生
            for (CheckSelectModel *model1 in self.mArr_list) {
                if (model1.mInt_allStudent==1) {
                    [self.mArr_dispaly addObject:model1];
                }
            }
        }
    }
    [self.mTableV_select reloadData];
}

//切换身份时，给默认审核值
-(void)setCheckValue{
    CheckSelectModel *model = [self.mArr_list objectAtIndex:0];
    CheckSelectModel *model1 = [self.mArr_list objectAtIndex:1];
    int a=0;
    if (model.mInt_id ==0) {//当前选择是教职工
        //有一审权限
        if ([[dm getInstance].leaveModel.ApproveListTea.A intValue]==1||[[dm getInstance].leaveModel.ApproveListTea.A isEqual:@"True"]) {
            model1.mInt_check = 0;
            self.mStr_checkName = [dm getInstance].leaveModel.LevelNoteTea.A;
            a++;
        }else{//有二审权限
            if ([[dm getInstance].leaveModel.ApproveListTea.B intValue]==1||[[dm getInstance].leaveModel.ApproveListTea.B isEqual:@"True"]) {
                model1.mInt_check = 1;
                self.mStr_checkName = [dm getInstance].leaveModel.LevelNoteTea.B;
                a++;
            }else{//有三审权限
                if ([[dm getInstance].leaveModel.ApproveListTea.C intValue]==1||[[dm getInstance].leaveModel.ApproveListTea.C isEqual:@"True"]) {
                    model1.mInt_check = 2;
                    self.mStr_checkName = [dm getInstance].leaveModel.LevelNoteTea.C;
                    a++;
                }else{//有四审权限
                    if ([[dm getInstance].leaveModel.ApproveListTea.D intValue]==1||[[dm getInstance].leaveModel.ApproveListTea.D isEqual:@"True"]) {
                        model1.mInt_check = 3;
                        self.mStr_checkName = [dm getInstance].leaveModel.LevelNoteTea.D;
                        a++;
                    }else{//有五审权限
                        if ([[dm getInstance].leaveModel.ApproveListTea.E intValue]==1||[[dm getInstance].leaveModel.ApproveListTea.E isEqual:@"True"]) {
                            model1.mInt_check = 4;
                            self.mStr_checkName = [dm getInstance].leaveModel.LevelNoteTea.E;
                            a++;
                        }
                    }
                }
            }
        }
    }else{//学生
        if ([[dm getInstance].userInfo.isAdmin intValue]==2||[[dm getInstance].userInfo.isAdmin intValue]==3){//是否是班主任，班主任必有1审
            model1.mInt_check = 0;
            self.mStr_checkName = [dm getInstance].leaveModel.LevelNoteStd.A;
            //如果是查询学生，并且是班主任级别，给默认值
            [self setClassTeacher];
        }else{//
            if ([[dm getInstance].leaveModel.ApproveListStd.B intValue]==1||[[dm getInstance].leaveModel.ApproveListStd.B isEqual:@"True"]) {//有二审权限
                model1.mInt_check = 1;
                self.mStr_checkName = [dm getInstance].leaveModel.LevelNoteStd.B;
            }else{//有一审权限
                if ([[dm getInstance].leaveModel.ApproveListStd.C intValue]==1||[[dm getInstance].leaveModel.ApproveListStd.C isEqual:@"True"]) {//有三审权限
                    model1.mInt_check = 2;
                    self.mStr_checkName = [dm getInstance].leaveModel.LevelNoteStd.C;
                }else{
                    if ([[dm getInstance].leaveModel.ApproveListStd.D intValue]==1||[[dm getInstance].leaveModel.ApproveListStd.D isEqual:@"True"]) {//有四审权限
                        model1.mInt_check = 3;
                        self.mStr_checkName = [dm getInstance].leaveModel.LevelNoteStd.D;
                    }else{
                        if ([[dm getInstance].leaveModel.ApproveListStd.E intValue]==1||[[dm getInstance].leaveModel.ApproveListStd.E isEqual:@"True"]) {//有五审权限
                            model1.mInt_check = 4;
                            self.mStr_checkName = [dm getInstance].leaveModel.LevelNoteStd.E;
                        }
                    }
                }
            }
        }
    }
    if (a==0) {
        model.mInt_id = 1;
    }
}

//如果是查询学生，并且是班主任级别，给默认值
-(void)setClassTeacher{
    CheckSelectModel *model0 = [self.mArr_list objectAtIndex:0];
    if (model0.mInt_id == 1) {//学生
        CheckSelectModel *model1 = [self.mArr_list objectAtIndex:1];
        //如果是班主任，不显示年级班级，直接给默认值
        if (model1.mInt_check==0) {//班主任级别审核查询
            if ([dm getInstance].mArr_leaveClass.count>0) {
                MyAdminClass *tempModel = [[dm getInstance].mArr_leaveClass objectAtIndex:0];
                CheckSelectModel *model3 = [self.mArr_list objectAtIndex:3];
                model3.mStr_value = tempModel.GradeName;
                CheckSelectModel *model4 = [self.mArr_list objectAtIndex:4];
                model4.mStr_value = tempModel.ClsName;
            }
        }
    }
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mArr_dispaly.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CheckSelectTableViewCell_indentifier = @"CheckSelectTableViewCell";
    CheckSelectModel *model = [self.mArr_dispaly objectAtIndex:indexPath.row];
    
    CheckSelectTableViewCell *cell = (CheckSelectTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CheckSelectTableViewCell_indentifier];
    if (cell == nil) {
        cell = [[CheckSelectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CheckSelectTableViewCell_indentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CheckSelectTableViewCell" owner:self options:nil];
        //这时myCell对象已经通过自定义xib文件生成了
        if ([nib count]>0) {
            cell = (CheckSelectTableViewCell *)[nib objectAtIndex:0];
            //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
        }
        
        //添加图片点击事件
        //若是需要重用，需要写上以下两句代码
        UINib * n= [UINib nibWithNibName:@"CheckSelectTableViewCell" bundle:[NSBundle mainBundle]];
        [self.mTableV_select registerNib:n forCellReuseIdentifier:CheckSelectTableViewCell_indentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    if (model.mInt_flag == 0) {//教职工、学生
        cell.mBtn_teacher.hidden = NO;
        cell.mBtn_student.hidden = NO;
        cell.mBtn_one.hidden = YES;
        cell.mBtn_two.hidden = YES;
        cell.mBtn_three.hidden = YES;
        cell.mBtn_four.hidden = YES;
        cell.mBtn_five.hidden = YES;
        cell.mLab_name.hidden = YES;
        cell.mLab_value.hidden = YES;
        float mFloag_width = 14.0;//判断坐标位置
        //判断是否有权限,老师审核
        if ([[dm getInstance].leaveModel.ApproveListTea.A isEqual:@"True"]||[[dm getInstance].leaveModel.ApproveListTea.B isEqual:@"True"]||[[dm getInstance].leaveModel.ApproveListTea.C isEqual:@"True"]||[[dm getInstance].leaveModel.ApproveListTea.D isEqual:@"True"]||[[dm getInstance].leaveModel.ApproveListTea.E isEqual:@"True"]) {
            //教职工
            cell.mBtn_teacher.frame = CGRectMake(mFloag_width, 10, 70, cell.mBtn_teacher.frame.size.height);
            mFloag_width = mFloag_width+cell.mBtn_teacher.frame.size.width+10;
        }else{
            cell.mBtn_teacher.hidden = YES;
        }
        if ([[dm getInstance].leaveModel.ApproveListStd.A isEqual:@"True"]||[[dm getInstance].leaveModel.ApproveListStd.B isEqual:@"True"]||[[dm getInstance].leaveModel.ApproveListStd.C isEqual:@"True"]||[[dm getInstance].leaveModel.ApproveListStd.D isEqual:@"True"]||[[dm getInstance].leaveModel.ApproveListStd.E isEqual:@"True"]||[[dm getInstance].userInfo.isAdmin intValue]==2||[[dm getInstance].userInfo.isAdmin intValue]==3) {
            //学生
            cell.mBtn_student.frame = CGRectMake(mFloag_width, 10, 70, cell.mBtn_student.frame.size.height);
        }else{
            cell.mBtn_student.hidden = YES;
        }
        
        if (model.mInt_id ==0) {
            [cell.mBtn_teacher setImage:[UIImage imageNamed:@"sigleSelect1"] forState:UIControlStateNormal];
            [cell.mBtn_student setImage:[UIImage imageNamed:@"sigleSelect0"] forState:UIControlStateNormal];
        }else{
            [cell.mBtn_teacher setImage:[UIImage imageNamed:@"sigleSelect0"] forState:UIControlStateNormal];
            [cell.mBtn_student setImage:[UIImage imageNamed:@"sigleSelect1"] forState:UIControlStateNormal];
        }
    }else if (model.mInt_flag == 1){//一审、二审等
        cell.mBtn_teacher.hidden = YES;
        cell.mBtn_student.hidden = YES;
        cell.mBtn_one.hidden = NO;
        cell.mBtn_two.hidden = NO;
        cell.mBtn_three.hidden = NO;
        cell.mBtn_four.hidden = NO;
        cell.mBtn_five.hidden = NO;
        cell.mLab_name.hidden = YES;
        cell.mLab_value.hidden = YES;
        CheckSelectModel *model1 = [self.mArr_list objectAtIndex:0];
        float mFloag_width = 14.0;//判断坐标位置
        float mFloag_height = 0.0;//判断坐标位置
        if (model1.mInt_id ==0) {//当前选择是教职工
            
            //一审
            if ([[dm getInstance].leaveModel.ApproveListTea.A intValue]==1||[[dm getInstance].leaveModel.ApproveListTea.A isEqual:@"True"]) {
                CGSize nameSize = [[dm getInstance].leaveModel.LevelNoteTea.A sizeWithFont:[UIFont systemFontOfSize:14]];
                cell.mBtn_one.frame = CGRectMake(mFloag_width, mFloag_height+10, nameSize.width+20, cell.mBtn_one.frame.size.height);
                [cell.mBtn_one setTitle:[dm getInstance].leaveModel.LevelNoteTea.A forState:UIControlStateNormal];
                mFloag_height = mFloag_height +44;
            }else{
                cell.mBtn_one.hidden = YES;
            }
            //二审
            if ([[dm getInstance].leaveModel.ApproveListTea.B intValue]==1||[[dm getInstance].leaveModel.ApproveListTea.B isEqual:@"True"]) {
                CGSize nameSize = [[dm getInstance].leaveModel.LevelNoteTea.B sizeWithFont:[UIFont systemFontOfSize:14]];
                cell.mBtn_two.frame = CGRectMake(mFloag_width, mFloag_height+10, nameSize.width+20, cell.mBtn_two.frame.size.height);
                [cell.mBtn_two setTitle:[dm getInstance].leaveModel.LevelNoteTea.B forState:UIControlStateNormal];
                mFloag_height = mFloag_height +44;
            }else{
                cell.mBtn_two.hidden = YES;
            }
            //三审
            if ([[dm getInstance].leaveModel.ApproveListTea.C intValue]==1||[[dm getInstance].leaveModel.ApproveListTea.C isEqual:@"True"]) {
                CGSize nameSize = [[dm getInstance].leaveModel.LevelNoteTea.C sizeWithFont:[UIFont systemFontOfSize:14]];
                cell.mBtn_three.frame = CGRectMake(mFloag_width, mFloag_height+10, nameSize.width+20, cell.mBtn_three.frame.size.height);
                [cell.mBtn_three setTitle:[dm getInstance].leaveModel.LevelNoteTea.C forState:UIControlStateNormal];
                mFloag_height = mFloag_height +44;
            }else{
                cell.mBtn_three.hidden = YES;
            }
            //四审
            if ([[dm getInstance].leaveModel.ApproveListTea.D intValue]==1||[[dm getInstance].leaveModel.ApproveListTea.D isEqual:@"True"]) {
                CGSize nameSize = [[dm getInstance].leaveModel.LevelNoteTea.D sizeWithFont:[UIFont systemFontOfSize:14]];
                cell.mBtn_four.frame = CGRectMake(mFloag_width, mFloag_height+10, nameSize.width+20, cell.mBtn_four.frame.size.height);
                [cell.mBtn_four setTitle:[dm getInstance].leaveModel.LevelNoteTea.D forState:UIControlStateNormal];
                mFloag_height = mFloag_height +44;
            }else{
                cell.mBtn_four.hidden = YES;
            }
            //五审
            if ([[dm getInstance].leaveModel.ApproveListTea.E intValue]==1||[[dm getInstance].leaveModel.ApproveListTea.E isEqual:@"True"]) {
                CGSize nameSize = [[dm getInstance].leaveModel.LevelNoteTea.E sizeWithFont:[UIFont systemFontOfSize:14]];
                cell.mBtn_five.frame = CGRectMake(mFloag_width, mFloag_height+10, nameSize.width+20, cell.mBtn_five.frame.size.height);
                [cell.mBtn_five setTitle:[dm getInstance].leaveModel.LevelNoteTea.E forState:UIControlStateNormal];
                mFloag_height = mFloag_height +44;
            }else{
                cell.mBtn_five.hidden = YES;
            }
        }else{//当前选择为学生
            if ([[dm getInstance].userInfo.isAdmin intValue]==2||[[dm getInstance].userInfo.isAdmin intValue]==3){//是否是班主任，班主任必有1审
                CGSize nameSize = [[dm getInstance].leaveModel.LevelNoteStd.A sizeWithFont:[UIFont systemFontOfSize:14]];
                cell.mBtn_one.frame = CGRectMake(mFloag_width, mFloag_height+10, nameSize.width+20, cell.mBtn_one.frame.size.height);
                [cell.mBtn_one setTitle:[dm getInstance].leaveModel.LevelNoteStd.A forState:UIControlStateNormal];
                mFloag_height = mFloag_height +44;
            }else{
                cell.mBtn_one.hidden = YES;
            }
            //二审
            if ([[dm getInstance].leaveModel.ApproveListStd.B intValue]==1||[[dm getInstance].leaveModel.ApproveListStd.B isEqual:@"True"]) {
                CGSize nameSize = [[dm getInstance].leaveModel.LevelNoteStd.B sizeWithFont:[UIFont systemFontOfSize:14]];
                cell.mBtn_two.frame = CGRectMake(mFloag_width, mFloag_height+10, nameSize.width+20, cell.mBtn_two.frame.size.height);
                [cell.mBtn_two setTitle:[dm getInstance].leaveModel.LevelNoteStd.B forState:UIControlStateNormal];
                mFloag_height = mFloag_height +44;
            }else{
                cell.mBtn_two.hidden = YES;
            }
            //三审
            if ([[dm getInstance].leaveModel.ApproveListStd.C intValue]==1||[[dm getInstance].leaveModel.ApproveListStd.C isEqual:@"True"]) {
                CGSize nameSize = [[dm getInstance].leaveModel.LevelNoteStd.C sizeWithFont:[UIFont systemFontOfSize:14]];
                cell.mBtn_three.frame = CGRectMake(mFloag_width, mFloag_height+10, nameSize.width+20, cell.mBtn_three.frame.size.height);
                [cell.mBtn_three setTitle:[dm getInstance].leaveModel.LevelNoteStd.C forState:UIControlStateNormal];
                mFloag_height = mFloag_height +44;
            }else{
                cell.mBtn_three.hidden = YES;
            }
            //四审
            if ([[dm getInstance].leaveModel.ApproveListStd.D intValue]==1||[[dm getInstance].leaveModel.ApproveListStd.D isEqual:@"True"]) {
                CGSize nameSize = [[dm getInstance].leaveModel.LevelNoteStd.D sizeWithFont:[UIFont systemFontOfSize:14]];
                cell.mBtn_four.frame = CGRectMake(mFloag_width, mFloag_height+10, nameSize.width+20, cell.mBtn_four.frame.size.height);
                [cell.mBtn_four setTitle:[dm getInstance].leaveModel.LevelNoteStd.D forState:UIControlStateNormal];
                mFloag_height = mFloag_height +44;
            }else{
                cell.mBtn_four.hidden = YES;
            }
            //五审
            if ([[dm getInstance].leaveModel.ApproveListStd.E intValue]==1||[[dm getInstance].leaveModel.ApproveListStd.E isEqual:@"True"]) {
                CGSize nameSize = [[dm getInstance].leaveModel.LevelNoteStd.E sizeWithFont:[UIFont systemFontOfSize:14]];
                cell.mBtn_five.frame = CGRectMake(mFloag_width, mFloag_height+10, nameSize.width+20, cell.mBtn_five.frame.size.height);
                [cell.mBtn_five setTitle:[dm getInstance].leaveModel.LevelNoteStd.E forState:UIControlStateNormal];
                mFloag_height = mFloag_height +44;
            }else{
                cell.mBtn_five.hidden = YES;
            }
        }
        if (model.mInt_check ==0) {//0一审，1二审，等
            [cell.mBtn_one setImage:[UIImage imageNamed:@"sigleSelect1"] forState:UIControlStateNormal];
            [cell.mBtn_two setImage:[UIImage imageNamed:@"sigleSelect0"] forState:UIControlStateNormal];
            [cell.mBtn_three setImage:[UIImage imageNamed:@"sigleSelect0"] forState:UIControlStateNormal];
            [cell.mBtn_four setImage:[UIImage imageNamed:@"sigleSelect0"] forState:UIControlStateNormal];
            [cell.mBtn_five setImage:[UIImage imageNamed:@"sigleSelect0"] forState:UIControlStateNormal];
        }else if (model.mInt_check == 1){//0一审，1二审，等
            [cell.mBtn_one setImage:[UIImage imageNamed:@"sigleSelect0"] forState:UIControlStateNormal];
            [cell.mBtn_two setImage:[UIImage imageNamed:@"sigleSelect1"] forState:UIControlStateNormal];
            [cell.mBtn_three setImage:[UIImage imageNamed:@"sigleSelect0"] forState:UIControlStateNormal];
            [cell.mBtn_four setImage:[UIImage imageNamed:@"sigleSelect0"] forState:UIControlStateNormal];
            [cell.mBtn_five setImage:[UIImage imageNamed:@"sigleSelect0"] forState:UIControlStateNormal];
        }else if (model.mInt_check == 2){//0一审，1二审，等
            [cell.mBtn_one setImage:[UIImage imageNamed:@"sigleSelect0"] forState:UIControlStateNormal];
            [cell.mBtn_two setImage:[UIImage imageNamed:@"sigleSelect0"] forState:UIControlStateNormal];
            [cell.mBtn_three setImage:[UIImage imageNamed:@"sigleSelect1"] forState:UIControlStateNormal];
            [cell.mBtn_four setImage:[UIImage imageNamed:@"sigleSelect0"] forState:UIControlStateNormal];
            [cell.mBtn_five setImage:[UIImage imageNamed:@"sigleSelect0"] forState:UIControlStateNormal];
        }else if (model.mInt_check == 3){//0一审，1二审，等
            [cell.mBtn_one setImage:[UIImage imageNamed:@"sigleSelect0"] forState:UIControlStateNormal];
            [cell.mBtn_two setImage:[UIImage imageNamed:@"sigleSelect0"] forState:UIControlStateNormal];
            [cell.mBtn_three setImage:[UIImage imageNamed:@"sigleSelect0"] forState:UIControlStateNormal];
            [cell.mBtn_four setImage:[UIImage imageNamed:@"sigleSelect1"] forState:UIControlStateNormal];
            [cell.mBtn_five setImage:[UIImage imageNamed:@"sigleSelect0"] forState:UIControlStateNormal];
        }else if (model.mInt_check == 4){//0一审，1二审，等
            [cell.mBtn_one setImage:[UIImage imageNamed:@"sigleSelect0"] forState:UIControlStateNormal];
            [cell.mBtn_two setImage:[UIImage imageNamed:@"sigleSelect0"] forState:UIControlStateNormal];
            [cell.mBtn_three setImage:[UIImage imageNamed:@"sigleSelect0"] forState:UIControlStateNormal];
            [cell.mBtn_four setImage:[UIImage imageNamed:@"sigleSelect0"] forState:UIControlStateNormal];
            [cell.mBtn_five setImage:[UIImage imageNamed:@"sigleSelect1"] forState:UIControlStateNormal];
        }
    }else if (model.mInt_flag == 2||model.mInt_flag == 3||model.mInt_flag == 4){//时间、年级、班级
        cell.mBtn_teacher.hidden = YES;
        cell.mBtn_student.hidden = YES;
        cell.mBtn_one.hidden = YES;
        cell.mBtn_two.hidden = YES;
        cell.mBtn_three.hidden = YES;
        cell.mBtn_four.hidden = YES;
        cell.mBtn_five.hidden = YES;
        cell.mLab_name.hidden = NO;
        cell.mLab_value.hidden = NO;
        //标题
        cell.mLab_name.frame = CGRectMake(14, (44-cell.mLab_name.frame.size.height)/2, cell.mLab_name.frame.size.width, cell.mLab_name.frame.size.height);
        cell.mLab_name.text = model.mStr_name;
        
        CGSize valueSize = [model.mStr_value sizeWithFont:[UIFont systemFontOfSize:14]];
        cell.mLab_value.frame = CGRectMake(14+cell.mLab_name.frame.size.width+20, cell.mLab_name.frame.origin.y, valueSize.width, cell.mLab_value.frame.size.height);
        cell.mLab_value.text = model.mStr_value;
    }
    return cell;
}

/*---------------------------------------
 cell高度默认为44
 --------------------------------------- */
-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    CheckSelectModel *model = [self.mArr_dispaly objectAtIndex:indexPath.row];
    if (model.mInt_flag == 1){//一审、二审等，判断有多少审核cell
        CheckSelectModel *model1 = [self.mArr_list objectAtIndex:0];
        int a=0;
        if (model1.mInt_id ==0) {//当前选择是教职工
            //一审
            if ([[dm getInstance].leaveModel.ApproveListTea.A intValue]==1||[[dm getInstance].leaveModel.ApproveListTea.A isEqual:@"True"]) {
                a++;
            }
            //二审
            if ([[dm getInstance].leaveModel.ApproveListTea.B intValue]==1||[[dm getInstance].leaveModel.ApproveListTea.B isEqual:@"True"]) {
                a++;
            }
            //三审
            if ([[dm getInstance].leaveModel.ApproveListTea.C intValue]==1||[[dm getInstance].leaveModel.ApproveListTea.C isEqual:@"True"]) {
                a++;
            }
            //四审
            if ([[dm getInstance].leaveModel.ApproveListTea.D intValue]==1||[[dm getInstance].leaveModel.ApproveListTea.D isEqual:@"True"]) {
                a++;
            }
            //五审
            if ([[dm getInstance].leaveModel.ApproveListTea.E intValue]==1||[[dm getInstance].leaveModel.ApproveListTea.E isEqual:@"True"]) {
                a++;
            }
        }else{//当前选择为学生
            if ([[dm getInstance].userInfo.isAdmin intValue]==2||[[dm getInstance].userInfo.isAdmin intValue]==3){//是否是班主任，班主任必有1审
                a++;
            }
            //二审
            if ([[dm getInstance].leaveModel.ApproveListStd.B intValue]==1||[[dm getInstance].leaveModel.ApproveListStd.B isEqual:@"True"]) {
                a++;
            }
            //三审
            if ([[dm getInstance].leaveModel.ApproveListStd.C intValue]==1||[[dm getInstance].leaveModel.ApproveListStd.C isEqual:@"True"]) {
                a++;
            }
            //四审
            if ([[dm getInstance].leaveModel.ApproveListStd.D intValue]==1||[[dm getInstance].leaveModel.ApproveListStd.D isEqual:@"True"]) {
                a++;
            }
            //五审
            if ([[dm getInstance].leaveModel.ApproveListStd.E intValue]==1||[[dm getInstance].leaveModel.ApproveListStd.E isEqual:@"True"]) {
                a++;
            }
        }
        return 44*a;
    }
    return 44;
}

/*---------------------------------------
 处理cell选中事件，需要自定义的部分
 --------------------------------------- */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CheckSelectModel *model = [self.mArr_dispaly objectAtIndex:indexPath.row];
    if (model.mInt_flag == 2) {//时间
        [self.dateTF becomeFirstResponder];
        
    }else if (model.mInt_flag == 3){//年级
        ChooseStudentViewController *choose = [[ChooseStudentViewController alloc] init];
        choose.delegate = self;
        choose.mStr_navName = @"选择年级";
        choose.mInt_flag = 2;
        choose.mInt_flagID = 3;
        choose.mArr_student = [dm getInstance].mArr_listClass;
        [utils pushViewController:choose animated:YES];
    }else if (model.mInt_flag == 4){//班级
        CheckSelectModel *model1 = [self.mArr_list objectAtIndex:3];
        ChooseStudentViewController *choose = [[ChooseStudentViewController alloc] init];
        choose.delegate = self;
        choose.mStr_navName = @"选择班级";
        choose.mInt_flag = 3;
        choose.mInt_flagID = 4;
        for (UserClassInfo *model in [dm getInstance].mArr_listClass) {
            if ([model.GradeName isEqual:model1.mStr_value]) {
                choose.mArr_student = model.mArr_class;
            }
        }
        [utils pushViewController:choose animated:YES];
    }
}

//选择班级、年级的回调
-(void)ChooseStudentViewCSelect:(id)student flag:(int)flag flagID:(int)flagID{
    UserClassInfo *model = student;
    if (flag == 2) {//年级
        CheckSelectModel *model1 = [self.mArr_list objectAtIndex:3];
        model1.mStr_value = model.GradeName;
    }else{//班级
        CheckSelectModel *model1 = [self.mArr_list objectAtIndex:4];
        model1.mStr_value = model.ClassName;
    }
    [self setValueDisplayArray];
}

//cell中，button的点击回调方法，选择教职工
-(void)CheckSelectTableViewCellTeacherBtn:(CheckSelectTableViewCell *) cell{
    [self.view endEditing:YES];
    CheckSelectModel *model = [self.mArr_list objectAtIndex:0];
    model.mInt_id = 0;
    [self setCheckValue];
    [self setValueDisplayArray];
}
//选择学生
-(void)CheckSelectTableViewCellStudentBtn:(CheckSelectTableViewCell *) cell{
    [self.view endEditing:YES];
    CheckSelectModel *model = [self.mArr_list objectAtIndex:0];
    model.mInt_id = 1;
    [self setCheckValue];
    [self setValueDisplayArray];
    //如果是查询学生，并且是班主任级别，给默认值
    [self setClassTeacher];
}
//选择一审
-(void) CheckSelectTableViewCellOneBtn:(CheckSelectTableViewCell *) cell{
    CheckSelectModel *model1 = [self.mArr_list objectAtIndex:1];
    model1.mInt_check = 0;
    [self.view endEditing:YES];
    [self setValueDisplayArray];
    //如果是查询学生，并且是班主任级别，给默认值
    [self setClassTeacher];
    //点击选择后，修改选择的审核名称
    CheckSelectModel *model = [self.mArr_list objectAtIndex:0];
    if (model.mInt_id ==0) {//当前选择是教职工
        self.mStr_checkName = [dm getInstance].leaveModel.LevelNoteTea.A;
    }else{//学生
        self.mStr_checkName = [dm getInstance].leaveModel.LevelNoteStd.A;
    }
}
//选择二审
-(void) CheckSelectTableViewCellTwoBtn:(CheckSelectTableViewCell *) cell{
    CheckSelectModel *model1 = [self.mArr_list objectAtIndex:1];
    model1.mInt_check = 1;
    [self.view endEditing:YES];
    [self setValueDisplayArray];
    //点击选择后，修改选择的审核名称
    CheckSelectModel *model = [self.mArr_list objectAtIndex:0];
    if (model.mInt_id ==0) {//当前选择是教职工
        self.mStr_checkName = [dm getInstance].leaveModel.LevelNoteTea.B;
    }else{//学生
        self.mStr_checkName = [dm getInstance].leaveModel.LevelNoteStd.B;
    }
}
//选择三审
-(void) CheckSelectTableViewCellThreeBtn:(CheckSelectTableViewCell *) cell{
    CheckSelectModel *model1 = [self.mArr_list objectAtIndex:1];
    model1.mInt_check = 2;
    [self.view endEditing:YES];
    [self setValueDisplayArray];
    //点击选择后，修改选择的审核名称
    CheckSelectModel *model = [self.mArr_list objectAtIndex:0];
    if (model.mInt_id ==0) {//当前选择是教职工
        self.mStr_checkName = [dm getInstance].leaveModel.LevelNoteTea.C;
    }else{//学生
        self.mStr_checkName = [dm getInstance].leaveModel.LevelNoteStd.C;
    }
}
//选择四审
-(void) CheckSelectTableViewCellFourBtn:(CheckSelectTableViewCell *) cell{
    CheckSelectModel *model1 = [self.mArr_list objectAtIndex:1];
    model1.mInt_check = 3;
    [self.view endEditing:YES];
    [self setValueDisplayArray];
    //点击选择后，修改选择的审核名称
    CheckSelectModel *model = [self.mArr_list objectAtIndex:0];
    if (model.mInt_id ==0) {//当前选择是教职工
        self.mStr_checkName = [dm getInstance].leaveModel.LevelNoteTea.D;
    }else{//学生
        self.mStr_checkName = [dm getInstance].leaveModel.LevelNoteStd.D;
    }
}
//选择五审
-(void) CheckSelectTableViewCellFiveBtn:(CheckSelectTableViewCell *) cell{
    CheckSelectModel *model1 = [self.mArr_list objectAtIndex:1];
    model1.mInt_check = 4;
    [self.view endEditing:YES];
    [self setValueDisplayArray];
    //点击选择后，修改选择的审核名称
    CheckSelectModel *model = [self.mArr_list objectAtIndex:0];
    if (model.mInt_id ==0) {//当前选择是教职工
        self.mStr_checkName = [dm getInstance].leaveModel.LevelNoteTea.E;
    }else{//学生
        self.mStr_checkName = [dm getInstance].leaveModel.LevelNoteStd.E;
    }
}

- (IBAction)cancelToolAction:(id)sender {
    [self.dateTF resignFirstResponder];
    
}
- (IBAction)doneToolAction:(id)sender {
    [self.dateTF resignFirstResponder];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM"];
    CheckSelectModel *model = [self.mArr_list objectAtIndex:2];
    model.mStr_value = [self.customPicker getDateString];
    [self setValueDisplayArray];
    
}

//导航条返回按钮回调
-(void)myNavigationGoback{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [utils popViewControllerAnimated:YES];
}
//确定按钮
-(void)navigationRightAction:(UIButton *)sender{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(CheckSelectViewCSelect:flag:CheckName:)]) {
        leaveRecordModel *selectModel = [[leaveRecordModel alloc] init];
        CheckSelectModel *model = [self.mArr_list objectAtIndex:0];
        CheckSelectModel *model1 = [self.mArr_list objectAtIndex:1];
        CheckSelectModel *model2 = [self.mArr_list objectAtIndex:2];
        CheckSelectModel *model3 = [self.mArr_list objectAtIndex:3];
        CheckSelectModel *model4 = [self.mArr_list objectAtIndex:4];
//        0待审、已审，1统计查询
        if (self.mInt_flag ==0) {//审核
            selectModel.level = [NSString stringWithFormat:@"%d",model1.mInt_check+1];
            selectModel.sDateTime = model2.mStr_value;
            if (model.mInt_id == 0) {//老师
                selectModel.manType = @"1";
            }else{//学生
                selectModel.manType = @"0";
                selectModel.gradeStr = model3.mStr_value;
                selectModel.classStr = model4.mStr_value;
            }
        }else{//统计查询
            selectModel.sDateTime = model2.mStr_value;
            if (model.mInt_id == 0) {//老师
                selectModel.manType = @"1";
            }else{//学生
                selectModel.manType = @"0";
                selectModel.gradeStr = model3.mStr_value;
            }
        }
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(CheckSelectViewCSelect:flag:CheckName:)]) {
            [self.delegate CheckSelectViewCSelect:selectModel flag:self.mInt_flag CheckName:self.mStr_checkName];
            [self myNavigationGoback];
        }
    }
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
