//
//  RecommentAddAnswerModel.m
//  JiaoBao
//
//  Created by Zqw on 15/8/14.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "RecommentAddAnswerModel.h"

@implementation RecommentAddAnswerModel

-(instancetype)init{
    if (self) {
        self.answerArray = [NSMutableArray array];
//        self.questionModel = [[RecommentQuestionModel alloc] init];
    }
    return self;
}

@end

@implementation RecommentQuestionModel

-(instancetype)init{
    if (self) {
        
    }
    return self;
}

@end