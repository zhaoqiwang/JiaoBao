//
//  TreeView_Level2_Cell.h
//  JiaoBao
//
//  Created by Zqw on 14-10-23.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreeView_node.h"
#import "dm.h"

@protocol TreeView_Level2_CellDelegate;

@interface TreeView_Level2_Cell : UITableViewCell{
    TreeView_node *mNode;//子类数据
    UIImageView *mImgV_head;//头像
    UILabel *mLab_name;//姓名
    UILabel *mLab_detail;//详情
    UILabel *mLab_time;//时间
    UIImageView *mImgV_select;//选择框
    id<TreeView_Level2_CellDelegate> delegate;
}
@property (strong,nonatomic) TreeView_node *mNode;
@property (strong,nonatomic) IBOutlet UIImageView *mImgV_head;
@property (strong,nonatomic) IBOutlet UILabel *mLab_name;//姓名
@property (strong,nonatomic) IBOutlet UILabel *mLab_detail;//详情
@property (strong,nonatomic) IBOutlet UILabel *mLab_time;//时间
@property (nonatomic,strong) IBOutlet UIImageView *mImgV_select;//选择框
@property(retain,nonatomic)id<TreeView_Level2_CellDelegate> delegate;

//显示选择框
- (void)initWithSelectImg;

//给头像添加点击事件
-(void)headImgClick;

@end

@protocol TreeView_Level2_CellDelegate <NSObject>
//向cell中添加头像点击手势
- (void) TreeView_Level2_CellTapPress:(TreeView_Level2_Cell *) TreeCell2;

@end
