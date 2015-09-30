//
//  SigleBtnView.h
//  JiaoBao
//  自定义的单个but
//  Created by Zqw on 15/9/21.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SigleBtnView : UIView

@property (nonatomic,strong) UIImageView *mImg_head;//图片
@property (nonatomic,strong) UILabel *mLab_title;//标题
@property (nonatomic,assign) int mInt_flag;//是1否0勾选

//          此按钮宽度，可传0   按钮高度                按钮标题
-(id)initWidth:(float)width height:(float)height title:(NSString *)title;

@end
