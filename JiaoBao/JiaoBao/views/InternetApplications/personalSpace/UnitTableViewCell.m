//
//  UnitTableViewCell.m
//  JiaoBao
//
//  Created by songyanming on 15/6/5.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "UnitTableViewCell.h"
#import "dm.h"

@implementation UnitTableViewCell

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addBtnAction:(id)sender {
    UIButton *btn = (UIButton*)sender;
    NSLog(@"addBtn");
    [self.delegate ClickBtnWith:btn cell:self];
}
@end
