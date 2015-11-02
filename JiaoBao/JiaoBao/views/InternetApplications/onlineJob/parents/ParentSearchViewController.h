//
//  ParentSearchViewController.h
//  JiaoBao
//  家长查询总界面
//  Created by Zqw on 15/11/2.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "dm.h"
#import "utils.h"
#import "define_constant.h"


@interface ParentSearchViewController : UIViewController<MyNavigationDelegate>
@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) UIScrollView *mScrollV_all;//做作业、做练习显示
@property (nonatomic,strong) IBOutlet UITableView *mTableV_list;//列表显示
@property (nonatomic,assign) int mInt_index;//练习选择的索引

@end
