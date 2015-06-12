//
//  SubUnitInfoViewController.m
//  JiaoBao
//
//  Created by Zqw on 14-11-22.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "SubUnitInfoViewController.h"
#import "Reachability.h"

@interface SubUnitInfoViewController ()

@end

@implementation SubUnitInfoViewController
@synthesize mNav_navgationBar,mArr_unit,mTableV_unit,mProgressV,mInt_section,mModel_unit;


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //获取到的子单位通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MySubUnitInfo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MySubUnitInfo:) name:@"MySubUnitInfo" object:nil];
    //获取到关联单位和所有单位
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getUnitClassShow" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUnitClassShow:) name:@"getUnitClassShow" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
    
    self.mArr_unit = [NSMutableArray array];
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:self.mModel_unit.UnitName];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    
    self.mTableV_unit.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height-[dm getInstance].statusBar, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height+[dm getInstance].statusBar);
    
    
    self.mProgressV = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.mProgressV];
    self.mProgressV.delegate = self;
//    self.mProgressV.userInteractionEnabled = NO;
    
    [self sendRequest];
}

-(void)sendRequest{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    if ([self.mModel_unit.UnitType intValue] == 1) {
        [[ShareHttp getInstance] shareHttpGetMySubUnitInfoWith:self.mModel_unit.UnitID];
    }else if([self.mModel_unit.UnitType intValue] == 2){
        [[ShareHttp getInstance] shareHttpGetUnitClassWith:self.mModel_unit.UnitID Section:@"2"];
    }
    self.mProgressV.labelText = @"加载中...";
    self.mProgressV.mode = MBProgressHUDModeIndeterminate;
    [self.mProgressV show:YES];
    [self.mProgressV showWhileExecuting:@selector(Loading) onTarget:self withObject:nil animated:YES];
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

//获取到关联单位和所有单位
-(void)getUnitClassShow:(NSNotification *)noti{
    [self.mProgressV hide:YES];
    NSMutableDictionary *dic = noti.object;
    int index = [[dic objectForKey:@"index"] intValue];
    
    if (index == 1) {//关联的班级
        
    } else {//所有班级
        [self.mProgressV hide:YES];
        NSArray *array = [dic objectForKey:@"array"];
        self.mArr_unit = [NSMutableArray arrayWithArray:array];
        [self.mTableV_unit reloadData];
    }
}
-(void)noMore{
    sleep(1);
}

- (void)Loading {
    sleep(TIMEOUT);
    self.mProgressV.mode = MBProgressHUDModeCustomView;
    self.mProgressV.labelText = @"加载超时";
//    self.mProgressV.userInteractionEnabled = NO;
    [self.mTableV_unit headerEndRefreshing];
    [self.mTableV_unit footerEndRefreshing];
    sleep(2);
}
//获取到的子单位通知
-(void)MySubUnitInfo:(NSNotification *)noti{
    [self.mProgressV hide:YES];
    self.mArr_unit = [NSMutableArray arrayWithArray:noti.object];
    [self.mTableV_unit reloadData];
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mArr_unit.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"TreeView_Level0_Cell";
    TreeView_Level0_Cell *cell0 = (TreeView_Level0_Cell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if(cell0 == nil){
        cell0 = [[[NSBundle mainBundle] loadNibNamed:@"TreeView_Level0_Cell" owner:self options:nil] lastObject];
        cell0.frame = CGRectMake(0, 0, [dm getInstance].width, 48);
    }
    if ([self.mModel_unit.UnitType intValue] == 1) {
        UnitInfoModel *model = [mArr_unit objectAtIndex:indexPath.row];
        
        cell0.mLab_name.text = model.UintName;
        CGSize nameSize = [model.UintName sizeWithFont:[UIFont systemFontOfSize:15]];
        cell0.mLab_name.frame = CGRectMake(cell0.mLab_name.frame.origin.x, cell0.mLab_name.frame.origin.y, nameSize.width, cell0.mLab_name.frame.size.height);
        //本地图片
        [cell0.mImgV_head setImage:[UIImage imageNamed:@"share_tableV_education"]];
        cell0.mImgV_head.frame = CGRectMake(32, 12, 24, 24);
        [cell0.mBtn_detail setImage:[UIImage imageNamed:@"share_tableV_more"] forState:UIControlStateNormal];
        cell0.mBtn_detail.frame = CGRectMake([dm getInstance].width-44-10, 0, 44, 48);
        if ([model.ArtUpdate intValue]>0) {
            cell0.mImgV_number.hidden = NO;
            cell0.mLab_number.hidden = NO;
            UIImage *img = [UIImage imageNamed:@"root_dian"];
            CGSize numSize = [model.ArtUpdate sizeWithFont:[UIFont systemFontOfSize:16]];
            cell0.mImgV_number.frame = CGRectMake(cell0.mLab_name.frame.origin.x+cell0.mLab_name.frame.size.width, (48-img.size.height)/2+2, numSize.width+5, img.size.height);
            [cell0.mImgV_number setImage:img];
            cell0.mLab_number.frame = cell0.mImgV_number.frame;
            cell0.mLab_number.text = model.ArtUpdate;
        }else{
            cell0.mImgV_number.hidden = YES;
            cell0.mLab_number.hidden = YES;
        }
    }else if([self.mModel_unit.UnitType intValue]==2){
        //[{"AccountID":0,"ArtUpdate":0,"ClsName":"调班临时数据","ClsNo":"9805","GradeName":"一年级","GradeYear":2013,"ParentID":991,"SchoolType":null,"TabID":19},
        UserSumClassModel *model = [mArr_unit objectAtIndex:indexPath.row];
        cell0.mLab_name.text = model.ClsName;
        CGSize nameSize = [model.ClsName sizeWithFont:[UIFont systemFontOfSize:15]];
        cell0.mLab_name.frame = CGRectMake(cell0.mLab_name.frame.origin.x, cell0.mLab_name.frame.origin.y, nameSize.width, cell0.mLab_name.frame.size.height);
        //本地图片
        [cell0.mImgV_head setImage:[UIImage imageNamed:@"share_tableV_education"]];
        cell0.mImgV_head.frame = CGRectMake(32, 12, 24, 24);
        [cell0.mBtn_detail setImage:[UIImage imageNamed:@"share_tableV_more"] forState:UIControlStateNormal];
        cell0.mBtn_detail.frame = CGRectMake([dm getInstance].width-44-10, 0, 44, 48);
        if ([model.ArtUpdate intValue]>0) {
            cell0.mImgV_number.hidden = NO;
            cell0.mLab_number.hidden = NO;
            UIImage *img = [UIImage imageNamed:@"root_dian"];
            CGSize numSize = [model.ArtUpdate sizeWithFont:[UIFont systemFontOfSize:16]];
            cell0.mImgV_number.frame = CGRectMake(cell0.mLab_name.frame.origin.x+cell0.mLab_name.frame.size.width, (48-img.size.height)/2+2, numSize.width+5, img.size.height);
            [cell0.mImgV_number setImage:img];
            cell0.mLab_number.frame = cell0.mImgV_number.frame;
            cell0.mLab_number.text = model.ArtUpdate;
        }else{
            cell0.mImgV_number.hidden = YES;
            cell0.mLab_number.hidden = YES;
        }
    }
    
    //是否显示详情按钮
    cell0.mBtn_detail.hidden = NO;
    cell0.mImgV_open_close.hidden = YES;
    return cell0;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    return 48;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UnitSectionMessageModel *model0 = [[UnitSectionMessageModel alloc] init];
    UnitSpaceViewController *space = [[UnitSpaceViewController alloc] init];
    
    if ([self.mModel_unit.UnitType intValue] ==1) {
        UnitInfoModel *model = [mArr_unit objectAtIndex:indexPath.row];
        model0.UnitID = model.TabID;
        model0.UnitName = model.UintName;
        model0.UnitType = model.UnitType;
        space.mModel_unit = model0;
        
    }else if ([self.mModel_unit.UnitType intValue] ==2){
        UserSumClassModel *model = [mArr_unit objectAtIndex:indexPath.row];
        model0.UnitID = model.TabID;
        model0.UnitName = model.ClsName;
        model0.UnitType = @"3";
        space.mModel_unit = model0;
    }
    [utils pushViewController:space animated:YES];
}

//导航条返回按钮回调
-(void)myNavigationGoback{
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
