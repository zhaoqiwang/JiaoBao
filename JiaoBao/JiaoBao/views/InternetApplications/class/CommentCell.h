//
//  CommentCell.h
//  JiaoBao
//
//  Created by songyanming on 15/5/20.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCLabel.h"

@interface CommentCell : UITableViewCell
@property (strong, nonatomic) IBOutlet RCLabel *contentLabel;
@property(strong,nonatomic)UILabel *commentLabel;

@end
