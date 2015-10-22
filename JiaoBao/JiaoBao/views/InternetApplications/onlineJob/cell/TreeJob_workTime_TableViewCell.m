//
//  TreeJob_workTime_TableViewCell.m
//  JiaoBao
//
//  Created by Zqw on 15/10/21.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "TreeJob_workTime_TableViewCell.h"

@implementation TreeJob_workTime_TableViewCell

- (void)awakeFromNib {
    // Initialization code
    //标题
    self.mLab_title.frame = CGRectMake(10, 10, self.mLab_title.frame.size.width, 21);
    
    self.sigleBtn1 = [[SigleBtnView alloc] initWidth:0 height:21 title:@" 10" select:1 sigle:1];
    self.sigleBtn1.tag = 10;
    self.sigleBtn1.delegate = self;
    self.sigleBtn1.frame = CGRectMake(20+self.mLab_title.frame.size.width, 10, self.sigleBtn1.frame.size.width, 21);
    [self addSubview:self.sigleBtn1];
    
    self.sigleBtn2 = [[SigleBtnView alloc] initWidth:0 height:21 title:@" 20" select:0 sigle:1];
    self.sigleBtn2.tag = 20;
    self.sigleBtn2.delegate = self;
    self.sigleBtn2.frame = CGRectMake(self.sigleBtn1.frame.origin.x+self.sigleBtn2.frame.size.width+20, 10, self.sigleBtn2.frame.size.width, 21);
    [self addSubview:self.sigleBtn2];
    
    self.sigleBtn3 = [[SigleBtnView alloc] initWidth:0 height:21 title:@" 30" select:0 sigle:1];
    self.sigleBtn3.tag = 30;
    self.sigleBtn3.delegate = self;
    self.sigleBtn3.frame = CGRectMake(self.sigleBtn2.frame.origin.x+self.sigleBtn3.frame.size.width+20, 10, self.sigleBtn3.frame.size.width, 21);
    [self addSubview:self.sigleBtn3];
    
    self.sigleBtn4 = [[SigleBtnView alloc] initWidth:0 height:21 title:@" 40" select:0 sigle:1];
    self.sigleBtn4.tag = 40;
    self.sigleBtn4.delegate = self;
    self.sigleBtn4.frame = CGRectMake(self.sigleBtn3.frame.origin.x+self.sigleBtn4.frame.size.width+20, 10, self.sigleBtn4.frame.size.width, 21);
    [self addSubview:self.sigleBtn4];
    
    self.sigleBtn5 = [[SigleBtnView alloc] initWidth:0 height:21 title:@" 60" select:0 sigle:1];
    self.sigleBtn5.tag = 60;
    self.sigleBtn5.delegate = self;
    self.sigleBtn5.frame = CGRectMake(self.sigleBtn1.frame.origin.x, 40, self.sigleBtn5.frame.size.width, 21);
    [self addSubview:self.sigleBtn5];
    
    self.sigleBtn6 = [[SigleBtnView alloc] initWidth:0 height:21 title:@" 90" select:0 sigle:1];
    self.sigleBtn6.tag = 90;
    self.sigleBtn6.delegate = self;
    self.sigleBtn6.frame = CGRectMake(self.sigleBtn5.frame.origin.x+self.sigleBtn6.frame.size.width+20, 40, self.sigleBtn6.frame.size.width, 21);
    [self addSubview:self.sigleBtn6];
    
    self.sigleBtn7 = [[SigleBtnView alloc] initWidth:0 height:21 title:@" 120" select:0 sigle:1];
    self.sigleBtn7.tag = 120;
    self.sigleBtn7.delegate = self;
    self.sigleBtn7.frame = CGRectMake(self.sigleBtn6.frame.origin.x+self.sigleBtn7.frame.size.width+20, 40, self.sigleBtn7.frame.size.width, 21);
    [self addSubview:self.sigleBtn7];
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
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(TreeJob_workTime_TableViewCellClick:)]) {
        self.mInt_count = (int)sigleBtnView.tag;
        [self.delegate TreeJob_workTime_TableViewCellClick:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
