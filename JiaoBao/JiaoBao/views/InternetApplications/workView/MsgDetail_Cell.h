//
//  MsgDetail_Cell.h
//  JiaoBao
//
//  Created by Zqw on 14-10-29.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MsgDetail_Cell : UITableViewCell{
    UILabel *mLab_name;//姓名
    UILabel *mLab_content;//内容
}

@property (nonatomic,strong) IBOutlet UILabel *mLab_name;//姓名
@property (nonatomic,strong) IBOutlet UILabel *mLab_content;//内容

@end
