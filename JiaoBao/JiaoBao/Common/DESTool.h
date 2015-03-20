//
//  DESTool.h
//  JiaoBao
//
//  Created by Zqw on 14-10-20.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import"GTMBase64.h"
#import<CommonCrypto/CommonCryptor.h>

@interface DESTool : NSObject

+ (NSString *)encryptWithText:(NSString *)sText Key:(NSString *)key;//加密
+ (NSString *)decryptWithText:(NSString *)sText Key:(NSString *)key;//解密


@end
