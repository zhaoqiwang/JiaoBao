//
//  AnswerModel.h
//  JiaoBao
//
//  Created by songyanming on 15/8/5.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnswerModel : NSObject
@property(nonatomic,strong)NSString *ATitle;//标题
@property(nonatomic,strong)NSString *Abstracts;//内容摘要
@property(nonatomic,strong)NSString *AFlag;//求真标志
@property(nonatomic,strong)NSString *TabID;//记录ID
@property(nonatomic,strong)NSString *RecDate;//日期
@property(nonatomic,strong)NSString *LikeCount;//支持数量
@property(nonatomic,strong)NSString *CaiCount;//反对数量
@property(nonatomic,strong)NSString *JiaoBaoHao;//JiaoBaoHao
@property(nonatomic,strong)NSString *IdFlag;//用户昵称或姓名，匿名为空字符串
@property(nonatomic,strong)NSString *CCount;//评论数量
@property(nonatomic,strong)NSMutableArray *Thumbnail;//图片url,字符串（url)json数组
@property(nonatomic,assign)float floatH;//webview高度
@property(nonatomic,strong)NSString *Flag;//0无内容，1有内容，2有证据

@end
