//
//  InternetAppTopScrollView.h
//  JiaoBao
//
//  Created by Zqw on 14-10-22.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dm.h"
#import "InternetAppRootScrollView.h"

@interface InternetAppTopScrollView : UIScrollView<UIScrollViewDelegate>{
    UIImageView *mImgV_slide;//蓝色滑块
    NSArray *mArr_name;//名称数组
    NSInteger mInt_userSelectedChannelID;//点击按钮选择名字ID
    NSInteger mInt_scrollViewSelectedChannelID;//滑动列表选择名字ID
}

@property (strong,nonatomic) UIImageView *mImgV_slide;//蓝色滑块
@property (strong,nonatomic) NSArray *mArr_name;//名称数组
@property (assign,nonatomic) NSInteger mInt_userSelectedChannelID;//点击按钮选择名字ID
@property (assign,nonatomic) NSInteger mInt_scrollViewSelectedChannelID;//滑动列表选择名字ID
@property (assign,nonatomic) NSInteger mInt_share;//0需要发送请求，1不需要
@property (assign,nonatomic) NSInteger mInt_show;//0需要发送所在单位请求，1不需要
@property (assign,nonatomic) NSInteger mInt_show2;//0需要发送关注单位请求，1不需要
@property (assign,nonatomic) NSInteger mInt_theme;//0需要发送关注及参与主题请求，1不需要
@property (assign,nonatomic) NSInteger mInt_work_mysend;//0需要发送1不需要
@property (assign,nonatomic) NSInteger mInt_work_sendToMe;//0需要发送，1不需要
@property(nonatomic,strong)NSTimer *timer;


+ (InternetAppTopScrollView *)shareInstance;
//滑动撤销选中按钮
- (void)setButtonUnSelect;
//滑动选择按钮
- (void)setButtonSelect;
- (void)initWithNameButtons;

//当第一次到达页面时，发送请求
-(void)sendRequest;


@end
