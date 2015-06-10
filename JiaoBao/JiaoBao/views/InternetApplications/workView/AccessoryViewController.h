//
//  AccessoryViewController.h
//  JiaoBao
//  附件页面
//  Created by Zqw on 15-3-13.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "dm.h"
#import "utils.h"
#import "MBProgressHUD.h"
#import "AccessoryTableViewCell.h"
#import "AccessoryModel.h"
#import "MWPhotoBrowser.h"
#import "utils.h"
#import "OpenFileViewController.h"

@class AccessoryViewControllerProtocol;

@protocol AccessoryViewControllerProtocol <NSObject>

-(void)selectFile:(NSMutableArray *)array;

@end

@interface AccessoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MyNavigationDelegate,AccessoryTableViewCellDelegate,UIActionSheetDelegate,MWPhotoBrowserDelegate>{
    MyNavigationBar *mNav_navgationBar;//导航条
    UITableView *mTableV_file;//文件列表
    NSMutableArray *mArr_sumFile;
    id <AccessoryViewControllerProtocol > delegate;
    int mInt_flag;//判断是选择附件0，还是查看1
    NSMutableArray *mArr_photo;//图片的名称
    NSMutableArray *_selections;//是否选中图片
}

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) IBOutlet UITableView *mTableV_file;//文件列表
@property (nonatomic,strong) NSMutableArray *mArr_sumFile;
@property (retain,nonatomic) id <AccessoryViewControllerProtocol > delegate;
@property (nonatomic,assign) int mInt_flag;//判断是选择附件0，还是查看1
@property (nonatomic,strong) NSMutableArray *photos;//图片的路径
@property (nonatomic,strong) NSMutableArray *mArr_photo;//图片的名称

@end

