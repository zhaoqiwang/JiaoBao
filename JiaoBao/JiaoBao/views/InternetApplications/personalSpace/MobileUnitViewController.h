//
//  MobileUnitViewController.h
//  JiaoBao
//
//  Created by songyanming on 15/6/5.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"


@interface MobileUnitViewController : UIViewController<MyNavigationDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条


@end
