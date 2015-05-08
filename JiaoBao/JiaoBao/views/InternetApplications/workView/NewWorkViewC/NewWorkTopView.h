//
//  NewWorkTopView.h
//  JiaoBao
//  新建界面的上半部分
//  Created by Zqw on 15-4-25.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dm.h"
#import "AccessoryViewController.h"
#import "ELCImagePickerHeader.h"
#import <MobileCoreServices/UTCoreTypes.h>

@class NewWorkTopViewProtocol;

@protocol NewWorkTopViewProtocol <NSObject>

//点击发送短信按钮
//-(void)sendMsgBtn:(UIButton *)btn;

//附件按钮点击事件
//-(void)mBtn_accessory:(UIButton *)btn;

//点击照片
//-(void)mBtn_photo:(UIButton *)btn;

//点击发送按钮
-(void)mBtn_send:(UIButton *)btn;

@end

@interface NewWorkTopView : UIView<UIActionSheetDelegate,ELCImagePickerControllerDelegate,UIImagePickerControllerDelegate,AccessoryViewControllerProtocol,UITextViewDelegate>{
    UITextView *mTextV_input;//输入内容
    UIButton *mBtn_accessory;//附件按钮
    UIButton *mBtn_photos;//拍照按钮
    UIButton *mBtn_sendMsg;//是否发送短信
    UIButton *mBtn_send;//发送按钮
    NSMutableArray *mArr_accessory;//附件数组
    UIView *mView_accessory;//显示附件用
    int mInt_sendMsg;//是否发送短信，0发送，1不发送
    id <NewWorkTopViewProtocol > delegate;
}

@property (nonatomic,strong) UITextView *mTextV_input;//输入内容
@property (nonatomic,strong) UIButton *mBtn_accessory;//附件按钮
@property (nonatomic,strong) UIButton *mBtn_photos;//拍照按钮
@property (nonatomic,strong) UIButton *mBtn_sendMsg;//是否发送短信
@property (nonatomic,strong) UIButton *mBtn_send;//发送按钮
@property (nonatomic,strong) NSMutableArray *mArr_accessory;//附件数组
@property (nonatomic,strong) UIView *mView_accessory;//显示附件用
@property (nonatomic,assign) int mInt_sendMsg;//是否发送短信，0发送，1不发送
@property (retain,nonatomic) id <NewWorkTopViewProtocol > delegate;
-(void)addAccessoryPhoto;

//刷新显示附件
-(void)addAccessoryPhoto;

//- (id)initWithFrame1:(CGRect)frame;

@end
