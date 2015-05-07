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

@interface SharePostingViewController : UIViewController<MyNavigationDelegate,MBProgressHUDDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,MHImagePickerMutilSelectorDelegate,ELCImagePickerControllerDelegate,UIGestureRecognizerDelegate,UITextViewDelegate,UITextFieldDelegate>{
    MyNavigationBar *mNav_navgationBar;//导航条
    UITextView *mTextV_content;//内容
    MBProgressHUD *mProgressV;//
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
}
@property (weak, nonatomic) IBOutlet UILabel *_placeholdLabel;
@property (weak, nonatomic) IBOutlet UIButton *pullDownBtn;
- (IBAction)pullAction:(id)sender;

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) IBOutlet UITextView *mTextV_content;//内容
@property (nonatomic,strong) MBProgressHUD *mProgressV;//
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
- (IBAction)cameraBtnAction:(id)sender;
- (IBAction)albumBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *secondVIew;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
- (IBAction)cancelAction:(id)sender;
- (IBAction)doneAction:(id)sender;

@end
