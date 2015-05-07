//
//  SchoolMessage.m
//  JiaoBao
//
//  Created by songyanming on 15/4/27.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "SchoolMessage.h"
#import "dm.h"

@implementation SchoolMessage
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [dm getInstance].width, 30)];
    [self addSubview:headerView];
    headerView.backgroundColor = [UIColor lightGrayColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [dm getInstance].width, 30)];
    label.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    label.text = [NSString stringWithFormat:@"%@【全校家长】",[dm getInstance].mStr_unit] ;
    label.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:label];
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn.frame = CGRectMake(self.frame.size.width-50, 12, 14, 14);
    self.rightBtn.tag = 1;
    [self.rightBtn setImage:[UIImage imageNamed:@"blank.png"] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.rightBtn];
    
    UIButton* rightBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn2.frame = CGRectMake(self.frame.size.width-36, 12, 30, 14);
    rightBtn2.tag = 2;
    [rightBtn2 setTitle:@"全选" forState:UIControlStateNormal];
    rightBtn2.titleLabel.font = [UIFont systemFontOfSize:12];
    [rightBtn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn2 addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightBtn2];
    UIButton* rightBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn3.frame = CGRectMake(self.frame.size.width-70, 0, 70, 30);
    rightBtn3.tag = 2;
    //rightBtn3.backgroundColor = [UIColor redColor];
    [rightBtn3 addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightBtn3];
    

    return self;
}
-(void)clickBtn:(id)sender
{
    if([[self.rightBtn imageForState:UIControlStateNormal]isEqual:[UIImage imageNamed:@"blank.png"]])
    {
        [self.rightBtn setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
        self.allSelected = YES;

        
    }
    else
    {
        [self.rightBtn setImage:[UIImage imageNamed:@"blank.png"] forState:UIControlStateNormal];
        self.allSelected = NO;

        
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
