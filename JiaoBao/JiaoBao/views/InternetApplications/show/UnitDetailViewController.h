//
//  UnitDetailViewController.h
//  JiaoBao
//  单位简介
//  Created by Zqw on 14-12-14.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "dm.h"
#import "utils.h"
#import "TopArthListModel.h"
#import "ShareHttp.h"
#import "MBProgressHUD.h"

@interface UnitDetailViewController : UIViewController<MyNavigationDelegate,UIWebViewDelegate,MBProgressHUDDelegate>{
    MyNavigationBar *mNav_navgationBar;//导航条
    UIWebView *mWebV_js;
    UnitSectionMessageModel *mModel_unit;
    MBProgressHUD *mProgressV;//
}

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) IBOutlet UIWebView *mWebV_js;
@property (nonatomic,strong) UnitSectionMessageModel *mModel_unit;
@property (nonatomic,strong) MBProgressHUD *mProgressV;//

@end
