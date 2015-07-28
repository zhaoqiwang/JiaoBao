//
//  AccessoryTableViewCell.h
//  JiaoBao
//
//  Created by Zqw on 15-3-13.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AccessoryTableViewCellDelegate;

@interface AccessoryTableViewCell : UITableViewCell{
    UIImageView *mImgV_select;//是否选择
    UILabel *mLab_name;//文件名称
//    id<AccessoryTableViewCellDelegate> delegate;
}

@property (nonatomic,strong) IBOutlet UIImageView *mImgV_select;//是否选择
@property (nonatomic,strong) IBOutlet UILabel *mLab_name;//文件名称
@property (nonatomic,strong) IBOutlet UILabel *mLab_size;//文件大小
@property (weak,nonatomic) id<AccessoryTableViewCellDelegate> delegate;

//给头像添加点击事件
-(void)headImgClick;

@end


@protocol AccessoryTableViewCellDelegate <NSObject>

//向cell中添加头像点击手势
- (void) AccessoryTableViewCellTapPress:(AccessoryTableViewCell *) accessoryTableViewCell;

@end