//
//  MyNavigationBar.h
//  iUM
//
//  Created by chai longlong on 12-10-23.
//
//

#import <UIKit/UIKit.h>
#import "Loger.h"
#import <QuartzCore/QuartzCore.h>

@protocol MyNavigationDelegate <NSObject>



-(void)myNavigationGoback;
@optional
-(void)navigationRightAction:(UIButton *)sender;

@end


@protocol MyNavigationBtnTitleDelegate <NSObject>

-(void)MyBtnTitleTap:(UIButton *)titleBtn;

@end

@interface MyNavigationBar : UIView{
    UILabel *_label_Title;
    id<MyNavigationDelegate> _delegate;
    NSString *_roomName;
    int _roomId;
    
    UIImage *_img_L_N;
    UIImage *_img_L_H;
    UIImage *_img_R_N;
    UIImage *_img_R_H;
    
    UIImageView * triImageView;//btnTitle三角图片
    BOOL triFlag;//三角图片变化标记
    UIButton *btn_Title;//navigationBtn;
    UIImageView * sliderImageV;//通讯录滑块ImageView
    
}
@property (nonatomic , retain) UIImage *img_L_N;
@property (nonatomic , retain) UIImage *img_L_H;
@property (nonatomic , retain) UIImage *img_R_N;
@property (nonatomic , retain) UIImage *img_R_H;



@property (nonatomic , retain) id<MyNavigationDelegate> delegate;
@property (nonatomic , retain) id<MyNavigationBtnTitleDelegate>btnDelegate;
@property (nonatomic , retain) UILabel *label_Title;
@property (nonatomic , retain) NSString *roomName;
@property (nonatomic , assign) int roomId;
@property (nonatomic , retain) UILabel * mainTitleLabel;
@property (nonatomic , retain) UILabel * subTitleLabel;


-(id)initWithTitle:(NSString*)title;
-(void)setRightBtn:(UIImage*)img heighlightImg:(UIImage *)heighImg;
-(void)setMyFrameBy:(CGRect)frame;
-(void)setGoBack;
-(void)setBackBtnTitle:(NSString *)backBtnTitle;

-(void)setRightBtn:(UIImage*)img;
-(void)setRightBtnTitle:(NSString *)title;
-(void)setRightBtn:(UIImage *)img Title:(NSString *)title FontSize:(float)size;

-(id)initWithName:(NSString *)title Tel:(NSString *)tel HeadImg:(UIImage *)img;
- (id)initWithRoomName:(NSString *)name RoomId:(int)roomId;


-(id)initWithButtonTitle:(NSString *)title andImage:(UIImage *)image;

-(void)closePopView;//关闭popView,三角图片改变。
-(void)setTitleBtnWithTitleString:(NSString *)titleStr;//navigationBtn修改按钮文字

-(id)initWithMainTitle:(NSString *)mainTitle andSubTitle:(NSString *)subTitle;
-(void)setSubTitleLabelText:(NSString *)titleText;
-(void)setSliderImageViewImage:(int)type;
@end
