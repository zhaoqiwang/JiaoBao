//
//  SharePostingViewController.h
//  JiaoBao
//  发表文章
//  Created by Zqw on 14-11-24.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "dm.h"
#import "utils.h"
#import "ShareHttp.h"
#import "MBProgressHUD.h"
#import "MHImagePickerMutilSelector.h"
#import "ELCImagePickerHeader.h"
#import "ReleaseNewsUnitsModel.h"
#import "GetmyUserClassModel.h"
#import "VideoRecorderViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface SharePostingViewController : UIViewController<MyNavigationDelegate,MBProgressHUDDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,ELCImagePickerControllerDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate,VideoRecorderViewControllerProtocol,AVAudioRecorderDelegate,AVAudioPlayerDelegate>{
    MyNavigationBar *mNav_navgationBar;//导航条
    UITextView *mTextV_content;//内容
    UIButton *mBtn_send;//发表文章按钮
    UIButton *mBtn_send2;//发表文章按钮
    UITextField *mTextF_title;//标题
    UIButton *mBtn_selectPic;//选择图片
    int mInt_index;//记录添加了多少图片,第几张
    NSMutableArray *mArr_pic;//添加的图片数组
    UnitSectionMessageModel *mModel_unit;//传递过来的单位信息
    int mInt_section;//判断是来自分享0还是展示1
    NSString *mStr_uType;//类型
    NSString *mStr_unitID;//单位ID
    UILabel *mLab_fabu;//发布lab
    UILabel *mLab_dongtai;//动态lab
    NSMutableArray *mArr_dynamic;//动态中的权限数组
    UILabel *mLab_hidden;//点击时输入框消失
    UILabel *_placeholderLabel;
    NSMutableArray *pullArr;
    
    NSTimer *timer;
    NSURL *urlPlay;
    NSString *mStr_path;//录音时的临时路径
    NSString *mStr_time;//录音时的临时时间戳
}
@property (weak, nonatomic) IBOutlet UILabel *_placeholdLabel;
@property (weak, nonatomic) IBOutlet UIButton *pullDownBtn;
- (IBAction)pullAction:(id)sender;

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) IBOutlet UITextView *mTextV_content;//内容
@property (nonatomic,strong) IBOutlet UIButton *mBtn_send;//发表文章按钮
@property (nonatomic,strong) IBOutlet UIButton *mBtn_send2;//发表文章按钮
@property (nonatomic,strong) IBOutlet UITextField *mTextF_title;//标题
@property (nonatomic,strong) IBOutlet UIButton *mBtn_selectPic;//选择图片
@property (nonatomic,assign) int mInt_index;//记录添加了多少图片
@property (nonatomic,strong) NSMutableArray *mArr_pic;//添加的图片数组
@property (nonatomic,strong) UnitSectionMessageModel *mModel_unit;//传递过来的单位信息
@property (nonatomic,assign) int mInt_section;//判断是来自分享0还是展示1
@property (nonatomic,strong) NSString *mStr_uType;//类型
@property (nonatomic,strong) NSString *mStr_unitID;//单位ID
@property (nonatomic,strong) IBOutlet UILabel *mLab_fabu;//发布lab
@property (nonatomic,strong) IBOutlet UILabel *mLab_dongtai;//动态lab
@property (nonatomic,strong) NSMutableArray *mArr_dynamic;//动态中的权限数组
@property (nonatomic,strong) IBOutlet UILabel *mLab_hidden;//点击时输入框消失
@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;
@property (weak, nonatomic) IBOutlet UIButton *albumBtn;
@property (weak, nonatomic) IBOutlet UIButton *videoBtn;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
@property (nonatomic,strong) NSMutableArray *pullArr;
//@property(nonatomic,strong)NSTimer *timer;

@property (nonatomic,strong) AVAudioRecorder *recorder;//音频录音机
@property (retain, nonatomic) AVAudioPlayer *audioPlayer;
@property (retain, nonatomic) UIImageView *imageView;


- (IBAction)cameraBtnAction:(id)sender;
- (IBAction)albumBtnAction:(id)sender;
- (IBAction)videoBtnAction:(id)sender;
- (IBAction)btnVoiceDown:(id)sender;
- (IBAction)btnVoiceUp:(id)sender;
- (IBAction)btnVoiceDragUp:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *secondVIew;
@property(nonatomic,assign)NSUInteger imageCount;
@property(nonatomic,assign)int tfContentFlag;

@end
