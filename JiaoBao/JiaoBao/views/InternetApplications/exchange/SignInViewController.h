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
@property(nonatomic,strong)NSArray *dateArr;
@property(nonatomic,strong)NSString *strFlag;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
- (IBAction)leftBtnAction:(id)sender;
- (IBAction)rightBtnAction:(id)sender;
- (IBAction)minusYearAction:(id)sender;
- (IBAction)addYearAction:(id)sender;

@end
