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
@property(nonatomic,strong)NSString *JiaoBaoHao2;//教宝号--如果是匿名回答，这里保存真实教宝号
@property(nonatomic,strong)NSString *rowCount;//记录数量，用于取第二页记录起给参数赋值
@property(nonatomic,strong)NSMutableArray *Thumbnail;//图片url,字符串（url)json数组
@property(nonatomic,strong)AnswerModel *answerModel;//答案model
@property(nonatomic,assign)int mInt_btn;//是否显示全部、有证据、在讨论等按钮标识，默认0不显示，1显示，2是当前的话题行
@property(nonatomic,assign)int mInt_top;//1为置顶数据，0为普通

@property(nonatomic,strong)NSString *Tag;//我已关注该问题，0未关注,1已关注--自己添加

@end
