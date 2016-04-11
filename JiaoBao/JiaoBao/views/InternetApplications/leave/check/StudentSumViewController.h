//
//  StudentSumViewController.h
//  JiaoBao
//
//  Created by SongYanming on 16/4/11.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SumLeavesModel.h"
#import "MyNavigationBar.h"


@interface StudentSumViewController : UIViewController<MyNavigationDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *stuSection;
@property(strong,nonatomic)SumLeavesModel *ClassSumModel;
@property(strong,nonatomic)NSString *unitClassId;
@property(strong,nonatomic)NSString *sDateTime;

@end
