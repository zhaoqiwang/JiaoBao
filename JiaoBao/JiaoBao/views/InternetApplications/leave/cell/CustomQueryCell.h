//
//  CustomQueryCell.h
//  JiaoBao
//
//  Created by SongYanming on 16/3/16.
//  Copyright © 2016年 JSY. All rights reserved.
//请假或查询没有学生或教职工的cell

#import <UIKit/UIKit.h>
#import "MyLeaveModel.h"
#import "SumLeavesModel.h"

@interface CustomQueryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
-(void)setCellData:(MyLeaveModel*)model;//设置审核查询列表数据
-(void)setCellData2:(MyLeaveModel*)model;//门卫审核
-(void)setStatisticsData:(SumLeavesModel*)model;//设置统计查询列表数据
-(void)setStatisticsClassData:(SumLeavesModel*)model;//设置统计查询班级列表数据


@end
