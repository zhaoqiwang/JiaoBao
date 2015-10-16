//
//  TreeJob_class_TableViewCell.h
//  JiaoBao
//  布置作业的班级选择cell
//  Created by Zqw on 15/10/15.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SigleBtnView.h"
#import "SigleNameImgBtnView.h"

@interface TreeJob_class_TableViewCell : UITableViewCell<SigleBtnViewDelegate>

@property (nonatomic,strong) SigleNameImgBtnView *sigleClassBtn;//班级选择
@property (nonatomic,strong) IBOutlet UILabel *mLab_nanDu;//难度
@property (nonatomic,strong) SigleBtnView *sigleBtn1;//难度1
@property (nonatomic,strong) SigleBtnView *sigleBtn2;//难度2
@property (nonatomic,strong) SigleBtnView *sigleBtn3;//难度3
@property (nonatomic,strong) SigleBtnView *sigleBtn4;//难度4
@property (nonatomic,strong) SigleBtnView *sigleBtn5;//难度5

@end
