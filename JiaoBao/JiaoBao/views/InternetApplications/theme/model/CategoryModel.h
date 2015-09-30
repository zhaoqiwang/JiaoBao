//
//  CategoryModel.h
//  JiaoBao
//
//  Created by songyanming on 15/8/4.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryModel : NSObject
@property(nonatomic,strong)NSString *TabID;//话题ID
@property(nonatomic,strong)NSString *Subject;//话题名称
@property(nonatomic,strong)NSString *ParentId;//上级话题ID
@property(nonatomic,strong)NSString *LogoPath;//话题logo
@property(nonatomic,strong)NSString *Description;//话题说明
@property(nonatomic,strong)NSString *QCount;//问题数量
@property(nonatomic,strong)NSString *AttCount;//关注人数

@property(nonatomic,strong)NSString *DefaultImg;//默认图片
@property(nonatomic,strong)NSString *Tag;
@property(nonatomic,strong)NSString *ActiveList;
@property(nonatomic,strong)NSString *LikeList;
@property(nonatomic,strong)NSString *State;
@property(nonatomic,strong)NSString *TopQIds;

@end
