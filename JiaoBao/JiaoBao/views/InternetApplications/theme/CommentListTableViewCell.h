//
//  CommentListTableViewCell.h
//  JiaoBao
//
//  Created by songyanming on 15/8/10.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImaV;//头像
@property (weak, nonatomic) IBOutlet UILabel *UserName;//用户名
@property (weak, nonatomic) IBOutlet UILabel *WContent;//内容
@property (weak, nonatomic) IBOutlet UILabel *RecDate;//日期

@end
