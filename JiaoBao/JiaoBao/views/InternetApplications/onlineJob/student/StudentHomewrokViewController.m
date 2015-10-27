//
//  StudentHomewrokViewController.m
//  JiaoBao
//
//  Created by Zqw on 15/10/23.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "StudentHomewrokViewController.h"
#import "define_constant.h"

@interface StudentHomewrokViewController ()

@end

@implementation StudentHomewrokViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //学生获取当前作业列表
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetStuHWList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetStuHWList:) name:@"GetStuHWList" object:nil];
    
    self.mArr_homework = [NSMutableArray array];
    self.mArr_practice = [NSMutableArray array];
    self.mInt_index = 0;
    
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"作业"];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    
    self.mScrollV_all = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.mNav_navgationBar.frame.size.height, [dm getInstance].width, 48)];
    int tempWidth = [dm getInstance].width/2;
    for (int i=0; i<2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(tempWidth*i, 1, tempWidth, 47)];
        [btn setTag:i];
        if (i==0) {
            btn.selected = YES;
            self.mInt_index = 0;
            [btn setTitle:@"做作业" forState:UIControlStateNormal];
        }else{
            [btn setTitle:@"做练习" forState:UIControlStateNormal];
        }
        [btn setBackgroundColor:[UIColor colorWithRed:247/255.0 green:246/255.0 blue:246/255.0 alpha:1]];
        
        
        [btn setTitleColor:[UIColor colorWithRed:3/255.0 green:170/255.0 blue:54/255.0 alpha:1] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"topBtnSelect0"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(selectScrollButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.mScrollV_all addSubview:btn];
    }
    self.mScrollV_all.contentSize = CGSizeMake(tempWidth*2, 48);
    [self.view addSubview:self.mScrollV_all];
    
    //
    self.mTableV_list.frame = CGRectMake(0, self.mScrollV_all.frame.size.height+self.mScrollV_all.frame.origin.y-[dm getInstance].statusBar, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height-48+[dm getInstance].statusBar);
    self.mTableV_list.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.mTableV_list addHeaderWithTarget:self action:@selector(headerRereshing)];
//    self.mTableV_list.headerPullToRefreshText = @"下拉刷新";
//    self.mTableV_list.headerReleaseToRefreshText = @"松开后刷新";
//    self.mTableV_list.headerRefreshingText = @"正在刷新...";
//    [self.mTableV_list addFooterWithTarget:self action:@selector(footerRereshing)];
//    self.mTableV_list.footerPullToRefreshText = @"上拉加载更多";
//    self.mTableV_list.footerReleaseToRefreshText = @"松开加载更多数据";
//    self.mTableV_list.footerRefreshingText = @"正在加载...";
    
    //根据角色信息，获取学生id信息
    for (int i=0; i<[dm getInstance].identity.count; i++) {
        Identity_model *idenModel = [[dm getInstance].identity objectAtIndex:i];
        if ([idenModel.RoleIdentity intValue]==4) {
            for (int m=0; m<idenModel.UserClasses.count; m++) {
                Identity_UserClasses_model *userUnitsModel = [idenModel.UserClasses objectAtIndex:m];
                D("sdrioghagilr;jae;l-====%@,%d",userUnitsModel.ClassID,[dm getInstance].UID);
                //找到当前登录的班级，然后获取
//                if ([userUnitsModel.ClassID intValue] ==[dm getInstance].UID) {
                    D("douifghdoj-====%@",userUnitsModel.ClassID);
                    [[OnlineJobHttp getInstance] getStuInfoWithAccID:[dm getInstance].jiaoBaoHao UID:userUnitsModel.ClassID];
//                }
            }
        }
    }
}

//学生获取当前作业列表
-(void)GetStuHWList:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSMutableArray *array = noti.object;
    [self.mArr_homework addObjectsFromArray:array];
    D("sdfjghakj-====%lu",(unsigned long)self.mArr_homework.count);
    [self.mTableV_list reloadData];
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
    if (btn.tag==0) {
        self.mInt_index = 0;
        
    }else{
        self.mInt_index = 1;
        
    }
    [self.mTableV_list reloadData];
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.mInt_index==0) {
        return self.mArr_homework.count;
    } else {
        return self.mArr_practice.count;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"StudentHomework_TableViewCell";
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
    StuHWModel *model = [self.mArr_homework objectAtIndex:indexPath.row];
    if ([model.isHaveAdd intValue]==1) {//主观题
        cell.mImg_pic.frame = CGRectMake(8, 10, 14, 14);
    }else{
        cell.mImg_pic.frame = CGRectMake(8, 10, 0, 0);
    }
    //名称
    cell.mLab_title.text = model.homeworkName;
    cell.mLab_title.frame  = CGRectMake(cell.mImg_pic.frame.origin.x+cell.mImg_pic.frame.size.width+5, 10, [dm getInstance].width-cell.mImg_pic.frame.origin.x-cell.mImg_pic.frame.size.width-10, cell.mLab_title.frame.size.height);
    //题量
    cell.mLab_numLab.frame = CGRectMake(8, cell.mLab_title.frame.origin.y+cell.mLab_title.frame.size.height, cell.mLab_numLab.frame.size.width, cell.mLab_numLab.frame.size.height);
    cell.mLab_num.text = model.itemNumber;
    CGSize numSize = [model.itemNumber sizeWithFont:[UIFont systemFontOfSize:10]];
    cell.mLab_num.frame = CGRectMake(cell.mLab_numLab.frame.origin.x+cell.mLab_numLab.frame.size.width, cell.mLab_numLab.frame.origin.y, numSize.width, cell.mLab_num.frame.size.height);
    //过期时间
    cell.mLab_timeLab.frame = CGRectMake(cell.mLab_num.frame.origin.x+cell.mLab_num.frame.size.width+20, cell.mLab_numLab.frame.origin.y, cell.mLab_timeLab.frame.size.width, cell.mLab_timeLab.frame.size.height);
    cell.mLab_time.text = model.EXPIRYDATE;
    D("dfuhguhj-====%@,%@",model.EXPIRYDATE,model.isHWFinish);
    CGSize timeSize = [model.EXPIRYDATE sizeWithFont:[UIFont systemFontOfSize:10]];
    cell.mLab_time.frame  = CGRectMake(cell.mLab_timeLab.frame.origin.x+cell.mLab_timeLab.frame.size.width, cell.mLab_numLab.frame.origin.y, timeSize.width, cell.mLab_time.frame.size.height);
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
        cell.mLab_goto.frame = CGRectMake([dm getInstance].width-9-cell.mLab_goto.frame.size.width, cell.mLab_numLab.frame.origin.y, cell.mLab_goto.frame.size.width, cell.mLab_goto.frame.size.height);
    }
    //分割线
    cell.mLab_line.frame = CGRectMake(0, cell.mLab_numLab.frame.origin.y+cell.mLab_numLab.frame.size.height+5, [dm getInstance].width, cell.mLab_line.frame.size.height);
    
    return cell;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    return 66;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    StuHWModel *model = [self.mArr_homework objectAtIndex:indexPath.row];
    [[OnlineJobHttp getInstance] GetStuHWWithHwInfoId:model.TabID];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing{
    
}

- (void)footerRereshing{
    
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
