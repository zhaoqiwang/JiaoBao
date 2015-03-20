//
//  TreeView_Level0_Cell.h
//  JiaoBao
//
//  Created by Zqw on 14-10-23.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreeView_node.h"
#import "dm.h"

@protocol TreeView_Level0_CellDelegate;

@interface TreeView_Level0_Cell : UITableViewCell{
    TreeView_node *mNode;//子类数据
    UIImageView *mImgV_head;//头像
    UIImageView *mImgV_open_close;//关闭还是打开按钮
    UIButton *mBtn_detail;//详情按钮
    UILabel *mLab_name;//名称
    UIImageView *mImgV_number;//未读条数图片
    UILabel *mLab_number;//未读条数
    id<TreeView_Level0_CellDelegate> delegate;//代理
}
@property (strong,nonatomic) TreeView_node *mNode;
@property (strong,nonatomic) IBOutlet UIImageView *mImgV_head;
@property (strong,nonatomic) IBOutlet UIImageView *mImgV_open_close;
@property (strong,nonatomic) IBOutlet UIButton *mBtn_detail;
@property (strong,nonatomic) IBOutlet UILabel *mLab_name;
@property (strong,nonatomic) IBOutlet UIImageView *mImgV_number;
@property (strong,nonatomic) IBOutlet UILabel *mLab_number;
@property (strong,nonatomic) id<TreeView_Level0_CellDelegate> delegate;

-(IBAction)clickBtn;

@end

@protocol TreeView_Level0_CellDelegate <NSObject>

//点击编辑按钮
-(void)selectedMoreBtn0:(TreeView_Level0_Cell *)cell;

@end
