//
//  CheckLeaveViewController.h
//  JiaoBao
//  审核总界面
//  Created by Zqw on 16/3/16.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonViewModel.h"
#import "LeaveTopScrollView.h"
#import "MyNavigationBar.h"
#import "dm.h"
#import "utils.h"
#import "define_constant.h"

@interface CheckLeaveViewController : UIViewController<MyNavigationDelegate,LeaveViewCellDelegate>

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) LeaveTopScrollView *mScrollV_all;//查询分类显示
@property (nonatomic,strong) NSString *mStr_navName;//导航条名称
@property (nonatomic,assign) int mInt_flag;//区分当前选择的是第几个

@end
