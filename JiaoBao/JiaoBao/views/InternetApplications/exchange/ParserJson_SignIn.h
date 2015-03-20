//
//  ParserJson_SignIn.h
//  JiaoBao
//
//  Created by songyanming on 15/3/6.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"
#import "ThemeListModel.h"
#import "SignInModel.h"

@interface ParserJson_SignIn : NSObject
+(NSMutableArray *)parserJsonSignIn:(NSString *)json;


@end
