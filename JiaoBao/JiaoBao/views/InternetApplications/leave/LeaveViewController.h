//
//  LeaveViewController.h
//  JiaoBao
//
//  Created by Zqw on 16/3/11.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonViewModel.h"
#import "LeaveTopScrollView.h"
#import "MyNavigationBar.h"
#import "dm.h"
#import "utils.h"
#import "define_constant.h"

@interface LeaveViewController : UIViewController<MyNavigationDelegate,UITableViewDataSource,UITableViewDelegate,LeaveViewDelegate>

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) LeaveTopScrollView *mScrollV_all;//查询分类显示
@property (nonatomic,strong) NSString *mStr_navName;//导航条名称

@end
