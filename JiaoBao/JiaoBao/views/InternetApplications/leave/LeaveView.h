//
//  LeaveView.h
//  JiaoBao
//
//  Created by Zqw on 16/3/12.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeaveNowModel.h"
#import "LeaveNowTableViewCell.h"
#import "dm.h"

@interface LeaveView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *mTableV_leave;//
@property (nonatomic,assign) NSInteger mInt_flag;//判断身份，班主任代请0，普通老师、班主任自己请假1，家长代请2
@property (nonatomic,assign) NSInteger mInt_flagID;//判断身份，班主任0，普通老师1，家长2
@property (nonatomic,strong) NSMutableArray *mArr_leave;//

- (id)initWithFrame1:(CGRect)frame flag:(int)flag flagID:(int)flagID;

@end
