//
//  MoreUnitWorkView.m
//  JiaoBao
//
//  Created by Zqw on 15-4-23.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "MoreUnitWorkView.h"

@implementation MoreUnitWorkView

- (id)initWithFrame1:(CGRect)frame{
    self = [super init];
    if (self) {
        // Initialization code
        self.frame = frame;
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, 70, 40)];
        lab.text = @"3333333";
        [self addSubview:lab];
    }
    return self;
}

@end
