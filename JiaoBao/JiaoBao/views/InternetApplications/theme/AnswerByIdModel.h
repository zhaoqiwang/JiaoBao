//
//  AnswerByIdModel.h
//  JiaoBao
//
//  Created by songyanming on 15/8/6.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnswerByIdModel : NSObject
@property(nonatomic,strong)NSString *TabID;//答案ID
@property(nonatomic,strong)NSString *JiaoBaoHao;//教宝号
@property(nonatomic,strong)NSString *JiaoBaoHao2;//教宝号--如果是匿名回答，这里保存真实教宝号
@property(nonatomic,strong)NSString *QId;//问题ID
@property(nonatomic,strong)NSString *RecDate;//回答时间
@property(nonatomic,strong)NSString *ATitle;//答案标题
@property(nonatomic,strong)NSString *CCount;//评论数量
@property(nonatomic,strong)NSString *LikeCount;//点赞数量
@property(nonatomic,strong)NSString *CaiCount;//反对数量
@property(nonatomic,strong)NSString *Flag;//0:普通回答  1:求真回答
@property(nonatomic,strong)NSString *Abstracts;//摘要
@property(nonatomic,strong)NSMutableArray *Thumbnail;//缩略图地址
@property(nonatomic,strong)NSString *IdFlag;//回答者姓名

@end