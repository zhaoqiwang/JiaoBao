//
//  LeaveView.h
//  JiaoBao
//
//  Created by Zqw on 16/3/12.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeaveView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *mTableV_leave;//
@property (nonatomic,assign) NSInteger mInt_flag;//判断身份，班主任0，普通老师1，家长2
@property (nonatomic,strong) NSMutableArray *mArr_leave;//

- (id)initWithFrame1:(CGRect)frame;

@end
