//
//  KnowledgeHttp.h
//  JiaoBao
//
//  Created by Zqw on 15/8/3.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "dm.h"
#import "ASIFormDataRequest.h"
#import "RSATool.h"
#import "NSString+Base64.h"
#import "NSData+Base64.h"
#import "NSData+CommonCrypto.h"
#import "DESTool.h"
#import "JSONKit.h"
#import "define_constant.h"
#import "ParserJson_share.h"
#import "ArthDetailModel.h"
#import "LoginSendHttp.h"
#import "VlorNetWorkAPI.h"
#import "ParserJson_knowledge.h"


@interface KnowledgeHttp : NSObject<ASIHTTPRequestDelegate>{
    
}

//单
+(KnowledgeHttp *)getInstance;

//取系统中的省份信息
-(void)knowledgeHttpGetProvice;

//取指定省份的地市数据或取指定地市的区县数据
//cityCode,当level=1，这个参数是省份代码，level=2，这个参数是地市代码
//level,1取地市数据，2取区县数据
-(void)knowledgeHttpGetCity:(NSString *)cityCode level:(NSString *)level;

@end
