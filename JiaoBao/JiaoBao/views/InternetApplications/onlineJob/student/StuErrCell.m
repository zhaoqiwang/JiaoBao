//
//  StuErrCell.m
//  JiaoBao
//
//  Created by SongYanming on 16/3/18.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "StuErrCell.h"

@implementation StuErrCell

- (void)awakeFromNib {
    self.webView.scrollView.scrollEnabled = NO;
    //self.webView.scalesPageToFit = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
