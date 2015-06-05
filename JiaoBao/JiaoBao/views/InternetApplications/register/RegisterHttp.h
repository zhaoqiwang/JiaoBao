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
#import "ParserJson.h"

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

//用户注册                      客户端版本号              客户端ID               加密后的登录JSON对象字符串             当前时间（如：2013-12-09 00:37:09        数字签名，base64(MD5(Ver+regAccIdStr+ClientKey+TimeStamp))        true,ios应用
-(void)registerHttpRegAccId:(NSString *)CliVer IAMSCID:(NSString *)IAMSCID regAccIdStr:(NSString *)regAccIdStr TimeStamp:(NSString *)TimeStamp Sign:(NSString *)Sign ios:(NSString *)ios;

//检查昵称是否重复      昵称不能全是数字，不能包含@
-(void)registerHttpCheckAccN:(NSString *)nickname;

//修改帐户信息的昵称和姓名          用户教宝号           昵称不能全是数字，不能包含@          姓名，20字以内
-(void)registerHttpUpateRecAcc:(NSString *)accid NickName:(NSString *)nickname TrueName:(NSString *)trueName;

//验证旧密码后修改帐户密码      加密后的json密码对象的base64字符串  true,ios应用
-(void)registerHttpChangePW:(NSString *)pwobjstr iOS:(NSString *)ios;

//获取根据手机号码匹配的单位数据           教宝号
-(void)registerHttpGetMyMobileUnitList:(NSString *)accid;

//加入单位操作                  教宝号         0=加入单位，1=不加入单位，-2下次恢复提示    加密Id，GetMyMobileUnitList中获对象的TabIdStr
-(void)registerHttpJoinUnitOP:(NSString *)accid option:(NSString *)option tableStr:(NSString *)tabIdStr;

//在重置密码时验证用户手机                  手机号码            收到的手机验证码        图片验证码
-(void)registerHttpCheckMobileVcode:(NSString *)phoneNum cCode:(NSString *)cCode vCode:(NSString *)vCode;

//重置用户密码                  加密后的json密码对象的base64字符串   true,ios应用
-(void)registerHttpResetAccPw:(NSString *)resetobjstr iOS:(NSString *)ios;

//重置用户密码时发送手机验证码
-(void)registerHttpReSendCheckCode:(NSString *)phone vCode:(NSString *)vCode;

@end
