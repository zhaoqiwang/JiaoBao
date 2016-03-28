//
//  LeaveViewController.h
//  JiaoBao
//  请假主界面
//  Created by Zqw on 16/3/11.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonViewModel.h"
#import "LeaveTopScrollView.h"
#import "MyNavigationBar.h"
#import "dm.h"
#import "utils.h"
#import "define_constant.h"
#import "LeaveView.h"
#import "QueryViewController.h"

@interface LeaveViewController : UIViewController<MyNavigationDelegate,LeaveViewCellDelegate>

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) LeaveTopScrollView *mScrollV_all;//查询分类显示
@property (nonatomic,strong) NSString *mStr_navName;//导航条名称
@property (nonatomic,strong) LeaveView *mView_root0;//请假表格,自己请假
@property (nonatomic,strong) LeaveView *mView_root1;//请假表格,代请
@property (nonatomic,assign) int mInt_flag;//区分是是请假还是查询
@property(nonatomic,strong)QueryViewController *myQueryVC;//个人查询
@property(nonatomic,strong)QueryViewController *classQueryVC;//班级查询

@property (nonatomic,assign) int mInt_leaveID;//区分身份，门卫0，班主任1，普通老师2，家长3

@end
