//
//  AppDelegate.m
//  JiaoBao
//
//  Created by Zqw on 14-10-18.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "AppDelegate.h"
#import "UncaughtExceptionHandler.h"
#import "Reachability.h"
#import<AVFoundation/AVFoundation.h>
#import "IQKeyboardManager.h"

//CLLocationManager *locationManager;

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize mInternet,mRegister_view,mInt_index;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [IQKeyboardManager sharedManager].enable = NO;//控制整个功能是否启用
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;//控制是否显示键盘上的工具条
    //友盟统计
    [MobClick setAppVersion:XcodeAppVersion];//参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    [MobClick startWithAppkey:@"559dd7ea67e58e790d00625c" reportPolicy:BATCH   channelId:@"test"];//channelId默认会被被当作@"App Store"渠道
    //初始化
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *tempPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"file-%@",[dm getInstance].jiaoBaoHao]];
    D("tempPath-====%@",tempPath);

    BMKMapManager *mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [mapManager start:@"iqYoKFAodVcfY8oRpi0KtuHs"  generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    {{0, 0}, {375, 667}}  {{0, 0}, {414, 736}}    {{0, 0}, {320, 568}} 13964035770  5150028  ghost0726
    D("self.window-== %@",NSStringFromCGRect(self.window.frame));
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    //全局异常捕获,bug服务器
    InstallUncaughtExceptionHandler();
    //添加网络切换时的处理
//    Reachability *_internetReach = [Reachability reachabilityForInternetConnection];
//    [_internetReach startNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    
    [dm getInstance].mStr_unit = @"暂无";
    [dm getInstance].name = @"新用户";
    //百度地图
//    BMKMapManager *mapManager = [[BMKMapManager alloc]init];
//    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
//    BOOL ret = [mapManager start:@"在此处输入您的授权Key"  generalDelegate:nil];
//    if (!ret) {
//        NSLog(@"manager start failed!");
//    }
    
    //webview内存问题
    int cacheSizeMemory = 1*1024*1024; // 4MB
    int cacheSizeDisk = 5*1024*1024; // 32MB
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
    [NSURLCache setSharedURLCache:sharedCache];
    
    //记录当前手机的宽高
    [dm getInstance].width = self.window.frame.size.width;
    [dm getInstance].height = self.window.frame.size.height;
    //根据系统版本，做状态栏的值
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0) {
        [dm getInstance].statusBar = 20;
    }else{
        [dm getInstance].statusBar = 0;
    }
    if (SHOWRONGYUN == 1) {
        if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge
                                                                                                 |UIRemoteNotificationTypeSound
                                                                                                 |UIRemoteNotificationTypeAlert) categories:nil];
            [application registerUserNotificationSettings:settings];
        } else {
            UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
            [application registerForRemoteNotificationTypes:myTypes];
        }
    }
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"registeredSuccessfully" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(registeredSuccessfully) name:@"registeredSuccessfully" object:nil];//注册成功跳转主界面通知
    //默认登录成功则记住密码
    [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:@"rememberPassWD"];
    //切换账号时，更新数据
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RegisterView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RegisterView:) name:@"RegisterView" object:nil];
    //通知到界面得到的分组
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ExchangeGetUnitGroups" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ExchangeGetUnitGroups:) name:@"ExchangeGetUnitGroups" object:nil];
    
    //生成唯一的UUID
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"UUID"] isEqual:@""]||[[NSUserDefaults standardUserDefaults]objectForKey:@"UUID"] == NULL) {
        [[NSUserDefaults standardUserDefaults] setValue:[utils uuid] forKey:@"UUID"];
    }
    //判断是否有客户端密钥，没有的话，向服务器发送通知
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"ClientKey"] isEqual:@""]||[[NSUserDefaults standardUserDefaults]objectForKey:@"ClientKey"] == NULL) {
        //先生成随机UUID
        NSString *tempKey = [utils uuid];
        //截取八位作为key
        [dm getInstance].uuid = [tempKey substringWithRange:NSMakeRange(3,8)];
        //向服务器发送注册通知
        [[LoginSendHttp getInstance] getTime:@"1"];
        [LoginSendHttp getInstance].flag_request = 1;
        [LoginSendHttp getInstance].flag_skip = 1;
    }
//    64e1a9aac22343acb664a8e8d31a35a1074aa0b2
    //判断应该进入哪个界面
    D("Register = %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"Register"]);
    NSString *tempName = [[NSUserDefaults standardUserDefaults]objectForKey:@"UserName"];
    NSString *tempPassWD = [[NSUserDefaults standardUserDefaults]objectForKey:@"PassWD"];
    D("UserName-==== %@,%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"],[[NSUserDefaults standardUserDefaults] valueForKey:@"PassWD"]);
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"Register"] isEqual:@"OK"]&&tempName.length>0&&tempPassWD.length>0) {//走主界面
        [[LoginSendHttp getInstance] hands_login];
        [LoginSendHttp getInstance].flag_skip = 2;
//        mRoot_view = [[RootViewController alloc]init];
        mInternet = [[InternetApplicationsViewController alloc] init];
        UINavigationController * aNa = [[UINavigationController alloc]initWithRootViewController:self.mInternet];
        [aNa setNavigationBarHidden:YES];
        self.navigationController = aNa;
        //走主界面
        [self.window addSubview:self.navigationController.view];
        self.window.rootViewController = self.navigationController;
    }else{
        //走登录界面
        mRegister_view = [[RegisterViewController alloc]init];
        [LoginSendHttp getInstance].flag_skip = 1;
        UINavigationController * aNa = [[UINavigationController alloc]initWithRootViewController:mRegister_view];
        [aNa setNavigationBarHidden:YES];
        self.window.rootViewController = aNa;
    }
    [self.window makeKeyAndVisible];
    return YES;
}
//友盟初始化
- (void)onlineConfigCallBack:(NSNotification *)note {
    D("online config has fininshed and note = %@", note.userInfo);
}

- (void)reachabilityChanged: (NSNotification* )note {
    Reachability *curReach = [note object];
    NetworkStatus networkStatus = [curReach currentReachabilityStatus];
    if (networkStatus == NotReachable) { //无网络状态
        D("111");
        //TODO
    } else { //有网络状态，3G或wifi
        NSString *tempName = [[NSUserDefaults standardUserDefaults]objectForKey:@"UserName"];
        NSString *tempPassWD = [[NSUserDefaults standardUserDefaults]objectForKey:@"PassWD"];
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"Register"] isEqual:@"OK"]&&tempName.length>0&&tempPassWD.length>0) {
            //走主界面
            //判断之前有没有登录成功
            if ([dm getInstance].url.length==0) {
                [[LoginSendHttp getInstance] hands_login];
                [LoginSendHttp getInstance].flag_skip = 2;
            }
        }
        D("222");
        //TODO
    }
}

//切换账号时，更新数据
-(void)RegisterView:(NSNotification *)noti{;
    [[dm getInstance].mArr_rongYunGroup removeAllObjects];
    [[dm getInstance].mArr_rongYunUser removeAllObjects];
    [[dm getInstance].mArr_unit_member removeAllObjects];
    [[dm getInstance].mArr_myFriends removeAllObjects];
    [[dm getInstance].mArr_unit_member removeAllObjects];
    self.mInt_index = 0;
}

//注册成功
-(void)registeredSuccessfully{
    [[NSUserDefaults standardUserDefaults] setValue:@"OK" forKey:@"Register"];
//    mRoot_view = [[RootViewController alloc]init];
    mInternet = [[InternetApplicationsViewController alloc] init];
    UINavigationController * aNa = [[UINavigationController alloc]initWithRootViewController:self.mInternet];
    [aNa setNavigationBarHidden:YES];
    self.navigationController = aNa;
    //走主界面
    self.window.rootViewController = aNa;
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    // Register to receive notifications.
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    // Handle the actions.
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif

//加载获取到得单位
//-(void)getUnitInfoShow:(NSNotification *)noti{
//    NSMutableArray *array = noti.object;
//    //开启线程加载数据
//    NSThread *tempThread = [[NSThread alloc] initWithTarget:self selector:@selector(AddUnit:) object:array];
//    [tempThread start];
//}

//向dm中加载获取到得单位
-(void)getUnitInfoToDM:(NSMutableArray *)array{
    [[dm getInstance].mArr_unit_member removeAllObjects];
    for (int i=0; i<array.count; i++) {
        UnitSectionMessageModel *model = [array objectAtIndex:i];
        D("UnitSectionMessageModel-=--===%@",model.UnitID);
        if ([model.IsMyUnit isEqual:@"1"]) {
            //发送获取当前单位分组的请求
            [[ExchangeHttp getInstance] exchangeHttpGetUnitGroupsWith:model.UnitID from:@""];
            //第0根节点
            TreeView_node *node0 = [[TreeView_node alloc]init];
            node0.nodeLevel = 0;
            node0.type = 0;
            node0.sonNodes = nil;
            node0.isExpanded = FALSE;
            node0.UID = model.UnitID;
            node0.readflag = self.mInt_index;
            self.mInt_index ++;
            TreeView_Level0_Model *temp0 =[[TreeView_Level0_Model alloc]init];
            temp0.mStr_name = model.UnitName;
            temp0.mStr_headImg = [NSString stringWithFormat:@"%@0",model.imgName];
            temp0.mStr_img_detail = @"root_detail";
            temp0.mStr_img_open_close = @"root_close";
            temp0.mInt_number = 0;
            temp0.mInt_show = 1;
            node0.nodeData = temp0;
            [[dm getInstance].mArr_unit_member addObject:node0];
        }
    }
}

//通知到界面得到的分组
-(void)ExchangeGetUnitGroups:(NSNotification *)noti{
    NSMutableDictionary *dic = noti.object;
//    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
//    NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
//    
//    if([ResultCode integerValue]!= 0)
//    {
//        [MBProgressHUD showError:ResultDesc toView:self.view];
//        return;
//    }
    NSString *uid = [dic objectForKey:@"UID"];
    NSMutableArray *array = [dic objectForKey:@"array"];
    D("exchangeUnitGroups-====%@",uid);
    for (int a= 0; a<[dm getInstance].mArr_unit_member.count; a++) {
        TreeView_node *node0 = [[dm getInstance].mArr_unit_member objectAtIndex:a];
        NSMutableArray *tempArr = [NSMutableArray array];
        if ([node0.UID intValue] == [uid intValue]) {//判断单位是否一样
            //获取到分组后，获取单位中的人
            [[ExchangeHttp getInstance] exchangeHttpGetUserUnfoByUnitIDWith:uid filter:@"0" from:@""];
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
                //        temp7.mStr_img_detail = @"root_detail";
                temp7.mStr_img_open_close = @"root_close";
                temp7.mInt_number = 0;
                node7.nodeData = temp7;
                [tempArr addObject:node7];
            }
            node0.sonNodes = [NSMutableArray arrayWithArray:tempArr];
        }
    }
}

//塞单位人员
-(void)ExchangeUserInfoByUnitIDToDM:(NSMutableDictionary *)dic{
    NSString *uid = [dic objectForKey:@"UID"];
    NSMutableArray *array = [dic objectForKey:@"array"];
    //对添加人员进行去重
    NSSet *set = [NSSet setWithArray:array];
    array = [NSMutableArray arrayWithArray:[set allObjects]];
    
    for (int a= 0; a<[dm getInstance].mArr_unit_member.count; a++) {//循环所有的单位
        TreeView_node *node0 = [[dm getInstance].mArr_unit_member objectAtIndex:a];
        if ([node0.UID intValue] == [uid intValue]) {//找到单位和通知里一样的
            for (int m=0; m<node0.sonNodes.count; m++) {//循环一样单位里面的所有分组
                TreeView_node *node1 = [node0.sonNodes objectAtIndex:m];
                NSMutableArray *tempArr = [NSMutableArray array];
                for (int n = 0; n<array.count; n++) {//循环通知里面的所有人员信息
                    UserInfoByUnitIDModel *userModel = [array objectAtIndex:n];
                    for (int b = 0; b<userModel.GroupFlag.count; b++) {//循环当前的人员中，有几个分组
                        if ([node1.UID isEqual:[userModel.GroupFlag objectAtIndex:b]]) {
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
                node1.sonNodes = [NSMutableArray arrayWithArray:tempArr];
            }
        }
    }
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication*)application{
//    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    // 清除内存中的图片缓存
//    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
//    [mgr cancelAll];
//    [mgr.imageCache clearMemory];
////    [[SDImageCache sharedImageCache] clearDisk];
//    [[SDImageCache sharedImageCache] clearMemory];
}
-(void)didReceiveMemoryWarnin{
//    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    // 清除内存中的图片缓存
//    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
//    [mgr cancelAll];
//    [mgr.imageCache clearMemory];
////    [[SDImageCache sharedImageCache] clearDisk];
//    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [BMKMapView willBackGround];

    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [BMKMapView didForeGround];

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    if (SHOWRONGYUN == 1) {
//        [UIApplication sharedApplication].applicationIconBadgeNumber = [[RCIM sharedRCIM] getTotalUnreadCount];
//        D("lskdhfaoghf;algnae;oghae;oifjae';kln;-===1111=====%d",[[RCIM sharedRCIM] getTotalUnreadCount]);
//    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//禁止横屏
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskPortrait;
}
//iOS8开始定位
//- (BOOL)beginLocationUpdate
//{
//    // 判断定位操作是否被允许
//    if([CLLocationManager locationServicesEnabled])
//    {
//        locationManager = [[CLLocationManager alloc] init];//注意，这里的locationManager不是局部变量
//        //兼容iOS8定位
//        SEL requestSelector = NSSelectorFromString(@"requestWhenInUseAuthorization");
//        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined &&
//            [locationManager respondsToSelector:requestSelector]) {
//            [locationManager requestWhenInUseAuthorization];
//        }
//        return YES;
//    }else {
//        //提示用户无法进行定位操作
//    }
//    return NO;
//}
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}


@end
