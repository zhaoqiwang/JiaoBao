//
//  StudentSumViewController.h
//  JiaoBao
//  学生统计界面
//  Created by SongYanming on 16/4/11.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SumLeavesModel.h"
#import "MyNavigationBar.h"


@interface StudentSumViewController : UIViewController<MyNavigationDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *stuSection;//列表section
@property(strong,nonatomic)SumLeavesModel *ClassSumModel;//学生统计model
@property(strong,nonatomic)NSString *unitClassId;//班级Id
@property(strong,nonatomic)NSString *sDateTime;//日期

@end
