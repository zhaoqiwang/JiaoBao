//
//  PeopleSpaceViewController.m
//  JiaoBao
//
//  Created by Zqw on 15/6/4.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "PeopleSpaceViewController.h"
#import "UnitTableViewCell.h"
#import "MobileUnitViewController.h"

@interface PeopleSpaceViewController ()
{
    id  _observer1,_observer2;

}
@property(nonatomic,strong)NSArray *unitArr,*unitArr2;//关联单位名称数组、关联单位身份数组
@property(nonatomic,strong)UIButton *addBtn;//指向点击cell上的addBtn，等数据返回时改变addbtn的title
@property(nonatomic,strong)UIScrollView *mainScrollView;

@end

@implementation PeopleSpaceViewController
@synthesize mTableV_personalS,mNav_navgationBar,mProgressV,mArr_personalS;

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
//    移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:_observer1];
    [[NSNotificationCenter defaultCenter]removeObserver:_observer2];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self setValueModel];

}

- (void)viewDidLoad {
    [super viewDidLoad];

    _observer1 = [[NSNotificationCenter defaultCenter]addObserverForName:@"getIdentity" object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSMutableArray *mArr = [[NSMutableArray alloc]initWithCapacity:0];
        NSMutableArray *mArr2 = [[NSMutableArray alloc]initWithCapacity:0];
        for(int i=0;i<[dm getInstance].identity.count;i++)
        {
            Identity_model *model= [[dm getInstance].identity objectAtIndex:i];
            if([model.RoleIdName isEqualToString:@"家长"]|[model.RoleIdName isEqualToString:@"学生"])
            {
                for(int i=0;i<model.UserClasses.count;i++)
                {
                    Identity_UserClasses_model *model2 = [model.UserClasses objectAtIndex:i];
                    [mArr addObject:model2.ClassName];
                    [mArr2 addObject:model.RoleIdName];
                    
                    
                }
                
            }
            else
            {
                for(int i=0;i<model.UserUnits.count;i++)
                {
                    Identity_UserUnits_model *model2 = [model.UserUnits objectAtIndex:i];
                    [mArr addObject:model2.UnitName];
                    [mArr2 addObject:model.RoleIdName];
                    
                }
                
            }
            
            
            
            
        }
        
        self.unitArr = mArr;
        self.unitArr2 = mArr2;
        [self.unitTabelView reloadData];

    }];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
    
    //获取关联身份数据 并加入到相应的数组中
    NSMutableArray *mArr = [[NSMutableArray alloc]initWithCapacity:0];
    NSMutableArray *mArr2 = [[NSMutableArray alloc]initWithCapacity:0];
    for(int i=0;i<[dm getInstance].identity.count;i++)
    {
        Identity_model *model= [[dm getInstance].identity objectAtIndex:i];
        if([model.RoleIdName isEqualToString:@"家长"]|[model.RoleIdName isEqualToString:@"学生"])
        {
            for(int i=0;i<model.UserClasses.count;i++)
            {
                Identity_UserClasses_model *model2 = [model.UserClasses objectAtIndex:i];
                [mArr addObject:model2.ClassName];
                [mArr2 addObject:model.RoleIdName];
                

            }
            
        }
        else
        {
            for(int i=0;i<model.UserUnits.count;i++)
            {
                Identity_UserUnits_model *model2 = [model.UserUnits objectAtIndex:i];
                [mArr addObject:model2.UnitName];
                [mArr2 addObject:model.RoleIdName];

            }
            
        }



        
    }

    self.unitArr = mArr;
    self.unitArr2 = mArr2;

    //加提示类的实例
    self.mProgressV = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:self.mProgressV];
    self.mProgressV.delegate = self;
    
    // Do any additional setup after loading the view from its nib.
    
    self.mArr_personalS = [NSMutableArray array];
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"个人中心"];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];


    
    //表格
    self.mTableV_personalS.frame = CGRectMake(0, 0, [dm getInstance].width, 70+2*44);
    
    self.unitTabelView.frame = CGRectMake(0, self.mTableV_personalS.frame.size.height+self.mTableV_personalS.frame.origin.y, [dm getInstance].width, 20*self.unitArr.count+40);
    self.tableVIewBtn.frame = self.unitTabelView.frame;
    
    self.mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.mNav_navgationBar.frame.size.height+self.mNav_navgationBar.frame.origin.y, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height)];
    self.mainScrollView.contentSize = CGSizeMake([dm getInstance].width, self.mTableV_personalS.frame.size.height+self.unitTabelView.frame.size.height);
    [self.view addSubview:self.mainScrollView];
    //self.mainScrollView.backgroundColor = [UIColor redColor];
    [self.mainScrollView addSubview:self.mTableV_personalS];
    [self.mainScrollView addSubview:self.unitTabelView];
    [self.mainScrollView addSubview:self.tableVIewBtn];
    
    

//    [[RegisterHttp getInstance]registerHttpGetMyMobileUnitList:[dm getInstance].jiaoBaoHao];
//    [[RegisterHttp getInstance]registerHttpJoinUnitOP:[dm getInstance].jiaoBaoHao option:0 tableStr:<#(NSString *)#>]
}

//设置显示值
-(void)setValueModel{
    [self.mArr_personalS removeAllObjects];
    NSString *trueName = [dm getInstance].TrueName;
    NSString *nickName = [dm getInstance].NickName;
//    NSMutableArray *tempArr0 = [NSMutableArray arrayWithObjects:nickName,@"账号信息",@"手机",@"邮箱",@"密码",@"所在单位", nil];
//    NSMutableArray *tempArr1 = [NSMutableArray arrayWithObjects:trueName,[dm getInstance].jiaoBaoHao,@"",@"",@"修改密码",@"加入单位", nil];
    NSMutableArray *tempArr0 = [NSMutableArray arrayWithObjects:nickName,@"教宝号",@"修改密码",@"所在单位", nil];
    NSMutableArray *tempArr1 = [NSMutableArray arrayWithObjects:trueName,[dm getInstance].jiaoBaoHao,@"",@"", nil];
    for (int i=0; i<4; i++) {
        PersonalSpaceModel *model = [[PersonalSpaceModel alloc] init];
        model.mStr_nickName = [NSString stringWithFormat:@"%@",[tempArr0 objectAtIndex:i]];
        model.mStr_trueName = [NSString stringWithFormat:@"%@",[tempArr1 objectAtIndex:i]];
        [self.mArr_personalS addObject:model];
    }
    [self.mTableV_personalS reloadData];
}
#pragma -mark 列表代理方法
-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    if([tableView isEqual:self.unitTabelView])
    {
        return self.unitArr.count;
    }
    return self.mArr_personalS.count-1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if([tableView isEqual:self.unitTabelView])
    {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [dm getInstance].width, 35)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 200, 35)];
        label.text = @"  我的单位";
        //label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:14];
        [headerView addSubview:label];
        
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, 200, 35)];
        //label2.text = @"加入单位";
        label2.textColor = [UIColor lightGrayColor];
        label2.font = [UIFont systemFontOfSize:14];
        [headerView addSubview:label2];
        return headerView;
        
    }
    return 0;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if([tableView isEqual:self.unitTabelView])
    {
        return 30;
    }
    else
    {
        return 0;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    if([tableView isEqual:self.unitTabelView])
    {
        return 20;
        
    }
    else
    {
        if (indexPath.row == 0) {
            return 70;
        }else{
            return 44;
        }
        
    }

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //如果是关联单位的列表
    if([tableView isEqual:self.unitTabelView])
    {
        static NSString *cellIdentifier = @"unitTabelViewCell";
        UnitTableViewCell *cell = (UnitTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"UnitTableViewCell" owner:self options:nil] lastObject];
        }
        cell.delegate = self;
        cell.tag = indexPath.row;

        cell.unitNameLabel.text = [self.unitArr objectAtIndex:indexPath.row];

        NSString *identTypeLabelStr = [NSString stringWithFormat:@"(%@)",[self.unitArr2 objectAtIndex:indexPath.row] ];
        cell.identTypeLabel.text = identTypeLabelStr;

        cell.addBtn.hidden = YES;

        if(indexPath.row == self.unitArr.count -1)
        {
            cell.bottomLine.hidden = NO;
        }
        else
        {
            cell.bottomLine.hidden = YES;
        }
        return cell;

        
        
    }
    else//如果是个人中心的主列表
    {
    static NSString *CellWithIdentifier = @"PeopleSpaceTableViewCell";
    PeopleSpaceTableViewCell *cell = (PeopleSpaceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PeopleSpaceTableViewCell" owner:self options:nil] lastObject];
    }
    PersonalSpaceModel *model = [self.mArr_personalS objectAtIndex:indexPath.row];
    
    if (indexPath.row ==0) {
        cell.mImgV_head.hidden = NO;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        //文件名
        NSString *imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",[dm getInstance].jiaoBaoHao]];
        UIImage *img= [UIImage imageWithContentsOfFile:imgPath];
        if (img.size.width>0) {
            [cell.mImgV_head setImage:img];
        }else{
            [cell.mImgV_head setImage:[UIImage imageNamed:@"root_img"]];
            //获取头像
            [[ExchangeHttp getInstance] getUserInfoFace:[dm getInstance].jiaoBaoHao];
        }
        cell.mImgV_head.frame = CGRectMake(10, 10, cell.mImgV_head.frame.size.width, cell.mImgV_head.frame.size.height);
        cell.mLab_nickName.frame = CGRectMake(cell.mImgV_head.frame.size.width+20, 15, [dm getInstance].width-75, cell.mLab_nickName.frame.size.height);
        cell.mLab_trueName.frame = CGRectMake(cell.mImgV_head.frame.size.width+20, 15+cell.mLab_nickName.frame.size.height+5, [dm getInstance].width-75, cell.mLab_nickName.frame.size.height);
        cell.mLab_line.frame = CGRectMake(0, 69, [dm getInstance].width, .5);
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }else{
        if (indexPath.row ==2) {
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.mImgV_head.hidden = YES;
        cell.mLab_nickName.frame = CGRectMake(15, 10, cell.mLab_nickName.frame.size.width, cell.mLab_nickName.frame.size.height);
        cell.mLab_trueName.frame = CGRectMake(100, 10, 200, cell.mLab_nickName.frame.size.height);
        cell.mLab_line.frame = CGRectMake(0, 43, [dm getInstance].width, .5);
    }
    cell.mLab_nickName.text = model.mStr_nickName;
    cell.mLab_trueName.text = model.mStr_trueName;
    
    return cell;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        ReviseNameViewController *reviseName = [[ReviseNameViewController alloc] init];
        reviseName.mInt_flag = 1;
        [utils pushViewController:reviseName animated:YES];
    }else if (indexPath.row == 2){
        ReviseNameViewController *reviseName = [[ReviseNameViewController alloc] init];
        reviseName.mInt_flag = 2;
        [utils pushViewController:reviseName animated:YES];
    }
    if(indexPath.row == 3)
    {
        MobileUnitViewController *detail = [[MobileUnitViewController alloc]init];
        [utils pushViewController:detail animated:YES];
        
    }
}
-(void)ClickBtnWith:(UIButton *)btn cell:(UnitTableViewCell *)cell
{
//    self.addBtn = btn;
//    unitModel *model = [self.unitArr objectAtIndex:cell.tag];
//    if ([self checkNetWork]) {
//        return;
//    }
//    [[RegisterHttp getInstance]registerHttpJoinUnitOP:model.AccId option:@"1" tableStr:model.TabIdStr];
    
    
}


//导航条返回按钮回调
-(void)myNavigationGoback{
    [utils popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//检查当前网络是否可用
-(BOOL)checkNetWork{
    if([Reachability isEnableNetwork]==NO){
        self.mProgressV.mode = MBProgressHUDModeCustomView;
        self.mProgressV.labelText = NETWORKENABLE;
        [self.mProgressV show:YES];
        [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
        return YES;
    }else{
        return NO;
    }
}

-(void)noMore{
    sleep(1);
}

-(void)progressViewTishi:(NSString *)title{
    self.mProgressV.labelText = title;
    self.mProgressV.mode = MBProgressHUDModeCustomView;
    [self.mProgressV show:YES];
    [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
}

-(void)ProgressViewLoad:(NSString *)title{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    self.mProgressV.mode = MBProgressHUDModeIndeterminate;
    self.mProgressV.labelText = title;
    [self.mProgressV show:YES];
    [self.mProgressV showWhileExecuting:@selector(Loading) onTarget:self withObject:nil animated:YES];
}

- (void)Loading {
    sleep(TIMEOUT);
    self.mProgressV.mode = MBProgressHUDModeCustomView;
    self.mProgressV.labelText = @"加载超时";
    sleep(2);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)tbBtnAction:(id)sender {
    MobileUnitViewController *detail = [[MobileUnitViewController alloc]init];
    [utils pushViewController:detail animated:YES];
}
@end
