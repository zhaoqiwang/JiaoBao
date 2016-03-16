//
//  addDateCell.m
//  JiaoBao
//
//  Created by SongYanming on 16/3/9.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "addDateCell.h"

@implementation addDateCell

- (void)awakeFromNib {
    self.layer.cornerRadius = 0.6;
    self.layer.masksToBounds = YES;
    self.mLab_startNow.layer.borderWidth=0.6;
    self.mLab_startNow.layer.cornerRadius=6;
    self.mLab_startNow.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.mLab_endNow.layer.borderWidth=0.6;
    self.mLab_endNow.layer.cornerRadius=6;
    self.mLab_endNow.layer.borderColor = [UIColor lightGrayColor].CGColor;

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)deleteCellAction:(id)sender {
}
@end
