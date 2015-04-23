//
//  HomeClassWorkView.m
//  JiaoBao
//
//  Created by Zqw on 15-4-23.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "HomeClassWorkView.h"

@implementation HomeClassWorkView
@synthesize mArr_accessory,mBtn_accessory,mBtn_photos,mBtn_send,mBtn_sendMsg,mScrollV_all,mTextV_input,mView_accessory,mView_top;

- (id)initWithFrame1:(CGRect)frame{
    self = [super init];
    if (self) {
        // Initialization code
        self.frame = frame;
        //总框
        self.mScrollV_all = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10, [dm getInstance].width, self.frame.size.height-10)];
        [self addSubview:self.mScrollV_all];
        //上半部分
        self.mView_top = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [dm getInstance].width, 0)];
        self.mView_top.backgroundColor = [UIColor whiteColor];
        [self.mScrollV_all addSubview:self.mView_top];
        //输入框
        self.mTextV_input = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, [dm getInstance].width-20, 60)];
        //添加边框
        self.mTextV_input.layer.borderWidth = .5;
        self.mTextV_input.layer.borderColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
        //将图层的边框设置为圆脚
        self.mTextV_input.layer.cornerRadius = 4;
        self.mTextV_input.layer.masksToBounds = YES;
        [self.mView_top addSubview:self.mTextV_input];
        //附件
        self.mBtn_accessory = [UIButton buttonWithType:UIButtonTypeCustom];
        self.mBtn_accessory.frame = CGRectMake(10, self.mTextV_input.frame.origin.y+self.mTextV_input.frame.size.height+10, 40, 30);
        [self.mBtn_accessory setTitle:@"附件" forState:UIControlStateNormal];
        [self.mBtn_accessory setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.mBtn_accessory.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.mView_top addSubview:self.mBtn_accessory];
        //拍照
        self.mBtn_photos = [UIButton buttonWithType:UIButtonTypeCustom];
        self.mBtn_photos.frame = CGRectMake(70, self.mBtn_accessory.frame.origin.y, 40, 30);
        [self.mBtn_photos setTitle:@"拍照" forState:UIControlStateNormal];
        [self.mBtn_photos setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.mBtn_photos.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.mView_top addSubview:self.mBtn_photos];
        //短信提醒
        self.mBtn_sendMsg = [UIButton buttonWithType:UIButtonTypeCustom];
        self.mBtn_sendMsg.frame = CGRectMake(130, self.mBtn_accessory.frame.origin.y, 60, 30);
        [self.mBtn_sendMsg setTitle:@"短信提醒" forState:UIControlStateNormal];
        [self.mBtn_sendMsg setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.mBtn_sendMsg.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.mView_top addSubview:self.mBtn_sendMsg];
        //发送按钮
        self.mBtn_send = [UIButton buttonWithType:UIButtonTypeCustom];
        self.mBtn_send.frame = CGRectMake(240, self.mBtn_accessory.frame.origin.y, 40, 30);
        [self.mBtn_send setTitle:@"发送" forState:UIControlStateNormal];
        [self.mBtn_send setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.mBtn_send.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.mView_top addSubview:self.mBtn_send];
        //附件显示框
        self.mView_accessory = [[UIView alloc] initWithFrame:CGRectMake(20, self.mBtn_accessory.frame.origin.y+self.mBtn_accessory.frame.size.height+10, [dm getInstance].width-30, 0)];
        //上半部分frame
        self.mView_top.frame = CGRectMake(0, 0, self.mView_top.frame.size.width, self.mView_accessory.frame.origin.y+self.mView_accessory.frame.size.height);
    }
    return self;
}

@end
