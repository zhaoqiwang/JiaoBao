//
//  OpenFileViewController.m
//  JiaoBao
//
//  Created by Zqw on 15/5/16.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "OpenFileViewController.h"
#import "define_constant.h"
#import "MobClick.h"
@interface OpenFileViewController ()

@end

@implementation OpenFileViewController
@synthesize mStr_name,mNav_navgationBar,mWebView;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:UMMESSAGE];
    [MobClick beginLogPageView:UMPAGE];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:UMMESSAGE];
    [MobClick endLogPageView:UMPAGE];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:self.mStr_name];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    
    [self.view addSubview:self.mNav_navgationBar];
    
    self.mWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, self.mNav_navgationBar.frame.size.height, 320, [dm getInstance].height-self.mNav_navgationBar.frame.size.height)];
    self.mWebView.delegate=self;
    [self.mWebView setBackgroundColor:[UIColor whiteColor]];
//    self.mWebView.contentMode = UIViewContentModeScaleToFill;
//    self.mWebView.contentStretch = CGRectFromString(@"{{0, 0}, {1, 1}}");
//    self.mWebView.autoresizesSubviews = YES;
//    self.mWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.mWebView setUserInteractionEnabled: YES ];  //是否支持交互
//    [self.mWebView setContentMode:UIViewContentModeScaleAspectFill];
    [self.mWebView setScalesPageToFit:YES];
    [self.view addSubview:self.mWebView];
    
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    //设置为播放和录音状态，以便可以在录制完之后播放录音
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
    
    [self openFile];
}

-(void)openFile{
//    NSArray * rslt = [self.mStr_name componentsSeparatedByString:@"."];//在“.”的位置将文件名分成几块
//    NSString * fileType = [rslt objectAtIndex:[rslt count]-1];//找到最后一块，即为后缀名
    
    //    if ([fileType isEqual:@"doc"]||[fileType isEqual: @"docx"]||[fileType isEqual:@"pdf"]||[fileType isEqual:@"mp4"]||[fileType isEqual:@"wav"]||[fileType isEqual:@"txt"]||[fileType isEqual:@"xls"]||[fileType isEqual:@"xlsx"]||[fileType isEqual:@"ppt"]||[fileType isEqual:@"pptx"]||[fileType isEqual:@"avi"]||[fileType isEqual:@"htm"]||[fileType isEqual:@"html"]||[fileType isEqual:@"pps"]||[fileType isEqual:@"m4v"]) {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *tempPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"file-%@",[dm getInstance].jiaoBaoHao]];
    NSString * mStr_filePath = [NSString stringWithFormat:@"%@/%@",tempPath,self.mStr_name];
    
    NSURL *url = [NSURL fileURLWithPath:mStr_filePath isDirectory:YES];
    
    if ([[self mimeType:url] isEqualToString:@"text/csv"]) {
        // 服务器的响应对象,服务器接收到请求返回给客户端的
        NSURLResponse *respnose = nil;
        NSData *data = [NSData dataWithContentsOfFile:mStr_filePath];

        // 在iOS开发中,如果不是特殊要求,所有的文本编码都是用UTF8
        // 先用UTF8解释接收到的二进制数据流
        [self.mWebView loadData:data MIMEType:respnose.MIMEType textEncodingName:@"GBK" baseURL:nil];
    }else{
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.mWebView loadRequest:request];
    }
//    else {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"此文件格式打不开" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        alert.tag = 11;
//        [alert show];
//    }
}

#pragma mark 获取指定URL的MIMEType类型
- (NSString *)mimeType:(NSURL *)url
{
    //1NSURLRequest
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //2NSURLConnection
    
    //3 在NSURLResponse里，服务器告诉浏览器用什么方式打开文件。
    
    //使用同步方法后去MIMEType
    NSURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    return response.MIMEType;
}

//导航条返回按钮
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
