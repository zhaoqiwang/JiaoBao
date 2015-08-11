//
//  CommentListTableViewCell.h
//  JiaoBao
//
//  Created by songyanming on 15/8/10.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImaV;
@property (weak, nonatomic) IBOutlet UILabel *UserName;
@property (weak, nonatomic) IBOutlet UILabel *WContent;
@property (weak, nonatomic) IBOutlet UILabel *RecDate;

@end
