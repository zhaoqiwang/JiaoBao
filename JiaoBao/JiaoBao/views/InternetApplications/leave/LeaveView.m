//
//  LeaveView.m
//  JiaoBao
//
//  Created by Zqw on 16/3/12.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "LeaveView.h"
#import "IQKeyboardManager.h"

@implementation LeaveView

- (id)initWithFrame1:(CGRect)frame flag:(int)flag flagID:(int)flagID{
    self = [super init];
    if (self)
    {
        // Initialization code
        self.frame = frame;
        self.mInt_flag = flag;
        self.mInt_flagID = flagID;
        self.mArr_leave = [NSMutableArray array];
        if (self.mInt_flag == 1) {//自己请假
            
        }else{//班主任或者家长请假
            LeaveNowModel *model = [[LeaveNowModel alloc] init];
            model.mInt_flag = 0 ;//选择学生
            model.mStr_name = @"学生";
            [self.mArr_leave addObject:model];
        }
        for (int i=0; i<4; i++) {
            LeaveNowModel *model = [[LeaveNowModel alloc] init];
//            mInt_flag;//判断是哪个cell，0选人，1理由选择，2理由填写，3时间，4添加时间段，5提交
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

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mArr_leave.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *LeaveNow_indentifier = @"LeaveNowTableViewCell";
    
    LeaveNowModel *model = [self.mArr_leave objectAtIndex:indexPath.row];
    if (model.mInt_flag==3) {
        
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
            CGSize valueSize = [model.mStr_value sizeWithFont:[UIFont systemFontOfSize:14]];
            cell.mLab_value.frame = CGRectMake(cell.mLab_name.frame.origin.x+cell.mLab_name.frame.size.width+20, cell.mLab_name.frame.origin.y, valueSize.width, cell.mLab_name.frame.size.height);
            cell.mLab_value.text = model.mStr_value;
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
        return 70;
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
        ChooseStudentViewController *chooseStu = [[ChooseStudentViewController alloc] init];
        chooseStu.delegate = self;
        [utils pushViewController:chooseStu animated:YES];
    }else if (model.mInt_flag == 1){//理由选择
        
    }else if (model.mInt_flag == 2){//理由填写
        
    }else if (model.mInt_flag == 3){//时间段显示
        
    }else if (model.mInt_flag == 4){//时间段添加
        
    }else if (model.mInt_flag == 5){//提交
        
    }
}

//选择人员后的回调
-(void)ChooseStudentViewCSelect:(id)student{
    if (self.mInt_flagID == 3) {//家长
        self.mModel_student = student;
        LeaveNowModel *model = [self.mArr_leave objectAtIndex:0];
        model.mStr_value = self.mModel_student.StdName;
    }else if (self.mInt_flagID == 1){//班主任
        
    }
    [self.mTableV_leave reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
