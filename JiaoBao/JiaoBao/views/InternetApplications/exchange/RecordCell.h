//
//  RecordCell.h
//  JiaoBao
//
//  Created by songyanming on 15/3/21.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *TypeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *signInFlagLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;

@end
