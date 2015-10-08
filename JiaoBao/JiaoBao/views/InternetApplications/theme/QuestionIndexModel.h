//
//  QuestionIndexModel.h
//  JiaoBao
//
//  Created by songyanming on 15/8/5.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionIndexModel : NSObject
@property(nonatomic,strong)NSString *TabID;//问题ID
@property(nonatomic,strong)NSString *Title;//标题
@property(nonatomic,strong)NSString *Abstracts;//摘要
@property(nonatomic,strong)NSString *ViewCount;//浏览人数
@property(nonatomic,strong)NSString *LastUpdate;//更新时间
@property(nonatomic,strong)NSString *AnswersCount;//答案数量
@property(nonatomic,strong)NSMutableArray *Thumbnail;//缩略图地址

@end