//
//  OtherItemsCell.h
//  JiaoBao
//  其他项目cell
//  Created by songyanming on 15/10/17.
//  Copyright © 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherItemsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//标题
@property (weak, nonatomic) IBOutlet UITextField *textField;//标题输入框
@property (nonatomic,strong) IBOutlet UILabel *mLab_line;//分割线

@end
