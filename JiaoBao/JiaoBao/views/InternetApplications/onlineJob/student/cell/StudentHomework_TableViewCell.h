//
//  StudentHomework_TableViewCell.h
//  JiaoBao
//
//  Created by Zqw on 15/10/23.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudentHomework_TableViewCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UIImageView *mImg_pic;//是否主观题
@property (nonatomic,strong) IBOutlet UILabel *mLab_title;//作业标题
@property (nonatomic,strong) IBOutlet UILabel *mLab_numLab;//题量标题
@property (nonatomic,strong) IBOutlet UILabel *mLab_num;//题量
@property (nonatomic,strong) IBOutlet UILabel *mLab_timeLab;//过期时间标题
@property (nonatomic,strong) IBOutlet UILabel *mLab_time;//过期时间
@property (nonatomic,strong) IBOutlet UILabel *mLab_goto;//开始、继续作业
@property (nonatomic,strong) IBOutlet UILabel *mLab_scoreLab;//得分标题
@property (nonatomic,strong) IBOutlet UILabel *mLab_score;//得分
@property (nonatomic,strong) IBOutlet UILabel *mLab_powerLab;//学力标题
@property (nonatomic,strong) IBOutlet UILabel *mLab_power;//学力
@property (nonatomic,strong) IBOutlet UILabel *mLab_line;//分割线

@end
