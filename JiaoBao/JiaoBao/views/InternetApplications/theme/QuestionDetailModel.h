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

@property(nonatomic,strong)NSString *Tag;//我已关注该问题，0未关注,1已关注
@property(nonatomic,strong)NSString *NickName;
@property(nonatomic,strong)NSString *JiaoBaoHao;
@property(nonatomic,strong)NSString *QFlag;//0=对回答无特殊要求，1=要求有证据的回答
@property(nonatomic,strong)NSString *RecDate;
@property(nonatomic,strong)NSString *CategoryId;
@property(nonatomic,strong)NSMutableArray *TagsList;
@property(nonatomic,strong)NSString *State;
@property(nonatomic,strong)NSString *AttCount;
@property(nonatomic,strong)NSString *FactSign;
@property(nonatomic,strong)NSString *Category;//所属话题名称
@property(nonatomic,strong)NSString *MyAnswerId;//当前用户对该问题的答案ID，=0则说明当前登录用户未回答该问题

@end
//{"Tag":0,"NickName":"郑召欣","TabID":133,"JiaoBaoHao":5200750,"Title":"小于９０度的角都是锐角吗？","KnContent":"<p><span style=\";font-family:宋体\">根据课标教材定义：小于９０度的角叫做锐角。答案似乎是肯定的，但由此又产生一个新的问题：０度的角是什么角，也是锐角吗？</span></p><p><br/></p>","QFlag":1,"RecDate":"2015-08-13T10:24:41","CategoryId":16,"TagsList":null,"State":1,"ViewCount":8,"AnswersCount":1,"LastUpdate":"2015-08-14T08:59:15","Abstracts":"根据课标教材定义：小于９０度的角叫做锐角。答案似乎是肯定的，但由此又产生一个新的问题：０度的角是什么角，也是锐角吗？","Thumbnail":null,"AreaCode":"371121","AtAccIds":"","AttCount":0,"FactSign":0}