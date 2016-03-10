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
//                 self.frame           当前数组            左右0还是上下1      需要高亮显示索引
-(id)initFrame:(CGRect)rect Array:(NSMutableArray *)array Flag:(int)flag index:(int)index{
    self = [super init];
    if (self) {
        self.flag = flag;
        self.frame = CGRectMake(rect.origin.x-1, rect.origin.y, rect.size.width+2, rect.size.height);
        self.backgroundColor = [UIColor whiteColor];
        if (flag==0) {
            self.layer.borderWidth = .5;
            self.layer.borderColor = [[UIColor blackColor] CGColor];
        }
        float tempF = [dm getInstance].width/array.count;
        for (int i=0; i<array.count; i++) {
            ButtonViewModel *model = [array objectAtIndex:i];
            ButtonViewCell *btn;
            if (self.flag == 0) {
                btn = [[ButtonViewCell alloc] initWithFrame:CGRectMake(tempF*i, 0, tempF, rect.size.height) Model:model Flag:(int)array.count-i];
            }else{
                //当前的是否需要高亮显示
                if (index==i) {
                    btn = [[ButtonViewCell alloc] initWithFrame1:CGRectMake(tempF*i, 0, tempF, rect.size.height) Model:model Flag:(int)array.count-i select:YES];
                }else{
                    btn = [[ButtonViewCell alloc] initWithFrame1:CGRectMake(tempF*i, 0, tempF, rect.size.height) Model:model Flag:(int)array.count-i select:NO];
                }
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
        ButtonViewCell *btn = (ButtonViewCell *)gest.view;
        for (ButtonViewCell *btn1 in self.subviews) {
            if ([btn1.class isSubclassOfClass:[ButtonViewCell class]]) {
                if ((int)btn1.tag == btn.tag) {
                    [btn1.mImgV_pic setImage:[UIImage imageNamed:btn1.bModel.mStr_imgNow]];
                    btn1.mLab_title.textColor = [UIColor greenColor];
                }else{
                    [btn1.mImgV_pic setImage:[UIImage imageNamed:btn1.bModel.mStr_img]];
                    btn1.mLab_title.textColor = [UIColor grayColor];
                }
            }
        }
    }
    
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
