//
//  AccessoryViewController.h
//  JiaoBao
//
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

@class AccessoryViewControllerProtocol;

@protocol AccessoryViewControllerProtocol <NSObject>

-(void)selectFile:(NSMutableArray *)array;

@end

@interface AccessoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MyNavigationDelegate>{
    MyNavigationBar *mNav_navgationBar;//导航条
    UITableView *mTableV_file;//文件列表
    NSMutableArray *mArr_sumFile;
    id <AccessoryViewControllerProtocol > delegate;
}

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) IBOutlet UITableView *mTableV_file;//文件列表
@property (nonatomic,strong) NSMutableArray *mArr_sumFile;
@property (retain,nonatomic) id <AccessoryViewControllerProtocol > delegate;

@end

