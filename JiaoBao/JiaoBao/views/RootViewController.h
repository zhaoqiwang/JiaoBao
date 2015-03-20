//
//  RootViewController.h
//  JiaoBao
//
//  Created by Zqw on 14-10-18.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabbarView.h"
#import "InternetApplicationsViewController.h"
#import "StudentFileViewController.h"
#import "ApplicationCenterViewController.h"

@interface RootViewController : UIViewController<TabbarViewDelegate,MBProgressHUDDelegate>{
    TabbarView *mTabbar_view;//自定义tabbar
    NSMutableArray *mArr_views;//放root中所有的viewC
    InternetApplicationsViewController *mViewC_appcation;
    StudentFileViewController *mViewC_studentFile;
    ApplicationCenterViewController *mViewC_center;
    MBProgressHUD *mProgressV;//
}
@property (strong,nonatomic) TabbarView *mTabbar_view;//自定义tabbar
@property (strong,nonatomic) NSMutableArray *mArr_views;//放root中所有的viewC
@property (strong,nonatomic) InternetApplicationsViewController *mViewC_appcation;
@property (strong,nonatomic) StudentFileViewController *mViewC_studentFile;
@property (strong,nonatomic) ApplicationCenterViewController *mViewC_center;
@property (nonatomic,strong) MBProgressHUD *mProgressV;//

@end
