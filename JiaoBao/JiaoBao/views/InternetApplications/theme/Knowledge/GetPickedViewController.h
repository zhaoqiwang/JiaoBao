//
//  GetPickedViewController.h
//  JiaoBao
//  单个精选页面
//  Created by Zqw on 15/9/18.
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

@interface GetPickedViewController : UIViewController<MyNavigationDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) IBOutlet UITableView *mTalbeV_liset;//

@property (nonatomic,strong) PickedIndexModel *mModel_first;//从首页中传值
@property (nonatomic,strong) GetPickedByIdModel *mModel_getPickdById;//当前页面的model

@end
