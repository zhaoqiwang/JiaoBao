//
//  CategorySection.m
//  JiaoBao
//
//  Created by songyanming on 15/8/13.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "CategorySection.h"

@implementation CategorySection

- (void)awakeFromNib {
    // Initialization code
}

- (IBAction)AddBtnAction:(id)sender {
    UIButton *btn = sender;
    [self.delegate CategorySectionClickBtnWith:btn section:self];
}
@end
