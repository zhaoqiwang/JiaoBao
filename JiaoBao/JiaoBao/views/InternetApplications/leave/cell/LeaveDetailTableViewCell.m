//
//  LeaveDetailTableViewCell.m
//  JiaoBao
//
//  Created by Zqw on 16/3/21.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "LeaveDetailTableViewCell.h"

@implementation LeaveDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(IBAction)mBtn_check:(id)sender{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(LeaveDetailTableViewCellCheckBtn:)]) {
        [self.delegate LeaveDetailTableViewCellCheckBtn:self];
    }
}

-(IBAction)mBtn_delete:(id)sender{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(LeaveDetailTableViewCellDeleteBtn:)]) {
        [self.delegate LeaveDetailTableViewCellDeleteBtn:self];
    }
}

-(IBAction)mBtn_update:(id)sender{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(LeaveDetailTableViewCellUpdateBtn:)]) {
        [self.delegate LeaveDetailTableViewCellUpdateBtn:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
