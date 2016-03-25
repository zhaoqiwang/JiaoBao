//
//  SelectChapteridViewController.h
//  JiaoBao
//  错题本时，筛选条件
//  Created by Zqw on 16/3/18.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "dm.h"
#import "utils.h"
#import "define_constant.h"
#import "TreeJob_node.h"
#import "TreeJob_level0_model.h"
#import "OnlineJobHttp.h"
#import "GradeModel.h"
#import "SubjectModel.h"
#import "VersionModel.h"
#import "TreeJob_sigleSelect_TableViewCell.h"
#import "TreeJob_default_TableViewCell.h"
#import "TreeView_node.h"

@protocol SelectChapteridViewCDelegate;

@interface SelectChapteridViewController : UIViewController<MyNavigationDelegate,UITableViewDataSource,UITableViewDelegate,TreeJob_sigleSelect_TableViewCellDelegate>

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) IBOutlet UITableView *mTableV_work;//列表显示
@property (strong,nonatomic) NSMutableArray *mArr_sumData;//保存全部数据的数组
@property (strong,nonatomic) NSArray *mArr_display;//保存要显示在界面上的数据的数组
@property (nonatomic,assign) int mInt_index;//每个节点在全局中的索引
@property (nonatomic,strong) PublishJobModel *publishJobModel;
@property (weak,nonatomic) id<SelectChapteridViewCDelegate> delegate;

@end

@protocol SelectChapteridViewCDelegate <NSObject>

@optional

//点击
-(void) SelectChapteridViewSure:(PublishJobModel *) model;

@end