//
//  ItemModel.h
//  JiaoBao
//
//  Created by songyanming on 15/8/5.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemModel : NSObject
@property(nonatomic,strong)NSString *TabID;//话题Id
@property(nonatomic,strong)NSString *Subject;//话题名称
@property(nonatomic,strong)NSString *QCount;//问题数量
@property(nonatomic,strong)NSString *AttCount;//关注人数量
@property(nonatomic,strong)NSString *ParentId;//上级Id


@end
