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
@property(nonatomic,strong)NSArray *unitArr;
@property(nonatomic,strong)UIButton *addBtn;

@end

@implementation PeopleSpaceViewController
@synthesize mTableV_personalS,mNav_navgationBar,mProgressV,mArr_personalS;

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:_observer1];
    [[NSNotificationCenter defaultCenter]removeObserver:_observer2];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [self setValueModel];
    _observer1 = [[NSNotificationCenter defaultCenter]addObserverForName:@"GetMyMobileUnitList" object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSArray *arr = note.object;
        self.unitArr = arr;
        [self.unitTabelView reloadData];
    }];
    _observer2 = [[NSNotificationCenter defaultCenter]addObserverForName:@"JoinUnitOP" object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *str =note.object;
        if([str integerValue ] == 0)
        {
            [self progressViewTishi:@"加入成功"];
            [self.addBtn setTitle:@"已加入" forState:UIControlStateNormal];
            self.addBtn.enabled = NO;
        }
        else {
            [self progressViewTishi:@"加入失败"];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    self.mTableV_personalS.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height-[dm getInstance].statusBar+20, [dm getInstance].width, 500);
    self.unitTabelView.frame = CGRectMake(0, self.mTableV_personalS.frame.size.height+self.mTableV_personalS.frame.origin.y-20, [dm getInstance].width, 400);
    
    
    self.mProgressV = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:self.mProgressV];
    self.mProgressV.delegate = self;
    [[RegisterHttp getInstance]registerHttpGetMyMobileUnitList:[dm getInstance].jiaoBaoHao];
//    [[RegisterHttp getInstance]registerHttpJoinUnitOP:[dm getInstance].jiaoBaoHao option:0 tableStr:<#(NSString *)#>]
}

//设置显示值
-(void)setValueModel{
    [self.mArr_personalS removeAllObjects];
    NSString *trueName = [dm getInstance].TrueName;
    NSString *nickName = [dm getInstance].NickName;
    NSMutableArray *tempArr0 = [NSMutableArray arrayWithObjects:nickName,@"账号信息",@"手机",@"邮箱",@"密码",@"所在单位", nil];
    NSMutableArray *tempArr1 = [NSMutableArray arrayWithObjects:trueName,[dm getInstance].jiaoBaoHao,@"",@"",@"修改密码",@"加入单位", nil];
    for (int i=0; i<6; i++) {
        PersonalSpaceModel *model = [[PersonalSpaceModel alloc] init];
        model.mStr_nickName = [NSString stringWithFormat:@"%@",[tempArr0 objectAtIndex:i]];
        model.mStr_trueName = [NSString stringWithFormat:@"%@",[tempArr1 objectAtIndex:i]];
        [self.mArr_personalS addObject:model];
    }
    [self.mTableV_personalS reloadData];
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    if([tableView isEqual:self.unitTabelView])
    {
        return self.unitArr.count;
    }
    return self.mArr_personalS.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if([tableView isEqual:self.unitTabelView])
    {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [dm getInstance].width, 35)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, [dm getInstance].width, 35)];
        label.text = @"所在单位";
        //label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:14];
        [headerView addSubview:label];
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
        return 30;
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

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([tableView isEqual:self.unitTabelView])
    {
        static NSString *cellIdentifier = @"unitTabelViewCell";
        UnitTableViewCell *cell = (UnitTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"UnitTableViewCell" owner:self options:nil] lastObject];
        }
        cell.delegate = self;
        cell.tag = indexPath.row;
        
        unitModel *unitModel = [self.unitArr objectAtIndex:indexPath.row];
        cell.unitNameLabel.text = unitModel.UnitName;
        cell.identTypeLabel.text =unitModel.Identity;
        if(unitModel.AccId>0)
        {
            [cell.addBtn setTitle:@"已加入" forState:UIControlStateNormal];
            cell.addBtn.enabled = NO;
        }
        else
        {
            [cell.addBtn setTitle:@"加入" forState:UIControlStateNormal];
            cell.addBtn.enabled = YES;

            
        }

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
    else
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
    }else{
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
    }else if (indexPath.row == 4){
        ReviseNameViewController *reviseName = [[ReviseNameViewController alloc] init];
        reviseName.mInt_flag = 2;
        [utils pushViewController:reviseName animated:YES];
    }
    if(indexPath.row == 5)
    {
        MobileUnitViewController *detail = [[MobileUnitViewController alloc]init];
        [utils pushViewController:detail animated:YES];
        
    }
}
-(void)ClickBtnWith:(UIButton *)btn cell:(UnitTableViewCell *)cell
{
    self.addBtn = btn;
    unitModel *model = [self.unitArr objectAtIndex:cell.tag];
    if ([self checkNetWork]) {
        return;
    }
    [[RegisterHttp getInstance]registerHttpJoinUnitOP:model.AccId option:@"1" tableStr:model.TabIdStr];
    
    
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

@end
