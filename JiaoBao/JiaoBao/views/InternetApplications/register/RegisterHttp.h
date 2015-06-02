//
//  RegisterHttp.h
//  JiaoBao
//
//  Created by 赵启旺 on 15/6/2.
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

@interface RegisterHttp : NSObject<ASIHTTPRequestDelegate>{
    
}

//单
+(RegisterHttp *)getInstance;

//检查手机是否重复                      手机号码
-(void)registerHttpCheckmyMobileAcc:(NSString *)accid;

//获取图片验证码url
-(void)registerHttpGetValidateCode;

//发送手机验证码                   手机号码            图上验证码（通过获取图片验证码url显示给用户）
-(void)registerHttpSendCheckCode:(NSString *)phoneNum Code:(NSString *)vCode;

//验证手机验证码
-(void)registerHttpRegCheckMobileVcode:(NSString *)phoneNum cCode:(NSString *)cCode vCode:(NSString *)vCode;

//用户注册                      客户端版本号              客户端ID               加密后的登录JSON对象字符串             当前时间（如：2013-12-09 00:37:09 数字签名，base64(MD5(Ver + IAMSCID + regAccIdStr + ClientKey))        true,ios应用
-(void)registerHttpRegAccId:(NSString *)CliVer IAMSCID:(NSString *)IAMSCID regAccIdStr:(NSString *)regAccIdStr TimeStamp:(NSString *)TimeStamp Sign:(NSString *)Sign ios:(NSString *)ios;

@end
