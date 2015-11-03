//
//  ParentSearchViewController.m
//  JiaoBao
//
//  Created by Zqw on 15/11/2.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "ParentSearchViewController.h"
#import "OnlineJobHttp.h"
#import "StuInfoModel.h"

@interface ParentSearchViewController ()
@property (nonatomic,strong) StuInfoModel *mModel_stuInf;//学生信息，包含id

@end

@implementation ParentSearchViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //获取到学生id
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getGenInfoWithAccID" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getGenInfoWithAccID:) name:@"getGenInfoWithAccID" object:nil];
    //获取某学生各科作业完成情况
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetCompleteStatusHW" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetCompleteStatusHW:) name:@"GetCompleteStatusHW" object:nil];
    //学生获取当前作业列表
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetStuHWList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetStuHWList:) name:@"GetStuHWList" object:nil];
    
    self.mArr_nowHomework = [NSMutableArray array];
    self.mArr_overHomework = [NSMutableArray array];
    self.mArr_score = [NSMutableArray array];
    self.mArr_parent = [NSMutableArray array];
    
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"家长查询"];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    
    self.mScrollV_all = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.mNav_navgationBar.frame.size.height, [dm getInstance].width, 48)];
    int tempWidth = [dm getInstance].width/3;
    for (int i=0; i<3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(tempWidth*i, 1, tempWidth, 47)];
        [btn setTag:i];
        if (i==0) {
            btn.selected = YES;
            self.mInt_index = 0;
            [btn setTitle:@"当前作业" forState:UIControlStateNormal];
        }else if (i==1){
            [btn setTitle:@"作业完成情况" forState:UIControlStateNormal];
        }else if (i==2){
            [btn setTitle:@"学力" forState:UIControlStateNormal];
        }
        [btn setBackgroundColor:[UIColor colorWithRed:247/255.0 green:246/255.0 blue:246/255.0 alpha:1]];
        btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        
        [btn setTitleColor:[UIColor colorWithRed:3/255.0 green:170/255.0 blue:54/255.0 alpha:1] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"topBtnSelect0"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(selectScrollButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.mScrollV_all addSubview:btn];
    }
    self.mScrollV_all.contentSize = CGSizeMake(tempWidth*3, 48);
    [self.view addSubview:self.mScrollV_all];
    
    //
    self.mTableV_list.frame = CGRectMake(0, self.mScrollV_all.frame.size.height+self.mScrollV_all.frame.origin.y-[dm getInstance].statusBar, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height-48+[dm getInstance].statusBar);
    self.mTableV_list.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //根据角色信息，获取学生id信息
    for (int i=0; i<[dm getInstance].identity.count; i++) {
        Identity_model *idenModel = [[dm getInstance].identity objectAtIndex:i];
        if ([idenModel.RoleIdentity intValue]==3) {
            for (int m=0; m<idenModel.UserClasses.count; m++) {
                Identity_UserClasses_model *userUnitsModel = [idenModel.UserClasses objectAtIndex:m];
                D("sdrioghagilr;jae;l-====%@,%d",userUnitsModel.ClassID,[dm getInstance].UID);
                [[OnlineJobHttp getInstance] getGenInfoWithAccID:[dm getInstance].jiaoBaoHao UID:userUnitsModel.ClassID];
            }
        }
    }
}

//获取到学生id
-(void)getGenInfoWithAccID:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSMutableDictionary *dic = noti.object;
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
    if ([ResultCode intValue]==0) {
        GenInfo *model = [dic objectForKey:@"model"];
        [self.mArr_parent addObject:model];
        //发送请求
//        [[OnlineJobHttp getInstance] GetCompleteStatusHWWithStuId:model.StudentID];
        [[OnlineJobHttp getInstance] GetStuHWListWithStuId:model.StudentID IsSelf:@"0"];
        [MBProgressHUD showMessage:@"" toView:self.view];
    }else{
        NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
        [MBProgressHUD showError:ResultDesc toView:self.view];
    }
}

//获取某学生各科作业完成情况
-(void)GetCompleteStatusHW:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSMutableDictionary *dic = noti.object;
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
    if ([ResultCode intValue]==0) {
        NSMutableArray *array = [dic objectForKey:@"array"];
        [self.mArr_nowHomework addObject:array];
    }else{
        NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
        [MBProgressHUD showError:ResultDesc toView:self.view];
    }
    [self.mTableV_list reloadData];
}

//学生获取当前作业列表
-(void)GetStuHWList:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSMutableDictionary *dic = noti.object;
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
    if ([ResultCode intValue]==0) {
        NSMutableArray *array = [dic objectForKey:@"array"];
        NSString *IsSelf = [dic objectForKey:@"IsSelf"];
        if ([IsSelf intValue]==0) {
            if (array.count>0) {
                [self.mArr_nowHomework addObjectsFromArray:array];
            }else{
                [MBProgressHUD showError:@"无数据" toView:self.view];
            }
        }
        [self.mTableV_list reloadData];
    }else{
        [MBProgressHUD showError:@"服务器异常" toView:self.view];
    }
}

-(void)selectScrollButton:(UIButton *)btn{
    self.mInt_index = (int)btn.tag;
    for (UIButton *btn1 in self.mScrollV_all.subviews) {
        if ([btn1.class isSubclassOfClass:[UIButton class]]) {
            if ((int)btn1.tag == self.mInt_index) {
                btn1.selected = YES;
            }else{
                btn1.selected = NO;
            }
        }
    }
    if (btn.tag==0) {//获取作业列表
        self.mInt_index = 0;
        //判断是否有值
        
    }else if (btn.tag==1) {//获取练习列表
        self.mInt_index = 1;
        //判断是否有值
        
    }else if (btn.tag==2) {//获取练习列表
        self.mInt_index = 2;
        //判断是否有值
        
    }
    [self.mTableV_list reloadData];
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.mInt_index==0) {
        return self.mArr_nowHomework.count;
    } else if (self.mInt_index==1){
        return self.mArr_overHomework.count;
    }else if (self.mInt_index==2){
        return self.mArr_score.count;
    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"StudentHomework_TableViewCell";
    if (self.mInt_index ==0) {
        StudentHomework_TableViewCell *cell = (StudentHomework_TableViewCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
        if (cell == nil) {
            cell = [[StudentHomework_TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StudentHomework_TableViewCell" owner:self options:nil];
            //这时myCell对象已经通过自定义xib文件生成了
            if ([nib count]>0) {
                cell = (StudentHomework_TableViewCell *)[nib objectAtIndex:0];
                //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
            }
            //添加图片点击事件
            //若是需要重用，需要写上以下两句代码
            UINib * n= [UINib nibWithNibName:@"StudentHomework_TableViewCell" bundle:[NSBundle mainBundle]];
            [self.mTableV_list registerNib:n forCellReuseIdentifier:indentifier];
        }
        StuHWModel *model;
        if (self.mInt_index == 0) {
            model = [self.mArr_nowHomework objectAtIndex:indexPath.row];
            
            if ([model.isHaveAdd intValue]==1) {//主观题
                cell.mImg_pic.frame = CGRectMake(8, 10, 14, 14);
            }else{
                cell.mImg_pic.frame = CGRectMake(8, 10, 0, 0);
            }
            //名称
            cell.mLab_title.text = model.homeworkName;
            cell.mLab_title.frame  = CGRectMake(cell.mImg_pic.frame.origin.x+cell.mImg_pic.frame.size.width+5, 10, [dm getInstance].width-cell.mImg_pic.frame.origin.x-cell.mImg_pic.frame.size.width-10, cell.mLab_title.frame.size.height);
            //题量
            cell.mLab_numLab.text = @"选/填/总: ";
            CGSize numSize0 = [cell.mLab_numLab.text sizeWithFont:[UIFont systemFontOfSize:10]];
            cell.mLab_numLab.frame = CGRectMake(8, cell.mLab_title.frame.origin.y+cell.mLab_title.frame.size.height, numSize0.width, cell.mLab_numLab.frame.size.height);
            
            NSString *num0 = model.distribution;//选择题、填空题分布---1:10,2:10
            num0 = [num0 stringByReplacingOccurrencesOfString:@"1:" withString:@""];
            num0 = [num0 stringByReplacingOccurrencesOfString:@",2:" withString:@"/"];
            num0 = [NSString stringWithFormat:@"%@/%@",num0,model.itemNumber];
            cell.mLab_num.text = num0;
            CGSize numSize = [num0 sizeWithFont:[UIFont systemFontOfSize:10]];
            cell.mLab_num.frame = CGRectMake(cell.mLab_numLab.frame.origin.x+cell.mLab_numLab.frame.size.width, cell.mLab_numLab.frame.origin.y, numSize.width, cell.mLab_num.frame.size.height);
            //过期时间
            cell.mLab_timeLab.hidden = YES;
            cell.mLab_time.hidden = YES;
            //判断是否做完
            if ([model.isHWFinish intValue]==1) {//完成
                cell.mLab_goto.hidden = YES;
                cell.mLab_power.hidden = NO;
                cell.mLab_powerLab.hidden = NO;
                cell.mLab_score.hidden = NO;
                cell.mLab_scoreLab.hidden = NO;
                //学力
                cell.mLab_power.text = model.EduLevel;
                CGSize EduLevelSize = [model.EduLevel sizeWithFont:[UIFont systemFontOfSize:10]];
                cell.mLab_power.frame = CGRectMake([dm getInstance].width-9-EduLevelSize.width, cell.mLab_numLab.frame.origin.y, EduLevelSize.width, cell.mLab_power.frame.size.height);
                cell.mLab_powerLab.frame = CGRectMake(cell.mLab_power.frame.origin.x-cell.mLab_powerLab.frame.size.width, cell.mLab_numLab.frame.origin.y, cell.mLab_powerLab.frame.size.width, cell.mLab_powerLab.frame.size.height);
                //得分
                cell.mLab_score.text = model.HWScore;
                CGSize HWScoreSize = [model.HWScore sizeWithFont:[UIFont systemFontOfSize:10]];
                cell.mLab_score.frame = CGRectMake(cell.mLab_powerLab.frame.origin.x-10-HWScoreSize.width, cell.mLab_numLab.frame.origin.y, HWScoreSize.width, cell.mLab_score.frame.size.height);
                cell.mLab_scoreLab.frame = CGRectMake(cell.mLab_score.frame.origin.x-cell.mLab_scoreLab.frame.size.width, cell.mLab_numLab.frame.origin.y, cell.mLab_scoreLab.frame.size.width, cell.mLab_scoreLab.frame.size.height);
            }else{
                cell.mLab_goto.hidden = NO;
                cell.mLab_power.hidden = YES;
                cell.mLab_powerLab.hidden = YES;
                cell.mLab_score.hidden = YES;
                cell.mLab_scoreLab.hidden = YES;
                cell.mLab_goto.text = @"未完成";
                cell.mLab_goto.frame = CGRectMake([dm getInstance].width-9-cell.mLab_goto.frame.size.width, cell.mLab_numLab.frame.origin.y, cell.mLab_goto.frame.size.width, cell.mLab_goto.frame.size.height);
            }
            //分割线
            cell.mLab_line.frame = CGRectMake(0, cell.mLab_numLab.frame.origin.y+cell.mLab_numLab.frame.size.height+5, [dm getInstance].width, cell.mLab_line.frame.size.height);
            
            return cell;
        }else{
            
        }
    }
    return nil;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    return 66;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.mInt_index ==0) {//当前作业查询
        StuHWModel *model = [self.mArr_nowHomework objectAtIndex:indexPath.row];
    }
}

//导航条返回按钮回调
-(void)myNavigationGoback{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
