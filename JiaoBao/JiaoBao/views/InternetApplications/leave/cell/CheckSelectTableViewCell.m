//
//  CheckSelectTableViewCell.m
//  JiaoBao
//
//  Created by Zqw on 16/3/24.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "CheckSelectTableViewCell.h"

@implementation CheckSelectTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
//教职工
-(IBAction)mBtn_teacher:(id)sender{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(CheckSelectTableViewCellTeacherBtn:)]) {
        [self.delegate CheckSelectTableViewCellTeacherBtn:self];
    }
}
//学生
-(IBAction)mBtn_student:(id)sender{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(CheckSelectTableViewCellStudentBtn:)]) {
        [self.delegate CheckSelectTableViewCellStudentBtn:self];
    }
}
//一审
-(IBAction)mBtn_one:(id)sender{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(CheckSelectTableViewCellOneBtn:)]) {
        [self.delegate CheckSelectTableViewCellOneBtn:self];
    }
}
//二审
-(IBAction)mBtn_two:(id)sender{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(CheckSelectTableViewCellTwoBtn:)]) {
        [self.delegate CheckSelectTableViewCellTwoBtn:self];
    }
}
//三审
-(IBAction)mBtn_three:(id)sender{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(CheckSelectTableViewCellThreeBtn:)]) {
        [self.delegate CheckSelectTableViewCellThreeBtn:self];
    }
}
//四审
-(IBAction)mBtn_four:(id)sender{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(CheckSelectTableViewCellFourBtn:)]) {
        [self.delegate CheckSelectTableViewCellFourBtn:self];
    }
}
//五审
-(IBAction)mBtn_five:(id)sender{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(CheckSelectTableViewCellFiveBtn:)]) {
        [self.delegate CheckSelectTableViewCellFiveBtn:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
