//
//  ButtonView.m
//  JiaoBao
//
//  Created by Zqw on 15/8/10.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "ButtonView.h"
#import "dm.h"
#import "Loger.h"

@implementation ButtonView

-(id)initFrame:(CGRect)rect Array:(NSMutableArray *)array{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(rect.origin.x-1, rect.origin.y, rect.size.width+2, rect.size.height);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = .5;
        self.layer.borderColor = [[UIColor blackColor] CGColor];
        float tempF = [dm getInstance].width/array.count;
        for (int i=0; i<array.count; i++) {
            ButtonViewModel *model = [array objectAtIndex:i];
            
            ButtonViewCell *btn = [[ButtonViewCell alloc] initWithFrame:CGRectMake(tempF*i, 0, tempF, rect.size.height) Model:model Flag:(int)array.count-i];
            btn.tag = i+100;
            [self addSubview:btn];
            
            btn.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonViewClick:)];
            [btn addGestureRecognizer:tap];
            
            //
            if (i<array.count-1) {
                
            }
        }
    }
    return self;
}

-(void)buttonViewClick:(UIGestureRecognizer *)gest{
    [self.delegate ButtonViewTitleBtn:(ButtonViewCell *)gest.view];
    D("idsjgldjgl;kjsl;d-=====%ld",(long)gest.view.tag);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
