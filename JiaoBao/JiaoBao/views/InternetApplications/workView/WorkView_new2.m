//
//  WorkView_new2.m
//  JiaoBao
//
//  Created by Zqw on 15-4-9.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "WorkView_new2.h"
#import "Reachability.h"


@implementation WorkView_new2
@synthesize mArr_mySend,mBtn_new,mInt_flag,mInt_index,mProgressV,mTableV_list,mView_button,mArr_reply,mArr_sum,mArr_unRead,mArr_unReply;

- (id)initWithFrame1:(CGRect)frame{
    self = [super init];
    if (self) {
        // Initialization code
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        
        //取发给我消息的用户列表，new
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UnReadMsgCell" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UnReadMsgCell:) name:@"UnReadMsgCell" object:nil];
        
        self.mArr_unReply = [NSMutableArray array];
        self.mArr_unRead = [NSMutableArray array];
        self.mArr_sum = [NSMutableArray array];
        self.mArr_mySend = [NSMutableArray array];
        self.mArr_reply = [NSMutableArray array];
        self.mInt_index = 0;
        
        //放四个按钮
        self.mView_button = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [dm getInstance].width, 42)];
        self.mView_button.backgroundColor = [UIColor colorWithRed:240/255.0 green:239/255.0 blue:247/255.0 alpha:1];
        [self addSubview:self.mView_button];
        
        //加载按钮
        for (int i=0; i<5; i++) {
            UIButton *tempbtn = [UIButton buttonWithType:UIButtonTypeCustom];
            tempbtn.tag = i;
            if (i == 0) {
                tempbtn.selected = YES;
            }
            [tempbtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"workView_%d",i]] forState:UIControlStateSelected];
            [tempbtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"workView_click_%d",i]] forState:UIControlStateNormal];
            tempbtn.frame = CGRectMake((([dm getInstance].width-56*5)/6)*(i+1)+56*i, 0, 52, 42);
            [tempbtn addTarget:self action:@selector(btnChange:) forControlEvents:UIControlEventTouchUpInside];
            [self.mView_button addSubview:tempbtn];
        }
        //列表
        self.mTableV_list = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, [dm getInstance].width, self.frame.size.height-44-51)];
        self.mTableV_list.delegate=self;
        self.mTableV_list.dataSource=self;
        self.mTableV_list.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.mTableV_list];
        [self.mTableV_list addHeaderWithTarget:self action:@selector(headerRereshing)];
        self.mTableV_list.headerPullToRefreshText = @"下拉刷新";
        self.mTableV_list.headerReleaseToRefreshText = @"松开后刷新";
        self.mTableV_list.headerRefreshingText = @"正在刷新...";
        [self.mTableV_list addFooterWithTarget:self action:@selector(footerRereshing)];
        self.mTableV_list.footerPullToRefreshText = @"上拉加载更多";
        self.mTableV_list.footerReleaseToRefreshText = @"松开加载更多数据";
        self.mTableV_list.footerRefreshingText = @"正在加载...";
        //新建按钮
        self.mBtn_new = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *img_btn = [UIImage imageNamed:@"root_addBtn"];
        [self.mBtn_new setBackgroundImage:img_btn forState:UIControlStateNormal];
        [self.mBtn_new addTarget:self action:@selector(clickPosting:) forControlEvents:UIControlEventTouchUpInside];
        self.mBtn_new.frame = CGRectMake(([dm getInstance].width-img_btn.size.width)/2, self.frame.size.height-51+(51-img_btn.size.height)/2, img_btn.size.width, img_btn.size.height);
        [self.mBtn_new setTitle:@"新建事务" forState:UIControlStateNormal];
        [self.mBtn_new setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:self.mBtn_new];
        
        self.mProgressV = [[MBProgressHUD alloc]initWithView:self];
        [self addSubview:self.mProgressV];
        self.mProgressV.delegate = self;
    }
    return self;
}

-(void)UnReadMsgCell:(NSNotification *)noti{
    [self.mProgressV hide:YES];
    [self.mTableV_list headerEndRefreshing];
    [self.mTableV_list footerEndRefreshing];
    NSMutableDictionary *dic = noti.object;
    NSString *tag = [dic objectForKey:@"tag"];
    NSMutableArray *array = [dic objectForKey:@"array"];
    //如果是刷新，将数据清除
    if (self.mInt_flag == 1) {
        if (self.mInt_index == 0) {
            [self.mArr_sum removeAllObjects];
        }else if (self.mInt_index == 1){
            [self.mArr_unRead removeAllObjects];
        }else if (self.mInt_index == 2){
            [self.mArr_unReply removeAllObjects];
        }else if (self.mInt_index == 3){
            [self.mArr_reply removeAllObjects];
        }else if (self.mInt_index == 4){
            [self.mArr_mySend removeAllObjects];
        }
    }
    if ([tag intValue] == 0) {
        [self.mArr_sum addObjectsFromArray:array];
    }else if ([tag intValue] == 6){
        [self.mArr_unRead addObjectsFromArray:array];
    }else if ([tag intValue] == 8){
        [self.mArr_unReply addObjectsFromArray:array];
    }else if ([tag intValue] == 9){
        [self.mArr_reply addObjectsFromArray:array];
    }else if ([tag intValue] == 2){
        [self.mArr_mySend addObjectsFromArray:array];
    }
    [self.mTableV_list reloadData];
}

#pragma mark - TableViewdelegate&&TableViewdataSource
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    return nil;
//}
//每个cell返回的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell= [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        return cell.frame.size.height;
        
    }
    return 0;
}

//在每个section中，显示多少cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.mInt_index == 0) {
        return self.mArr_sum.count;
    }else if (self.mInt_index == 1){
        return self.mArr_unRead.count;
    }else if (self.mInt_index == 2){
        return self.mArr_unReply.count;
    }else if (self.mInt_index == 3){
        return self.mArr_reply.count;
    }else if (self.mInt_index == 4){
        return self.mArr_mySend.count;
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"WorkViewListCell";
    WorkViewListCell *cell = (WorkViewListCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WorkViewListCell" owner:self options:nil] lastObject];
    }
    //找到当前应该显示的数组
    NSMutableArray *array = [NSMutableArray array];
    if (self.mInt_index == 0) {
        array = [NSMutableArray arrayWithArray:self.mArr_sum];
    }else if (self.mInt_index == 1){
        array = [NSMutableArray arrayWithArray:self.mArr_unRead];
    }else if (self.mInt_index == 2){
        array = [NSMutableArray arrayWithArray:self.mArr_unReply];
    }else if (self.mInt_index == 3){
        array = [NSMutableArray arrayWithArray:self.mArr_reply];
    }else if (self.mInt_index == 4){
        array = [NSMutableArray arrayWithArray:self.mArr_mySend];
    }
    
    
    UnReadMsg_model *model = [array objectAtIndex:indexPath.row];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //文件名
    NSString *imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",model.JiaoBaoHao]];
    UIImage *img= [UIImage imageWithContentsOfFile:imgPath];
    if (img.size.width>0) {
        [cell.mImgV_head setImage:img];
    }else{
        [cell.mImgV_head setImage:[UIImage imageNamed:@"root_img"]];
        //获取头像
        [[ExchangeHttp getInstance] getUserInfoFace:model.JiaoBaoHao];
    }
    cell.mImgV_head.frame = CGRectMake(10, 10, 45, 45);
    cell.delegate = self;
    cell.tag = indexPath.row;
    //头像点击事件
    [cell headImgClick];
    //未读数量
    cell.mImgV_unRead.hidden = YES;
    cell.mLab_unRead.hidden = YES;
    //姓名
    NSString *name;
    name = model.UserName;

    CGSize nameSize = [[NSString stringWithFormat:@"%@",name] sizeWithFont:[UIFont systemFontOfSize:16]];
    cell.mLab_name.frame = CGRectMake(cell.mImgV_head.frame.origin.x+cell.mImgV_head.frame.size.width+10, 15, nameSize.width, 20);
    cell.mLab_name.text = name;
    
    //单位
    if (model.UnitShortName.length>0) {
        cell.mLab_unit.hidden = NO;
    }
    NSString *unitName = [NSString stringWithFormat:@"(%@)",model.UnitShortName];
    CGSize unitSize = [[NSString stringWithFormat:@"%@",unitName] sizeWithFont:[UIFont systemFontOfSize:12]];
    cell.mLab_unit.frame = CGRectMake(cell.mLab_name.frame.origin.x+nameSize.width, cell.mLab_name.frame.origin.y, unitSize.width, cell.mLab_unit.frame.size.height);
    cell.mLab_unit.text = unitName;
    //时间
    CGSize timeSize = [[NSString stringWithFormat:@"%@",model.RecDate] sizeWithFont:[UIFont systemFontOfSize:12]];
    cell.mLab_time.frame = CGRectMake([dm getInstance].width-timeSize.width-12, 15, timeSize.width, 20);
    cell.mLab_time.textColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1];
    cell.mLab_time.text = model.RecDate;
    
    //内容
    cell.mLab_content.text = model.MsgContent;
    cell.mLab_content.frame = CGRectMake(cell.mLab_name.frame.origin.x, cell.mLab_name.frame.origin.y+25, [dm getInstance].width-cell.mImgV_head.frame.size.width-30, 20);
    //分割线
    cell.mLab_line.frame = CGRectMake(0, 64, [dm getInstance].width, .5);
    cell.frame = CGRectMake(0, 0, [dm getInstance].width, 65);
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self clickImg:(int)indexPath.row flag:2];
}

//头像点击回调
-(void)WorkViewListCellTapPress:(WorkViewListCell *)workViewListCell{
    [self clickImg:(int)workViewListCell.tag flag:1];
}
//头像点击
-(void)clickImg:(int)index flag:(int)flag{
    UnReadMsg_model *unReadMsgModel;
    if (self.mInt_index == 0) {
        unReadMsgModel = [self.mArr_sum objectAtIndex:index];
    }else if (self.mInt_index == 1){
        unReadMsgModel = [self.mArr_unRead objectAtIndex:index];
    }else if (self.mInt_index == 2){
        unReadMsgModel = [self.mArr_unReply objectAtIndex:index];
    }else if (self.mInt_index == 3){
        unReadMsgModel = [self.mArr_reply objectAtIndex:index];
    }else if (self.mInt_index == 4){
        unReadMsgModel = [self.mArr_mySend objectAtIndex:index];
    }
    
    WorkMsgListViewController *work = [[WorkMsgListViewController alloc] init];
    if (self.mInt_index == 4) {
        work.mStr_name = @"我发送的信息";
        work.mInt_our = 1;
    }else{
        work.mStr_name = unReadMsgModel.UserName;
        work.mInt_our = 2;
    }
    work.mInt_flag = flag;

    work.mStr_tableID = unReadMsgModel.TabIDStr;
    [utils pushViewController:work animated:YES];
}

//按钮点击事件
-(void)btnChange:(UIButton *)btn{
    D("utype-===%d",[dm getInstance].uType);
    self.mInt_index = (int)btn.tag;
    //点击按钮时，判断是否应该进行数据获取
    if (self.mInt_index == 0&&self.mArr_sum.count==0) {
        if (self.mArr_sum.count==0) {
            [[LoginSendHttp getInstance] wait_unReadMsgWithTag:0 page:@"1"];
            [self ProgressViewLoad];
        }
    }else if (self.mInt_index == 1&&self.mArr_unRead.count==0){
        [[LoginSendHttp getInstance] wait_unReadMsgWithTag:6 page:@"1"];
        [self ProgressViewLoad];
    }else if (self.mInt_index == 2&&self.mArr_unReply.count == 0){
        [[LoginSendHttp getInstance] wait_unReadMsgWithTag:8 page:@"1"];
        [self ProgressViewLoad];
    }else if (self.mInt_index == 3&&self.mArr_reply.count==0){
        [[LoginSendHttp getInstance] wait_unReadMsgWithTag:9 page:@"1"];
        [self ProgressViewLoad];
    }else if (self.mInt_index == 4&&self.mArr_mySend.count==0){
        [[LoginSendHttp getInstance] getMyselfSendMsgWithPage:@"1"];
        [self ProgressViewLoad];
    }
    //切换图片
    for (UIButton *tempBtn in self.mView_button.subviews) {
        if ([tempBtn isKindOfClass:[UIButton class]]) {
            if (tempBtn.tag == btn.tag) {
                tempBtn.selected = YES;
            }else{
                tempBtn.selected = NO;
            }
        }
    }
    [self.mTableV_list reloadData];
}

//发表文章按钮
-(void)clickPosting:(UIButton *)btn{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    D("点击新建事务、发布通知按钮");
    ForwardViewController *forward = [[ForwardViewController alloc] init];
    forward.mStr_navName = @"新建事务";
    forward.mInt_forwardFlag = 1;
    forward.mInt_forwardAll = 2;
    forward.mInt_flag = 1;
    forward.mInt_all = 2;
    forward.mInt_where = 0;
    [utils pushViewController:forward animated:YES];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    //标注为刷新
    self.mInt_flag = 1;
    //刚进入学校圈，或者下拉刷新时执行
    [self tableViewDownReloadData];
}
- (void)footerRereshing{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    //不是刷新
    self.mInt_flag = 0;
    if (self.mInt_index == 0) {
        if (self.mArr_sum.count>=20) {
            //检查当前网络是否可用
            int a = (int)self.mArr_sum.count/20+1;
            [[LoginSendHttp getInstance] wait_unReadMsgWithTag:0 page:[NSString stringWithFormat:@"%d",a]];
            [self ProgressViewLoad];
        } else {
            [self loadNoMore];
        }
    }else if (self.mInt_index == 1){
        if (self.mArr_unRead.count>=20) {
            int a = (int)self.mArr_unRead.count/20+1;
            [[LoginSendHttp getInstance] wait_unReadMsgWithTag:6 page:[NSString stringWithFormat:@"%d",a]];
            [self ProgressViewLoad];
        } else {
            [self loadNoMore];
        }
    }else if (self.mInt_index == 2){
        if (self.mArr_unReply.count>=20) {
            int a = (int)self.mArr_unReply.count/20+1;
            [[LoginSendHttp getInstance] wait_unReadMsgWithTag:8 page:[NSString stringWithFormat:@"%d",a]];
            [self ProgressViewLoad];
        } else {
            [self loadNoMore];
        }
    }else if (self.mInt_index == 3){
        if (self.mArr_reply.count>=20) {
            int a = (int)self.mArr_reply.count/20+1;
            [[LoginSendHttp getInstance] wait_unReadMsgWithTag:9 page:[NSString stringWithFormat:@"%d",a]];
            [self ProgressViewLoad];
        } else {
            [self loadNoMore];
        }
    }else if (self.mInt_index == 4){
        if (self.mArr_mySend.count>=20) {
            int a = (int)self.mArr_mySend.count/20+1;
            [[LoginSendHttp getInstance] getMyselfSendMsgWithPage:[NSString stringWithFormat:@"%d",a]];
            [self ProgressViewLoad];
        } else {
            [self loadNoMore];
        }
    }
}

//刚进入学校圈，或者下拉刷新时执行
-(void)tableViewDownReloadData{
    if (self.mInt_index == 0) {
        [[LoginSendHttp getInstance] wait_unReadMsgWithTag:0 page:@"1"];
        [self ProgressViewLoad];
    }else if (self.mInt_index == 1){
        [[LoginSendHttp getInstance] wait_unReadMsgWithTag:6 page:@"1"];
        [self ProgressViewLoad];
    }else if (self.mInt_index == 2){
        [[LoginSendHttp getInstance] wait_unReadMsgWithTag:8 page:@"1"];
        [self ProgressViewLoad];
    }else if (self.mInt_index == 3){
        [[LoginSendHttp getInstance] wait_unReadMsgWithTag:9 page:@"1"];
        [self ProgressViewLoad];
    }else if (self.mInt_index == 4){
        [[LoginSendHttp getInstance] getMyselfSendMsgWithPage:@"1"];
        [self ProgressViewLoad];
    }
}

-(void)ProgressViewLoad{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    self.mProgressV.mode = MBProgressHUDModeIndeterminate;
    self.mProgressV.labelText = @"加载中...";
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

-(void)loadNoMore{
    [self.mTableV_list headerEndRefreshing];
    [self.mTableV_list footerEndRefreshing];
    self.mProgressV.mode = MBProgressHUDModeCustomView;
    self.mProgressV.labelText = @"没有更多了";
    [self.mProgressV show:YES];
    [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
}

-(void)noMore{
    sleep(1);
}

- (void)Loading {
    [self.mTableV_list headerEndRefreshing];
    [self.mTableV_list footerEndRefreshing];
    sleep(TIMEOUT);
    self.mProgressV.mode = MBProgressHUDModeCustomView;
    self.mProgressV.labelText = @"加载超时";
    sleep(2);
}

@end
