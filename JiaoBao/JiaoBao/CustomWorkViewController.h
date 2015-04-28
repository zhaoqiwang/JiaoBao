//
//  CustomWorkViewController.h
//  JiaoBao
//
//  Created by songyanming on 15/4/28.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "utils.h"
#import "dm.h"
#import "LoginSendHttp.h"
#import "Forward_cell.h"
#import "MBProgressHUD.h"


@interface CustomWorkViewController : UIViewController
@property (nonatomic,strong) MBProgressHUD *mProgressV;//
@property (nonatomic,strong) CommMsgRevicerUnitListModel *mModel_unitList;//
@property (nonatomic,strong) myUnit *mModel_myUnit;//当前界面显示的人员model




@end
