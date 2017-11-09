//
//  BaseTextField.m
//  JiaoBao
//
//  Created by SongYanming on 2017/11/8.
//  Copyright © 2017年 JSY. All rights reserved.
//

#import "BaseTextField.h"
@implementation BaseTextField
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    UIMenuController*menuController = [UIMenuController sharedMenuController];
    
    if(menuController) {
        
        [UIMenuController sharedMenuController].menuVisible=NO;
        
    }
    
    return NO;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
