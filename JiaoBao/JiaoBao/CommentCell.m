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
    self.contentLabel = [[RCLabel alloc]initWithFrame:CGRectMake(0, 0, [dm getInstance].width, 100)];
    //self.contentLabel.frame = CGRectMake(0, 0, 320, 100);
//    self.contentLabel.numberOfLines = 0;
//    self.contentLabel.textAlignment = NSTextAlignmentLeft;
//    self.contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.contentLabel.lineBreakMode = RTTextLineBreakModeCharWrapping;
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.contentLabel];
    //[self fuwenbenLabel:self.contentLabel FontNumber:[UIFont systemFontOfSize:14] AndRange:NSMakeRange(1, 1) AndColor:[UIColor redColor]];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
