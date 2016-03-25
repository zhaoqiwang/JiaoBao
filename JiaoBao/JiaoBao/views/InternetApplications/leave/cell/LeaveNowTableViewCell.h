//
//  LeaveNowTableViewCell.h
//  JiaoBao
//
//  Created by Zqw on 16/3/12.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeaveNowTableViewCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel *mLab_name;//名称标签
@property (nonatomic,strong) IBOutlet UILabel *mLab_value;//名称实际值
@property (nonatomic,strong) IBOutlet UITextField *mTextF_reason;//理由
@property (nonatomic,strong) IBOutlet UIButton *mBtn_add;//添加
@property (nonatomic,strong) IBOutlet UILabel *mLab_add;//添加时间段
@property (nonatomic,strong) IBOutlet UIButton *mBtn_submit;//提交

@end
