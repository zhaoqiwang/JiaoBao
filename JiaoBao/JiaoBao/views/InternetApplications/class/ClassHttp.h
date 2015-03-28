//
//  ClassHttp.h
//  JiaoBao
//
//  Created by Zqw on 15-3-27.
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
#import "LoginSendHttp.h"
#import "ParserJson_class.h"

@interface ClassHttp : NSObject<ASIHTTPRequestDelegate>{
    
}

//单
+(ClassHttp *)getInstance;

//客户端通过本接口获取本单位栏目文章。    默认第一页           默认20条           1个人发布文章，2单位发布文章     单位ID           0按最新排序，1按最热排序，默认为0  标题关键字搜索
-(void)classHttpUnitArthListIndex:(NSString *)page Num:(NSString *)num Flag:(NSString *)flag UnitID:(NSString *)UnitID order:(NSString *)order title:(NSString *)title;

@end
