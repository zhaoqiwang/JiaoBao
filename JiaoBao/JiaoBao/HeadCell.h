//
//  HeadCell.h
//  JiaoBao
//
//  Created by songyanming on 15/9/16.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mImgV_head;
@property (weak, nonatomic) IBOutlet UIButton *imgBtn;
@property (weak, nonatomic) IBOutlet UILabel *mLab_trueName;
@property (weak, nonatomic) IBOutlet UILabel *mLab_nickName;
@property (weak, nonatomic) IBOutlet UILabel *mLab_categoryCount;
@property (weak, nonatomic) IBOutlet UIButton *categoryBtn;
@property (weak, nonatomic) IBOutlet UILabel *monthPointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayPointsLabel;
@property (weak, nonatomic) IBOutlet UIButton *personBtn;//我关注的人
@property (weak, nonatomic) IBOutlet UIButton *meBtn;//关注我的人

@end
