//
//  SubUnitInfoViewController.m
//  JiaoBao
//
//  Created by Zqw on 14-11-22.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "SubUnitInfoViewController.h"
#import "Reachability.h"
#import <UMAnalytics/MobClick.h>
@interface SubUnitInfoViewController ()

@end

@implementation SubUnitInfoViewController
@synthesize mNav_navgationBar,mArr_unit,mTableV_unit,mInt_section,mModel_unit;


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:UMMESSAGE];
    [MobClick endLogPageView:UMPAGE];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:UMMESSAGE];
    [MobClick beginLogPageView:UMPAGE];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
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
    
    self.mArr_unit = [NSMutableArray array];
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:self.mModel_unit.UnitName];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    
    self.mTableV_unit.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height-[dm getInstance].statusBar, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height+[dm getInstance].statusBar);
    
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
    [MBProgressHUD showMessage:@"" toView:self.view];
}

//检查当前网络是否可用
-(BOOL)checkNetWork{
    if([Reachability isEnableNetwork]==NO){
        [MBProgressHUD showError:NETWORKENABLE toView:self.view];
        return YES;
    }else{
        return NO;
    }
}

//获取到关联单位和所有单位
-(void)getUnitClassShow:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSMutableDictionary *dic = noti.object;
    NSString *flag = [dic objectForKey:@"flag"];
    if ([flag integerValue]==0) {
        int index = [[dic objectForKey:@"index"] intValue];
        if (index == 1) {//关联的班级
        } else {//所有班级
            NSMutableArray *temp = [dic objectForKey:@"array"];
            self.mArr_unit = [self userNameChineseSort:temp Flag:2];
            [self.mTableV_unit reloadData];
        }
    }else{
        [MBProgressHUD showError:@"超时" toView:self.view];
    }
}

//获取到的子单位通知
-(void)MySubUnitInfo:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSMutableDictionary *dic = noti.object;
    NSString *flag = [dic objectForKey:@"flag"];
    if ([flag integerValue]==0) {
        NSMutableArray *temp = [dic objectForKey:@"array"];
        self.mArr_unit = [self userNameChineseSort:temp Flag:1];
        [self.mTableV_unit reloadData];
    }else{
        [MBProgressHUD showError:@"超时" toView:self.view];
    }
}

//对人员1和分组2进行排序，
-(NSMutableArray *)userNameChineseSort:(NSMutableArray *)array Flag:(int)flag{
    //Step2:获取字符串中文字的拼音首字母并与字符串共同存放
    NSMutableArray *chineseStringsArray=[NSMutableArray array];
    for(int i=0;i<[array count];i++){
        ChineseString *chineseString=[[ChineseString alloc]init];
        if (flag == 1) {
            UnitInfoModel *model = [array objectAtIndex:i];
            chineseString.string=[NSString stringWithString:model.UintName];
            chineseString.unitInfoModel = model;
        }else if (flag == 2){
            UserSumClassModel *model = [array objectAtIndex:i];
            chineseString.string=[NSString stringWithString:model.ClsName];
            chineseString.userSumClassModel = model;
        }
        
        if(chineseString.string==nil){
            chineseString.string=@"";
        }
        
        if(![chineseString.string isEqualToString:@""]){
            NSString *pinYinResult=[NSString string];
            for(int j=0;j<chineseString.string.length;j++){
                NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([chineseString.string characterAtIndex:j])]uppercaseString];
                pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            chineseString.pinYin=pinYinResult;
        }else{
            chineseString.pinYin=@"";
        }
        [chineseStringsArray addObject:chineseString];
    }
    
    //Step3:按照拼音首字母对这些Strings进行排序
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    // Step4:如果有需要，再把排序好的内容从ChineseString类中提取出来
    NSMutableArray *result=[NSMutableArray array];
    for(int i=0;i<[chineseStringsArray count];i++){
        if (flag == 1) {
            UnitInfoModel *tempModel = ((ChineseString*)[chineseStringsArray objectAtIndex:i]).unitInfoModel;
            [result addObject:tempModel];
        }else if (flag == 2){
            UserSumClassModel *tempModel = ((ChineseString*)[chineseStringsArray objectAtIndex:i]).userSumClassModel;
            [result addObject:tempModel];
        }
    }
    
    return result;
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mArr_unit.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"TreeView_Level0_Cell";
    TreeView_Level0_Cell *cell0 = (TreeView_Level0_Cell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell0 == nil) {
        cell0 = [[TreeView_Level0_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TreeView_Level0_Cell" owner:self options:nil];
        //这时myCell对象已经通过自定义xib文件生成了
        if ([nib count]>0) {
            cell0 = (TreeView_Level0_Cell *)[nib objectAtIndex:0];
            //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
        }
        //添加图片点击事件
        //若是需要重用，需要写上以下两句代码
        UINib * n= [UINib nibWithNibName:@"TreeView_Level0_Cell" bundle:[NSBundle mainBundle]];
        [self.mTableV_unit registerNib:n forCellReuseIdentifier:indentifier];
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
