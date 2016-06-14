//
//  OpenFileViewController.h
//  JiaoBao
//  打开附件界面
//  Created by Zqw on 15/5/16.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "dm.h"
#import "utils.h"
#import <AVFoundation/AVFoundation.h>

@interface OpenFileViewController : UIViewController<MyNavigationDelegate,UIWebViewDelegate>{
    MyNavigationBar *mNav_navgationBar;//导航条
    UIWebView *mWebView;
    NSString *mStr_name;//fileName
}

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) UIWebView *mWebView;
@property (nonatomic,strong) NSString *mStr_name;//fileName

@end
