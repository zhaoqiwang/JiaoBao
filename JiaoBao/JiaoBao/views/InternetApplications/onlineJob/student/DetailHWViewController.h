//
//  DetailHWViewController.h
//  JiaoBao
//
//  Created by songyanming on 15/10/29.
//  Copyright © 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"


@interface DetailHWViewController : UIViewController<MyNavigationDelegate>
@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property(nonatomic,strong)NSString *TabID;//作业ID
@property(nonatomic,strong)NSString *hwName;//作业名字
@property (weak, nonatomic) IBOutlet UILabel *hwNameLabel;

@end
