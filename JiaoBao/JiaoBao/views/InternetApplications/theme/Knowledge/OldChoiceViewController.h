//
//  OldChoiceViewController.h
//  JiaoBao
//  往期精选
//  Created by Zqw on 15/9/9.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "dm.h"
#import "utils.h"
#import "MBProgressHUD.h"
#import "KnowledgeHttp.h"
#import "UIImageView+WebCache.h"
#import "OldChoiceTableViewCell.h"

@interface OldChoiceViewController : UIViewController<MyNavigationDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) IBOutlet UITableView *mTableV_list;//精选列表
@property (nonatomic,strong) NSMutableArray *mArr_list;//精选数组

@end
