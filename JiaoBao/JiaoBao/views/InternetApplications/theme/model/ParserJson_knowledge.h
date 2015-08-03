//
//  ParserJson_knowledge.h
//  JiaoBao
//
//  Created by Zqw on 15/8/3.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"
#import "ProviceModel.h"

@interface ParserJson_knowledge : NSObject

//取系统中的省份信息
+(NSMutableArray *)parserJsonGetProvice:(NSString *)json;

@end
