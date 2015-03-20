//
//  AccessoryTableViewCell.h
//  JiaoBao
//
//  Created by Zqw on 15-3-13.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccessoryTableViewCell : UITableViewCell{
    UIImageView *mImgV_select;//是否选择
    UILabel *mLab_name;//文件名称
}

@property (nonatomic,strong) IBOutlet UIImageView *mImgV_select;//是否选择
@property (nonatomic,strong) IBOutlet UILabel *mLab_name;//文件名称

@end
