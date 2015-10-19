//
//  TreeJob_sigleSelect_TableViewCell.m
//  JiaoBao
//
//  Created by Zqw on 15/10/19.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "TreeJob_sigleSelect_TableViewCell.h"

@implementation TreeJob_sigleSelect_TableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.sigleBtn = [[SigleBtnView alloc] initWidth:0 height:21 title:@"一年级一班" select:0 sigle:2];
    self.sigleBtn.frame = CGRectMake(20, 10, self.sigleBtn.frame.size.width, 21);
    self.sigleBtn.tag = 0;
    self.sigleBtn.delegate = self;
    [self addSubview:self.sigleBtn];
}

-(void)SigleBtnViewClick:(SigleBtnView *)sigleBtnView{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(TreeJob_sigleSelect_TableViewCellClick:)]) {
        [self.delegate TreeJob_sigleSelect_TableViewCellClick:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
