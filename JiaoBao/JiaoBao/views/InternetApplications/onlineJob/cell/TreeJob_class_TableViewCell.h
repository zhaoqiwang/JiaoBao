//
//  TreeJob_class_TableViewCell.h
//  JiaoBao
//  布置作业的班级选择cell
//  Created by Zqw on 15/10/15.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SigleBtnView.h"
#import "SigleNameImgBtnView.h"
#import "TreeJob_node.h"

@protocol TreeJob_class_TableViewCellDelegate;

@interface TreeJob_class_TableViewCell : UITableViewCell<SigleBtnViewDelegate,SigleNameImgBtnViewDelegate>

@property (nonatomic,strong) SigleBtnView *sigleClassBtn;//班级选择
@property (nonatomic,strong) IBOutlet UILabel *mLab_nanDu;//难度
@property (nonatomic,strong) SigleBtnView *sigleBtn1;//难度1
@property (nonatomic,strong) SigleBtnView *sigleBtn2;//难度2
@property (nonatomic,strong) SigleBtnView *sigleBtn3;//难度3
@property (nonatomic,strong) SigleBtnView *sigleBtn4;//难度4
@property (nonatomic,strong) SigleBtnView *sigleBtn5;//难度5
@property (nonatomic,assign) int mInt_diff;//难度
@property (nonatomic,strong) NSString *mStr_tableId;//班级id
@property (weak,nonatomic) id<TreeJob_class_TableViewCellDelegate> delegate;
@property (nonatomic,assign) int mInt_flag;//判断是点击班级0，难度1，回调里用
@property (nonatomic,strong) TreeJob_node *node;
@property (nonatomic,strong) IBOutlet UILabel *mLab_line;//分割线


@end

//向cell中添加点击事件
@protocol TreeJob_class_TableViewCellDelegate <NSObject>

@optional

//点击
-(void)TreeJob_class_TableViewCellClick:(TreeJob_class_TableViewCell *) treeJob_class_TableViewCell;

@end