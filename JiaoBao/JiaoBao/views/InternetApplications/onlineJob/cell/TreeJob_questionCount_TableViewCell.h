//
//  TreeJob_questionCount_TableViewCell.h
//  JiaoBao
//  布置作业中选择题、填空题自定义选择cell
//  Created by Zqw on 15/10/20.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SigleBtnView.h"
#import "TreeJob_node.h"

@protocol TreeJob_questionCount_TableViewCellDelegate;

@interface TreeJob_questionCount_TableViewCell : UITableViewCell<SigleBtnViewDelegate>

@property (nonatomic,strong) IBOutlet UILabel *mLab_title;//标题
@property (nonatomic,strong) SigleBtnView *sigleBtn1;//个数5
@property (nonatomic,strong) SigleBtnView *sigleBtn2;//个数10
@property (nonatomic,strong) SigleBtnView *sigleBtn3;//个数20
@property (nonatomic,strong) SigleBtnView *sigleBtn4;//个数40
@property (nonatomic,assign) int mInt_count;//个数
@property (weak,nonatomic) id<TreeJob_questionCount_TableViewCellDelegate> delegate;
@property (nonatomic,strong) TreeJob_node *node;
@property (nonatomic,strong) IBOutlet UILabel *mLab_line;//分割线

@end

//向cell中添加点击事件
@protocol TreeJob_questionCount_TableViewCellDelegate <NSObject>

@optional

//点击
-(void)TreeJob_questionCount_TableViewCellClick:(TreeJob_questionCount_TableViewCell *) treeJob_questionCount_TableViewCell;

@end