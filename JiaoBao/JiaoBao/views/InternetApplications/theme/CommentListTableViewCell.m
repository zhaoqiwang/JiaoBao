//
//  CommentListTableViewCell.m
//  JiaoBao
//
//  Created by songyanming on 15/8/10.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "CommentListTableViewCell.h"

@implementation CommentListTableViewCell

- (void)awakeFromNib {
    self.WContent.lineBreakMode = NSLineBreakByWordWrapping;
    self.WContent.font = [UIFont systemFontOfSize:13];
    self.WContent.numberOfLines =0;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
