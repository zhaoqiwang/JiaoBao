//
//  QuestionModel.m
//  JiaoBao
//
//  Created by songyanming on 15/8/5.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "QuestionModel.h"

@implementation QuestionModel

-(instancetype)init{
    self = [super init];
    self.answerModel = [[AnswerModel alloc]init];
    self.hiddenid = [[NSMutableArray alloc]init];
    return self;
}

@end
