//
//  ThemeView.m
//  JiaoBao
//
//  Created by Zqw on 14-12-16.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "ThemeView.h"
#import "Reachability.h"
#import "MobClick.h"

@implementation ThemeView
@synthesize mScrollV_share,mTableV_detail,mTableV_difine,mInt_index,mArr_tabel,mBtn_add,mLab_name,mArr_difine;

- (id)initWithFrame1:(CGRect)frame{
    self = [super init];
    if (self) {
        // Initialization code
        self.frame = frame;
        //做bug服务器显示当前的哪个界面
        NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
        [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
        //将我的主题通知界面
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"EnjoyInterestList" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EnjoyInterestList:) name:@"EnjoyInterestList" object:nil];
        //获取到单位头像后，刷新界面
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshShowViewNew" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshShowViewNew) name:@"refreshShowViewNew" object:nil];
        
        self.mArr_tabel = [NSMutableArray array];
        self.mArr_difine = [NSMutableArray array];
        self.mArr_difine = [NSMutableArray arrayWithObjects:@"最新更新主题",@"我关注及我参与的主题", nil];
        self.mInt_index = 1;
        [self.mArr_tabel addObjectsFromArray:self.mArr_difine];
        
        //scrollview
//        self.mScrollV_share = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [dm getInstance].width, self.frame.size.height)];
//        [self addSubview:self.mScrollV_share];
        
        //表格,更改里面的自定义cell
//        self.mTableV_difine = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [dm getInstance].width, 50)];
//        self.mTableV_difine.delegate = self;
//        self.mTableV_difine.dataSource = self;
//        self.mTableV_difine.tag = 1;
//        self.mTableV_difine.scrollEnabled = NO;
//        [self.mScrollV_share addSubview:self.mTableV_difine];
        
        //表格的标签
//        self.mLab_name = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, [dm getInstance].width, 20)];
//        self.mLab_name.backgroundColor = [UIColor grayColor];
//        self.mLab_name.text = @"  我关注及我参与的主题";
//        self.mLab_name.font = [UIFont systemFontOfSize:12];
//        [self.mScrollV_share addSubview:self.mLab_name];
        
        //表格,更改里面的自定义cell
//        self.mTableV_detail = [[UITableView alloc] initWithFrame:CGRectMake(0, self.mLab_name.frame.origin.y+self.mLab_name.frame.size.height, [dm getInstance].width, 0)];
        self.mTableV_detail = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [dm getInstance].width, self.frame.size.height)];
        self.mTableV_detail.delegate = self;
        self.mTableV_detail.dataSource = self;
//        self.mTableV_detail.scrollEnabled = NO;
        self.mTableV_detail.tag = 2;
//        [self.mScrollV_share addSubview:self.mTableV_detail];
        [self addSubview:self.mTableV_detail];
        [self.mTableV_detail addHeaderWithTarget:self action:@selector(headerRereshing)];
        self.mTableV_detail.headerPullToRefreshText = @"下拉刷新";
        self.mTableV_detail.headerReleaseToRefreshText = @"松开后刷新";
        self.mTableV_detail.headerRefreshingText = @"正在刷新...";
        
        //加载更多按钮
//        self.mBtn_add = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.mBtn_add.frame = CGRectMake(0, self.mTableV_detail.frame.origin.y+self.mTableV_detail.frame.size.height, [dm getInstance].width, 40);
//        self.mBtn_add.hidden = NO;
//        [self.mBtn_add setTitle:@"查看更多" forState:UIControlStateNormal];
//        self.mBtn_add.titleLabel.font = [UIFont systemFontOfSize:12];
//        [self.mBtn_add addTarget:self action:@selector(clickAddBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [self.mBtn_add setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [self.mScrollV_share addSubview:self.mBtn_add];
    }
    return self;
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
#pragma mark 开始进入刷新状态
- (void)headerRereshing{
    self.mInt_index = 1;
    //获取同事、关注人、好友的分享文章
//    [[ShowHttp getInstance] showHttpGetMyShareingArth:[dm getInstance].jiaoBaoHao page:@"1" viewFlag:@""];
    [[ThemeHttp getInstance] themeHttpEnjoyInterestList:[dm getInstance].jiaoBaoHao];
    [self ProgressViewLoad];
}
- (void)footerRereshing{
    if (self.mArr_tabel.count>=23) {
        //检查当前网络是否可用
        if ([self checkNetWork]) {
        return;
    }
        self.mInt_index = (int)(self.mArr_tabel.count-2)/20+1;
        D("self.mint.page-====%lu %d",(unsigned long)self.mArr_tabel.count,self.mInt_index);
        //获取同事、关注人、好友的分享文章
        [[ShowHttp getInstance] showHttpGetMyShareingArth:[dm getInstance].jiaoBaoHao page:[NSString stringWithFormat:@"%d",self.mInt_index] viewFlag:@""];
        [self ProgressViewLoad];
    } else {
        [self.mTableV_detail headerEndRefreshing];
        [self.mTableV_detail footerEndRefreshing];
        [MBProgressHUD showError:@"没有更多了" toView:self];
    }
}

//获取到单位头像后，刷新界面
-(void)refreshShowViewNew{
    [self.mTableV_detail reloadData];
}

//将我的主题通知界面
-(void)EnjoyInterestList:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self];
    [self.mTableV_detail headerEndRefreshing];
    [self.mTableV_detail footerEndRefreshing];
    NSDictionary *dic = noti.object;
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
    NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
    
    if([ResultCode integerValue]!=0)
    {
        [MBProgressHUD showError:ResultDesc toView:self];
        return;
    }
    NSMutableArray *array = [dic objectForKey:@"array"];
    if (self.mInt_index > 1) {
        if (array.count>0) {
            [self.mArr_tabel addObjectsFromArray:array];
        }
    }else{
        [self.mArr_tabel removeAllObjects];
        [self.mArr_tabel addObjectsFromArray:self.mArr_difine];
        [self.mArr_tabel addObjectsFromArray:array];
        if (array.count ==20&&self.mInt_index == 1) {
        }
    }
    //刷新，布局
//    [self reSetFrame];
    [self.mTableV_detail reloadData];
}

//切换账号时，更新数据
-(void)RegisterView:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self];
    [self.mArr_tabel removeAllObjects];
    [dm getInstance].mImt_showUnRead = 0;
    [dm getInstance].mImt_shareUnRead = 0;
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
//    if (tableView.tag == 1) {
//        return self.mArr_difine.count;
//    }else if (tableView.tag == 2){
        return self.mArr_tabel.count;
//    }
//    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"TopArthListCell";
    TopArthListCell *cell = (TopArthListCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[TopArthListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TopArthListCell" owner:self options:nil];
        //这时myCell对象已经通过自定义xib文件生成了
        if ([nib count]>0) {
            cell = (TopArthListCell *)[nib objectAtIndex:0];
            //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
        }
        //添加图片点击事件
        //若是需要重用，需要写上以下两句代码
        UINib * n= [UINib nibWithNibName:@"TopArthListCell" bundle:[NSBundle mainBundle]];
        [self.mTableV_detail registerNib:n forCellReuseIdentifier:indentifier];
    }
//    if (tableView.tag == 1){
    if (indexPath.row == 0){
        cell.mImgV_headImg.frame = CGRectMake(13, 5, 40, 40);
        [cell.mImgV_headImg setImage:[UIImage imageNamed:@"themeTotal"]];
        [cell.mImgV_headImg setHidden:NO];
        cell.backgroundColor = [UIColor whiteColor];
        //标题
        NSString *str = [self.mArr_difine objectAtIndex:indexPath.row];
        CGSize numSize = [str sizeWithFont:[UIFont systemFontOfSize:14]];
        cell.mLab_title.frame = CGRectMake(70, 5, [dm getInstance].width-cell.mImgV_headImg.frame.size.width-23, numSize.height*2);
        cell.mLab_title.text = str;
        cell.mLab_title.font = [UIFont systemFontOfSize:14];
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
    }if (indexPath.row == 1){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        cell.mImgV_headImg.hidden = YES;
        //标题
        NSString *str = [self.mArr_difine objectAtIndex:indexPath.row];
        cell.mLab_title.frame = CGRectMake(10, 0, [dm getInstance].width, 20);
        cell.mLab_title.font = [UIFont systemFontOfSize:12];
        cell.mLab_title.text = str;
        
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
    }else {
        ThemeListModel *model = [self.mArr_tabel objectAtIndex:indexPath.row];
        [cell.mImgV_headImg sd_setImageWithURL:(NSURL *)[NSString stringWithFormat:@"%@%@",UnitIDImg,[NSString stringWithFormat:@"-%@",model.TabID]] placeholderImage:[UIImage  imageNamed:@"root_img"]];
        cell.mImgV_headImg.frame = CGRectMake(13, 5, 40, 40);
        cell.mImgV_headImg.hidden = NO;
        cell.mLab_title.font = [UIFont systemFontOfSize:14];
        cell.backgroundColor = [UIColor whiteColor];
        //标题
        CGSize numSize = [[NSString stringWithFormat:@"%@",model.InterestName] sizeWithFont:[UIFont systemFontOfSize:14]];
        cell.mLab_title.frame = CGRectMake(70, cell.mLab_title.frame.origin.y, [dm getInstance].width-cell.mImgV_headImg.frame.size.width-23, numSize.height*2);
        cell.mLab_title.text = model.InterestName;
        if (numSize.width>cell.mLab_title.frame.size.width) {
            cell.mLab_title.numberOfLines = 2;
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
    return nil;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
//    if (tableView.tag == 1) {
//        return 50;
//    }else if (tableView.tag == 2){
//        return 50;
//    }
    if (indexPath.row == 1) {
        return 20;
    }else{
        return 50;
    }
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (tableView.tag == 1) {
    if (indexPath.row == 0) {
        [MobClick event:@"ThemeView_didSelectRow_new" label:@""];
        UpdateUnitListViewController *unitList = [[UpdateUnitListViewController alloc] init];
        unitList.mStr_flag = @"3";
        unitList.mStr_title = @"最新更新主题";
        [utils pushViewController:unitList animated:YES];
    }else if (indexPath.row == 1){
    }else {
        [MobClick event:@"ThemeView_didSelectRow" label:@""];
        ThemeListModel *model = [self.mArr_tabel objectAtIndex:indexPath.row];
        ThemeSpaceViewController *themeSpace = [[ThemeSpaceViewController alloc] init];
        themeSpace.mStr_title = model.InterestName;
        themeSpace.mStr_unitID = model.TabID;
        themeSpace.mStr_tableID = model.TabIDStr;
        [utils pushViewController:themeSpace animated:YES];
    }
}

@end
