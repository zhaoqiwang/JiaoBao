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
            UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(tempF*i, 0, tempF, rect.size.height)];
            tempView.tag = i+100;
            [self addSubview:tempView];
            
            NSString *str = [NSString stringWithFormat:@"     %@",model.mStr_title];
            CGSize titleSize = [str sizeWithFont:[UIFont systemFontOfSize:12]];
            UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake((tempF-titleSize.width)/2, (rect.size.height-titleSize.height)/2, titleSize.width, titleSize.height)];
            tempLabel.font = [UIFont systemFontOfSize:12];
            tempLabel.backgroundColor = [UIColor clearColor];
            tempLabel.textColor = [UIColor grayColor];
            tempLabel.text = str;
            tempLabel.tag = i+100;
            [tempView addSubview:tempLabel];
            
            UIImageView *tempImgV = [[UIImageView alloc] initWithFrame:CGRectMake(tempLabel.frame.origin.x, tempLabel.frame.origin.y, 15, 15)];
            [tempImgV setImage:[UIImage imageNamed:model.mStr_img]];
            tempImgV.tag = i+100;
            [tempView addSubview:tempImgV];
            
            tempView.userInteractionEnabled = YES;
            tempView.tag = i+100;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonViewClick:)];
            [tempView addGestureRecognizer:tap];
            
            //
            if (i<array.count-1) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(tempF-1, 7, .5, rect.size.height-14)];
                label.backgroundColor = [UIColor grayColor];
                [tempView addSubview:label];
            }
        }
    }
    return self;
}

-(void)buttonViewClick:(UIGestureRecognizer *)gest{
    [self.delegate ButtonViewTitleBtn:gest.view];
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
