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
//审核
-(IBAction)mBtn_check:(id)sender{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(LeaveDetailTableViewCellCheckBtn:)]) {
        [self.delegate LeaveDetailTableViewCellCheckBtn:self];
    }
}
//删除
-(IBAction)mBtn_delete:(id)sender{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(LeaveDetailTableViewCellDeleteBtn:)]) {
        [self.delegate LeaveDetailTableViewCellDeleteBtn:self];
    }
}
//修改
-(IBAction)mBtn_update:(id)sender{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(LeaveDetailTableViewCellUpdateBtn:)]) {
        [self.delegate LeaveDetailTableViewCellUpdateBtn:self];
    }
}
//门卫一审
-(IBAction)mBtn_checkDoor:(id)sender{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(LeaveDetailTableViewCellCheckDoorBtn:)]) {
        [self.delegate LeaveDetailTableViewCellCheckDoorBtn:self];
    }
}
//门卫二审
-(IBAction)mBtn_checkDoor2:(id)sender{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(LeaveDetailTableViewCellCheckDoor2Btn:)]) {
        [self.delegate LeaveDetailTableViewCellCheckDoor2Btn:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
