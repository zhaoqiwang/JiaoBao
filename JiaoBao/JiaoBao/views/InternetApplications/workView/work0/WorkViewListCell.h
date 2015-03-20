//
//  WorkViewListCell.h
//  JiaoBao
//
//  Created by Zqw on 15-2-9.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkViewListCell : UITableViewCell{
    UIImageView *mImgV_head;
    UILabel *mLab_name;
    UILabel *mLab_time;
    UILabel *mLab_content;
    UILabel *mLab_line;
    UIImageView *mImgV_unRead;
    UILabel *mLab_unRead;
}

@property (nonatomic,strong) IBOutlet UIImageView *mImgV_head;
@property (nonatomic,strong) IBOutlet UILabel *mLab_name;
@property (nonatomic,strong) IBOutlet UILabel *mLab_time;
@property (nonatomic,strong) IBOutlet UILabel *mLab_content;
@property (nonatomic,strong) IBOutlet UILabel *mLab_line;
@property (nonatomic,strong) IBOutlet UIImageView *mImgV_unRead;
@property (nonatomic,strong) IBOutlet UILabel *mLab_unRead;

@end
