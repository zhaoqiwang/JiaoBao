//
//  RelatedUnitViewController.m
//  JiaoBao
//
//  Created by Zqw on 14-12-14.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "RelatedUnitViewController.h"
#import "Reachability.h"
#import "MobClick.h"

@interface RelatedUnitViewController ()

@end

@implementation RelatedUnitViewController
@synthesize mModel_unit,mTableV_list,mArr_list,mNav_navgationBar,mStr_title,mStr_UID,mLab_down,mLab_up,mScrollV_all,mTableV_down,mArr_down;

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:UMMESSAGE];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:UMMESSAGE];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
    //获取到的子单位通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MySubUnitInfo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MySubUnitInfo:) name:@"MySubUnitInfo" object:nil];
    //获取到下级单位logo
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshShowViewNew" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshShowViewNew:) name:@"refreshShowViewNew" object:nil];
}

-(id)init{
    self = [super init];
    self.mArr_list = [[NSMutableArray alloc] init];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mArr_down = [[NSMutableArray alloc] init];
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:self.mStr_title];
    //添加导航条
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    
    //scrollview大小
    self.mScrollV_all.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height);
    //上级标签
    self.mLab_up.frame = CGRectMake(0, 0, [dm getInstance].width, self.mLab_up.frame.size.height);
    //上级列表
    self.mTableV_list.frame = CGRectMake(0, self.mLab_up.frame.size.height, [dm getInstance].width, 50*self.mArr_list.count);
    //下级标签
    self.mLab_down.frame = CGRectMake(0, self.mTableV_list.frame.origin.y+self.mTableV_list.frame.size.height, [dm getInstance].width, self.mLab_down.frame.size.height);
    //下级列表
    self.mTableV_down.frame = CGRectMake(0, self.mLab_down.frame.origin.y+self.mLab_down.frame.size.height, [dm getInstance].width, 0);
    //内容大小
    self.mScrollV_all.contentSize = CGSizeMake([dm getInstance].width, self.mTableV_down.frame.origin.y+0);
    
    [self sendRequest];
}


-(void)sendRequest{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    [[ShareHttp getInstance] shareHttpGetMySubUnitInfoWith:self.mStr_UID];
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

//获取到下级单位logo
-(void)refreshShowViewNew:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    [self.mTableV_down reloadData];
}

//获取到的子单位通知
-(void)MySubUnitInfo:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSMutableDictionary *dic = noti.object;
    NSString *flag = [dic objectForKey:@"flag"];
    if ([flag integerValue]==0) {
        self.mArr_down = [dic objectForKey:@"array"];
        //下级列表
        self.mTableV_down.frame = CGRectMake(0, self.mLab_down.frame.origin.y+self.mLab_down.frame.size.height, [dm getInstance].width, 50*self.mArr_down.count);
        //内容大小
        self.mScrollV_all.contentSize = CGSizeMake([dm getInstance].width, self.mTableV_down.frame.origin.y+self.mTableV_down.frame.size.height);
        [self.mTableV_down reloadData];
    }else{
        [MBProgressHUD showError:@"超时" toView:self.view];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 1) {
        return self.mArr_list.count;
    }else if (tableView.tag == 2){
        return self.mArr_down.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellWithIdentifier = @"TopArthListCell";
    TopArthListCell *cell = (TopArthListCell *)[tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TopArthListCell" owner:self options:nil] lastObject];
        cell.frame = CGRectMake(0, 0, [dm getInstance].width, 50);
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    if (tableView.tag == 1) {
        UnitSectionMessageModel *model = [self.mArr_list objectAtIndex:indexPath.row];
        [cell.mImgV_headImg sd_setImageWithURL:(NSURL *)[NSString stringWithFormat:@"%@%@",UnitIDImg,model.UnitID] placeholderImage:[UIImage  imageNamed:@"root_img"]];
//        //文件名
//        NSString *imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",model.UnitID]];
//        UIImage *img= [UIImage imageWithContentsOfFile:imgPath];
//        if (img.size.width>0) {
//            [cell.mImgV_headImg setImage:img];
//        }else{
//            [cell.mImgV_headImg setImage:[UIImage imageNamed:@"root_img"]];
//            //获取单位logo
//            [[ShowHttp getInstance] showHttpGetUnitLogo:model.UnitID Size:@""];
//        }
        cell.mImgV_headImg.frame = CGRectMake(13, 5, 40, 40);
        //标题
        CGSize numSize = [model.UnitName sizeWithFont:[UIFont systemFontOfSize:14]];
        cell.mLab_title.frame = CGRectMake(cell.mLab_title.frame.origin.x, cell.mLab_title.frame.origin.y, [dm getInstance].width-cell.mImgV_headImg.frame.size.width-23, numSize.height*2);
        cell.mLab_title.text = model.UnitName;
    }else if (tableView.tag == 2){
        UnitInfoModel *model = [self.mArr_down objectAtIndex:indexPath.row];
        [cell.mImgV_headImg sd_setImageWithURL:(NSURL *)[NSString stringWithFormat:@"%@%@",UnitIDImg,model.TabID] placeholderImage:[UIImage  imageNamed:@"root_img"]];
//        //文件名
//        NSString *imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",model.TabID]];
//        UIImage *img= [UIImage imageWithContentsOfFile:imgPath];
//        if (img.size.width>0) {
//            [cell.mImgV_headImg setImage:img];
//        }else{
//            [cell.mImgV_headImg setImage:[UIImage imageNamed:@"root_img"]];
//            //获取单位logo
//            [[ShowHttp getInstance] showHttpGetUnitLogo:model.TabID Size:@""];
//        }
        cell.mImgV_headImg.frame = CGRectMake(13, 5, 40, 40);
        //标题
        CGSize numSize = [model.UintName sizeWithFont:[UIFont systemFontOfSize:14]];
        cell.mLab_title.frame = CGRectMake(cell.mLab_title.frame.origin.x, cell.mLab_title.frame.origin.y, [dm getInstance].width-cell.mImgV_headImg.frame.size.width-23, numSize.height*2);
        cell.mLab_title.text = model.UintName;
    }
    
    
    //姓名
    cell.mLab_name.hidden = YES;
    //时间
    cell.mLab_time.hidden = YES;
    //赞个数
    cell.mLab_likeCount.hidden = YES;
    //赞图标
    cell.mImgV_likeCount.hidden = YES;
    //阅读人数
    cell.mLab_viewCount.hidden = YES;
    //阅读图标
    cell.mImgV_viewCount.hidden = YES;
    return cell;
}
// 用于延时显示图片，以减少内存的使用
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    TopArthListCell *cell0 = (TopArthListCell *)cell;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    if (tableView.tag == 1) {
        UnitSectionMessageModel *model = [self.mArr_list objectAtIndex:indexPath.row];
        //文件名
        NSString *imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",model.UnitID]];
        UIImage *img= [UIImage imageWithContentsOfFile:imgPath];
        if (img.size.width>0) {
            [cell0.mImgV_headImg setImage:img];
        }else{
            [cell0.mImgV_headImg setImage:[UIImage imageNamed:@"root_img"]];
        }
    }else if (tableView.tag == 2){
        UnitInfoModel *model = [self.mArr_down objectAtIndex:indexPath.row];
        //文件名
        NSString *imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",model.TabID]];
        UIImage *img= [UIImage imageWithContentsOfFile:imgPath];
        if (img.size.width>0) {
            [cell0.mImgV_headImg setImage:img];
        }else{
            [cell0.mImgV_headImg setImage:[UIImage imageNamed:@"root_img"]];
        }
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag == 1){
        UnitSectionMessageModel *model = [self.mArr_list objectAtIndex:indexPath.row];
        UnitSpaceViewController *space = [[UnitSpaceViewController alloc] init];
        space.mModel_unit = model;
        [utils pushViewController:space animated:YES];
    }else if (tableView.tag == 2){
        UnitInfoModel *tempModel = [self.mArr_down objectAtIndex:indexPath.row];
        UnitSectionMessageModel *model = [[UnitSectionMessageModel alloc] init];
        model.UnitID = tempModel.TabID;
        model.UnitName = tempModel.UintName;
        model.UnitType = tempModel.UnitType;
        UnitSpaceViewController *space = [[UnitSpaceViewController alloc] init];
        space.mModel_unit = model;
        [utils pushViewController:space animated:YES];
    }
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
