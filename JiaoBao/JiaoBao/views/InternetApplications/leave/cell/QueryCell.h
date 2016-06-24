//
//  QueryCell.h
//  JiaoBao
//  请假查询或审核查询有学生、教职工或人员的cell
//  Created by SongYanming on 16/3/14.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyLeaveModel.h"

@interface QueryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;//时间
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//学生、教职工或人员
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;//理由
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;//状态
-(void)setCellData:(MyLeaveModel*)model;//设置cell上的数据

@end
