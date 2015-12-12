//
//  MyAttQViewController.h
//  JiaoBao
//  获取我关注的问题列表
//  Created by Zqw on 15/9/17.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "dm.h"
#import "utils.h"
#import "MBProgressHUD.h"
#import "KnowledgeTableViewCell.h"
#import "QuestionModel.h"
#import "KnowledgeHttp.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"//上拉下拉刷新

@interface MyAttQViewController : UIViewController<MyNavigationDelegate,KnowledgeTableViewCellDelegate>

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) IBOutlet UITableView *mTalbeV_liset;//

@property (nonatomic,strong) NSMutableArray *mArr_list;//我提出的问题列表
@property (nonatomic,assign) int mInt_reloadData;//记录是刷新0还是加载更多1
@property (nonatomic,assign) int mInt_load;//加载数据页码page
@property (nonatomic,assign) int mInt_list;//总数组，包括隐藏的

@end
