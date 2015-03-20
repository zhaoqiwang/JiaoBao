//
//  RongYunTokenModel.h
//  JiaoBao
//
//  Created by Zqw on 14-12-3.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RongYunTokenModel : NSObject{
    NSString *code;
    NSString *userId;
    NSString *token;
}

@property (nonatomic,strong) NSString *code;
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *token;

@end
//{"code":200,"userId":"jb_5150028","token":"KZbXampHeMdkvrB7yCfLD/23Y81mtDc0PdpjyOVwFQZkdUCsLJkn/s3gY4Mny/3u1A0vHB0ewJRfFuWR8fDDa5gqRf8kheZj"}