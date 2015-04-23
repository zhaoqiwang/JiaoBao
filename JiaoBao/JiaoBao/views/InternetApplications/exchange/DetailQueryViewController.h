//
//  DetailQueryViewController.h
//  JiaoBao
//
//  Created by songyanming on 15/3/6.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "utils.h"



@interface DetailQueryViewController : UIViewController<MyNavigationDelegate>
@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property(nonatomic,strong)NSString *selectedDateStr;
@property (weak, nonatomic) IBOutlet UILabel *selectedDate;//已选日期
@property (weak, nonatomic) IBOutlet UITableView *tableView;//查询到的日程记录列表


@end
