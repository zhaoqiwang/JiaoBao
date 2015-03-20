//
//  SignInViewController.h
//  JiaoBao
//
//  Created by songyanming on 15/3/5.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "utils.h"
#import "dm.h"
#import "MBProgressHUD.h"



@interface SignInViewController : UIViewController<MyNavigationDelegate>

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条

- (IBAction)leftBtnAction:(id)sender;
- (IBAction)rightBtnAction:(id)sender;
- (IBAction)minusYearAction:(id)sender;
- (IBAction)addYearAction:(id)sender;

@end
