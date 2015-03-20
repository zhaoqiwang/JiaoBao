//
//  WorkView.h
//  JiaoBao
//
//  Created by Zqw on 14-10-22.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dm.h"
#import "TreeView_Level0_Cell.h"
#import "TreeView_Level0_Model.h"
#import "TreeView_Level1_Cell.h"
#import "TreeView_Level1_Model.h"
#import "TreeView_Level2_Cell.h"
#import "TreeView_Level2_Model.h"
#import "LoginSendHttp.h"
#import "UnReadMsg_model.h"
#import "utils.h"
#import "MsgDetailViewController.h"
#import "MBProgressHUD.h"
#import "WorkDetailListViewController.h"
#import "ForwardViewController.h"


@interface WorkView : UIView<UITableViewDataSource,UITableViewDelegate,TreeView_Level0_CellDelegate,TreeView_Level1_CellDelegate,MBProgressHUDDelegate>{
    UITableView *mTableV_work;
    UIButton *mBtn_new;
    NSMutableArray *mArr_sumData;//保存全部数据的数组
    NSArray *mArr_display;//保存要显示在界面上的数据的数组
    MBProgressHUD *mProgressV;//
}
@property (strong,nonatomic) UITableView *mTableV_work;
@property (strong,nonatomic) UIButton *mBtn_new;
@property(strong,nonatomic) NSMutableArray *mArr_sumData;//保存全部数据的数组
@property(strong,nonatomic) NSArray *mArr_display;//保存要显示在界面上的数据的数组
@property (nonatomic,strong) MBProgressHUD *mProgressV;//

- (id)initWithFrame1:(CGRect)frame;

@end
