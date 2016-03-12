//
//  LeaveTopScrollView.m
//  JiaoBao
//
//  Created by Zqw on 16/3/11.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "LeaveTopScrollView.h"

@implementation LeaveTopScrollView

//                 self.frame           当前数组            左右0还是上下1      需要高亮显示索引
-(id)initFrame:(CGRect)rect Array:(NSMutableArray *)array Flag:(int)flag index:(int)index{
    self = [super init];
    if (self) {
        self.flag = flag;
        self.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
        self.backgroundColor = [UIColor whiteColor];
        if (flag==0) {
            self.layer.borderWidth = .5;
            self.layer.borderColor = [[UIColor blackColor] CGColor];
        }
        float tempF = [dm getInstance].width/array.count;
        for (int i=0; i<array.count; i++) {
            ButtonViewModel *model = [array objectAtIndex:i];
            LeaveViewCell *btn;
                //当前的是否需要高亮显示
                if (index==i) {
                    btn = [[LeaveViewCell alloc] initWithFrame1:CGRectMake(tempF*i, 0, tempF, rect.size.height) Model:model Flag:(int)array.count-i select:YES];
                }else{
                    btn = [[LeaveViewCell alloc] initWithFrame1:CGRectMake(tempF*i, 0, tempF, rect.size.height) Model:model Flag:(int)array.count-i select:NO];
                }
            
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
    if (self.flag == 1) {
        LeaveViewCell *btn = (LeaveViewCell *)gest.view;
        for (LeaveViewCell *btn1 in self.subviews) {
            if ([btn1.class isSubclassOfClass:[LeaveViewCell class]]) {
                if ((int)btn1.tag == btn.tag) {
                    btn1.mLab_title.textColor = [UIColor colorWithRed:54/255.0 green:168/255.0 blue:12/255.0 alpha:1];
                    btn1.mLab_line.hidden = NO;
                }else{
                    btn1.mLab_title.textColor = [UIColor colorWithRed:80/255.0 green:79/255.0 blue:79/255.0 alpha:1];
                    btn1.mLab_line.hidden = YES;
                }
            }
        }
    }
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(LeaveViewCellTitleBtn:)]) {
        [self.delegate LeaveViewCellTitleBtn:(LeaveViewCell *)gest.view];
    }
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
