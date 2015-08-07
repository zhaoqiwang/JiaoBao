//
//  AllCommentListModel.m
//  JiaoBao
//
//  Created by songyanming on 15/8/6.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "AllCommentListModel.h"

@implementation AllCommentListModel
-(instancetype)init
{
    self = [super init];
    self.mArr_CommentList = [[NSMutableArray alloc]initWithCapacity:0];
    self.mArr_refcomments = [[NSMutableArray alloc]initWithCapacity:0];
    return self;
}
@end
