//
//  MyCommentViewController.h
//  JiaoBao
//
//  Created by songyanming on 15/12/18.
//  Copyright © 2015年 JSY. All rights reserved.
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

@interface MyCommentViewController : UIViewController<MyNavigationDelegate>
@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) IBOutlet UITableView *mTalbeV_liset;//

@property (nonatomic,strong) NSMutableArray *mArr_list;//我提出的问题列表
@property (nonatomic,assign) int mInt_reloadData;//记录是刷新0还是加载更多1
@property (nonatomic,assign) int mInt_load;//加载数据页码page

@end
