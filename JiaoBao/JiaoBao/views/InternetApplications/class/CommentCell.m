//
//  CommentCell.m
//  JiaoBao
//
//  Created by songyanming on 15/5/20.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "CommentCell.h"
#import "dm.h"

@implementation CommentCell

- (void)awakeFromNib {
    self.contentLabel = [[RCLabel alloc]initWithFrame:CGRectMake(0, 0, [dm getInstance].width-65, 100)];
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.contentLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
