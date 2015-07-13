//
//  WorkView_new.m
//  JiaoBao
//
//  Created by Zqw on 15-2-9.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "WorkView_new.h"
#import "Reachability.h"
#import "UIImageView+WebCache.h"

@implementation WorkView_new
@synthesize mArr_list,mBtn_new,mTableV_list,mInt_index,mStr_lastID;

- (id)initWithFrame1:(CGRect)frame{
    self = [super init];
    if (self) {
        // Initialization code
        //获取我发送的消息列表
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetMySendMsgList" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetMySendMsgList:) name:@"GetMySendMsgList" object:nil];
        //取发给我消息的用户列表，new
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SendToMeUserList" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SendToMeUserList:) name:@"SendToMeUserList" object:nil];
        //切换账号时，更新数据
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RegisterView" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RegisterView:) name:@"RegisterView" object:nil];
        //获取到头像
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"exchangeGetFaceImg" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TopArthListIndexImg:) name:@"exchangeGetFaceImg" object:nil];
        self.frame = frame;
        self.mArr_list = [NSMutableArray array];
        self.mInt_index = 1;
        
        self.mTableV_list = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-51)];
        self.mTableV_list.delegate = self;
        self.mTableV_list.dataSource = self;
        self.mTableV_list.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.mTableV_list addHeaderWithTarget:self action:@selector(headerRereshing)];
        self.mTableV_list.headerPullToRefreshText = @"下拉刷新";
        self.mTableV_list.headerReleaseToRefreshText = @"松开后刷新";
        self.mTableV_list.headerRefreshingText = @"正在刷新...";
        [self addSubview:self.mTableV_list];
        self.mBtn_new = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *img_btn = [UIImage imageNamed:@"root_addBtn"];
        [self.mBtn_new setBackgroundImage:img_btn forState:UIControlStateNormal];
        self.mBtn_new.frame = CGRectMake(([dm getInstance].width-img_btn.size.width)/2, self.frame.size.height-51+(51-img_btn.size.height)/2, img_btn.size.width, img_btn.size.height);
        [self.mBtn_new setTitle:@"新建事务" forState:UIControlStateNormal];
        [self.mBtn_new setImage:[UIImage imageNamed:@"work_photo"] forState:UIControlStateNormal];
        self.mBtn_new.imageEdgeInsets = UIEdgeInsetsMake(4,self.mBtn_new.frame.size.width-65,0,0);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
        self.mBtn_new.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
        self.mBtn_new.titleEdgeInsets = UIEdgeInsetsMake(5, -60, 4, 0);
        [self.mBtn_new setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.mBtn_new addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.mBtn_new];
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

//获取到头像后，更新界面
-(void)TopArthListIndexImg:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self];
    [self.mTableV_list reloadData];
}

//
-(void)GetMySendMsgList:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self];
    NSMutableDictionary *dic = noti.object;
    NSString *flag = [dic objectForKey:@"flag"];
    if ([flag intValue] ==0) {//成功
        NSMutableArray *array = [dic objectForKey:@"array"];
        if (array.count>0) {
            if (self.mArr_list.count>0) {
                CommMsgListModel *model = [self.mArr_list objectAtIndex:0];
                if ([model.flag integerValue] != 0) {
                    CommMsgListModel *model = [array objectAtIndex:0];
                    [self.mArr_list insertObject:model atIndex:0];
                    [self.mTableV_list reloadData];
                }
            }
            if (self.mArr_list.count == 0) {
                CommMsgListModel *model = [array objectAtIndex:0];
                [self.mArr_list insertObject:model atIndex:0];
                [self.mTableV_list reloadData];
            }
        }
    }else{
        [MBProgressHUD showError:@"获取失败" toView:self];
    }
}

//
-(void)SendToMeUserList:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self];
    [self.mTableV_list headerEndRefreshing];
    [self.mTableV_list footerEndRefreshing];
    NSMutableDictionary *dic = noti.object;
    NSString *flag = [dic objectForKey:@"flag"];
    if ([flag intValue] ==0) {//成功
        SendToMeUserListModel *model = [dic objectForKey:@"model"];
        [self.mArr_list addObjectsFromArray:model.CommMsgList];
        [self.mTableV_list reloadData];
        //根据数值多少，做是否添加上拉判断
        if (model.LastID.length>0) {
            self.mStr_lastID = model.LastID;
            [self.mTableV_list addFooterWithTarget:self action:@selector(footerRereshing)];
            self.mTableV_list.footerPullToRefreshText = @"上拉加载更多";
            self.mTableV_list.footerReleaseToRefreshText = @"松开加载更多数据";
            self.mTableV_list.footerRefreshingText = @"正在加载...";
        }else{
            [self.mTableV_list removeFooter];
        }
    }else{
        [MBProgressHUD showError:@"获取失败" toView:self];
    }
}

-(void)clickBtn:(UIButton *)btn{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    D("点击新建事务、发布通知按钮");
    ForwardViewController *forward = [[ForwardViewController alloc] init];
    forward.mInt_forwardFlag = 1;
    forward.mInt_forwardAll = 2;
    forward.mInt_flag = 1;
    forward.mInt_all = 2;
    [utils pushViewController:forward animated:YES];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing{
    self.mInt_index = 1;
    //获取我发送的消息列表
    [[LoginSendHttp getInstance] login_GetMySendMsgList:@"1" Page:@"1" SendName:@"" sDate:@"" eDate:@""];
    //取发给我消息的用户列表，new
    [[LoginSendHttp getInstance] login_SendToMeUserList:@"20" Page:@"1" SendName:@"" sDate:@"" eDate:@"" readFlag:@"" lastId:@""];
    [self ProgressViewLoad];
    [self.mArr_list removeAllObjects];
    [self.mTableV_list reloadData];
}
- (void)footerRereshing{
    if (self.mArr_list.count>=21) {
        //检查当前网络是否可用
        if ([self checkNetWork]) {
            return;
        }
        self.mInt_index = (int)(self.mArr_list.count-1)/20+1;
        D("self.mint.page-====%lu %d",(unsigned long)self.mArr_list.count,self.mInt_index);
        //取发给我消息的用户列表，new
        [[LoginSendHttp getInstance] login_SendToMeUserList:@"20" Page:[NSString stringWithFormat:@"%d",self.mInt_index] SendName:@"" sDate:@"" eDate:@"" readFlag:@"" lastId:self.mStr_lastID];
        [self ProgressViewLoad];
    } else {
        [self.mTableV_list headerEndRefreshing];
        [self.mTableV_list footerEndRefreshing];
        [MBProgressHUD showError:@"没有更多了" toView:self];
    }
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mArr_list.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"WorkViewListCell";
    WorkViewListCell *cell = (WorkViewListCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WorkViewListCell" owner:self options:nil] lastObject];
        cell.frame = CGRectMake(0, 0, [dm getInstance].width, 54);
    }
    CommMsgListModel *model = [self.mArr_list objectAtIndex:indexPath.row];
    [cell.mImgV_head sd_setImageWithURL:(NSURL *)[NSString stringWithFormat:@"%@%@",AccIDImg,model.JiaoBaoHao] placeholderImage:[UIImage  imageNamed:@"root_img"]];

    cell.mImgV_head.frame = CGRectMake(10, 7, 40, 40);
    //未读数量
    if ([model.NoReadCount intValue]>0) {
        cell.mImgV_unRead.hidden = NO;
        cell.mLab_unRead.hidden = NO;
        CGSize unReadSize = [model.NoReadCount sizeWithFont:[UIFont systemFontOfSize:10]];
        cell.mImgV_unRead.frame = CGRectMake(42, 2, unReadSize.width+7, 15);
        cell.mLab_unRead.frame = cell.mImgV_unRead.frame;
        cell.mLab_unRead.text = model.NoReadCount;
    }else{
        cell.mImgV_unRead.hidden = YES;
        cell.mLab_unRead.hidden = YES;
    }
    //姓名
    NSString *name;
    if ([model.flag intValue] == 0) {
        name = @"我";
    }else if ([model.flag intValue] == 1){
        name = model.UserName;
    }
    CGSize nameSize = [[NSString stringWithFormat:@"%@",name] sizeWithFont:[UIFont systemFontOfSize:15]];
    cell.mLab_name.frame = CGRectMake(cell.mImgV_head.frame.origin.x+cell.mImgV_head.frame.size.width+10, 10, nameSize.width, 20);
    cell.mLab_name.text = name;
    //时间
    CGSize timeSize = [[NSString stringWithFormat:@"%@",model.RecDate] sizeWithFont:[UIFont systemFontOfSize:12]];
    cell.mLab_time.frame = CGRectMake([dm getInstance].width-timeSize.width-10, 10, timeSize.width, 20);
    cell.mLab_time.text = model.RecDate;
    //内容
    cell.mLab_content.text = model.MsgContent;
    cell.mLab_content.frame = CGRectMake(cell.mLab_name.frame.origin.x, cell.mLab_name.frame.origin.y+20, [dm getInstance].width-cell.mImgV_head.frame.size.width-30, 20);
    //分割线
    cell.mLab_line.frame = CGRectMake(0, 53, [dm getInstance].width, .5);
    
    return cell;
}
// 用于延时显示图片，以减少内存的使用
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    WorkViewListCell *cell2 = (WorkViewListCell *)cell;
    CommMsgListModel *model = [self.mArr_list objectAtIndex:indexPath.row];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //文件名
    NSString *imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",model.JiaoBaoHao]];
    UIImage *img= [UIImage imageWithContentsOfFile:imgPath];
    if (img.size.width>0) {
        [cell2.mImgV_head setImage:img];
    }else{
        [cell2.mImgV_head setImage:[UIImage imageNamed:@"root_img"]];
    }
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    return 54;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WorkMsgListViewController *work = [[WorkMsgListViewController alloc] init];
    CommMsgListModel *model = [self.mArr_list objectAtIndex:indexPath.row];
    if ([model.flag integerValue]==0) {
        work.mStr_name = @"我发送的信息";
        work.mStr_flag = model.NoReadCount;
    }else{
        work.mStr_name = model.UserName;
    }
    if (indexPath.row == 0) {
        work.mInt_our = 1;
    }else{
        work.mInt_our = 2;
    }
    work.mInt_flag = 1;
    work.mStr_tableID = model.TabIDStr;
    [utils pushViewController:work animated:YES];
}

//切换账号时，更新数据
-(void)RegisterView:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self];
    [self.mArr_list removeAllObjects];
    [self.mTableV_list reloadData];
}

@end
