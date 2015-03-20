//
//  ParserJson_theme.h
//  JiaoBao
//
//  Created by Zqw on 14-12-16.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"
#import "ThemeListModel.h"

@interface ParserJson_theme : NSObject

//取我关注的和我所参与的主题
+(NSMutableArray *)parserJsonEnjoyInterestList:(NSString *)json;

@end
