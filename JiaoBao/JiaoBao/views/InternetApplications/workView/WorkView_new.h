//
//  WorkView_new.h
//  JiaoBao
//
//  Created by Zqw on 15-2-9.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "dm.h"
#import "LoginSendHttp.h"
#import "utils.h"
#import "SendToMeUserListModel.h"
#import "WorkViewListCell.h"
#import "MJRefresh.h"
#import "WorkMsgListViewController.h"

@interface WorkView_new : UIView<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>{
    UITableView *mTableV_list;//自己发送和发给自己的
    UIButton *mBtn_new;//新建事务
    NSMutableArray *mArr_list;//显示总数组
    MBProgressHUD *mProgressV;//
    int mInt_index;//当前应该加载的第几页
    NSString *mStr_lastID;//上拉时，加载用，获取到别人发给我的信息中的值
}

@property (strong,nonatomic) UITableView *mTableV_list;//自己发送和发给自己的
@property (strong,nonatomic) UIButton *mBtn_new;
@property (strong,nonatomic) NSMutableArray *mArr_list;//显示总数组
@property (nonatomic,strong) MBProgressHUD *mProgressV;//
@property (nonatomic,assign) int mInt_index;//当前应该加载的第几页
@property (nonatomic,strong) NSString *mStr_lastID;//上拉时，加载用

- (id)initWithFrame1:(CGRect)frame;
-(void)ProgressViewLoad;

@end
