//
//  CustomQueryCell.m
//  JiaoBao
//
//  Created by SongYanming on 16/3/16.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "CustomQueryCell.h"

@implementation CustomQueryCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setCellData:(MyLeaveModel*)model{
    self.dateLabel.text = model.WriteDate;
    self.stateLabel.text = model.StatusStr;
    self.reasonLabel.text = model.LeaveType;
    
}
-(void)setCellData2:(MyLeaveModel*)model{
    NSArray *currentArr = [model.WriteDate componentsSeparatedByString:@" "];
    if(currentArr.count>0){
        NSString *dateStr = [currentArr objectAtIndex:0];
        self.dateLabel.text = dateStr;
    }
    self.stateLabel.text = model.LeaveType;
    self.reasonLabel.text = model.ManName;
    
}
-(void)setStatisticsData:(SumLeavesModel*)model{
    self.dateLabel.text = model.ManName;
    if([model.Amount2 isEqualToString:@"(null)"]){
        model.Amount2 = @"0";
    }
    self.reasonLabel.text = model.Amount2;
    self.reasonLabel.textAlignment = NSTextAlignmentRight;

    self.stateLabel.text = model.Amount;
    self.stateLabel.textAlignment = NSTextAlignmentCenter;

}
-(void)setStatisticsClassData:(SumLeavesModel*)model//设置统计查询班级列表数据
{
    self.dateLabel.text = model.ClassStr;
    self.reasonLabel.text = model.Amount;
    self.reasonLabel.textAlignment = NSTextAlignmentRight;
    self.stateLabel.text = model.Amount2;
    self.stateLabel.textAlignment = NSTextAlignmentCenter;
}

@end
