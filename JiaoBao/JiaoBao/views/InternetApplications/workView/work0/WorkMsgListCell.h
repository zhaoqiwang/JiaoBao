//
//  WorkMsgListCell.h
//  JiaoBao
//
//  Created by Zqw on 15-2-10.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkMsgListCell : UITableViewCell{
    UIImageView *mImgV_head;
    UILabel *mLab_name;
    UILabel *mLab_time;
    UILabel *mLab_content;
    UIImageView *mImgV_background;
    UIButton *mBtn_work;
    UILabel *mLab_line;
}

@property (nonatomic,strong) IBOutlet UIImageView *mImgV_head;
@property (nonatomic,strong) IBOutlet UILabel *mLab_name;
@property (nonatomic,strong) IBOutlet UILabel *mLab_time;
@property (nonatomic,strong) IBOutlet UILabel *mLab_content;
@property (nonatomic,strong) IBOutlet UIImageView *mImgV_background;
@property (nonatomic,strong) IBOutlet UIButton *mBtn_work;
@property (nonatomic,strong) IBOutlet UILabel *mLab_line;
@property (nonatomic,strong) IBOutlet UIView *mView_att;//放置附件

@end
