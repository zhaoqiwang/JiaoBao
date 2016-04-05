//
//  QueryCell.h
//  JiaoBao
//
//  Created by SongYanming on 16/3/14.
//  Copyright © 2016年 JSY. All rights reserved.
//请假查询或审核查询有学生、教职工或人员的cell

#import <UIKit/UIKit.h>
#import "MyLeaveModel.h"

@interface QueryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
-(void)setCellData:(MyLeaveModel*)model;

@end
