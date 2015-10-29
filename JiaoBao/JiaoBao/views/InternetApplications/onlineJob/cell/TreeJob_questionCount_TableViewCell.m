//
//  TreeJob_questionCount_TableViewCell.m
//  JiaoBao
//
//  Created by Zqw on 15/10/20.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "TreeJob_questionCount_TableViewCell.h"
#import "dm.h"

@implementation TreeJob_questionCount_TableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.mLab_line.frame = CGRectMake(0, 0, [dm getInstance].width, 5);
    //标题
    self.mLab_title.frame = CGRectMake(20, 15, self.mLab_title.frame.size.width, 21);
    
    self.sigleBtn1 = [[SigleBtnView alloc] initWidth:0 height:21 title:@" 5" select:1 sigle:1];
    self.sigleBtn1.tag = 5;
    self.sigleBtn1.mLab_title.textColor = [UIColor colorWithRed:121/255.0 green:121/255.0 blue:121/255.0 alpha:1];
    self.sigleBtn1.delegate = self;
    self.sigleBtn1.frame = CGRectMake(20+self.mLab_title.frame.size.width+20, 15, self.sigleBtn1.frame.size.width, 21);
    [self addSubview:self.sigleBtn1];
    
    self.sigleBtn2 = [[SigleBtnView alloc] initWidth:0 height:21 title:@" 10" select:0 sigle:1];
    self.sigleBtn2.tag = 10;
    self.sigleBtn2.mLab_title.textColor = [UIColor colorWithRed:121/255.0 green:121/255.0 blue:121/255.0 alpha:1];
    self.sigleBtn2.delegate = self;
    self.sigleBtn2.frame = CGRectMake(self.sigleBtn1.frame.origin.x+self.sigleBtn2.frame.size.width+15, 15, self.sigleBtn2.frame.size.width, 21);
    [self addSubview:self.sigleBtn2];
    
    self.sigleBtn3 = [[SigleBtnView alloc] initWidth:0 height:21 title:@" 20" select:0 sigle:1];
    self.sigleBtn3.tag = 20;
    self.sigleBtn3.mLab_title.textColor = [UIColor colorWithRed:121/255.0 green:121/255.0 blue:121/255.0 alpha:1];
    self.sigleBtn3.delegate = self;
    self.sigleBtn3.frame = CGRectMake(self.sigleBtn2.frame.origin.x+self.sigleBtn3.frame.size.width+15, 15, self.sigleBtn3.frame.size.width, 21);
    [self addSubview:self.sigleBtn3];
    
    self.sigleBtn4 = [[SigleBtnView alloc] initWidth:0 height:21 title:@" 40" select:0 sigle:1];
    self.sigleBtn4.tag = 40;
    self.sigleBtn4.mLab_title.textColor = [UIColor colorWithRed:121/255.0 green:121/255.0 blue:121/255.0 alpha:1];
    self.sigleBtn4.delegate = self;
    self.sigleBtn4.frame = CGRectMake(self.sigleBtn3.frame.origin.x+self.sigleBtn4.frame.size.width+15, 15, self.sigleBtn4.frame.size.width, 21);
    [self addSubview:self.sigleBtn4];
}

//题目个数的回调
-(void)SigleBtnViewClick:(SigleBtnView *)sigleBtnView{
    for (SigleBtnView *view in self.subviews) {
        if ([view.class isSubclassOfClass:SigleBtnView.class]) {
            if (view.tag == sigleBtnView.tag) {
                view.mInt_flag = 1;
                [view.mImg_head setImage:[UIImage imageNamed:@"sigleSelect1"]];
            }else{
                view.mInt_flag = 0;
                [view.mImg_head setImage:[UIImage imageNamed:@"sigleSelect0"]];
            }
        }
    }
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(TreeJob_questionCount_TableViewCellClick:)]) {
        self.mInt_count = (int)sigleBtnView.tag;
        [self.delegate TreeJob_questionCount_TableViewCellClick:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
