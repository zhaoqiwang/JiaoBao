//
//  OpenFileViewController.m
//  JiaoBao
//
//  Created by Zqw on 15/5/16.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "OpenFileViewController.h"
#import "define_constant.h"
#import <UMAnalytics/MobClick.h>
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
    NSArray * rslt = [self.mStr_name componentsSeparatedByString:@"."];//在“.”的位置将文件名分成几块
    NSString * fileType = [rslt objectAtIndex:[rslt count]-1];//找到最后一块，即为后缀名
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *tempPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"file-%@",[dm getInstance].jiaoBaoHao]];
    NSString * mStr_filePath = [NSString stringWithFormat:@"%@/%@",tempPath,self.mStr_name];
//    [self checkEncodingWithfilePath:mStr_filePath];
    NSURL *url = [NSURL fileURLWithPath:mStr_filePath isDirectory:YES];
    //打开图片类型
    if ([fileType isEqual:@"png"]||[fileType isEqual: @"gif"]||[fileType isEqual:@"bmp"]||[fileType isEqual:@"jpg"]||[fileType isEqual:@"jpeg"]) {
        //编码图片
        UIImage *selectedImage = [UIImage imageWithContentsOfFile:mStr_filePath];
        NSString *stringImage = [self htmlForJPGImage:selectedImage];
        
        //构造内容
        NSString *contentImg = [NSString stringWithFormat:@"%@", stringImage];
        NSString *content =[NSString stringWithFormat:
                            @"<html>"
                            "<style type=\"text/css\">"
                            "<!--"
                            "body{font-size:40pt;line-height:60pt;}"
                            "-->"
                            "</style>"
                            "<body>"
                            "%@"
                            "</body>"
                            "</html>"
                            , contentImg];
        
        //让self.contentWebView加载content
        [self.mWebView loadHTMLString:content baseURL:nil];
    }else if ([fileType isEqual:@"txt"]){
        NSString *htmlString = [NSString stringWithContentsOfFile:mStr_filePath encoding:NSUTF8StringEncoding error:nil];
        if (htmlString.length>0) {
            [self.mWebView loadHTMLString:htmlString baseURL:nil];
        }else{
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [self.mWebView loadRequest:request];
        }
    }else{
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.mWebView loadRequest:request];
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
//    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%d, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", [dm getInstance].width];
//    [webView stringByEvaluatingJavaScriptFromString:meta];
}
-(NSString *)checkEncodingWithfilePath:(NSString *)filePath{
    
    @autoreleasepool {
        
        NSArray *arrEncoding = @[@(NSASCIIStringEncoding),
                                 @(NSNEXTSTEPStringEncoding),
                                 @(NSJapaneseEUCStringEncoding),
                                 @(NSUTF8StringEncoding),
                                 @(NSISOLatin1StringEncoding),
                                 @(NSSymbolStringEncoding),
                                 @(NSNonLossyASCIIStringEncoding),
                                 @(NSShiftJISStringEncoding),
                                 @(NSISOLatin2StringEncoding),
                                 @(NSUnicodeStringEncoding),
                                 @(NSWindowsCP1251StringEncoding),
                                 @(NSWindowsCP1252StringEncoding),
                                 @(NSWindowsCP1253StringEncoding),
                                 @(NSWindowsCP1254StringEncoding),
                                 @(NSWindowsCP1250StringEncoding),
                                 @(NSISO2022JPStringEncoding),
                                 @(NSMacOSRomanStringEncoding),
                                 @(NSUTF16StringEncoding),
                                 @(NSUTF16BigEndianStringEncoding),
                                 @(NSUTF16LittleEndianStringEncoding),
                                 @(NSUTF32StringEncoding),
                                 @(NSUTF32BigEndianStringEncoding),
                                 @(NSUTF32LittleEndianStringEncoding)
                                 ];
        
        NSArray *arrEncodingName = @[@"NSASCIIStringEncoding",
                                     @"NSNEXTSTEPStringEncoding",
                                     @"NSJapaneseEUCStringEncoding",
                                     @"NSUTF8StringEncoding",
                                     @"NSISOLatin1StringEncoding",
                                     @"NSSymbolStringEncoding",
                                     @"NSNonLossyASCIIStringEncoding",
                                     @"NSShiftJISStringEncoding",
                                     @"NSISOLatin2StringEncoding",
                                     @"NSUnicodeStringEncoding",
                                     @"NSWindowsCP1251StringEncoding",
                                     @"NSWindowsCP1252StringEncoding",
                                     @"NSWindowsCP1253StringEncoding",
                                     @"NSWindowsCP1254StringEncoding",
                                     @"NSWindowsCP1250StringEncoding",
                                     @"NSISO2022JPStringEncoding",
                                     @"NSMacOSRomanStringEncoding",
                                     @"NSUTF16StringEncoding",
                                     @"NSUTF16BigEndianStringEncoding",
                                     @"NSUTF16LittleEndianStringEncoding",
                                     @"NSUTF32StringEncoding",
                                     @"NSUTF32BigEndianStringEncoding",
                                     @"NSUTF32LittleEndianStringEncoding"
                                     ];
        
        for (int i = 0 ; i < [arrEncoding count]; i++) {
            unsigned long encodingCode = [arrEncoding[i] unsignedLongValue];
            NSLog(@"(%@)", arrEncodingName[i]);
            NSError *error = nil;
            NSString *filePath1 = filePath; // <---这里是要查看的文件路径
            NSString *aString = [NSString stringWithContentsOfFile:filePath1 encoding:encodingCode  error:&error];
            NSLog(@"Error:%@,%lu,%@", [error localizedDescription],(unsigned long)aString.length,aString);
            NSData *data = [aString dataUsingEncoding:encodingCode];
            NSString *string = [[NSString alloc] initWithData:data encoding:encodingCode];
            NSLog(@"%@", string);
            
            /*
             // 如果有必要，还可以把文件创建出来再测试
             [string writeToFile:[NSString stringWithFormat:@"/Users/dlios1/Desktop/%@.xml", arrEncodingName[i]]
             atomically:YES
             encoding:encodingCode
             error:&error];
             */
        }
    }
    return 0;
}
//编码图片
- (NSString *)htmlForJPGImage:(UIImage *)image
{
    NSData *imageData = UIImageJPEGRepresentation(image,1.0);
    NSString *imageSource = [NSString stringWithFormat:@"data:image/jpg;base64,%@",[imageData base64Encoding]];
    return [NSString stringWithFormat:@"<img src = \"%@\" width=100%% />", imageSource];
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
