//
//  SigleNameImgBtnView.h
//  JiaoBao
//  自定义按钮，名称在前，图片在后
//  Created by Zqw on 15/10/15.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SigleNameImgBtnViewDelegate;

@interface SigleNameImgBtnView : UIView

@property (nonatomic,strong) UIImageView *mImg_head;//图片
@property (nonatomic,strong) UILabel *mLab_title;//标题
@property (nonatomic,assign) int mInt_flag;//是1否0勾选
@property (weak,nonatomic) id<SigleNameImgBtnViewDelegate> delegate;

//          此按钮宽度，可传0   按钮高度                按钮标题                是否选中，是1否0
-(id)initWidth:(float)width height:(float)height title:(NSString *)title select:(int)flag;

@end

//向cell中添加点击事件
@protocol SigleNameImgBtnViewDelegate <NSObject>

@optional

//点击
-(void)SigleNameImgBtnViewClick:(SigleNameImgBtnView *) sigleNameImgBtnView;

@end