//
//  QuestionModel.h
//  JiaoBao
//
//  Created by songyanming on 15/8/5.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnswerModel.h"

@interface QuestionModel : NSObject
@property(nonatomic,strong)NSString *tabid;//推荐ID
@property(nonatomic,strong)NSString *TabID;
@property(nonatomic,strong)NSString *Title;//标题
@property(nonatomic,strong)NSString *AnswersCount;//回答数量
@property(nonatomic,strong)NSString *AttCount;//关注数量
@property(nonatomic,strong)NSString *ViewCount;//浏览数量（打开看过明细的数量)
@property(nonatomic,strong)NSString *CategorySuject;//话题名称
@property(nonatomic,strong)NSString *CategoryId;//话题ID
@property(nonatomic,strong)NSString *LastUpdate;//动态更新日期
@property(nonatomic,strong)NSString *AreaCode;//区域代码
@property(nonatomic,strong)NSString *JiaoBaoHao;//
@property(nonatomic,strong)NSString *rowCount;//记录数量，用于取第二页记录起给参数赋值
@property(nonatomic,strong)NSMutableArray *Thumbnail;//图片url,字符串（url)json数组
@property(nonatomic,strong)AnswerModel *answerModel;//答案model

@end
