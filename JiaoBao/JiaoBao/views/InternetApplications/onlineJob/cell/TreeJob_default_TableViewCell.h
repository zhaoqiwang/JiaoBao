//
//  TreeJob_default_TableViewCell.h
//  JiaoBao
//  布置作业的普通类型cell
//  Created by Zqw on 15/10/14.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TreeJob_default_TableViewCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel *mLab_title;//标题
@property (nonatomic,strong) IBOutlet UILabel *mLab_select;//选择显示
@property (nonatomic,strong) IBOutlet UILabel *mLab_line;//分割线
@property (nonatomic,strong) IBOutlet UIImageView *mImg_pic;//下拉


@end
