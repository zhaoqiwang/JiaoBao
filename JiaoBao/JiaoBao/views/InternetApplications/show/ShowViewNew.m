 //
//  ShowViewNew.m
//  JiaoBao
//
//  Created by Zqw on 14-12-13.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "ShowViewNew.h"
#import "ShareCollectionViewCell.h"
#import "Reachability.h"

static NSString *ShowNewCell = @"ShareCollectionViewCell";

@implementation ShowViewNew
@synthesize mScrollV_view,mArr_define,mLab_myUnit,mArr_myUnit,mTableV_myUnit,mLab_follow,mArr_follow,mTalbeV_follow,mCollectionV_unit,mArr_related;

- (id)initWithFrame1:(CGRect)frame{
    self = [super init];
    if (self) {
        //做bug服务器显示当前的哪个界面
        NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
        [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
        self.frame = frame;
        self.mArr_define = [[NSMutableArray alloc] init];
        self.mArr_follow = [[NSMutableArray alloc] init];
        self.mArr_myUnit = [[NSMutableArray alloc] init];
        self.mArr_related = [[NSMutableArray alloc] init];
        self.mArr_define = [NSMutableArray arrayWithObjects:@"最新更新单位",@"最新更新文章",@"本地最新单位",@"本地最新文章",@"相关单位", nil];
        //通知shareview界面，将得到的值，传到界面,获取到得单位
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getUnitInfo" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUnitInfo:) name:@"getUnitInfo" object:nil];
        //获取到单位头像后，刷新界面
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshShowViewNew" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshShowViewNew) name:@"refreshShowViewNew" object:nil];
        //获取到我关注的单位后，通知界面
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetMyAttUnit" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetMyAttUnit:) name:@"GetMyAttUnit" object:nil];
        //将空间，加到view中,总界面
        self.mScrollV_view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [dm getInstance].width, self.frame.size.height)];
        [self addSubview:self.mScrollV_view];
        //默认表格
//        self.mTableV_define = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [dm getInstance].width, 120)];
//        self.mTableV_define.dataSource = self;
//        self.mTableV_define.delegate = self;
//        self.mTableV_define.tag = 1;
//        [self.mScrollV_view addSubview:self.mTableV_define];
        //collectionview,单位列表
        UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
        self.mCollectionV_unit = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, [dm getInstance].width, 200) collectionViewLayout:flowLayout];
        
        self.mCollectionV_unit.delegate = self;
        self.mCollectionV_unit.dataSource = self;
        self.mCollectionV_unit.backgroundColor = [UIColor whiteColor];
        [self.mCollectionV_unit registerClass:[ShareCollectionViewCell class] forCellWithReuseIdentifier:ShowNewCell];
        //设置本身大小和内容大小
        self.mCollectionV_unit.frame = CGRectMake(self.mCollectionV_unit.frame.origin.x, self.mCollectionV_unit.frame.origin.y, self.mCollectionV_unit.frame.size.width, self.mCollectionV_unit.collectionViewLayout.collectionViewContentSize.height);
        [self.mScrollV_view addSubview:self.mCollectionV_unit];
        //自己所在单位标签
        self.mLab_myUnit = [[UILabel alloc] initWithFrame:CGRectMake(0, self.mCollectionV_unit.frame.origin.y+self.mCollectionV_unit.frame.size.height, [dm getInstance].width, 20 )];
        self.mLab_myUnit.text = @"     我所在的单位";
        self.mLab_myUnit.font = [UIFont systemFontOfSize:13];
        [self.mScrollV_view addSubview:self.mLab_myUnit];
        //自己所在单位表格
        self.mTableV_myUnit = [[UITableView alloc] initWithFrame:CGRectMake(0, self.mLab_myUnit.frame.origin.y+self.mLab_myUnit.frame.size.height, [dm getInstance].width, 0)];
        self.mTableV_myUnit.dataSource = self;
        self.mTableV_myUnit.delegate = self;
        self.mTableV_myUnit.tag = 2;
        [self.mScrollV_view addSubview:self.mTableV_myUnit];
        //关注单位标签
        self.mLab_follow = [[UILabel alloc] initWithFrame:CGRectMake(0, self.mTableV_myUnit.frame.origin.y+self.mTableV_myUnit.frame.size.height, [dm getInstance].width, 20 )];
        self.mLab_follow.text = @"     我关注的单位";
        self.mLab_follow.font = [UIFont systemFontOfSize:13];
        [self.mScrollV_view addSubview:self.mLab_follow];
        //关注单位表格
        self.mTalbeV_follow = [[UITableView alloc] initWithFrame:CGRectMake(0, self.mLab_follow.frame.origin.y+self.mLab_follow.frame.size.height, [dm getInstance].width, 0)];
        self.mTalbeV_follow.dataSource = self;
        self.mTalbeV_follow.delegate = self;
        self.mTalbeV_follow.tag = 3;
        [self.mScrollV_view addSubview:self.mTalbeV_follow];
    }
    return self;
}

//获取到我关注的单位后，通知界面
-(void)GetMyAttUnit:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self];
    NSMutableDictionary *dic = noti.object;
    NSString *flag = [dic objectForKey:@"flag"];
    if ([flag intValue]==0) {//成功
        NSMutableArray *array = noti.object;
        [self.mArr_follow removeAllObjects];
        self.mArr_follow = [NSMutableArray arrayWithArray:array];
        //重置界面
        [self reSetFrame];
    }else{
        [MBProgressHUD showError:@"获取单位出错" toView:self];
    }
    
}

-(void)ProgressViewLoad{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    [MBProgressHUD showMessage:@"" toView:self];
}

//检查当前网络是否可用
-(BOOL)checkNetWork{
    if([Reachability isEnableNetwork]==NO){
        [MBProgressHUD showError:NETWORKENABLE toView:self];
        return YES;
    }else{
        return NO;
    }
}

//获取到单位头像后，刷新界面
-(void)refreshShowViewNew{
    [self.mTableV_myUnit reloadData];
    [self.mTalbeV_follow reloadData];
}

//加载获取到得单位
-(void)getUnitInfo:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self];
    
    NSMutableDictionary *dic = noti.object;
    NSString *flag = [dic objectForKey:@"flag"];
    if ([flag integerValue]==0) {
        NSMutableArray *array = [dic objectForKey:@"array"];
        //未读数量标记
        [self.mArr_myUnit removeAllObjects];
        [self.mArr_related removeAllObjects];
        //未读数量标记
        for (int i=0; i<array.count; i++) {
            UnitSectionMessageModel *model = [array objectAtIndex:i];
            D("UnitSectionMessageModel *model-===%@",model.IsMyUnit);
            if ([model.IsMyUnit intValue] == 1) {
                [self.mArr_myUnit addObject:model];
            }else{
                [self.mArr_related addObject:model];
            }
//        [dm getInstance].mImt_showUnRead = [dm getInstance].mImt_showUnRead + [model.MessageCount intValue];
        }
        //重置界面
        [self reSetFrame];
    }else{
        [MBProgressHUD showError:@"超时" toView:self];
    }
}

//重置界面
-(void)reSetFrame{
    self.mTableV_myUnit.frame = CGRectMake(0, self.mTableV_myUnit.frame.origin.y, self.mTableV_myUnit.frame.size.width, self.mArr_myUnit.count*50);
    [self.mTableV_myUnit reloadData];
    self.mLab_follow.frame = CGRectMake(0, self.mTableV_myUnit.frame.origin.y+self.mTableV_myUnit.frame.size.height, [dm getInstance].width, 20 );
    self.mTalbeV_follow.frame = CGRectMake(0, self.mLab_follow.frame.origin.y+self.mLab_follow.frame.size.height, [dm getInstance].width, self.mArr_follow.count*50);
    [self.mTalbeV_follow reloadData];
    self.mScrollV_view.contentSize = CGSizeMake([dm getInstance].width, self.mTalbeV_follow.frame.origin.y+self.mTalbeV_follow.frame.size.height);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 1) {
        return self.mArr_define.count;
    }else if (tableView.tag == 2){
        return self.mArr_myUnit.count;
    }else if (tableView.tag == 3){
        return self.mArr_follow.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 1) {
        return 40;
    }else if (tableView.tag == 2){
        return 50;
    }else if (tableView.tag == 3){
        return 50;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellWithIdentifier = @"TopArthListCell";
    TopArthListCell *cell = (TopArthListCell *)[tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TopArthListCell" owner:self options:nil] lastObject];
        cell.frame = CGRectMake(0, 0, [dm getInstance].width, 50);
    }
//    TopArthListModel *model = [self.mArr_tabel objectAtIndex:indexPath.row];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    cell.mImgV_headImg.frame = CGRectMake(13, 5, 40, 40);
    if (tableView.tag == 1) {
        [cell.mImgV_headImg setImage:[UIImage imageNamed:@"root_img"]];
        //标题
        NSString *str = [self.mArr_define objectAtIndex:indexPath.row];
        CGSize numSize = [str sizeWithFont:[UIFont systemFontOfSize:14]];
        cell.mLab_title.frame = CGRectMake(cell.mLab_title.frame.origin.x, cell.mLab_title.frame.origin.y, [dm getInstance].width-cell.mImgV_headImg.frame.size.width-23, numSize.height*2);
        cell.mLab_title.text = str;
    }else if (tableView.tag == 2){
        UnitSectionMessageModel *model = [self.mArr_myUnit objectAtIndex:indexPath.row];
        if([model.UnitType integerValue] == 3)
        {
            [cell.mImgV_headImg sd_setImageWithURL:(NSURL *)[NSString stringWithFormat:@"%@%@",UnitIDImg,[NSString stringWithFormat:@"-%@",model.UnitID]] placeholderImage:[UIImage  imageNamed:@"root_img"]];
            
        }
        else
        {
            [cell.mImgV_headImg sd_setImageWithURL:(NSURL *)[NSString stringWithFormat:@"%@%@",UnitIDImg,model.UnitID] placeholderImage:[UIImage  imageNamed:@"root_img"]];

        }

        //标题
        CGSize numSize = [model.UnitName sizeWithFont:[UIFont systemFontOfSize:14]];
        cell.mLab_title.frame = CGRectMake(cell.mLab_title.frame.origin.x, cell.mLab_title.frame.origin.y, [dm getInstance].width-cell.mImgV_headImg.frame.size.width-23, numSize.height*2);
        cell.mLab_title.text = model.UnitName;
    }else if (tableView.tag == 3){
        //文件名
        MyAttUnitModel *model = [self.mArr_follow objectAtIndex:indexPath.row];
        NSString *unitID = model.InterestUnitID;
        if ([unitID intValue]<0) {
            NSString *b = [unitID substringToIndex:1];
            if ([b isEqual:@"-"]) {
                unitID = [unitID substringFromIndex:1];
            }
        }
        [cell.mImgV_headImg sd_setImageWithURL:(NSURL *)[NSString stringWithFormat:@"%@%@",UnitIDImg,model.InterestUnitID] placeholderImage:[UIImage  imageNamed:@"root_img"]];

        
        //标题
        CGSize numSize = [model.unitName sizeWithFont:[UIFont systemFontOfSize:14]];
        cell.mLab_title.frame = CGRectMake(cell.mLab_title.frame.origin.x, cell.mLab_title.frame.origin.y, [dm getInstance].width-cell.mImgV_headImg.frame.size.width-23, numSize.height*2);
        cell.mLab_title.text = model.unitName;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag == 1) {
//        UpdateUnitListViewController *unitList = [[UpdateUnitListViewController alloc] init];
//        if (indexPath.row == 0) {//最新单位
//            unitList.mStr_flag = @"1";
//            unitList.mStr_local = @"false";
//            unitList.mStr_title = @"最新单位";
//            [utils pushViewController:unitList animated:YES];
//        }else if (indexPath.row == 1){//本地最新
//            unitList.mStr_flag = @"1";
//            unitList.mStr_local = @"true";
//            unitList.mStr_title = @"本地最新";
//            [utils pushViewController:unitList animated:YES];
//        }else if (indexPath.row == 2){//相关单位
//            
//        }
    }else if (tableView.tag == 2){
        UnitSectionMessageModel *model = [self.mArr_myUnit objectAtIndex:indexPath.row];
        UnitSpaceViewController *space = [[UnitSpaceViewController alloc] init];
        space.mModel_unit = model;
        D("tempModel.unitType-====%@",model.UnitType);
        [utils pushViewController:space animated:YES];
    }else if (tableView.tag == 3){
        MyAttUnitModel *tempModel = [self.mArr_follow objectAtIndex:indexPath.row];
        UnitSectionMessageModel *model = [[UnitSectionMessageModel alloc] init];
        model.UnitID = tempModel.InterestUnitID;
        model.UnitName = tempModel.unitName;
        model.UnitType = tempModel.unitType;
        D("tempModel.unitType-====%@",tempModel.unitType);
        UnitSpaceViewController *space = [[UnitSpaceViewController alloc] init];
        space.mModel_unit = model;
        [utils pushViewController:space animated:YES];
    }
}

#pragma mark - Collection View Data Source
//每一组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section{
    return self.mArr_define.count;
}
//定义并返回每个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ShareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ShowNewCell forIndexPath:indexPath];
    if (!cell) {
        
    }
    NSString *name = [self.mArr_define objectAtIndex:indexPath.row];
    //文章个数
    cell.mImgV_red.hidden = YES;
    cell.mLab_count.hidden = YES;
    //图标
//    int a = ([dm getInstance].width-50)/4;
    cell.mImgV_background.frame = CGRectMake(10, 10, 40, 40);
    if (indexPath.row == 0||indexPath.row == 2) {
        cell.mImgV_background.image = [UIImage imageNamed:@"showUnit"];
    }else if (indexPath.row == 4){
        cell.mImgV_background.image = [UIImage imageNamed:@"share_next0"];
    }else {
        cell.mImgV_background.image = [UIImage imageNamed:@"showArticle"];
    }
    
    //标题
    cell.mLab_name.text = name;
    CGSize size = [name sizeWithFont:[UIFont systemFontOfSize:14]];
    cell.mLab_name.font = [UIFont systemFontOfSize:14];
    cell.mLab_name.frame = CGRectMake(55, 0, ([dm getInstance].width-50)/2-50, 50);
    cell.mLab_name.textAlignment = NSTextAlignmentLeft;
    if (size.width>cell.mLab_name.frame.size.width) {
        cell.mLab_name.numberOfLines = 2;
    }
    return cell;
}

//设置每组的cell的边界
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {//最新单位
        UpdateUnitListViewController *unitList = [[UpdateUnitListViewController alloc] init];
        unitList.mStr_flag = @"1";
        unitList.mStr_local = @"false";
        unitList.mStr_title = [self.mArr_define objectAtIndex:indexPath.row];
        [utils pushViewController:unitList animated:YES];
    }else if (indexPath.row == 1){//最新文章
        ArthLIstViewController *list = [[ArthLIstViewController alloc] init];
        list.mStr_title = [self.mArr_define objectAtIndex:indexPath.row];
        list.mInt_class = 2;//不能发布文章
        list.mInt_section = 3;//来自showviewnew
        list.mInt_flag = 3;//showview中3
        list.mStr_local = @"";
        list.mStr_flag = @"1";//1最新2推荐
        [utils pushViewController:list animated:YES];
    }else if (indexPath.row == 2){//本地最新
        UpdateUnitListViewController *unitList = [[UpdateUnitListViewController alloc] init];
        unitList.mStr_flag = @"1";
        unitList.mStr_local = @"true";
        unitList.mStr_title = [self.mArr_define objectAtIndex:indexPath.row];
        [utils pushViewController:unitList animated:YES];
    }else if (indexPath.row == 3){//本地文章
        ArthLIstViewController *list = [[ArthLIstViewController alloc] init];
        list.mStr_title = [self.mArr_define objectAtIndex:indexPath.row];
        list.mInt_class = 2;//不能发布文章
        list.mInt_section = 3;//来自showviewnew
        list.mInt_flag = 3;//showview中3
        list.mStr_flag = @"1";//1最新2推荐
        list.mStr_local = @"local";
        [utils pushViewController:list animated:YES];
    }else if (indexPath.row == 4){//相关单位
        RelatedUnitViewController *list = [[RelatedUnitViewController alloc] init];
        list.mStr_title = [self.mArr_define objectAtIndex:indexPath.row];
        list.mStr_UID = [NSString stringWithFormat:@"%d",[dm getInstance].UID];
        D("self.mArr_related-====%lu",(unsigned long)self.mArr_related.count);
        list.mArr_list = [NSMutableArray arrayWithArray:self.mArr_related];
        [utils pushViewController:list animated:YES];
    }
}
//每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(([dm getInstance].width-50)/2, 50);
}

//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
