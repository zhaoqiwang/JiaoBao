//
//  TreeJob_workTime_TableViewCell.h
//  JiaoBao
//  作业时长
//  Created by Zqw on 15/10/21.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SigleBtnView.h"
#import "TreeJob_node.h"

@protocol TreeJob_workTime_TableViewCellDelegate;

@interface TreeJob_workTime_TableViewCell : UITableViewCell<SigleBtnViewDelegate>

@property (nonatomic,strong) IBOutlet UILabel *mLab_title;//标题
@property (nonatomic,strong) SigleBtnView *sigleBtn1;//时长10
@property (nonatomic,strong) SigleBtnView *sigleBtn2;//时长20
@property (nonatomic,strong) SigleBtnView *sigleBtn3;//时长30
@property (nonatomic,strong) SigleBtnView *sigleBtn4;//时长40
@property (nonatomic,strong) SigleBtnView *sigleBtn5;//时长60
@property (nonatomic,strong) SigleBtnView *sigleBtn6;//时长90
@property (nonatomic,strong) SigleBtnView *sigleBtn7;//时长120
@property (nonatomic,assign) int mInt_count;//个数
@property (weak,nonatomic) id<TreeJob_workTime_TableViewCellDelegate> delegate;
@property (nonatomic,strong) TreeJob_node *node;
@property (nonatomic,strong) IBOutlet UILabel *mLab_line;//分割线

@end
//向cell中添加点击事件
@protocol TreeJob_workTime_TableViewCellDelegate <NSObject>

@optional

//点击
-(void)TreeJob_workTime_TableViewCellClick:(TreeJob_workTime_TableViewCell *) treeJob_workTime_TableViewCell;

@end