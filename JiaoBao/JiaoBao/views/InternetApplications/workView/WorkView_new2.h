//
//  WorkView_new2.h
//  JiaoBao
//
//  Created by Zqw on 15-4-9.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dm.h"
#import "WorkViewListCell.h"
#import "ClassHttp.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"//上拉下拉刷新
#import "ArthDetailViewController.h"
#import "ClassTopViewController.h"
#import "SharePostingViewController.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "ForwardViewController.h"
#import "WorkMsgListViewController.h"

@interface WorkView_new2 : UIView<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,WorkViewListCellDelegate>{
    UIView *mView_button;//放四个按钮
    UITableView *mTableV_list;//表格
    NSMutableArray *mArr_unRead;//未读
    NSMutableArray *mArr_unReply;//未回复
    NSMutableArray *mArr_reply;//已回复
    NSMutableArray *mArr_mySend;//我发的
    NSMutableArray *mArr_sum;//全部
    UIButton *mBtn_new;//新建事务
    int mInt_index;//当前点击的是第几个
    MBProgressHUD *mProgressV;//
    int mInt_flag;//判断是否在下拉刷新,1是在刷新
}

@property (nonatomic,strong) UIView *mView_button;//放四个按钮
@property (nonatomic,strong) UITableView *mTableV_list;
@property (nonatomic,strong) NSMutableArray *mArr_unRead;//未读
@property (nonatomic,strong) NSMutableArray *mArr_unReply;//未回复
@property (nonatomic,strong) NSMutableArray *mArr_reply;//已回复
@property (nonatomic,strong) NSMutableArray *mArr_mySend;//我发的
@property (nonatomic,strong) NSMutableArray *mArr_sum;//全部
@property (strong,nonatomic) UIButton *mBtn_new;//新建事务
@property (assign,nonatomic) int mInt_index;//当前点击的是第几个
@property (nonatomic,strong) MBProgressHUD *mProgressV;//
@property (assign,nonatomic) int mInt_flag;//判断是否在下拉刷新
@property(nonatomic,strong) UILabel *label;
@property(nonatomic,assign)BOOL firstSymbol;


- (id)initWithFrame1:(CGRect)frame;

//刚进入学校圈，或者下拉刷新时执行
-(void)tableViewDownReloadData;

//清空所有数据
-(void)clearArray;

@end
