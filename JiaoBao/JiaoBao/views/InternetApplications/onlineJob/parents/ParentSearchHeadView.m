//
//  ParentSearchHeadView.m
//  JiaoBao
//
//  Created by Zqw on 15/11/3.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "ParentSearchHeadView.h"
#import "dm.h"

@implementation ParentSearchHeadView

-(id)initFrame1{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [dm getInstance].width, 30);
        self.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        //
        self.mLab_title0 = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 40, 20)];
        self.mLab_title0.text = @"科目";
        self.mLab_title0.font = [UIFont systemFontOfSize:12];
        self.mLab_title0.textColor = [UIColor colorWithRed:33/255.0 green:41/255.0 blue:43/255.0 alpha:1];
        [self addSubview:self.mLab_title0];
        
        //学力或数量
        self.mLab_title1 = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, [dm getInstance].width-20-60, 20)];
        self.mLab_title1.font = [UIFont systemFontOfSize:12];
        self.mLab_title1.textAlignment = NSTextAlignmentRight;
        self.mLab_title1.textColor = [UIColor colorWithRed:33/255.0 green:41/255.0 blue:43/255.0 alpha:1];
        [self addSubview:self.mLab_title1];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
