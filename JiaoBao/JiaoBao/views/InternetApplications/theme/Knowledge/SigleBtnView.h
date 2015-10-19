//
//  SigleBtnView.h
//  JiaoBao
//  自定义的单个btn
//  Created by Zqw on 15/9/21.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SigleBtnViewDelegate;

@interface SigleBtnView : UIView

@property (nonatomic,strong) UIImageView *mImg_head;//图片
@property (nonatomic,strong) UILabel *mLab_title;//标题
@property (nonatomic,assign) int mInt_flag;//是1否0勾选
@property (nonatomic,assign) int mInt_sigle;//只有一个，需要反选0，还是多个是一个整体1，只有一个，点击即选中2
@property (nonatomic,assign) int mInt_tag;//区分
@property (weak,nonatomic) id<SigleBtnViewDelegate> delegate;

//          此按钮宽度，可传0   按钮高度                按钮标题                是否选中，是1否0
-(id)initWidth:(float)width height:(float)height title:(NSString *)title select:(int)flag sigle:(int)sigle;

@end

//向cell中添加点击事件
@protocol SigleBtnViewDelegate <NSObject>

@optional

//点击
-(void)SigleBtnViewClick:(SigleBtnView *) sigleBtnView;

@end