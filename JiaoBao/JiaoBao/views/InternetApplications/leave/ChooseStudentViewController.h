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

@protocol ChooseStudentViewCDelegate;

@interface ChooseStudentViewController : UIViewController<MyNavigationDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) IBOutlet UITableView *mTableV_list;//
@property (nonatomic,strong) NSMutableArray *mArr_student;//学生列表
@property (weak,nonatomic) id<ChooseStudentViewCDelegate> delegate;

@end

@protocol ChooseStudentViewCDelegate <NSObject>
//向cell中添加长按手势
- (void) ChooseStudentViewCSelect:(id) student;

@end