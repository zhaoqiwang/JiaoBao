//
//  PeopleSpaceTableViewCell.h
//  JiaoBao
//
//  Created by Zqw on 15/6/4.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PeopleSpaceTableViewCell : UITableViewCell{
    UIImageView *mImgV_head;
    UILabel *mLab_nickName;
    UILabel *mLab_trueName;
    UILabel *mLab_line;
}

@property (nonatomic,strong) IBOutlet UIImageView *mImgV_head;
@property (nonatomic,strong) IBOutlet UILabel *mLab_nickName;
@property (nonatomic,strong) IBOutlet UILabel *mLab_trueName;
@property (nonatomic,strong) IBOutlet UILabel *mLab_line;

@end
