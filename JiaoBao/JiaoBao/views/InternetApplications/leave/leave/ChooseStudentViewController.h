//
//  ChooseStudentViewController.h
//  JiaoBao
//  请假时，选择学生界面
//  Created by Zqw on 16/3/15.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "dm.h"
#import "utils.h"
#import "define_constant.h"
#import "MyStdInfo.h"
#import "MyAdminClass.h"
#import "LeaveHttp.h"
#import "StuInfoModel.h"

@protocol ChooseStudentViewCDelegate;

@interface ChooseStudentViewController : UIViewController<MyNavigationDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) NSString *mStr_navName;//导航条名称
@property (nonatomic,strong) IBOutlet UITableView *mTableV_list;//
@property (nonatomic,strong) NSMutableArray *mArr_student;//学生列表
@property (weak,nonatomic) id<ChooseStudentViewCDelegate> delegate;
@property (nonatomic,assign) int mInt_flag;//选择请假学生0，选择请假理由1
@property (nonatomic,assign) int mInt_flagID;//家长请假0，班主任代请1，班主任、老师、门卫自己请假2

@end

@protocol ChooseStudentViewCDelegate <NSObject>
//向cell中添加长按手势
- (void) ChooseStudentViewCSelect:(id) student flag:(int)flag flagID:(int)flagID;

@end