//
//  ShowPickedModel.h
//  JiaoBao
//
//  Created by Zqw on 15/8/28.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowPickedModel : NSObject

@property (nonatomic,strong) NSString *TabID;//内容ID
@property (nonatomic,strong) NSString *Title;//内容标题
@property (nonatomic,strong) NSString *PContent;//内容
@property (nonatomic,strong) NSString *QID;//该精选内容对应的问题ID,通过此ID查看原文

@end
