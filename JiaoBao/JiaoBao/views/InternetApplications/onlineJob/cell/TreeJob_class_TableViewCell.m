//
//  TreeJob_class_TableViewCell.m
//  JiaoBao
//
//  Created by Zqw on 15/10/15.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "TreeJob_class_TableViewCell.h"

@implementation TreeJob_class_TableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.sigleClassBtn = [[SigleBtnView alloc] initWidth:0 height:21 title:@"一年级一班" select:0 sigle:0];
    self.sigleClassBtn.frame = CGRectMake(20, 10, self.sigleClassBtn.frame.size.width, 21);
    self.sigleClassBtn.tag = 0;
    self.sigleClassBtn.delegate = self;
    [self addSubview:self.sigleClassBtn];
    
    //难度
    self.mLab_nanDu.frame = CGRectMake(20, 35, self.mLab_nanDu.frame.size.width, 21);
    
    self.sigleBtn1 = [[SigleBtnView alloc] initWidth:0 height:21 title:@" 1" select:1 sigle:1];
    self.sigleBtn1.tag = 1;
    self.sigleBtn1.delegate = self;
    self.sigleBtn1.frame = CGRectMake(20+self.mLab_nanDu.frame.size.width, 35, self.sigleBtn1.frame.size.width, 21);
    [self addSubview:self.sigleBtn1];
    
    self.sigleBtn2 = [[SigleBtnView alloc] initWidth:0 height:21 title:@" 2" select:0 sigle:1];
    self.sigleBtn2.tag = 2;
    self.sigleBtn2.delegate = self;
    self.sigleBtn2.frame = CGRectMake(self.sigleBtn1.frame.origin.x+self.sigleBtn2.frame.size.width+20, 35, self.sigleBtn2.frame.size.width, 21);
    [self addSubview:self.sigleBtn2];
    
    self.sigleBtn3 = [[SigleBtnView alloc] initWidth:0 height:21 title:@" 3" select:0 sigle:1];
    self.sigleBtn3.tag = 3;
    self.sigleBtn3.delegate = self;
    self.sigleBtn3.frame = CGRectMake(self.sigleBtn2.frame.origin.x+self.sigleBtn3.frame.size.width+20, 35, self.sigleBtn3.frame.size.width, 21);
    [self addSubview:self.sigleBtn3];
    
    self.sigleBtn4 = [[SigleBtnView alloc] initWidth:0 height:21 title:@" 4" select:0 sigle:1];
    self.sigleBtn4.tag = 4;
    self.sigleBtn4.delegate = self;
    self.sigleBtn4.frame = CGRectMake(self.sigleBtn3.frame.origin.x+self.sigleBtn4.frame.size.width+20, 35, self.sigleBtn4.frame.size.width, 21);
    [self addSubview:self.sigleBtn4];
    
    self.sigleBtn5 = [[SigleBtnView alloc] initWidth:0 height:21 title:@" 5" select:0 sigle:1];
    self.sigleBtn5.tag = 5;
    self.sigleBtn5.delegate = self;
    self.sigleBtn5.frame = CGRectMake(self.sigleBtn4.frame.origin.x+self.sigleBtn5.frame.size.width+20, 35, self.sigleBtn5.frame.size.width, 21);
    [self addSubview:self.sigleBtn5];
}

//难度的回调
-(void)SigleBtnViewClick:(SigleBtnView *)sigleBtnView{
    if (sigleBtnView.mInt_sigle==0) {//班级
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(TreeJob_class_TableViewCellClick:)]) {
            self.mInt_flag = 0;
            [self.delegate TreeJob_class_TableViewCellClick:self];
        }
    }else{//难度
        for (SigleBtnView *view in self.subviews) {
            if ([view.class isSubclassOfClass:SigleBtnView.class]) {
                if (view.tag == 0) {
                    
                }else if (view.tag == sigleBtnView.tag) {
                    view.mInt_flag = 1;
                    [view.mImg_head setImage:[UIImage imageNamed:@"sigleSelect1"]];
                }else{
                    view.mInt_flag = 0;
                    [view.mImg_head setImage:[UIImage imageNamed:@"sigleSelect0"]];
                }
            }
        }
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(TreeJob_class_TableViewCellClick:)]) {
            self.mInt_flag = 1;
            self.mInt_diff = (int)sigleBtnView.tag;
            [self.delegate TreeJob_class_TableViewCellClick:self];
        }
    }
}

//班级的回调
-(void)SigleNameImgBtnViewClick:(SigleNameImgBtnView *)sigleNameImgBtnView{
//    self.mInt_diff = self.sigleClassBtn.mInt_flag;
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(TreeJob_class_TableViewCellClick:)]) {
        self.mInt_flag = 0;
        [self.delegate TreeJob_class_TableViewCellClick:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
