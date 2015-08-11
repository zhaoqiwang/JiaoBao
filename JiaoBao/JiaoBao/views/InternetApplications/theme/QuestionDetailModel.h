//
//  QuestionDetailModel.h
//  JiaoBao
//
//  Created by songyanming on 15/8/6.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionDetailModel : NSObject
@property(nonatomic,strong)NSString *TabID;//问题ID
@property(nonatomic,strong)NSString *Title;//标题
@property(nonatomic,strong)NSString *Abstracts;//摘要
@property(nonatomic,strong)NSString *ViewCount;//浏览人数
@property(nonatomic,strong)NSString *LastUpdate;//更新时间
@property(nonatomic,strong)NSString *AnswersCount;//答案数量
@property(nonatomic,strong)NSMutableArray *Thumbnail;//缩略图地址
@property(nonatomic,strong)NSString *KnContent;//内容
@property(nonatomic,strong)NSString *AreaCode;//区域代码
@property(nonatomic,strong)NSString *AtAccIds;//回答人的教宝号

@end
