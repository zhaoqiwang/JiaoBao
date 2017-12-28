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
#import "BBLaunchAdMonitor.h"
#import <UMCommon/UMCommon.h>           // 公共组件是所有友盟产品的基础组件，必选
#import <UMAnalytics/MobClick.h>        // 统计组件

//CLLocationManager *locationManager;

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize mInternet,mRegister_view,mInt_index;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [IQKeyboardManager sharedManager].enable = NO;//控制整个功能是否启用
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;//控制是否显示键盘上的工具条
    //友盟统计
    [UMConfigure setEncryptEnabled:YES]; // optional: 设置加密传输, 默认NO
    [UMConfigure initWithAppkey:@"559dd7ea67e58e790d00625c" channel:@"App Store"];
    // 统计组件配置
    [MobClick setScenarioType:E_UM_NORMAL];
    //初始化方法,也可以使用(void)startWithAppkey:(NSString *)appKey launchOptions:(NSDictionary * )launchOptions httpsenable:(BOOL)value;这个方法，方便设置https请求。
    [UMessage startWithAppkey:@"559dd7ea67e58e790d00625c" launchOptions:launchOptions httpsenable:YES];
    //注册通知，如果要使用category的自定义策略，可以参考demo中的代码。
    [UMessage registerForRemoteNotifications];
    
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
    //打开日志，方便调试
    [UMessage setLogEnabled:YES];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *tempPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"file-%@",[dm getInstance].jiaoBaoHao]];
    D("tempPath-====%@",tempPath);
//    [[SDWebImageManager sharedManager].imageCache clearMemory];
//    [[SDWebImageManager sharedManager].imageCache clearDisk];
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
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(checkNetworkStatus:)
     
                                                 name:kReachabilityChangedNotification object:nil];
    
    // Override point for customization after application launch.
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAdDetail:) name:BBLaunchAdDetailDisplayNotification object:nil];
//    NSString *path = @"http://qn-edures.jiaobaowang.net/zypt/gx-k12/dongman/img/img-0-0-61403.png?e=1503996986&token=SDtQBeriWyCnNor8FnDFuRYWuvlsZ1xbPYQkLFT0:hlT_mlT25c-mg7zXp4QMvx8CzK0=";
//    [BBLaunchAdMonitor showAdAtPath:path
//                             onView:self.window.rootViewController.view
//                       timeInterval:5.
//                   detailParameters:@{@"carId":@(12345), @"name":@"奥迪-品质生活"}];
    
    internetReachable = [Reachability reachabilityForInternetConnection];
    
    [internetReachable startNotifier];
//    Reachability *_internetReach = [Reachability reachabilityForInternetConnection];
//    [_internetReach startNotifier];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    
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
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    NSLog(@"status width - %f", rectStatus.size.width); // 宽度
    NSLog(@"status height - %f", rectStatus.size.height); // 高度
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0) {
        [dm getInstance].statusBar = rectStatus.size.height;
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
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}
- (void)showAdDetail:(NSNotification *)noti
{
    NSLog(@"detail parameters:%@", noti.object);
}

//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //关闭U-Push自带的弹出框
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    
    //    self.userInfo = userInfo;
    //    //定制自定的的弹出框
    //    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    //    {
    //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"标题"
    //                                                            message:@"Test On ApplicationStateActive"
    //                                                           delegate:self
    //                                                  cancelButtonTitle:@"确定"
    //                                                  otherButtonTitles:nil];
    //
    //        [alertView show];
    //
    //    }
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
}

//友盟初始化
- (void)onlineConfigCallBack:(NSNotification *)note {
    D("online config has fininshed and note = %@", note.userInfo);
}
- (void)checkNetworkStatus:(NSNotification *)notice {
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    
    {
        case NotReachable:
            
        {
            [MBProgressHUD showError:@"网络连接异常" ];
            NSLog(@"The internet is down.");
            break;
            
        }
            
        case ReachableViaWiFi:
            
        {
            [MBProgressHUD showError:@"接入wifi网络" ];
            NSLog(@"The internet is working via WIFI");
            break;
            
        }
            
        case ReachableViaWWAN:
            
        {
            [MBProgressHUD showError:@"接入wwan网络" ];
            
            NSLog(@"The internet is working via WWAN!");
            break;
            
        }
            
    }
    
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

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "JSY.___" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

/**
 *  当一个指定的URL资源打开时调用，iOS9之前
 *
 *  @param url               指定的url
 *  @param sourceApplication 请求打开应用的bundle ID
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"url : %@",url);
    
    NSLog(@"sourceApplication : %@",sourceApplication);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[url absoluteString]
                                                    message:sourceApplication
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OtherBtn",nil];
    [alert show];
    
    return YES;
}
/**
 *  当一个指定的URL资源打开时调用，iOS9之后
 *
 *  @param url     指定的url
 *  @param options 打开选项，其中通过UIApplicationOpenURLOptionsSourceApplicationKey获得sourceApplication
 */
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    NSLog(@"url : %@",url);
    
    NSString *sourceApplication = options[UIApplicationOpenURLOptionsSourceApplicationKey];
    NSLog(@"sourceApplication : %@",sourceApplication);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[url absoluteString]
                                                    message:sourceApplication
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:nil];
    [alert show];
    
    return YES;
}



@end
