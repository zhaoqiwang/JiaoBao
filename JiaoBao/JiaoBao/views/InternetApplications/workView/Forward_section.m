//
//  Forward_section.m
//  JiaoBao
//
//  Created by Zqw on 14-11-6.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "Forward_section.h"

#define BtnColor [UIColor colorWithRed:185/255.0 green:185/255.0 blue:185/255.0 alpha:1]//按钮背景色

@implementation Forward_section
@synthesize mBtn_all,mBtn_invertSelect,mLab_name,delegate;

//- (void)awakeFromNib {
//    // Initialization code
//}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width-5, self.frame.size.height);
        D("Forward_section-=tag=%ld==%@",(long)self.tag,NSStringFromCGRect(self.frame));
        self.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        // Initialization code
        self.mLab_name = [[UILabel alloc] init];
        self.mLab_name.font = [UIFont systemFontOfSize:12];
        self.mLab_name.frame = CGRectMake(10, 0, 200, 40);
        [self addSubview:self.mLab_name];
        
        self.mBtn_all = [UIButton buttonWithType:UIButtonTypeCustom];
        self.mBtn_all.frame = CGRectMake(self.frame.size.width-10-36*2, 5, 36, 30);
        [self.mBtn_all setTitle:@"全选" forState:UIControlStateNormal];
        self.mBtn_all.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.mBtn_all setBackgroundColor:BtnColor];
        self.mBtn_all.tag = 1;
        [self.mBtn_all addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.mBtn_all];
        
        self.mBtn_invertSelect = [UIButton buttonWithType:UIButtonTypeCustom];
        self.mBtn_invertSelect.frame = CGRectMake(self.frame.size.width-5-36, 5, 36, 30);
        [self.mBtn_invertSelect setTitle:@"反选" forState:UIControlStateNormal];
        self.mBtn_invertSelect.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.mBtn_invertSelect setBackgroundColor:BtnColor];
        self.mBtn_invertSelect.tag = 2;
        [self.mBtn_invertSelect addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.mBtn_invertSelect];
    }
    return self;
}

- (void)initWithFrame1:(CGRect)frame{
    self.frame = frame;
}

//按钮点击事件
-(void)clickBtn:(UIButton *)btn{
    D("点击section中的btn-====%ld,%ld",(long)btn.tag,(long)self.tag);
    [self.delegate Forward_sectionClickBtnWith:btn cell:self];
}

@end
