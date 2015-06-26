//
//  ShareView.h
//  JiaoBao
//
//  Created by Zqw on 14-11-15.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareCollectionViewCell.h"
#import "dm.h"
#import "Identity_model.h"
#import "Identity_UserUnits_model.h"
#import "Identity_UserClasses_model.h"
#import "ShareHttp.h"
#import "TopArthListCell.h"
#import "TreeView_node.h"
#import "TreeView_Level0_Model.h"
#import "TreeView_Level0_Cell.h"
#import "MBProgressHUD.h"
#import "ArthDetailViewController.h"
#import "utils.h"
#import "ArthLIstViewController.h"
#import "SubUnitInfoViewController.h"
#import "SharePostingViewController.h"

@interface ShareView : UIView<UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MBProgressHUDDelegate>{
    UIScrollView *mScrollV_share;//放colletionV,tableV
    UIButton *mBtn_posting;//发表文章
    UICollectionView *mCollectionV_unit;//放单位等
    UILabel *mLab_name;//详情标签，分割单位和列表
    UITableView *mTableV_detail;//放单位等详情
    NSMutableArray *mArr_unit;//collection中的单位
    int mInt_flag;//记录当前点击的是哪个collection中的cell
    NSMutableArray *mArr_tabel;//表格中的数据,教育局、最新更新、推荐
    NSMutableArray *mArr_class;//学校数据，下级单位
    UIButton *mBtn_add;//加载更多按钮
    int mInt_index;//当前应该加载的第几页
    NSMutableArray *mArr_display;//当为多级列表时，显示用的数组
}

@property (nonatomic,strong) UIScrollView *mScrollV_share;//放colletionV,tableV
@property (nonatomic,strong) UIButton *mBtn_posting;//发表文章
@property (nonatomic,strong) UICollectionView *mCollectionV_unit;//放单位等
@property (nonatomic,strong) UILabel *mLab_name;//详情标签，分割单位和列表
@property (nonatomic,strong) UITableView *mTableV_detail;//放单位等详情
@property (nonatomic,strong) NSMutableArray *mArr_unit;//collection中的单位
@property (nonatomic,assign) int mInt_flag;//记录当前点击的是哪个collection中的cell
@property (nonatomic,strong) NSMutableArray *mArr_tabel;//表格中的数据
@property (nonatomic,strong) NSMutableArray *mArr_class;//学校数据，下级单位
@property (nonatomic,strong) UIButton *mBtn_add;//加载更多按钮
@property (nonatomic,assign) int mInt_index;//当前应该加载的第几页
@property (nonatomic,strong) NSMutableArray *mArr_display;//当为多级列表时，显示用的数组

- (id)initWithFrame1:(CGRect)frame;

@end
