//
//  RecordViewController.h
//  JiaoBao
//
//  Created by songyanming on 15/3/20.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "utils.h"
#import "dm.h"
#import "MBProgressHUD.h"

@interface RecordViewController : UIViewController<MyNavigationDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property(nonatomic,strong)NSDate *currentDate;
@property(nonatomic,assign)BOOL firstFlag;
@property(nonatomic,strong)NSString *strFlag;

- (IBAction)leftBtnAction:(id)sender;
- (IBAction)rightBtnAction:(id)sender;
- (IBAction)minusYearAction:(id)sender;
- (IBAction)addYearAction:(id)sender;

@end
