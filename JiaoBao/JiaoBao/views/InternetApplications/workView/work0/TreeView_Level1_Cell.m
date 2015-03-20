//
//  TreeView_Level1_Cell.m
//  JiaoBao
//
//  Created by Zqw on 14-10-23.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "TreeView_Level1_Cell.h"

@implementation TreeView_Level1_Cell
@synthesize mBtn_detail,mImgV_open_close,mImgV_number,mLab_name,mLab_number,mNode,delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(IBAction)clickBtn{
    if (delegate && [delegate respondsToSelector:@selector(selectedMoreBtn1:)]){
        [delegate selectedMoreBtn1:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect
{
//    int addX = self.mNode.nodeLevel*25; //根据节点所在的层次计算平移距离
//    CGRect imgFrame = self.mImgV_open_close.frame;
//    imgFrame.origin.x = 14 + addX;
//    self.mImgV_open_close.frame = imgFrame;
    
    //    CGRect nameFrame = self.mLab_name.frame;
    //    nameFrame.origin.x = 62 + addX;
    //    self.mLab_name.frame = nameFrame;
}

@end
