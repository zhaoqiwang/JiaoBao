//
//  CreatAlbumsViewController.h
//  JiaoBao
//
//  Created by Zqw on 14-12-24.
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


@protocol CreatAlbumsDelegate;

@interface CreatAlbumsViewController : UIViewController<MyNavigationDelegate,MBProgressHUDDelegate>{
    MyNavigationBar *mNav_navgationBar;//导航条
    UILabel *mLab_name;//相册名
    UITextField *mTextF_name;//相册名
    UILabel *mLab_desInfo;//相册描述
    UITextField *mTextF_desInfo;//相册描述
    UILabel *mLab_type;//相册权限，个人，0:私有；1：好友可访问；2：关注可访问；3：游客可访问，单位：0无限制，1单位内可见
    UITextField *mTextF_type;//显示选择的类型
    UIButton *mBtn_type;//弹出类型选择框
    TableViewWithBlock *mTableV_type;//下拉选择框
    NSString *mStr_flag;//来自个人1，单位2
    NSString *mStr_unitID;//单位id
    NSString *mStr_type;//当前选择的权限
    BOOL isOpened;
//    id<CreatAlbumsDelegate> delegate;
}

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) IBOutlet UILabel *mLab_name;//相册名
@property (nonatomic,strong) IBOutlet UITextField *mTextF_name;//相册名
@property (nonatomic,strong) IBOutlet UILabel *mLab_desInfo;//相册描述
@property (nonatomic,strong) IBOutlet UITextField *mTextF_desInfo;//相册描述
@property (nonatomic,strong) IBOutlet UILabel *mLab_type;//相册权限，个人，0:私有；1：好友可访问；2：关注可访问；3：游客可访问，单位：0无限制，1单位内可见
@property (nonatomic,strong) IBOutlet UITextField *mTextF_type;//显示选择的类型
@property (nonatomic,strong) IBOutlet UIButton *mBtn_type;//弹出类型选择框
@property (nonatomic,strong) IBOutlet TableViewWithBlock *mTableV_type;//下拉选择框
@property (nonatomic,strong) NSString *mStr_flag;//来自个人1，单位2
@property (nonatomic,strong) NSString *mStr_unitID;//单位id
@property (nonatomic,strong) NSString *mStr_type;//当前选择的权限
@property (weak,nonatomic) id<CreatAlbumsDelegate> delegate;

- (IBAction)changeOpenStatus:(id)sender;

@end

@protocol CreatAlbumsDelegate <NSObject>

- (void) CreatePhotoGroupSuccess;

@end