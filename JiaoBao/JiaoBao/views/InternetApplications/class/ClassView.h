//
//  ClassView.h
//  JiaoBao
//
//  Created by Zqw on 15-3-19.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dm.h"
#import "WorkViewListCell.h"

@interface ClassView : UIView<UITableViewDataSource,UITableViewDelegate>{
    UITableView *mTableV_list;
    NSMutableArray *mArr_list;//
}

@property (nonatomic,strong) UITableView *mTableV_list;
@property (nonatomic,strong) NSMutableArray *mArr_list;//

- (id)initWithFrame1:(CGRect)frame;

@end
