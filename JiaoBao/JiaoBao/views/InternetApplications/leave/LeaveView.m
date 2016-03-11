//
//  LeaveView.m
//  JiaoBao
//
//  Created by Zqw on 16/3/11.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "LeaveView.h"

@implementation LeaveView

-(instancetype)initWithFrame1:(CGRect)frame Model:(ButtonViewModel *)model Flag:(int)flag select:(BOOL)select{
    self = [super init];
    if (self) {
        self.frame = frame;
        self.bModel = model;
        
        NSString *str = [NSString stringWithFormat:@"%@",model.mStr_title];
        CGSize titleSize = [str sizeWithFont:[UIFont systemFontOfSize:14]];
        self.mLab_title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.frame.size.width, titleSize.height)];
        self.mLab_title.font = [UIFont systemFontOfSize:14];
        self.mLab_title.backgroundColor = [UIColor clearColor];
        self.mLab_title.textAlignment = NSTextAlignmentCenter;
        
        self.mLab_title.text = str;
        
        self.mLab_line = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height-10, self.frame.size.width, 5)];
        self.mLab_line.backgroundColor = [UIColor colorWithRed:54/255.0 green:168/255.0 blue:12/255.0 alpha:1];
        
        //判断是否默认选中
        if (select) {
            self.mLab_title.textColor = [UIColor colorWithRed:54/255.0 green:168/255.0 blue:12/255.0 alpha:1];
            self.mLab_line.hidden = NO;
        }else{
            self.mLab_title.textColor = [UIColor colorWithRed:80/255.0 green:79/255.0 blue:79/255.0 alpha:1];
            self.mLab_line.hidden = YES;
        }
        [self addSubview:self.mLab_title];
        [self addSubview:self.mLab_line];
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
