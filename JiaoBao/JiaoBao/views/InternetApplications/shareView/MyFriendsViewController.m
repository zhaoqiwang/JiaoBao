//
//  MyFriendsViewController.m
//  JiaoBao
//
//  Created by Zqw on 14-12-16.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "MyFriendsViewController.h"
#import "Reachability.h"
#import "MobClick.h"
@interface MyFriendsViewController ()

@end

@implementation MyFriendsViewController
@synthesize mArr_friends,mTableV_friends,mNav_navgationBar,mStr_title,mInt_flag;

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    //获取到该用户的所有好友通知
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
    //获取到该用户的所有好友通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetMyFriends" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetMyFriends:) name:@"GetMyFriends" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mArr_friends = [NSMutableArray array];
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:self.mStr_title];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    
    self.mTableV_friends.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height-[dm getInstance].statusBar, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height+[dm getInstance].statusBar);
    
    [self sendRequest];
}

-(void)sendRequest{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    //发送请求
    if (self.mInt_flag == 1) {//好友
        [[ShowHttp getInstance] showHttpGetMyFriends:[dm getInstance].jiaoBaoHao];
    }else if (self.mInt_flag == 2){//关注
        [[ShowHttp getInstance] showHttpGetMyAttFriends:[dm getInstance].jiaoBaoHao];
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

//获取到该用户的所有好友通知
-(void)GetMyFriends:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSMutableDictionary *dic = noti.object;
    NSString *flag = [dic objectForKey:@"flag"];
    if ([flag integerValue]==0) {
        self.mArr_friends = [dic objectForKey:@"array"];
        [self.mTableV_friends reloadData];
    }else{
        [MBProgressHUD showError:@"" toView:self.view];
    }
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mArr_friends.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"TopArthListCell";
    TopArthListCell *cell = (TopArthListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TopArthListCell" owner:self options:nil] lastObject];
        cell.frame = CGRectMake(0, 0, [dm getInstance].width, 50);
    }
    FriendSpaceModel *model = [self.mArr_friends objectAtIndex:indexPath.row];

    [cell.mImgV_headImg sd_setImageWithURL:(NSURL *)[NSString stringWithFormat:@"%@%@",AccIDImg,model.Friendjiaobaohao] placeholderImage:[UIImage  imageNamed:@"root_img"]];
    D("cellforrowm-====%@,",model.Friendjiaobaohao);
    //标题
    CGSize numSize = [[NSString stringWithFormat:@"%@",model.Friendjiaobaohao] sizeWithFont:[UIFont systemFontOfSize:14]];
    cell.mLab_title.frame = CGRectMake(cell.mLab_title.frame.origin.x, 15, [dm getInstance].width-cell.mImgV_headImg.frame.size.width-23, numSize.height);
    cell.mLab_title.text = model.Friendjiaobaohao;
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

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FriendSpaceModel *friendModel = [self.mArr_friends objectAtIndex:indexPath.row];
    UserInfoByUnitIDModel *model = [[UserInfoByUnitIDModel alloc] init];
    model.AccID = friendModel.Friendjiaobaohao;
    model.UserName = friendModel.Friendjiaobaohao;
    PersonalSpaceViewController *personal = [[PersonalSpaceViewController alloc] init];
    personal.mModel_personal = model;
    [utils pushViewController:personal animated:YES];
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
