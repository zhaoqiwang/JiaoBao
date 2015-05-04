//
//  HomeClassTopScrollView.h
//  JiaoBao
//
//  Created by songyanming on 15/4/27.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dm.h"
#import "HomeClassRootScrollView.h"
#import "utils.h"
#import "LoginSendHttp.h"
#import "Forward_cell.h"
#import "MBProgressHUD.h"
#import "Forward_section.h"
#import "groupselit_selitModel.h"

@interface HomeClassTopScrollView : UIScrollView<UIScrollViewDelegate>{
    UIImageView *mImgV_slide;//蓝色滑块
    NSArray *mArr_name;//名称数组
    NSInteger mInt_userSelectedChannelID;//点击按钮选择名字ID
    NSInteger mInt_scrollViewSelectedChannelID;//滑动列表选择名字ID
}

@property (strong,nonatomic) UIImageView *mImgV_slide;//蓝色滑块
@property (strong,nonatomic) NSArray *mArr_name;//名称数组
@property (assign,nonatomic) NSInteger mInt_userSelectedChannelID;//点击按钮选择名字ID
@property (assign,nonatomic) NSInteger mInt_scrollViewSelectedChannelID;//滑动列表选择名字ID
@property (nonatomic,strong) CommMsgRevicerUnitListModel *mModel_unitList;//
@property (nonatomic,strong) myUnit *mModel_myUnit;//当前界面显示的人员model
@property(nonatomic,strong)NSString *genseliStr;
@property(nonatomic,strong)NSMutableArray *genseliArr;
@property(nonatomic,strong)NSString *curunitid;



+ (HomeClassTopScrollView *)shareInstance;
//滑动撤销选中按钮
- (void)setButtonUnSelect;
//滑动选择按钮
- (void)setButtonSelect;
- (void)initWithNameButtons;


@end
