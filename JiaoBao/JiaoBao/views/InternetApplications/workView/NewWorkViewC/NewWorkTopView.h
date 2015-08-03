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
#import <AVFoundation/AVFoundation.h>
#import "VideoRecorderViewController.h"
#import "MBProgressHUD+AD.h"

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

@interface NewWorkTopView : UIView<UIActionSheetDelegate,ELCImagePickerControllerDelegate,UIImagePickerControllerDelegate,AccessoryViewControllerProtocol,UITextViewDelegate,AVAudioRecorderDelegate,AVAudioPlayerDelegate,VideoRecorderViewControllerProtocol>{
    UITextView *mTextV_input;//输入内容
    UIButton *mBtn_accessory;//附件按钮
    UIButton *mBtn_photos;//拍照按钮
    UIButton *mBtn_sendMsg;//是否发送短信
    UIButton *mBtn_send;//发送按钮
    NSMutableArray *mArr_accessory;//附件数组
    UIView *mView_accessory;//显示附件用
    int mInt_sendMsg;//是否发送短信，0发送，1不发送
    //__weak id <NewWorkTopViewProtocol > delegate;
//    AVAudioRecorder *recorder;
    NSTimer *timer;
    NSURL *urlPlay;
    NSString *mStr_path;//录音时的临时路径
    NSString *mStr_time;//录音时的临时时间戳
}

@property (nonatomic,strong) UITextView *mTextV_input;//输入内容
@property (nonatomic,strong) UIButton *mBtn_accessory;//附件按钮
@property (nonatomic,strong) UIButton *mBtn_photos;//拍照按钮
@property (nonatomic,strong) UIButton *mBtn_sendMsg;//是否发送短信
@property (nonatomic,strong) UIButton *mBtn_send;//发送按钮
@property (nonatomic,strong) NSMutableArray *mArr_accessory;//附件数组
@property (nonatomic,strong) UIView *mView_accessory;//显示附件用
@property (nonatomic,assign) int mInt_sendMsg;//是否发送短信，0发送，1不发送
@property (weak,nonatomic) id <NewWorkTopViewProtocol > delegate;

@property (nonatomic,strong) AVAudioRecorder *recorder;//音频录音机
//@property (nonatomic,strong) AVAudioPlayer *audioPlayer;//音频播放器，用于播放录音文件
//@property (nonatomic,strong) NSTimer *timer;//录音声波监控（注意这里暂时不对播放进行监控）
@property (retain, nonatomic) AVAudioPlayer *audioPlayer;
@property (retain, nonatomic) UIImageView *imageView;
@property (nonatomic,assign) double mInt_time;//录音时间
@property (nonatomic,assign) int mInt_flag;//录音按钮是否按下状态

@property(nonatomic,strong)UIImagePickerController *picker;


//刷新显示附件
-(void)addAccessoryPhoto;

//- (id)initWithFrame1:(CGRect)frame;

@end
