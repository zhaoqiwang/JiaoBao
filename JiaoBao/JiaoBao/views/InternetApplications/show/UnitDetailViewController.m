//
//  UnitDetailViewController.m
//  JiaoBao
//
//  Created by Zqw on 14-12-14.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "UnitDetailViewController.h"
#import "Reachability.h"

@interface UnitDetailViewController ()

@end

@implementation UnitDetailViewController
@synthesize mModel_unit,mNav_navgationBar,mWebV_js;

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    mWebV_js.delegate = nil;
    [mWebV_js loadHTMLString:@"" baseURL:nil];
    [mWebV_js stopLoading];
    [mWebV_js removeFromSuperview];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //将获取到的简介，推送到界面
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Getintroduce" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Getintroduce:) name:@"Getintroduce" object:nil];
}

-(void)dealloc{
    mWebV_js.delegate = nil;
    [mWebV_js loadHTMLString:@"" baseURL:nil];
    [mWebV_js stopLoading];
    [mWebV_js removeFromSuperview];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
    
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:self.mModel_unit.UnitName];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    
    self.mWebV_js.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height-[dm getInstance].statusBar, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height+[dm getInstance].statusBar);
    
    //设置webview属性
    self.mWebV_js.scalesPageToFit = NO;
//    [self.mWebV_js.scrollView setScrollEnabled:YES];
    //发送请求
    D("单位简介。。。。-====%@，%@",self.mModel_unit.UnitID,self.mModel_unit.UnitType);
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

-(void)sendRequest{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    [[ShowHttp getInstance] showHttpGetintroduce:self.mModel_unit.UnitID uTyper:self.mModel_unit.UnitType];
    [MBProgressHUD showMessage:@"" toView:self.view];
}

//文章详情通知
-(void)Getintroduce:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSString *str = noti.object;
    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    NSString *string1 = [str substringToIndex:1];//从字符串的开头一直截取到指定的位置,但不包括该位置的字符
    NSString *string2 = [str substringFromIndex:str.length-1];// 以指定位置开始（包括指定位置的字符），并包括之后的全部字符
    if ([string2 isEqual:@"\""]) {
        str = [str substringToIndex:str.length-1];
    }
    if ([string1 isEqual:@"\""]) {
        str = [str substringFromIndex:1];
    }
    str = [str stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
    str = [str stringByReplacingOccurrencesOfString:@"nowrap" withString:@"no wrap"];
    str = [str stringByReplacingOccurrencesOfString:@"normal" withString:@"no rmal"];
    str = [str stringByReplacingOccurrencesOfString:@"top: -" withString:@"top: +"];
    str = [str stringByReplacingOccurrencesOfString:@"top:-" withString:@"top:+"];
    str = [str stringByReplacingOccurrencesOfString:@"data-src" withString:@"src"];
    str = [str stringByReplacingOccurrencesOfString:@"width=\"auto\" _width=\"auto\"" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"width: auto" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"width:auto" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\\n" withString:@"<br/>"];
    str = [str stringByReplacingOccurrencesOfString:@"table width=\"100%\"" withString:@"table"];
    str = [str stringByReplacingOccurrencesOfString:@"width:" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"<img" withString:@"<img width=\"310\"; height\"200\"; "];
    
    [self.mWebV_js loadHTMLString:str baseURL:baseURL];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:self.view];
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
//    CGFloat webViewHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"]floatValue];
    
}



//导航条返回按钮回调
-(void)myNavigationGoback{
    [utils popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
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
