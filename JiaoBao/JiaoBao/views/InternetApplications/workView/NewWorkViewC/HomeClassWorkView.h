//
//  HomeClassWorkView.h
//  JiaoBao
//
//  Created by Zqw on 15-4-23.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dm.h"
#import "AccessoryViewController.h"
#import "ELCImagePickerHeader.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface HomeClassWorkView : UIView<AccessoryViewControllerProtocol,UIActionSheetDelegate,ELCImagePickerControllerDelegate,UIImagePickerControllerDelegate>{
    UIScrollView *mScrollV_all;//放所有控件
    UIView *mView_top;//放列表的上部分控件
    UITextView *mTextV_input;//输入内容
    UIButton *mBtn_accessory;//附件按钮
    UIButton *mBtn_photos;//拍照按钮
    UIButton *mBtn_sendMsg;//是否发送短信
    UIButton *mBtn_send;//发送按钮
    NSMutableArray *mArr_accessory;//附件数组
    UIView *mView_accessory;//显示附件用
    int mInt_sendMsg;//是否发送短信，0发送，1不发送
}

@property (nonatomic,strong) UIScrollView *mScrollV_all;//放所有控件
@property (nonatomic,strong) UIView *mView_top;//放列表的上部分控件
@property (nonatomic,strong) UITextView *mTextV_input;//输入内容
@property (nonatomic,strong) UIButton *mBtn_accessory;//附件按钮
@property (nonatomic,strong) UIButton *mBtn_photos;//拍照按钮
@property (nonatomic,strong) UIButton *mBtn_sendMsg;//是否发送短信
@property (nonatomic,strong) UIButton *mBtn_send;//发送按钮
@property (nonatomic,strong) NSMutableArray *mArr_accessory;//附件数组
@property (nonatomic,strong) UIView *mView_accessory;//显示附件用
@property (nonatomic,assign) int mInt_sendMsg;//是否发送短信，0发送，1不发送

- (id)initWithFrame1:(CGRect)frame;

@end
