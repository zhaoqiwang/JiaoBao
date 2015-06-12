//
//  OpenFileViewController.m
//  JiaoBao
//
//  Created by Zqw on 15/5/16.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "OpenFileViewController.h"
#import "define_constant.h"

@interface OpenFileViewController ()

@end

@implementation OpenFileViewController
@synthesize mStr_name,mNav_navgationBar,mWebView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
    
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
    
    [self openFile];
}

-(void)openFile{
    NSArray * rslt = [self.mStr_name componentsSeparatedByString:@"."];//在“.”的位置将文件名分成几块
    NSString * fileType = [rslt objectAtIndex:[rslt count]-1];//找到最后一块，即为后缀名
    
    if ([fileType isEqual:@"doc"]||[fileType isEqual: @"docx"]||[fileType isEqual:@"pdf"]||[fileType isEqual:@"mp4"]||[fileType isEqual:@"wav"]||[fileType isEqual:@"txt"]||[fileType isEqual:@"xls"]||[fileType isEqual:@"xlsx"]||[fileType isEqual:@"ppt"]||[fileType isEqual:@"pptx"]||[fileType isEqual:@"avi"]||[fileType isEqual:@"htm"]||[fileType isEqual:@"html"]||[fileType isEqual:@"pps"]) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *tempPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"file-%@",[dm getInstance].jiaoBaoHao]];
        NSString * mStr_filePath = [NSString stringWithFormat:@"%@/%@",tempPath,self.mStr_name];
        
        NSURL *url = [NSURL fileURLWithPath:mStr_filePath isDirectory:YES];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.mWebView loadRequest:request];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"此文件格式打不开" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        alert.tag = 11;
        [alert show];
    }
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
