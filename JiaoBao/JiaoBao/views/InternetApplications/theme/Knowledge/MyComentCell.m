//
//  MyComentCell.m
//  JiaoBao
//
//  Created by songyanming on 15/12/18.
//  Copyright © 2015年 JSY. All rights reserved.
//

#import "MyComentCell.h"
#import "dm.h"

@implementation MyComentCell

- (void)awakeFromNib {
    self.lineHeight.constant= 0.5;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
