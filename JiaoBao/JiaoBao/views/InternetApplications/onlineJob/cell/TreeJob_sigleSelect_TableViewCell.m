//
//  TreeJob_sigleSelect_TableViewCell.m
//  JiaoBao
//
//  Created by Zqw on 15/10/19.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "TreeJob_sigleSelect_TableViewCell.h"
#import "dm.h"

@implementation TreeJob_sigleSelect_TableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.mLab_line.frame = CGRectMake(20, 0, [dm getInstance].width-20, .5);
    //初始化，给默认值
    self.sigleBtn = [[SigleBtnView alloc] initWidth:0 height:21 title:@"一年级一班" select:0 sigle:2];
    self.sigleBtn.frame = CGRectMake(30, 10, self.sigleBtn.frame.size.width, 21);
    self.sigleBtn.tag = 0;
    self.sigleBtn.mLab_title.textColor = [UIColor colorWithRed:121/255.0 green:121/255.0 blue:121/255.0 alpha:1];
    self.sigleBtn.delegate = self;
    [self addSubview:self.sigleBtn];
}
//点击
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
