//
//  AppDelegate.h
//  JiaoBao
//
//  Created by Zqw on 14-10-18.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "RootViewController.h"
#import "InternetApplicationsViewController.h"
#import "RegisterViewController.h"
#import "dm.h"
#import "Loger.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
//    RootViewController *mRoot_view;
    InternetApplicationsViewController *mInternet;
    RegisterViewController *mRegister_view;
    int mInt_index;//当往数组中添加数据时，记录当前的readflag
}

//@property (nonatomic,strong) RootViewController *mRoot_view;
@property (nonatomic,strong) InternetApplicationsViewController *mInternet;
@property (nonatomic,strong) RegisterViewController *mRegister_view;
@property (nonatomic,assign) int mInt_index;//当往数组中添加数据时，记录当前的readflag

@property (strong, nonatomic) UIWindow *window;
@property (retain,nonatomic) UINavigationController *navigationController;


@end

