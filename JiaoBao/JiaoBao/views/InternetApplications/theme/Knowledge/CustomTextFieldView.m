//
//  CustomTextFieldView.m
//  JiaoBao
//
//  Created by Zqw on 15/9/8.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "CustomTextFieldView.h"
#import "dm.h"

@implementation CustomTextFieldView

-(id)initFrame:(CGRect)rect{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(rect.origin.x-1, rect.origin.y, rect.size.width+2, rect.size.height);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = .5;
        self.layer.borderColor = [[UIColor blackColor] CGColor];
        
        //键盘事件
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
        
        //输入框
        self.mTextF_input = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, [dm getInstance].width-30-40, rect.size.height-20)];
        self.mTextF_input.placeholder = @"";
        self.mTextF_input.delegate = self;
        self.mTextF_input.clearsOnBeginEditing = YES;
        self.mTextF_input.font = [UIFont systemFontOfSize:14];
        self.mTextF_input.borderStyle = UITextBorderStyleRoundedRect;
        self.mTextF_input.returnKeyType = UIReturnKeyDone;//return键的类型
        [self addSubview:self.mTextF_input];
        
        //确定按钮
        self.mBtn_sure = [UIButton buttonWithType:UIButtonTypeCustom];
        self.mBtn_sure.frame = CGRectMake([dm getInstance].width-50, 0, 40, rect.size.height);
        self.mBtn_sure.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        [self.mBtn_sure setTitle:@"确定" forState:UIControlStateNormal];
        [self.mBtn_sure setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.mBtn_sure addTarget:self action:@selector(click_mBtn_sure:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.mBtn_sure];
    }
    return self;
}

-(void)click_mBtn_sure:(UIButton *)btn{
    [self.mTextF_input resignFirstResponder];
    if (self.mTextF_input.text.length>0) {
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(CustomTextFieldViewSureBtn:)]) {
            [self.delegate CustomTextFieldViewSureBtn:self];
        }
    }
}

//键盘点击DO
#pragma mark - UITextView Delegate Methods
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@"\n"]) {
        self.hidden = YES;
        [textField resignFirstResponder];
        //若其有输入内容，则发送
        if (textField.text.length>0) {
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(CustomTextFieldViewSureBtn:)]) {
                [self.delegate CustomTextFieldViewSureBtn:self];
            }
        }
        return NO;
    }
    return YES;
}

- (void) keyboardWasShown:(NSNotification *) notif{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSValue *animationDurationValue = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         self.hidden = NO;
                         self.frame = CGRectMake(-1, [dm getInstance].height-keyboardSize.height-51*1, [dm getInstance].width+2, self.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         ;
                     }];
}
- (void) keyboardWasHidden:(NSNotification *) notif{
    self.hidden = YES;
    NSDictionary *userInfo = [notif userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         self.frame = CGRectMake(-1, [dm getInstance].height, [dm getInstance].width+2, 51);
                     }
                     completion:^(BOOL finished){
                         ;
                     }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
