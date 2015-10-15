//
//  Mode_Selection_Cell.m
//  JiaoBao
//
//  Created by songyanming on 15/10/15.
//  Copyright © 2015年 JSY. All rights reserved.
//

#import "Mode_Selection_Cell.h"

@implementation Mode_Selection_Cell

- (void)awakeFromNib {
    self.characterButton.selected = YES;
    self.sameButton.selected = NO;
    self.customButton.selected = NO;
    self.characterButton.tag = 0;
    self.sameButton.tag = 1;
    self.customButton.tag = 2;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)modeSelectionAction:(id)sender {
    UIButton *btn = sender;
    if([btn isEqual:self.characterButton])
    {
        btn.selected = YES;
        self.sameButton.selected = NO;
        self.customButton.selected = NO;


    }
    if([btn isEqual:self.sameButton])
    {
        btn.selected = YES;
        self.characterButton.selected = NO;
        self.customButton.selected = NO;
    }
    if([btn isEqual:self.customButton])
    {
        btn.selected = YES;
        self.sameButton.selected = NO;
        self.characterButton.selected = NO;
    }
    [self.delegate modeSelectionActionWithButtonTag:btn.tag];
}
@end
