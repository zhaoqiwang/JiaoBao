//
//  TreeJob_sigleSelect_TableViewCell.h
//  JiaoBao
//  年级、科目、教版、章节的单选cell
//  Created by Zqw on 15/10/19.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SigleBtnView.h"
@protocol TreeJob_sigleSelect_TableViewCellDelegate;

@interface TreeJob_sigleSelect_TableViewCell : UITableViewCell<SigleBtnViewDelegate>
@property (nonatomic,strong) id model;
@property (nonatomic,strong) SigleBtnView *sigleBtn;
@property (weak,nonatomic) id<TreeJob_sigleSelect_TableViewCellDelegate> delegate;

@end

//向cell中添加点击事件
@protocol TreeJob_sigleSelect_TableViewCellDelegate <NSObject>

@optional

//点击
-(void)TreeJob_sigleSelect_TableViewCellClick:(TreeJob_sigleSelect_TableViewCell *) treeJob_sigleSelect_TableViewCell;

@end