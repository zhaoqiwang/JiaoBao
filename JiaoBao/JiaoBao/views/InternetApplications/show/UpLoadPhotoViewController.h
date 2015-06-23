//
//  UpLoadPhotoViewController.h
//  JiaoBao
//
//  Created by Zqw on 14-12-25.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "dm.h"
#import "utils.h"
#import "MBProgressHUD.h"
#import "ThemeHttp.h"
#import "UITableView+DataSourceBlocks.h"
#import "TableViewWithBlock.h"
#import "ELCImagePickerHeader.h"

@protocol UpLoadPhotoDelegate;

@interface UpLoadPhotoViewController : UIViewController<MyNavigationDelegate,MBProgressHUDDelegate,UIActionSheetDelegate,ELCImagePickerControllerDelegate>{
    MyNavigationBar *mNav_navgationBar;//导航条
    MBProgressHUD *mProgressV;//
    UILabel *mLab_name;//相册名
    UITextField *mTextF_name;//相册名
    UIButton *mBtn_name;//弹出类型选择框
    TableViewWithBlock *mTableV_name;//下拉选择框
    UIButton *mBtn_upload;//选择照片上传
    NSString *mStr_flag;//来自个人1，单位2
    NSString *mStr_groupID;//相册id
    BOOL isOpened;
    NSMutableArray *mArr_albums;//相册数组
    int mInt_uploadCount;//上传照片个数
    int mInt_count;//返回照片通知的个数
//    id<UpLoadPhotoDelegate> delegate;
}

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) MBProgressHUD *mProgressV;//
@property (nonatomic,strong) IBOutlet UILabel *mLab_name;//相册名
@property (nonatomic,strong) IBOutlet UITextField *mTextF_name;//相册名
@property (nonatomic,strong) IBOutlet UIButton *mBtn_name;//弹出类型选择框
@property (nonatomic,strong) IBOutlet TableViewWithBlock *mTableV_name;//下拉选择框
@property (nonatomic,strong) IBOutlet UIButton *mBtn_upload;//选择照片上传
@property (nonatomic,strong) NSString *mStr_flag;//来自个人1，单位2
@property (nonatomic,strong) NSString *mStr_groupID;//相册id
@property (nonatomic,strong) NSMutableArray *mArr_albums;//相册数组
@property (weak,nonatomic) id<UpLoadPhotoDelegate> delegate;

- (IBAction)changeOpenStatus:(id)sender;

-(IBAction)uploadPhoto:(id)sender;

@end

@protocol UpLoadPhotoDelegate <NSObject>

- (void) UpLoadPhotoSuccess;

@end