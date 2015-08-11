//
//  AnswerDetailModel.h
//  JiaoBao
//
//  Created by songyanming on 15/8/6.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnswerDetailModel : NSObject
@property(nonatomic,strong)NSString *TabID;//答案ID
@property(nonatomic,strong)NSString *JiaoBaoHao;//教宝号
@property(nonatomic,strong)NSString *QId;//问题ID
@property(nonatomic,strong)NSString *Title;//答案标题
@property(nonatomic,strong)NSString *RecDate;//回答时间
@property(nonatomic,strong)NSString *CCount;//评论数量
@property(nonatomic,strong)NSString *LikeCount;//点赞数量
@property(nonatomic,strong)NSString *Flag;//0普通回答 1求真回答
@property(nonatomic,strong)NSString *Abstracts;//摘要
@property(nonatomic,strong)NSMutableArray *Thumbnail;//缩略图地址
@property(nonatomic,strong)NSString *IdFlag;//回答者姓名+称号
@property(nonatomic,strong)NSString *AContent;// 内容


@end
