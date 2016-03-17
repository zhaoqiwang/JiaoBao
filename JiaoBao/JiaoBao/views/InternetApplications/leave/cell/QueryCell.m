//
//  QueryCell.m
//  JiaoBao
//
//  Created by SongYanming on 16/3/14.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "QueryCell.h"

@implementation QueryCell

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

@end
