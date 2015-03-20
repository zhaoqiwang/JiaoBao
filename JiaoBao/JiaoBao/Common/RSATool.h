//
//  RSATool.h
//  EncryptionDemo
//
//  Created by Lhp@WPH on 14-8-26.
//  Copyright (c) 2014年 vip.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Loger.h"

@interface RSATool : NSObject
+ (SecKeyRef) getPublicKey;
+ (NSString *) rsaEncryptString:(NSString*) string;

+ (NSData *)encrypt:(NSString *)plainText error:(NSError **)err;
@end
