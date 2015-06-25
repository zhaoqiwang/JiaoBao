//
//  ShowViewNew.h
//  JiaoBao
//
//  Created by Zqw on 14-12-13.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "dm.h"
#import "utils.h"
#import "ShowHttp.h"
#import "TopArthListCell.h"
#import "UpdateUnitListViewController.h"
#import "ArthLIstViewController.h"
#import "RelatedUnitViewController.h"
#import "UnitSpaceViewController.h"

@interface ShowViewNew : UIView<UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MBProgressHUDDelegate>{
    UIScrollView *mScrollV_view;//放总界面
    NSMutableArray *mArr_define;//默认表格数组
    UICollectionView *mCollectionV_unit;//放单位等
//    UITableView *mTableV_define;//默认表格
    UILabel *mLab_myUnit;//自己所在单位标签
    NSMutableArray *mArr_myUnit;//自己所在单位数组
    UITableView *mTableV_myUnit;//自己在的单位
    UILabel *mLab_follow;//关注单位标签
    NSMutableArray *mArr_follow;//关注单位数组
    UITableView *mTalbeV_follow;//关注的单位
    NSMutableArray *mArr_related;//相关单位数组
}

@property (nonatomic,strong) UIScrollView *mScrollV_view;//放总界面
@property (nonatomic,strong) NSMutableArray *mArr_define;//默认表格数组
//@property (nonatomic,strong) UITableView *mTableV_define;//默认表格
@property (nonatomic,strong) UICollectionView *mCollectionV_unit;//放单位等
@property (nonatomic,strong) UILabel *mLab_myUnit;//自己所在单位标签
@property (nonatomic,strong) NSMutableArray *mArr_myUnit;//自己所在单位数组
@property (nonatomic,strong) UITableView *mTableV_myUnit;//自己在的单位
@property (nonatomic,strong) UILabel *mLab_follow;//关注单位标签
@property (nonatomic,strong) NSMutableArray *mArr_follow;//关注单位数组
@property (nonatomic,strong) UITableView *mTalbeV_follow;//关注的单位
@property (nonatomic,strong) NSMutableArray *mArr_related;//相关单位数组

- (id)initWithFrame1:(CGRect)frame;
-(void)ProgressViewLoad;

@end
