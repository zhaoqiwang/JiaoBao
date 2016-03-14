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

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
