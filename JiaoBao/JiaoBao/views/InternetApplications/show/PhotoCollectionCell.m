//
//  PhotoCollectionCell.m
//  MobileDoctor
//
//  Created by SYM on 14-4-30.
//  Copyright (c) 2014年 SYM. All rights reserved.
//

#import "PhotoCollectionCell.h"

@implementation PhotoCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)awakeFromNib
{

    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (IBAction)deleteAction:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"delete" object:self.deleteBtn];
}
@end
