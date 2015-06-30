//
//  UnitPeopleViewController.m
//  JiaoBao
//
//  Created by Zqw on 14-12-14.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "UnitPeopleViewController.h"
#import "AppDelegate.h"
#import "Reachability.h"

@interface UnitPeopleViewController ()

@end

@implementation UnitPeopleViewController
@synthesize mNav_navgationBar,mTableV_list,mArr_list,mModel_unit,mInt_index,mArr_sum;

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
    //单位分组的请求
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UnitPeopleGroupList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UnitPeopleGroupList:) name:@"UnitPeopleGroupList" object:nil];
    //分组人员的请求
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UnitPeoplePeopleList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UnitPeoplePeopleList:) name:@"UnitPeoplePeopleList" object:nil];
    //获得头像后，刷新界面
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"exchangeGetFaceImg" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exchangeGetFaceImg:) name:@"exchangeGetFaceImg" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mArr_list = [NSMutableArray array];
    self.mArr_sum = [NSMutableArray array];
    D("self.mlst-===%lu",(unsigned long)[dm getInstance].mArr_unit_member.count);
    [self sendRequest];
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:self.mModel_unit.UnitName];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    
    self.mTableV_list.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height-[dm getInstance].statusBar, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height+[dm getInstance].statusBar);
}

-(void)sendRequest{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    //如果人员为空，则重新获取
    if (self.mArr_list.count == 0) {
        //发送获取当前单位分组的请求
        if ([self.mModel_unit.UnitType intValue]== 3) {
            [[ExchangeHttp getInstance] exchangeHttpGetUnitGroupsWith:[NSString stringWithFormat:@"-%@",self.mModel_unit.UnitID] from:@"1"];
            //        }else if ([self.mModel_unit.UnitType intValue] ==2){
        }else{
            [[ExchangeHttp getInstance] exchangeHttpGetUnitGroupsWith:self.mModel_unit.UnitID from:@"1"];
        }
        
        [MBProgressHUD showMessage:@"" toView:self.view];
    }
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

//获得头像后，刷新界面
-(void)exchangeGetFaceImg:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    [self.mTableV_list reloadData];
}

//单位分组的请求
-(void)UnitPeopleGroupList:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSMutableDictionary *dic = noti.object;
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
    NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];

    if([ResultCode integerValue]!= 0)
    {
        [MBProgressHUD showError:ResultDesc toView:self.view];
        return;
    }
    NSString *uid = [dic objectForKey:@"UID"];
    NSMutableArray *arr = [dic objectForKey:@"array"];
    //对分组名字进行排序
    NSArray *array = [self userNameChineseSort:arr Flag:2];
    //获取到分组后，获取单位中的人
    [[ExchangeHttp getInstance] exchangeHttpGetUserUnfoByUnitIDWith:uid filter:@"0" from:@"1"];
    for (int i=0; i<array.count; i++) {
        ExchangeUnitGroupsModel *model = [array objectAtIndex:i];
        D("ExchangeUnitGroupsModel-===%@",model.GroupID);
        TreeView_node *node7 = [[TreeView_node alloc]init];
        node7.nodeLevel = 1;
        node7.type = 1;
        node7.sonNodes = nil;
        node7.isExpanded = YES;
        node7.UID = model.GroupID;
        node7.readflag = self.mInt_index;
        self.mInt_index ++;
        TreeView_Level1_Model *temp7 =[[TreeView_Level1_Model alloc]init];
        temp7.mStr_name = model.GroupName;
        temp7.mStr_img_open_close = @"root_close";
        temp7.mInt_number = 0;
        node7.nodeData = temp7;
        [self.mArr_sum addObject:node7];
    }
}

//分组人员的请求
-(void)UnitPeoplePeopleList:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSMutableDictionary *dic = noti.object;
    NSString *uid = [dic objectForKey:@"UID"];
    NSMutableArray *arr = [dic objectForKey:@"array"];
    
    NSArray *array = [self userNameChineseSort:arr Flag:1];
    
    for (int a= 0; a<self.mArr_sum.count; a++) {//循环所有的单位
        TreeView_node *node0 = [self.mArr_sum objectAtIndex:a];
        D("NSMutableArray..lnodel-===%@,%@",node0.UID,uid);
//        if ([node0.UID intValue] == [uid intValue]) {//找到单位和通知里一样的
            NSMutableArray *tempArr = [NSMutableArray array];
            for (int n = 0; n<array.count; n++) {//循环通知里面的所有人员信息
                UserInfoByUnitIDModel *userModel = [array objectAtIndex:n];
                for (int b = 0; b<userModel.GroupFlag.count; b++) {//循环当前的人员中，有几个分组
                    if ([node0.UID isEqual:[userModel.GroupFlag objectAtIndex:b]]) {
                        TreeView_node *node7 = [[TreeView_node alloc]init];
                        node7.nodeLevel = 2;
                        node7.type = 2;
                        node7.sonNodes = nil;
                        node7.isExpanded = YES;
                        node7.UID = userModel.UserID;
                        node7.readflag = self.mInt_index;
                        self.mInt_index ++;
                        TreeView_Level2_Model *temp =[[TreeView_Level2_Model alloc]init];
                        temp.mStr_name = userModel.UserName;
                        temp.mStr_headImg = @"root_img";
                        temp.mStr_JiaoBaoHao = userModel.AccID;
                        node7.nodeData = temp;
                        [tempArr addObject:node7];
                    }
                }
            }
            node0.sonNodes = [NSMutableArray arrayWithArray:tempArr];
//        }
    }
    [self reloadDataForDisplayArray];
}

//对人员1和分组2进行排序，
-(NSMutableArray *)userNameChineseSort:(NSMutableArray *)array Flag:(int)flag{
    //Step2:获取字符串中文字的拼音首字母并与字符串共同存放
    NSMutableArray *chineseStringsArray=[NSMutableArray array];
    for(int i=0;i<[array count];i++){
        ChineseString *chineseString=[[ChineseString alloc]init];
        if (flag == 1) {
            UserInfoByUnitIDModel *model = [array objectAtIndex:i];
            chineseString.string=[NSString stringWithString:model.UserName];
            chineseString.userModel = model;
        }else if (flag == 2){
            ExchangeUnitGroupsModel *model = [array objectAtIndex:i];
            chineseString.string=[NSString stringWithString:model.GroupName];
            chineseString.groupModel = model;
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
            UserInfoByUnitIDModel *tempModel = ((ChineseString*)[chineseStringsArray objectAtIndex:i]).userModel;
            [result addObject:tempModel];
        }else if (flag == 2){
            ExchangeUnitGroupsModel *tempModel = ((ChineseString*)[chineseStringsArray objectAtIndex:i]).groupModel;
            [result addObject:tempModel];
        }
    }
    
    return result;
}


-(void) reloadDataForDisplayArray{
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    for (TreeView_node *node in self.mArr_sum) {
        [tmp addObject:node];
        if (node.isExpanded) {
            for(TreeView_node *node2 in node.sonNodes){
                [tmp addObject:node2];
            }
        }
    }
    self.mArr_list = [NSMutableArray arrayWithArray:tmp];
    [self.mTableV_list reloadData];
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mArr_list.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"TreeView_Level0_Cell";
    static NSString *indentifier1 = @"TreeView_Level1_Cell";
    static NSString *indentifier2 = @"TreeView_Level2_Cell";
    TreeView_node *node = [self.mArr_list objectAtIndex:indexPath.row];
    if(node.type == 0){//类型为0的cell
        TreeView_Level0_Cell *cell = (TreeView_Level0_Cell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TreeView_Level0_Cell" owner:self options:nil] lastObject];
            cell.frame = CGRectMake(0, 0, [dm getInstance].width, 48);
        }
        //        cell.delegate = self;
        cell.mNode = node;
        cell.tag = [node.UID intValue];
        [self loadDataForTreeViewCell:cell with:node];//重新给cell装载数据
        [cell setNeedsDisplay]; //重新描绘cell
        
        return cell;
    }else if(node.type == 1){//类型为1的cell
        TreeView_Level1_Cell *cell = (TreeView_Level1_Cell *)[tableView dequeueReusableCellWithIdentifier:indentifier1];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TreeView_Level1_Cell" owner:self options:nil] lastObject];
            cell.frame = CGRectMake(0, 0, [dm getInstance].width, 32);
        }
        cell.mNode = node;
        cell.tag = [node.UID intValue];
        [self loadDataForTreeViewCell:cell with:node];
        [cell setNeedsDisplay];
        return cell;
    }else{//类型为2的cell
        TreeView_Level2_Cell *cell = (TreeView_Level2_Cell *)[tableView dequeueReusableCellWithIdentifier:indentifier2];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TreeView_Level2_Cell" owner:self options:nil] lastObject];
            cell.frame = CGRectMake(0, 0, [dm getInstance].width, 40);
        }
        cell.mNode = node;
        cell.delegate = self;
        [cell headImgClick];
        cell.tag = [node.UID intValue];
        [self loadDataForTreeViewCell:cell with:node];
        [cell setNeedsDisplay];
        return cell;
    }
    return nil;
}
/*---------------------------------------
 为不同类型cell填充数据
 --------------------------------------- */
-(void) loadDataForTreeViewCell:(UITableViewCell*)cell with:(TreeView_node*)node{
    if(node.type == 0){
        TreeView_Level0_Cell *cell0 = (TreeView_Level0_Cell*)cell;
        TreeView_Level0_Model *nodeData = node.nodeData;
        cell0.mLab_name.text = nodeData.mStr_name;
        //本地图片
        [cell0.mImgV_head setImage:[UIImage imageNamed:nodeData.mStr_headImg]];
        cell0.mImgV_head.frame = CGRectMake(32, 8, 32, 32);
        [cell0.mBtn_detail setImage:[UIImage imageNamed:nodeData.mStr_img_detail] forState:UIControlStateNormal];
        cell0.mBtn_detail.frame = CGRectMake([dm getInstance].width-44-10, 0, 44, 48);
        cell0.mBtn_detail.tag = node.readflag;
        if (node.isExpanded) {
            [cell0.mImgV_open_close setImage:[UIImage imageNamed:@"root_open"]];
        } else {
            [cell0.mImgV_open_close setImage:[UIImage imageNamed:nodeData.mStr_img_open_close]];
        }
        //定位
        CGSize nameSize = [nodeData.mStr_name sizeWithFont:[UIFont systemFontOfSize:15]];
        cell0.mLab_name.frame = CGRectMake(cell0.mLab_name.frame.origin.x, cell0.mLab_name.frame.origin.y, nameSize.width, cell0.mLab_name.frame.size.height);
        if (nodeData.mInt_number>0) {
            cell0.mImgV_number.hidden = NO;
            cell0.mLab_number.hidden = NO;
            UIImage *img = [UIImage imageNamed:@"root_dian"];
            CGSize numSize = [[NSString stringWithFormat:@"%d",nodeData.mInt_number] sizeWithFont:[UIFont systemFontOfSize:16]];
            cell0.mImgV_number.frame = CGRectMake(cell0.mLab_name.frame.origin.x+cell0.mLab_name.frame.size.width, (48-img.size.height)/2+2, numSize.width+5, img.size.height);
            [cell0.mImgV_number setImage:img];
            cell0.mLab_number.frame = cell0.mImgV_number.frame;
            cell0.mLab_number.text = [NSString stringWithFormat:@"%d",nodeData.mInt_number];
        }else{
            cell0.mImgV_number.hidden = YES;
            cell0.mLab_number.hidden = YES;
        }
        //是否显示详情按钮
        cell0.mBtn_detail.hidden = YES;
        if (nodeData.mInt_show == 1) {
            cell0.mImgV_open_close.hidden = NO;
        }else{
            cell0.mImgV_open_close.hidden = YES;
        }
    }
    
    else if(node.type == 1){
        TreeView_Level1_Cell *cell1 = (TreeView_Level1_Cell*)cell;
        TreeView_Level1_Model *nodeData = node.nodeData;
        cell1.mLab_name.text = nodeData.mStr_name;
        [cell1.mBtn_detail setImage:[UIImage imageNamed:nodeData.mStr_img_detail] forState:UIControlStateNormal];
        cell1.mBtn_detail.frame = CGRectMake([dm getInstance].width-44-10, 0, 44, 32);
        cell1.mBtn_detail.tag = node.readflag;
        if (node.isExpanded) {
            [cell1.mImgV_open_close setImage:[UIImage imageNamed:@"root_open"]];
        } else {
            [cell1.mImgV_open_close setImage:[UIImage imageNamed:nodeData.mStr_img_open_close]];
        }
        //定位
        CGSize nameSize = [nodeData.mStr_name sizeWithFont:[UIFont systemFontOfSize:15]];
        cell1.mLab_name.frame = CGRectMake(cell1.mLab_name.frame.origin.x, cell1.mLab_name.frame.origin.y, nameSize.width, cell1.mLab_name.frame.size.height);
        if (nodeData.mInt_number>0) {
            cell1.mImgV_number.hidden = NO;
            cell1.mLab_number.hidden = NO;
            UIImage *img = [UIImage imageNamed:@"root_dian"];
            CGSize numSize = [[NSString stringWithFormat:@"%d",nodeData.mInt_number] sizeWithFont:[UIFont systemFontOfSize:16]];
            cell1.mImgV_number.frame = CGRectMake(cell1.mLab_name.frame.origin.x+cell1.mLab_name.frame.size.width, (32-img.size.height)/2, numSize.width+5, img.size.height);
            [cell1.mImgV_number setImage:img];
            cell1.mLab_number.frame = cell1.mImgV_number.frame;
            cell1.mLab_number.text = [NSString stringWithFormat:@"%d",nodeData.mInt_number];
        }else{
            cell1.mImgV_number.hidden = YES;
            cell1.mLab_number.hidden = YES;
        }
    }else{
        TreeView_Level2_Cell *cell2 = (TreeView_Level2_Cell*)cell;
        TreeView_Level2_Model *nodeData = node.nodeData;
        if ([nodeData.mStr_JiaoBaoHao intValue]>0) {
            cell2.mLab_name.text = nodeData.mStr_name;
        }else{
            cell2.mLab_name.text = [NSString stringWithFormat:@"%@(暂未开通空间)",nodeData.mStr_name];
        }
        
        cell2.mLab_name.textColor = [UIColor blackColor];
        cell2.mLab_detail.hidden = YES;
        cell2.mLab_time.hidden = YES;
        cell2.mImgV_head.frame = CGRectMake(35, 3, 34, 34);
        cell2.mLab_name.frame = CGRectMake(cell2.mImgV_head.frame.origin.x+40, 0, [dm getInstance].width-cell2.mLab_name.frame.origin.x, 40);
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        //文件名
        NSString *imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",nodeData.mStr_JiaoBaoHao]];
        UIImage *img= [UIImage imageWithContentsOfFile:imgPath];
        if (img.size.width>0) {
            [cell2.mImgV_head setImage:img];
        }else{
            [cell2.mImgV_head setImage:[UIImage imageNamed:nodeData.mStr_headImg]];
            //获取头像
            [[ExchangeHttp getInstance] getUserInfoFace:nodeData.mStr_JiaoBaoHao];
        }
    }
}

// 用于延时显示图片，以减少内存的使用
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    TreeView_node *node = [self.mArr_list objectAtIndex:indexPath.row];
    if(node.type == 0){//类型为0的cell
        
    }else if(node.type == 1){//类型为1的cell
        
    }else{//类型为2的cell
        TreeView_Level2_Cell *cell2 = (TreeView_Level2_Cell*)cell;
        TreeView_Level2_Model *nodeData = node.nodeData;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        //文件名
        NSString *imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",nodeData.mStr_JiaoBaoHao]];
        UIImage *img= [UIImage imageWithContentsOfFile:imgPath];
        if (img.size.width>0) {
            [cell2.mImgV_head setImage:img];
        }else{
            [cell2.mImgV_head setImage:[UIImage imageNamed:nodeData.mStr_headImg]];
        }
    }
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    TreeView_node *node = [self.mArr_list objectAtIndex:indexPath.row];
    if(node.type == 0){//类型为0的cell
        return 48;
    }else if(node.type == 1){//类型为1的cell
        return 32;
    }else if(node.type == 2){//类型为2的cell
        return 40;
    }
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TreeView_node *node = [self.mArr_list objectAtIndex:indexPath.row];
    TreeView_Level2_Model *model = node.nodeData;
    if(node.type == 2){
        if ([model.mStr_JiaoBaoHao intValue]>0) {
            //生成个人信息
            UserInfoByUnitIDModel *userModel = [[UserInfoByUnitIDModel alloc] init];
            userModel.UserID = model.mStr_JiaoBaoHao;
            userModel.UserName = model.mStr_name;
            userModel.AccID = model.mStr_JiaoBaoHao;
            
            PersonalSpaceViewController *personal = [[PersonalSpaceViewController alloc] init];
            personal.mModel_personal = userModel;
            [utils pushViewController:personal animated:YES];
        }else{
            [MBProgressHUD showError:@"暂时没有开通个人空间" toView:self.view];
        }
    }else if(node.type == 1){//类型为1的cell
        [self reloadDataForDisplayArrayChangeAt:node.readflag];//修改cell的状态(关闭或打开)
    }
}

/*---------------------------------------
 修改cell的状态(关闭或打开)
 --------------------------------------- */
-(void) reloadDataForDisplayArrayChangeAt:(NSInteger)row{
    for (TreeView_node *node in self.mArr_sum) {
        if(node.readflag == row){
            node.isExpanded = !node.isExpanded;
        }
        for(TreeView_node *node2 in node.sonNodes){
            if(node2.readflag == row){
                node2.isExpanded = !node2.isExpanded;
            }
        }
    }
    [self reloadDataForDisplayArray];
}

//cell2中，点击头像
-(void)TreeView_Level2_CellTapPress:(TreeView_Level2_Cell *)TreeCell2{
    TreeView_node *node = TreeCell2.mNode;
    TreeView_Level2_Model *model = node.nodeData;
    //生成个人信息
    UserInfoByUnitIDModel *userModel = [[UserInfoByUnitIDModel alloc] init];
    userModel.UserID = model.mStr_JiaoBaoHao;
    userModel.UserName = model.mStr_name;
    userModel.AccID = model.mStr_JiaoBaoHao;
    
    PersonalSpaceViewController *personal = [[PersonalSpaceViewController alloc] init];
    personal.mModel_personal = userModel;
    [utils pushViewController:personal animated:YES];
}

//导航条返回按钮回调
-(void)myNavigationGoback{
    [utils popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
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
