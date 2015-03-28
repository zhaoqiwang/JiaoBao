//
//  ParserJson_class.h
//  JiaoBao
//
//  Created by Zqw on 15-3-27.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"
#import "ClassModel.h"

@interface ParserJson_class : NSObject

//客户端通过本接口获取本单位栏目文章
+(NSMutableArray *)parserJsonUnitArthListIndex:(NSString *)json;

@end
