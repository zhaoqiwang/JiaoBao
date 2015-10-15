//
//  MessageSelectionCell.m
//  JiaoBao
//
//  Created by songyanming on 15/10/15.
//  Copyright © 2015年 JSY. All rights reserved.
//

#import "MessageSelectionCell.h"

@implementation MessageSelectionCell

- (void)awakeFromNib {
    self.notificationBtn.selected = YES;
    self.feedbackBtn.selected = YES;
    self.notificationBtn.tag = 0;
    self.feedbackBtn.tag = 1;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)buttonSelectionAction:(id)sender {
    UIButton *btn = sender;
    btn.selected = !btn.selected;
    

    [self.delegate MessageSelectionActionWithButtonTag0:self.notificationBtn.selected  tag1:self.feedbackBtn.selected];
}
@end
