//
//  ShareViewNew.m
//  JiaoBao
//
//  Created by Zqw on 14-12-15.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "ShareViewNew.h"
#import "Reachability.h"

@implementation ShareViewNew
@synthesize mScrollV_share,mTableV_detail,mTableV_difine,mInt_index,mArr_tabel,mBtn_add,mLab_name,mArr_difine;

- (id)initWithFrame1:(CGRect)frame{
    self = [super init];
    if (self) {
        // Initialization code
        self.frame = frame;
        
        //通知shareview界面，将得到的值，传到界面,最新更新，推荐
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TopArthListIndexNewShare" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TopArthListIndex:) name:@"TopArthListIndexNewShare" object:nil];
        //获取到头像后刷新
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"exchangeGetFaceImg" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TopArthListIndexImg:) name:@"exchangeGetFaceImg" object:nil];
        //切换账号时，更新数据
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RegisterView" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RegisterView:) name:@"RegisterView" object:nil];
        
        self.mArr_tabel = [NSMutableArray array];
        self.mArr_difine = [NSMutableArray array];
        self.mArr_difine = [NSMutableArray arrayWithObjects:@"最新文章",@"推荐文章",@"最新更新", nil];
        self.mInt_index = 1;
        self.mArr_tabel = [NSMutableArray arrayWithArray:self.mArr_difine];
        
        self.mTableV_detail = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [dm getInstance].width, self.frame.size.height)];
        self.mTableV_detail.delegate = self;
        self.mTableV_detail.dataSource = self;
        self.mTableV_detail.tag = 2;
        [self.mTableV_detail addHeaderWithTarget:self action:@selector(headerRereshing)];
        self.mTableV_detail.headerPullToRefreshText = @"下拉刷新";
        self.mTableV_detail.headerReleaseToRefreshText = @"松开后刷新";
        self.mTableV_detail.headerRefreshingText = @"正在刷新...";
        
        [self.mScrollV_share addSubview:self.mTableV_detail];
        [self addSubview:self.mTableV_detail];
    }
    return self;
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

-(void)ProgressViewLoad{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    [MBProgressHUD showMessage:@"" toView:self];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    self.mInt_index = 1;
    //获取同事、关注人、好友的分享文章
    [[ShowHttp getInstance] showHttpGetMyShareingArth:[dm getInstance].jiaoBaoHao page:@"1" viewFlag:@"shareNew"];
    [self ProgressViewLoad];
}
- (void)footerRereshing{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    if (self.mArr_tabel.count>=23) {
        self.mInt_index = (int)(self.mArr_tabel.count-3)/20+1;
        D("self.mint.page-====%lu %d",(unsigned long)self.mArr_tabel.count,self.mInt_index);
        //获取同事、关注人、好友的分享文章
        [[ShowHttp getInstance] showHttpGetMyShareingArth:[dm getInstance].jiaoBaoHao page:[NSString stringWithFormat:@"%d",self.mInt_index] viewFlag:@"shareNew"];
        [self ProgressViewLoad];
    } else {
        [self.mTableV_detail headerEndRefreshing];
        [self.mTableV_detail footerEndRefreshing];
        [MBProgressHUD showError:@"没有更多了" toView:self];
    }
}

//获取到头像后，更新界面
-(void)TopArthListIndexImg:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self];
    [self.mTableV_detail reloadData];
}

//最新更新、推荐的通知
-(void)TopArthListIndex:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self];
    [self.mTableV_detail headerEndRefreshing];
    [self.mTableV_detail footerEndRefreshing];
    NSMutableArray *array = noti.object;
    if (self.mInt_index > 1) {
        if (array.count>0) {
            [self.mArr_tabel addObjectsFromArray:array];
        }
        if (array.count<20) {
            [self.mTableV_detail removeFooter];
        }
    }else{
        [self.mArr_tabel removeAllObjects];
        [self.mArr_tabel addObjectsFromArray:self.mArr_difine];
        [self.mArr_tabel addObjectsFromArray:array];
        if (array.count ==20&&self.mInt_index == 1) {
            [self.mTableV_detail addFooterWithTarget:self action:@selector(footerRereshing)];
            self.mTableV_detail.footerPullToRefreshText = @"上拉加载更多";
            self.mTableV_detail.footerReleaseToRefreshText = @"松开加载更多数据";
            self.mTableV_detail.footerRefreshingText = @"正在加载...";
        }
//        self.mArr_tabel = [NSMutableArray arrayWithArray:array];
    }
    //刷新，布局
    [self.mTableV_detail reloadData];
//    [self reSetFrame];
}

//切换账号时，更新数据
-(void)RegisterView:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self];
    [self.mArr_tabel removeAllObjects];
    [self.mTableV_detail reloadData];
    [dm getInstance].mImt_showUnRead = 0;
    [dm getInstance].mImt_shareUnRead = 0;
}


-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
        return self.mArr_tabel.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellWithIdentifier = @"TopArthListCell";
    TopArthListCell *cell = (TopArthListCell *)[tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    
//    if (tableView.tag == 1){
    if (indexPath.row == 0||indexPath.row == 1){
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TopArthListCell" owner:self options:nil] lastObject];
            cell.frame = CGRectMake(0, 0, [dm getInstance].width, 40);
        }
        cell.mImgV_headImg.frame = CGRectMake(13, 5, 30, 30);
        [cell.mImgV_headImg setImage:[UIImage imageNamed:@"shareArticle"]];
        //标题
        NSString *str = [self.mArr_difine objectAtIndex:indexPath.row];
        CGSize numSize = [str sizeWithFont:[UIFont systemFontOfSize:14]];
        cell.mLab_title.frame = CGRectMake(cell.mLab_title.frame.origin.x, 5, [dm getInstance].width-cell.mImgV_headImg.frame.size.width-23, numSize.height*2);
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
    }if (indexPath.row == 2){
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TopArthListCell" owner:self options:nil] lastObject];
            cell.frame = CGRectMake(0, 0, [dm getInstance].width, 20);
        }
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
    }else{
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TopArthListCell" owner:self options:nil] lastObject];
            cell.frame = CGRectMake(0, 0, [dm getInstance].width, 70);
        }
        TopArthListModel *model = [self.mArr_tabel objectAtIndex:indexPath.row];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        //文件名
        NSString *imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",model.JiaoBaoHao]];
        UIImage *img= [UIImage imageWithContentsOfFile:imgPath];
        cell.mImgV_headImg.frame = CGRectMake(13, 10, 48, 48);
        if (img.size.width>0) {
            [cell.mImgV_headImg setImage:img];
        }else{
            [cell.mImgV_headImg setImage:[UIImage imageNamed:@"root_img"]];
            //获取头像
            [[ExchangeHttp getInstance] getUserInfoFace:model.JiaoBaoHao];
        }
        //添加头像点击事件
        [cell headImgClick];
        cell.delegate = self;
        cell.tag = indexPath.row;
        //标题
        CGSize numSize = [[NSString stringWithFormat:@"%@",model.Title] sizeWithFont:[UIFont systemFontOfSize:14]];
        cell.mLab_title.frame = CGRectMake(cell.mLab_title.frame.origin.x, cell.mLab_title.frame.origin.y, [dm getInstance].width-cell.mImgV_headImg.frame.size.width-23, numSize.height*2);
        cell.mLab_title.text = model.Title;
        if (numSize.width>cell.mLab_title.frame.size.width) {
            cell.mLab_title.numberOfLines = 2;
        }
        //姓名
        CGSize size = [@"金视野" sizeWithFont:[UIFont systemFontOfSize:10]];
        cell.mLab_name.text = model.UserName;
        cell.mLab_name.frame = CGRectMake(cell.mLab_name.frame.origin.x, 70-12-size.height, cell.mLab_name.frame.size.width, size.height);
        //时间
        cell.mLab_time.text = model.RecDate;
        cell.mLab_time.frame = CGRectMake(cell.mLab_time.frame.origin.x, 70-12-size.height, cell.mLab_time.frame.size.width, size.height);
        //赞个数
        CGSize likeSize = [[NSString stringWithFormat:@"%@",model.LikeCount] sizeWithFont:[UIFont systemFontOfSize:10]];
        cell.mLab_likeCount.frame = CGRectMake([dm getInstance].width-10-likeSize.width, 70-12-likeSize.height, likeSize.width, likeSize.height);
        cell.mLab_likeCount.text = model.LikeCount;
        //赞图标
        UIImage *likeImg = [UIImage imageNamed:@"share_like_1"];
        cell.mImgV_likeCount.frame = CGRectMake(cell.mLab_likeCount.frame.origin.x-likeImg.size.width-5, 70-12-likeImg.size.height, likeImg.size.width, likeImg.size.height);
        cell.mImgV_likeCount.image = likeImg;
        //阅读人数
        CGSize lookSize = [[NSString stringWithFormat:@"%@",model.ViewCount] sizeWithFont:[UIFont systemFontOfSize:10]];
        cell.mLab_viewCount.frame = CGRectMake(cell.mImgV_likeCount.frame.origin.x-lookSize.width-5, 70-12-lookSize.height, lookSize.width, lookSize.height);
        cell.mLab_viewCount.text = model.ViewCount;
        //阅读图标
        UIImage *lookImg = [UIImage imageNamed:@"share_look"];
        cell.mImgV_viewCount.frame = CGRectMake(cell.mLab_viewCount.frame.origin.x-lookImg.size.width-5, 70-12-lookImg.size.height, lookImg.size.width, lookImg.size.height);
        cell.mImgV_viewCount.image = lookImg;
        return cell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    if (indexPath.row == 0||indexPath.row == 1) {
        return 40;
    }else if (indexPath.row == 2){
        return 20;
    }else{
        return 70;
    }
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (tableView.tag == 1) {
    if (indexPath.row == 0||indexPath.row ==1) {
        ArthLIstViewController *list = [[ArthLIstViewController alloc] init];
        
        list.mInt_class = 2;//不能发布文章
        list.mInt_section = 0;//来自showviewnew
        list.mInt_flag = 4;//shareNew中的最新文章和推荐文章
        list.mStr_local = @"";
        list.mStr_classID = [NSString stringWithFormat:@"%d",[dm getInstance].UID];
        if (indexPath.row == 0) {
            list.mStr_title = @"最新文章";
            list.mStr_flag = @"1";//1最新2推荐
        }else if (indexPath.row == 1){
            list.mStr_title = @"推荐文章";
            list.mStr_flag = @"2";//1最新2推荐
        }
        [utils pushViewController:list animated:YES];
    }else if (indexPath.row == 2){
        
    }else{
        TopArthListModel *model = [self.mArr_tabel objectAtIndex:indexPath.row];
        ArthDetailViewController *arth = [[ArthDetailViewController alloc] init];
        arth.Arthmodel = model;
        [utils pushViewController:arth animated:YES];
    }
}

//向cell中添加头像点击手势
- (void) TopArthListCellTapPress:(TopArthListCell *)topArthListCell{
    TopArthListModel *model = [self.mArr_tabel objectAtIndex:topArthListCell.tag];
    //生成个人信息
    UserInfoByUnitIDModel *userModel = [[UserInfoByUnitIDModel alloc] init];
    userModel.UserID = model.JiaoBaoHao;
    userModel.UserName = model.UserName;
    userModel.AccID = model.JiaoBaoHao;
    
    PersonalSpaceViewController *personal = [[PersonalSpaceViewController alloc] init];
    personal.mModel_personal = userModel;
    [utils pushViewController:personal animated:YES];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
