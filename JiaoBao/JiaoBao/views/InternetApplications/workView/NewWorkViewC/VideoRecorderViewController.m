//
//  VideoRecorderViewController.m
//  JiaoBao
//
//  Created by Zqw on 15/7/20.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "VideoRecorderViewController.h"
#import "AVCaptureManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "utils.h"
#import "dm.h"
#import "MobClick.h"
#import "define_constant.h"
#import "MBProgressHUD+AD.h"

@interface VideoRecorderViewController ()

<AVCaptureManagerDelegate>
{
    NSTimeInterval startTime;
    BOOL isNeededToSave;
    NSURL *videoUrl;
}
@property (nonatomic, strong) AVCaptureManager *captureManager;
@property (nonatomic, assign) NSTimer *timer;//录制、停止用到的计时器
@property (nonatomic, strong) UIImage *recStartImage;//开始图片
@property (nonatomic, strong) UIImage *recStopImage;//停止图片
//@property (nonatomic, strong) UIImage *outerImage1;
//@property (nonatomic, strong) UIImage *outerImage2;

@property (nonatomic, weak) IBOutlet UILabel *statusLabel;//时间
@property (nonatomic, weak) IBOutlet UIButton *recBtn;//录制、停止按钮
//@property (nonatomic, weak) IBOutlet UIImageView *outerImageView;//录制、停止时按钮图片
@property (nonatomic, weak) IBOutlet UIView *topView;//
@property (nonatomic, weak) IBOutlet UIView *rootView;//
@property (nonatomic, weak) IBOutlet UIButton *cancelBtn;//取消按钮
@property (nonatomic, weak) IBOutlet UIButton *sureBtn;//取消按钮

- (IBAction)recButtonTapped:(id)sender;
- (IBAction)recButtonCancelBtn:(id)sender;
- (IBAction)recButtonSureBtn:(id)sender;

@end

@implementation VideoRecorderViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:UMMESSAGE];
    [MobClick endLogPageView:UMPAGE];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:UMMESSAGE];
    [MobClick beginLogPageView:UMPAGE];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
    
    self.captureManager = [[AVCaptureManager alloc] initWithPreviewView:self.view];
    [self.captureManager.captureSession setSessionPreset:AVCaptureSessionPreset352x288];
    self.captureManager.delegate = self;
    
    // Setup images for the Shutter Button
//    UIImage *image;
//    image = [UIImage imageNamed:@"ShutterButtonStart"];
//    self.recStartImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    [self.recBtn setImage:self.recStartImage
//                 forState:UIControlStateNormal];
    
//    image = [UIImage imageNamed:@"ShutterButtonStop"];
//    self.recStopImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
//    [self.recBtn setTintColor:[UIColor colorWithRed:245./255.
//                                              green:51./255.
//                                               blue:51./255.
//                                              alpha:1.0]];
    self.topView.frame = CGRectMake(0, 0, [dm getInstance].width, self.topView.frame.size.height);
    self.statusLabel.frame = self.topView.frame;
    self.rootView.frame = CGRectMake(0, [dm getInstance].height-self.rootView.frame.size.height, [dm getInstance].width, self.rootView.frame.size.height);
    self.recBtn.frame = CGRectMake(([dm getInstance].width-self.recBtn.frame.size.width)/2, (self.rootView.frame.size.height-self.recBtn.frame.size.height)/2, self.recBtn.frame.size.width, self.recBtn.frame.size.height);
    self.cancelBtn.frame = CGRectMake([dm getInstance].width-self.cancelBtn.frame.size.width-10, (self.rootView.frame.size.height-self.cancelBtn.frame.size.height)/2, self.cancelBtn.frame.size.width, self.cancelBtn.frame.size.height);
    self.sureBtn.frame = CGRectMake(10, (self.rootView.frame.size.height-self.sureBtn.frame.size.height)/2, self.sureBtn.frame.size.width, self.sureBtn.frame.size.height);
    [self.recBtn setImage:[UIImage imageNamed:@"VideoShot0"] forState:UIControlStateNormal];
    [self.sureBtn setHidden:YES];
//    self.outerImage1 = [UIImage imageNamed:@"outer1"];
//    self.outerImage2 = [UIImage imageNamed:@"outer2"];
//    self.outerImageView.image = self.outerImage1;
}

#pragma mark - Private
- (void)saveRecordedFile:(NSURL *)recordedFile {
    
//    [SVProgressHUD showWithStatus:@"Saving..." maskType:SVProgressHUDMaskTypeGradient];
    
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(queue, ^{
//        
//        ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
//        [assetLibrary writeVideoAtPathToSavedPhotosAlbum:recordedFile
//                                         completionBlock:
//         ^(NSURL *assetURL, NSError *error) {
//             
//             dispatch_async(dispatch_get_main_queue(), ^{
//                 
////                 [SVProgressHUD dismiss];
//                 
//                 NSString *title;
//                 NSString *message;
//                 
//                 if (error != nil) {
//                     
//                     title = @"Failed to save video";
//                     message = [error localizedDescription];
//                 }
//                 else {
//                     title = @"Saved!";
//                     message = nil;
//                 }
//                 
////                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
////                                                                 message:message
////                                                                delegate:nil
////                                                       cancelButtonTitle:@"OK"
////                                                       otherButtonTitles:nil];
////                 [alert show];
//                [[UIApplication sharedApplication] setStatusBarHidden:NO];
//                 [utils popViewControllerAnimated:NO];
//             });
//         }];
//    });
    
    AccessoryModel *model = [[AccessoryModel  alloc] init];
    NSData *tempData = [[NSData alloc] initWithContentsOfURL:recordedFile];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    NSString *path = [self audioRecordingPath000];
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",timeSp]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL yesNo=[[NSFileManager defaultManager] fileExistsAtPath:path];
    [MBProgressHUD showMessage:@"保存中..." toView:self.view];
    
    if (!yesNo) {//不存在，则直接写入后通知界面刷新
        BOOL result = [tempData writeToFile:path atomically:YES];
        for (;;) {
            if (result) {
                model.mStr_name= [NSString stringWithFormat:@"%@.mp4",timeSp];
                model.pathStr = path;
                model.fileAttributeDic = [fileManager attributesOfItemAtPath:path error:nil];
                [MBProgressHUD hideHUDForView:self.view];
                break;
            }
        }
    }else {//存在
        BOOL blDele= [fileManager removeItemAtPath:path error:nil];//先删除
        if (blDele) {//删除成功后，写入，通知界面
            BOOL result = [tempData writeToFile:path atomically:YES];
            for (;;) {
                if (result) {
                    model.mStr_name= [NSString stringWithFormat:@"%@.mp4",timeSp];
                    model.pathStr = path;
                    model.fileAttributeDic = [fileManager attributesOfItemAtPath:path error:nil];
                    [MBProgressHUD hideHUDForView:self.view];
                    break;
                }
            }
        }
    }
    [self.delegate VideoRecorderSelectFile:model];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [utils popViewControllerAnimated:NO];
}

// =============================================================================
#pragma mark - Timer Handler

- (void)timerHandler:(NSTimer *)timer {
    
    NSTimeInterval current = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval recorded = current - startTime;
    
    self.statusLabel.text = [NSString stringWithFormat:@"%.2f", recorded];
}



// =============================================================================
#pragma mark - AVCaptureManagerDeleagte

- (void)didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL error:(NSError *)error {
    
    if (error) {
        NSLog(@"error:%@", error);
        return;
    }
    
    if (!isNeededToSave) {
        return;
    }
    [self.sureBtn setHidden:NO];
//    [self saveRecordedFile:outputFileURL];
    videoUrl = outputFileURL;
}


// =============================================================================
#pragma mark - IBAction

- (IBAction)recButtonSureBtn:(id)sender{
    [self saveRecordedFile:videoUrl];
}

- (IBAction)recButtonCancelBtn:(id)sender{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [utils popViewControllerAnimated:NO];
}

- (IBAction)recButtonTapped:(id)sender {
    
    // REC START
    if (!self.captureManager.isRecording) {
        [self.recBtn setImage:[UIImage imageNamed:@"VideoShot1"] forState:UIControlStateNormal];
        // change UI
//        [self.recBtn setImage:self.recStopImage forState:UIControlStateNormal];
        
        // timer start
        startTime = [[NSDate date] timeIntervalSince1970];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                      target:self
                                                    selector:@selector(timerHandler:)
                                                    userInfo:nil
                                                     repeats:YES];
        
        [self.captureManager startRecording];
        [self.sureBtn setHidden:YES];
    }
    // REC STOP
    else {
        [self.recBtn setImage:[UIImage imageNamed:@"VideoShot0"] forState:UIControlStateNormal];
        isNeededToSave = YES;
        [self.captureManager stopRecording];
        
        [self.timer invalidate];
        self.timer = nil;
        
        // change UI
//        [self.recBtn setImage:self.recStartImage forState:UIControlStateNormal];
        [self.sureBtn setHidden:NO];
    }
}

-(NSString *)audioRecordingPath000{
    NSString *result = nil;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *tempPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"file-%@",[dm getInstance].jiaoBaoHao]];
    //判断文件夹是否存在
    if(![fileManager fileExistsAtPath:tempPath]) {//如果不存在
        [fileManager createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    result = tempPath;
    return result;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
