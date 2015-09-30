//
//  QuestionDetailModel.m
//  JiaoBao
//
//  Created by songyanming on 15/8/6.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "QuestionDetailModel.h"

@implementation QuestionDetailModel
-(instancetype)init
{
    self = [super init];
    self.Thumbnail = [[NSMutableArray alloc]initWithCapacity:0];
    self.TagsList = [NSMutableArray array];
    return self;
}

@end
