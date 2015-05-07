//
//  PatriarchView.h
//  JiaoBao
//
//  Created by songyanming on 15/4/27.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "utils.h"
#import "dm.h"
#import "LoginSendHttp.h"
#import "Forward_cell.h"
#import "MBProgressHUD.h"
#import "Forward_section.h"
#import "UserListModel.h"

@interface PatriarchView : UIView<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UICollectionView *mCollectionV_list;
@property(nonatomic,strong)NSArray *datasource;
@property (nonatomic,strong) MBProgressHUD *mProgressV;//
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIButton *mBtn_all;
@property(nonatomic,assign)NSUInteger allSelSymbol;
@property(nonatomic,strong)UIButton * rightBtn;

@end
