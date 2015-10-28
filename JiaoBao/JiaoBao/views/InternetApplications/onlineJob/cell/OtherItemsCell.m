//
//  OtherItemsCell.m
//  JiaoBao
//
//  Created by songyanming on 15/10/17.
//  Copyright © 2015年 JSY. All rights reserved.
//

#import "OtherItemsCell.h"

@implementation OtherItemsCell

- (void)awakeFromNib {
    // Initialization code
}




/**
 
 *  通过以下代码实现设置文本框高度
 
 *  44是所希望的高度
 
 */

- (CGRect)borderRectForBounds:(CGRect)bounds

{
    
    bounds.size.height = 25;
    
    return bounds;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
