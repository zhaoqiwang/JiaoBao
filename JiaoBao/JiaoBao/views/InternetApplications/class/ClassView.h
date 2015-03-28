//
//  ClassView.h
//  JiaoBao
//
//  Created by Zqw on 15-3-19.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dm.h"
#import "ClassTableViewCell.h"
#import "ClassHttp.h"

@interface ClassView : UIView<UITableViewDataSource,UITableViewDelegate>{
    UIView *mView_button;//放四个按钮
    UITableView *mTableV_list;//表格
    NSMutableArray *mArr_unit;//本单位
    NSMutableArray *mArr_class;//本班级
    NSMutableArray *mArr_local;//本地
    NSMutableArray *mArr_attention;//关注
    NSMutableArray *mArr_sum;//全部
    UIButton *mBtn_photo;//拍照发布
    int mInt_index;//当前点击的是第几个
    UIScrollView *mScrollV_sum;//放可滑动组件
}

@property (nonatomic,strong) UIView *mView_button;//放四个按钮
@property (nonatomic,strong) UITableView *mTableV_list;
@property (nonatomic,strong) NSMutableArray *mArr_unit;//本单位
@property (nonatomic,strong) NSMutableArray *mArr_class;//本班级
@property (nonatomic,strong) NSMutableArray *mArr_local;//本地
@property (nonatomic,strong) NSMutableArray *mArr_attention;//关注
@property (nonatomic,strong) NSMutableArray *mArr_sum;//全部
@property (strong,nonatomic) UIButton *mBtn_photo;//拍照发布
@property (assign,nonatomic) int mInt_index;//当前点击的是第几个
@property (strong,nonatomic) UIScrollView *mScrollV_sum;//放可滑动组件

- (id)initWithFrame1:(CGRect)frame;

@end
