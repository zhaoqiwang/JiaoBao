//
//  PublishJobCellTableViewCell.m
//  JiaoBao
//
//  Created by songyanming on 15/10/20.
//  Copyright © 2015年 JSY. All rights reserved.
//

#import "PublishJobCellTableViewCell.h"

@implementation PublishJobCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)publishBtnAction:(id)sender {
    
    [self.delegate PublishJob];
}
@end
