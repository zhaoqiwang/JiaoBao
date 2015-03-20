//
//  ShareViewNew.h
//  JiaoBao
//  分享新页面
//  Created by Zqw on 14-12-15.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "dm.h"
#import "utils.h"
#import "ShowHttp.h"
#import "TopArthListCell.h"
#import "TopArthListModel.h"
#import "ArthDetailViewController.h"
#import "ArthLIstViewController.h"
#import "PersonalSpaceViewController.h"
#import "MJRefresh.h"//上拉下拉刷新

@interface ShareViewNew : UIView<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,TopArthListCellDelegate>{
    UIScrollView *mScrollV_share;//放colletionV,tableV
    UITableView *mTableV_difine;//放默认
    UILabel *mLab_name;//详情标签，分割单位和列表
    UITableView *mTableV_detail;//放单位等详情
    NSMutableArray *mArr_difine;//默认
    NSMutableArray *mArr_tabel;//表格中的数据,教育局、最新更新、推荐
    UIButton *mBtn_add;//加载更多按钮
    int mInt_index;//当前应该加载的第几页
    MBProgressHUD *mProgressV;//
}

@property (nonatomic,strong) UIScrollView *mScrollV_share;//放colletionV,tableV
@property (nonatomic,strong) UITableView *mTableV_difine;//放默认
@property (nonatomic,strong) UILabel *mLab_name;//详情标签，分割单位和列表
@property (nonatomic,strong) UITableView *mTableV_detail;//放单位等详情
@property (nonatomic,strong) NSMutableArray *mArr_tabel;//表格中的数据
@property (nonatomic,strong) NSMutableArray *mArr_difine;//表格中的数据
@property (nonatomic,strong) UIButton *mBtn_add;//加载更多按钮
@property (nonatomic,assign) int mInt_index;//当前应该加载的第几页
@property (nonatomic,strong) MBProgressHUD *mProgressV;//

- (id)initWithFrame1:(CGRect)frame;
-(void)ProgressViewLoad;

@end
