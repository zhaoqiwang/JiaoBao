//
//  MoreUnitWorkView.h
//  JiaoBao
//
//  Created by Zqw on 15-4-23.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dm.h"
#import "LoginSendHttp.h"
#import "NewWorkTopView.h"
#import "TreeView_node.h"
#import "TreeView_Level0_Model.h"
#import "TreeView_Level0_Cell.h"
#import "TreeView_Level1_Cell.h"
#import "TreeView_Level2_Cell.h"
#import "NewWorkTree_model.h"

@interface MoreUnitWorkView : UIView<NewWorkTopViewProtocol,UITableViewDataSource,UITableViewDelegate>{
    UIScrollView *mScrollV_all;//放所有控件
    NewWorkTopView *mViewTop;//上半部分
    CommMsgRevicerUnitListModel *mModel_unitList;//
    NSMutableArray *mArr_sumData;//保存全部数据的数组
    NSArray *mArr_display;//保存要显示在界面上的数据的数组
    UITableView *mTableV_work;//
    int mInt_readflag;//标注cell中的readflag
}

@property (nonatomic,strong) UIScrollView *mScrollV_all;//放所有控件
@property (nonatomic,strong) NewWorkTopView *mViewTop;//上半部分
@property (nonatomic,strong) CommMsgRevicerUnitListModel *mModel_unitList;//
@property(strong,nonatomic) NSMutableArray *mArr_sumData;//保存全部数据的数组
@property(strong,nonatomic) NSArray *mArr_display;//保存要显示在界面上的数据的数组
@property (strong,nonatomic) UITableView *mTableV_work;//
@property (nonatomic,assign) int mInt_readflag;//标注cell中的readflag


- (id)initWithFrame1:(CGRect)frame;

@end
