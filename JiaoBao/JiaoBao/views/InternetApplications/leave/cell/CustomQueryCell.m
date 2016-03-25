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
-(void)setStatisticsData:(MyLeaveModel*)model{
    self.dateLabel.text = model.ManName;
    self.reasonLabel.text = @"3";
    self.reasonLabel.textAlignment = NSTextAlignmentRight;
    self.stateLabel.text = @"2";
    self.stateLabel.textAlignment = NSTextAlignmentCenter;


    
}

@end
