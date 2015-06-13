//
//  Forward_section.m
//  JiaoBao
//
//  Created by Zqw on 14-11-6.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "Forward_section.h"
#import "dm.h"

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
        //self.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        // Initialization code

        self.mLab_name = [[UILabel alloc] init];
        self.mLab_name.font = [UIFont systemFontOfSize:12];
        //CGSize size = [self.mLab_name.text sizeWithFont:[UIFont systemFontOfSize:12]];

        self.mLab_name.frame = CGRectMake(30, 0, 200, 40);
        [self addSubview:self.mLab_name];

        self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.addBtn.frame = CGRectMake(50+30, 5, 30, 30);
        self.addBtn.tag = 3;
        [self.addBtn setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
        [self.addBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.addBtn];
        
        self.triangleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.triangleBtn.frame = CGRectMake(5, 5, 30, 30);
        self.triangleBtn.tag = 4;
        [self.triangleBtn setImage:[UIImage imageNamed:@"rTri.png"] forState:UIControlStateNormal];
        [self.triangleBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.triangleBtn];
        
        UIButton *bigButton =[UIButton buttonWithType:UIButtonTypeCustom];
        bigButton.frame = CGRectMake(0, 0, 120, 40);
        [bigButton addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        bigButton.tag = 6;
        //[bigButton setBackgroundColor:[UIColor redColor]];
        [self addSubview:bigButton];
        
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightBtn.frame = CGRectMake(self.frame.size.width-10-36*2-15, 12, 14, 14);
        self.rightBtn.tag = 5;
        [self.rightBtn setImage:[UIImage imageNamed:@"blank.png"] forState:UIControlStateNormal];
        [self.rightBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.rightBtn];
        
        self.mBtn_all = [UIButton buttonWithType:UIButtonTypeCustom];
        self.mBtn_all.frame = CGRectMake(self.frame.size.width-10-36*2, 5, 36, 30);
        [self.mBtn_all setTitle:@"全选" forState:UIControlStateNormal];
        [self.mBtn_all setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.mBtn_all.titleLabel.font = [UIFont systemFontOfSize:12];
        //[self.mBtn_all setBackgroundColor:BtnColor];
        self.mBtn_all.tag = 1;
        [self.mBtn_all addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.mBtn_all];
        UIButton *bigButton2 =[UIButton buttonWithType:UIButtonTypeCustom];
        bigButton2.frame = CGRectMake(self.frame.size.width-10-36*2-15, 0, 65, 40);
        [bigButton2 addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        bigButton2.tag = 7;
        [self addSubview:bigButton2];
        
        
        self.mBtn_invertSelect = [UIButton buttonWithType:UIButtonTypeCustom];
        self.mBtn_invertSelect.frame = CGRectMake(self.frame.size.width-15-36, 0, 55, 40);
        [self.mBtn_invertSelect setTitle:@"反选" forState:UIControlStateNormal];
        self.mBtn_invertSelect.titleLabel.font = [UIFont systemFontOfSize:12];
        //[self.mBtn_invertSelect setBackgroundColor:[UIColor redColor]];
        self.mBtn_invertSelect.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.mBtn_invertSelect setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        //[self.mBtn_invertSelect setBackgroundColor:BtnColor];
        self.mBtn_invertSelect.tag = 2;
        [self.mBtn_invertSelect addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.mBtn_invertSelect];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [dm getInstance].width, 0.5)];
        [self addSubview:label];
        label.backgroundColor = [UIColor grayColor];
        
    }
    return self;
}

- (void)initWithFrame1:(CGRect)frame{
    self.frame = frame;
}

//按钮点击事件
-(void)clickBtn:(UIButton *)btn{
    
    
    NSNumber *num = [NSNumber numberWithInteger:self.tag];
        
        
    

    if(btn.tag == 6)//三角 加号 bigButton
    {
        if(!([dm getInstance].sectionSet))
        {
            [dm getInstance].sectionSet = [[NSMutableSet alloc]initWithCapacity:0];
            
        }
        if(![[dm getInstance].sectionSet containsObject:num] )
        {
            [[dm getInstance].sectionSet addObject:num];
            
            
        }
        else
        {
            [[dm getInstance].sectionSet removeObject:num];
        }
    }
    
 
    


            D("点击section中的btn-====%ld,%ld",(long)btn.tag,(long)self.tag);
            [self.delegate Forward_sectionClickBtnWith:btn cell:self];
            
        

}

@end
