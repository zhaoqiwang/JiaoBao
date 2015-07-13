//
//  UnitAlbumsViewController.m
//  JiaoBao
//
//  Created by Zqw on 14-12-19.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "UnitAlbumsViewController.h"
#import "ShareCollectionViewCell.h"
#import "Reachability.h"
#import "MobClick.h"

static NSString *UnitAlbums = @"ShareCollectionViewCell";

@interface UnitAlbumsViewController ()

@end

@implementation UnitAlbumsViewController
@synthesize mArr_list,mCollectionV_albums,mNav_navgationBar,mModel_unit,mStr_flag,mModel_personal,mArr_myselfAlbums;

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    
    //获取单位相册后，通知界面
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetUnitPGroup" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetUnitPGroup:) name:@"GetUnitPGroup" object:nil];
    //获取到个人相册后
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetPhotoList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetPhotoList:) name:@"GetPhotoList" object:nil];
    //获取单位相册的第一张照片后，通知界面
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetUnitFristPhotoByGroup" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetUnitFristPhotoByGroup:) name:@"GetUnitFristPhotoByGroup" object:nil];
    //获取个人相册的第一张照片后，通知界面
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetFristPhotoByGroup" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetFristPhotoByGroup:) name:@"GetFristPhotoByGroup" object:nil];
    
    self.mArr_list = [NSMutableArray array];
    self.mArr_myselfAlbums = [NSMutableArray array];
    
    NSString *title;
    if ([self.mStr_flag intValue] == 1) {
        title = [NSString stringWithFormat:@"%@[相簿]",self.mModel_personal.UserName];
    }else{
        title = [NSString stringWithFormat:@"%@[相簿]",self.mModel_unit.UnitName];
    }
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:title];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    
    //collectionview,单位列表
    self.mCollectionV_albums.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height-[dm getInstance].statusBar, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height+[dm getInstance].statusBar);
    self.mCollectionV_albums.backgroundColor = [UIColor whiteColor];
    [self.mCollectionV_albums registerClass:[ShareCollectionViewCell class] forCellWithReuseIdentifier:UnitAlbums];
    //发送请求
    [self sendRequest];
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

//获取个人相册的第一张照片后，通知界面
-(void)GetFristPhotoByGroup:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSDictionary *dic = noti.object;
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
//    NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
    
    if([ResultCode integerValue]!=0)
    {
//        [MBProgressHUD showError:ResultDesc toView:self.view];
        return;
    }
    NSString *str = [dic objectForKey:@"groupID"];
    NSMutableArray *array = [dic objectForKey:@"array"];
    for (int i=0; i<self.mArr_list.count; i++) {
        PersonPhotoModel *model = [self.mArr_list objectAtIndex:i];
        D("GetUnitFristPhotoByGroup-===%@,%@,%lu",str,model.ID,(unsigned long)array.count);
        if ([model.ID isEqual:str]) {
            if (array.count>0) {
                UnitAlbumsListModel *model1 = [array objectAtIndex:0];
                model.SMPhotoPath = model1.SMPhotoPath;
                break;
            }
        }
    }
    [self.mCollectionV_albums reloadData];
}

//获取单位相册的第一张照片后，通知界面
-(void)GetUnitFristPhotoByGroup:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSDictionary *dic = noti.object;
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
//    NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
    
    if([ResultCode integerValue]!=0)
    {
//        [MBProgressHUD showError:ResultDesc toView:self.view];
        return;
    }
    NSString *str = [dic objectForKey:@"groupID"];
    NSMutableArray *array = [dic objectForKey:@"array"];
    for (int i=0; i<self.mArr_list.count; i++) {
        UnitAlbumsModel *model = [self.mArr_list objectAtIndex:i];
        if ([model.TabID isEqual:str]) {
            if (array.count>0) {
                UnitAlbumsListModel *model1 = [array objectAtIndex:0];
                model.fristPhoto = model1.SMPhotoPath;
                break;
            }
        }
    }
    [self.mCollectionV_albums reloadData];
}

//获取到个人相册后
-(void)GetPhotoList:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSDictionary *dic = noti.object;
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
//    NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
    
    if([ResultCode integerValue]!=0)
    {
//        [MBProgressHUD showError:ResultDesc toView:self.view];
        return;
    }
    NSMutableArray *array = [dic objectForKey:@"array"];
    [self.mArr_list removeAllObjects];
    self.mArr_list = [NSMutableArray arrayWithArray:array];
    D("self.mInt_flag-===%@",self.mStr_flag);
    for (int i=0; i<self.mArr_list.count; i++) {
        PersonPhotoModel *model = [self.mArr_list objectAtIndex:i];
        [[ThemeHttp getInstance] themeHttpGetFristPhotoByGroup:self.mModel_personal.AccID GroupInfo:model.ID];
    }
    //区分是否本人的空间
    if ([self.mModel_personal.AccID integerValue] ==[[dm getInstance].jiaoBaoHao integerValue]) {
        [self.mNav_navgationBar setRightBtnTitle:@"更多"];
        self.mArr_myselfAlbums = [NSMutableArray arrayWithArray:self.mArr_list];
    }
    [self.mCollectionV_albums reloadData];
}

//获取单位相册后，通知界面
-(void)GetUnitPGroup:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSDictionary *dic = noti.object;
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
//    NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
    
    if([ResultCode integerValue]!=0)
    {
        [MBProgressHUD showError:@"数据错误或没有相册" toView:self.view];
        return;
    }
    NSMutableArray *array = [dic objectForKey:@"array"];
    [self.mArr_list removeAllObjects];
    self.mArr_list = [NSMutableArray arrayWithArray:array];
    [self.mArr_myselfAlbums removeAllObjects];
    D("self.mInt_flag-===%@",self.mStr_flag);
    for (int i=0; i<self.mArr_list.count; i++) {
        UnitAlbumsModel *model = [self.mArr_list objectAtIndex:i];
        D("CreateByjiaobaohao-====%@,%@",model.CreateByjiaobaohao,[dm getInstance].jiaoBaoHao);
        if ([model.CreateByjiaobaohao intValue] == [[dm getInstance].jiaoBaoHao intValue]) {
            [self.mArr_myselfAlbums addObject:model];
        }
        [[ThemeHttp getInstance] themeHttpGetUnitFristPhotoByGroup:model.UnitID GroupID:model.TabID];
    }
    //判断自己是否在当前这个单位中
    int a=0;
    for (int i=0; i<[dm getInstance].identity.count; i++) {
        Identity_model *idenModel = [[dm getInstance].identity objectAtIndex:i];
        if (i==0||i==1) {
            NSMutableArray *array ;
            array = [NSMutableArray arrayWithArray:idenModel.UserUnits];
            for (int m=0; m<array.count; m++) {
                Identity_UserUnits_model *userUnitsModel = [array objectAtIndex:m];
                if ([userUnitsModel.UnitID intValue] == [self.mModel_unit.UnitID intValue]) {
                    a++;
                }
            }
        }else if(i==2||i==3){
            NSMutableArray *array ;
            array = [NSMutableArray arrayWithArray:idenModel.UserClasses];
            for (int m=0; m<array.count; m++) {
                Identity_UserClasses_model *userUnitsModel = [array objectAtIndex:m];
                if ([userUnitsModel.ClassID intValue]==[self.mModel_unit.UnitID intValue]) {
                    a++;
                }
            }
        }
    }
    if (a>0) {
        [self.mNav_navgationBar setRightBtnTitle:@"更多"];
    }
    [self.mCollectionV_albums reloadData];
}

//发送请求
-(void)sendRequest{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    if ([self.mStr_flag intValue] == 1) {
        if ([self.mModel_unit.UnitType intValue]== 3) {
            [[ThemeHttp getInstance] themeHttpGetPhotoList:[NSString stringWithFormat:@"-%@",self.mModel_unit.UnitID]];
        }else {
            [[ThemeHttp getInstance] themeHttpGetPhotoList:self.mModel_personal.AccID];
        }
    }else{
        if ([self.mModel_unit.UnitType intValue]== 3) {
            [[ThemeHttp getInstance] themeHttpGetUnitPGroup:[NSString stringWithFormat:@"-%@",self.mModel_unit.UnitID]];
        }else {
            [[ThemeHttp getInstance] themeHttpGetUnitPGroup:self.mModel_unit.UnitID];
        }
    }
    [MBProgressHUD showMessage:@"" toView:self.view];
}

-(void)CreatePhotoGroupSuccess{
    [self sendRequest];
}
-(void)UpLoadPhotoSuccess{
    [self sendRequest];
}

#pragma mark - Collection View Data Source
//每一组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section{
    D("self.mArr_list.count-===%lu",(unsigned long)self.mArr_list.count);
    return self.mArr_list.count;
}
//定义并返回每个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ShareCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:UnitAlbums forIndexPath:indexPath];
    if (!cell) {
        
    }
    if ([self.mStr_flag intValue] == 1) {
        PersonPhotoModel *model = [self.mArr_list objectAtIndex:indexPath.row];
        [cell.mImgV_background sd_setImageWithURL:[NSURL  URLWithString:model.SMPhotoPath] placeholderImage:[UIImage  imageNamed:@"photo_default"]];
        //标题
        cell.mLab_name.text = model.GroupName;
        CGSize size = [model.GroupName sizeWithFont:[UIFont systemFontOfSize:12]];
        cell.mLab_name.frame = CGRectMake(0, 60, ([dm getInstance].width-50)/3, size.height);
    }else{
        UnitAlbumsModel *model = [self.mArr_list objectAtIndex:indexPath.row];
        [cell.mImgV_background sd_setImageWithURL:[NSURL  URLWithString:model.fristPhoto] placeholderImage:[UIImage  imageNamed:@"photo_default"]];
        //标题
        cell.mLab_name.text = model.nameStr;
        CGSize size = [model.nameStr sizeWithFont:[UIFont systemFontOfSize:12]];
        cell.mLab_name.frame = CGRectMake(0, 60, ([dm getInstance].width-50)/3, size.height);
    }
    //文章个数
    cell.mImgV_red.hidden = YES;
    cell.mLab_count.hidden = YES;
    cell.mImgV_background.frame = CGRectMake((([dm getInstance].width-50)/3-([dm getInstance].width-50)/3)/2, 0, ([dm getInstance].width-50)/3, 60);
    cell.mImgV_background.contentMode = UIViewContentModeScaleAspectFit;
    cell.mLab_name.font = [UIFont systemFontOfSize:12];
    cell.mLab_name.textAlignment = NSTextAlignmentCenter;
    
    return cell;
}

//设置每组的cell的边界
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UnintAlbumsListViewController *albums = [[UnintAlbumsListViewController alloc] init];
    if ([self.mStr_flag intValue] == 1) {
        [MobClick event:@"UnitAlbums_didSelectItem" label:@"个人相簿"];
        PersonPhotoModel *model = [self.mArr_list objectAtIndex:indexPath.row];
        model.accid = self.mModel_personal.AccID;
        albums.mStr_flag = @"1";
        albums.mModel_person = model;
    }else{
        [MobClick event:@"UnitAlbums_didSelectItem" label:@"单位相簿"];
        UnitAlbumsModel *model = [self.mArr_list objectAtIndex:indexPath.row];
        albums.mModel_albums = model;
        albums.mStr_flag = @"2";
    }
    
    [utils pushViewController:albums animated:YES];
}
//每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(([dm getInstance].width-50)/3, 80);
}

//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

//导航条返回按钮回调
-(void)myNavigationGoback{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [utils popViewControllerAnimated:YES];
}
-(void)navigationRightAction:(UIButton *)sender{
    if ([self.mStr_flag intValue] == 1) {
        if ([self.mModel_personal.AccID integerValue]==[[dm getInstance].jiaoBaoHao integerValue]) {
            UIActionSheet * action = [[UIActionSheet alloc] initWithTitle:@"更多" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"创建相册",@"上传照片",nil];
            action.tag = 2;
            [action showInView:self.view.superview];
        }
    }else{
        //判断自己是否在当前这个单位中
        int a=0;
        for (int i=0; i<[dm getInstance].identity.count; i++) {
            Identity_model *idenModel = [[dm getInstance].identity objectAtIndex:i];
            if (i==0||i==1) {
                NSMutableArray *array ;
                array = [NSMutableArray arrayWithArray:idenModel.UserUnits];
                for (int m=0; m<array.count; m++) {
                    Identity_UserUnits_model *userUnitsModel = [array objectAtIndex:m];
                    if ([userUnitsModel.UnitID intValue] == [self.mModel_unit.UnitID intValue]) {
                        a++;
                    }
                }
            }else if(i==2||i==3){
                NSMutableArray *array ;
                array = [NSMutableArray arrayWithArray:idenModel.UserClasses];
                for (int m=0; m<array.count; m++) {
                    Identity_UserClasses_model *userUnitsModel = [array objectAtIndex:m];
                    if ([userUnitsModel.ClassID intValue]==[self.mModel_unit.UnitID intValue]) {
                        a++;
                    }
                }
            }
        }
        //a大于0，则自己在这个单位中
        if (a>0&&self.mArr_myselfAlbums.count>0) {
            UIActionSheet * action = [[UIActionSheet alloc] initWithTitle:@"更多" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"创建相册",@"上传照片",nil];
            action.tag = 1;
            [action showInView:self.view.superview];
        }else if(a>0){
            UIActionSheet * action = [[UIActionSheet alloc] initWithTitle:@"更多" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"创建相册",nil];
            action.tag = 3;
            [action showInView:self.view.superview];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UpLoadPhotoViewController *uploadV = [[UpLoadPhotoViewController alloc] init];
    uploadV.delegate = self;
    CreatAlbumsViewController *creatV = [[CreatAlbumsViewController alloc] init];
    creatV.delegate = self;
    if (actionSheet.tag == 1) {//单位
        if (buttonIndex == 0) {//创建相册
            creatV.mStr_flag = @"2";
            creatV.mStr_unitID = self.mModel_unit.UnitID;
            [utils pushViewController:creatV animated:YES];
        }else if (buttonIndex == 1){//上传照片
            uploadV.mStr_flag = @"2";
            uploadV.mArr_albums = [NSMutableArray arrayWithArray:self.mArr_myselfAlbums];
            [utils pushViewController:uploadV animated:YES];
        }
    }else if (actionSheet.tag == 3){//单位
        if (buttonIndex == 0) {//创建相册
            creatV.mStr_flag = @"2";
            creatV.mStr_unitID = self.mModel_unit.UnitID;
            [utils pushViewController:creatV animated:YES];
        }
    }else if (actionSheet.tag == 2){//个人
        if (buttonIndex == 0) {//创建相册
            creatV.mStr_flag = @"1";
            [utils pushViewController:creatV animated:YES];
        }else if (buttonIndex == 1){//上传照片
            uploadV.mStr_flag = @"1";
            uploadV.mArr_albums = [NSMutableArray arrayWithArray:self.mArr_myselfAlbums];
            [utils pushViewController:uploadV animated:YES];
        }
    }
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
