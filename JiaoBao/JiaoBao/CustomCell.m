//
//  CustomCell.m
//  JiaoBao
//
//  Created by songyanming on 15/4/30.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (void)awakeFromNib {
    [self.rightBtn setEnabled:NO];
    //[self.rightBtn setImage:[UIImage imageNamed:@"balnk.png"] forState:UIControlStateNormal];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
