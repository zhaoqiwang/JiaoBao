//
//  QuestionModel.h
//  JiaoBao
//  问题列表model
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
@property(nonatomic,strong)NSMutableArray *hiddenid;//关注之后被隐藏或被删除的问题id，可以提示用户，原问题已隐藏或已删除，提供取消关注按钮
@property(nonatomic,strong)NSString *Flag;//如果flag==1,那么在结果集中answer=null就隐藏起来，不显示了。（因为有证据的答案已隐藏或删除）
@property(nonatomic,strong)NSString *State;//=1是正常的，=0是禁用的

@property(nonatomic,strong)NSString *Tag;//我已关注该问题，0未关注,1已关注--自己添加

@end

//[{"TabID":1393,"Title":"人为什么会放屁?","AnswersCount":4,"AttCount":5,"ViewCount":142,"CategorySuject":"科普","CategoryId":113,"LastUpdate":"2015-12-11T16:15:18","AreaCode":null,"JiaoBaoHao":5236924,"rowCount":94,"answer":{"ATitle":"放屁，是人体胃肠道通过向下蠕动，将其中气体排出肛门的过程。","Abstracts":"人们进餐、喝水、吞咽时，会把空气带入胃肠。唾液泡沫和食物中的气体也会经口腔潜入体内。除了外来空气，潜伏在人体肠道内数以亿计的各种细菌，它们在帮助发酵、分解消化道中的食物的同时，也会产生气体。……","AFlag":1,"TabID":1228,"RecDate":"2015-11-25T09:42:35","LikeCount":1,"Flag":2,"CaiCount":2,"CCount":33,"JiaoBaoHao":5263784,"IdFlag":"一二三四五六七八九十","Thumbnail":null}}