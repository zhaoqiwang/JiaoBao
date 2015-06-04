//
//  RegisterHttp.m
//  JiaoBao
//
//  Created by 赵启旺 on 15/6/2.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "RegisterHttp.h"

static RegisterHttp *registerHttp = nil;

@implementation RegisterHttp

+(RegisterHttp *)getInstance{
    if (registerHttp == nil) {
        registerHttp = [[RegisterHttp alloc] init];
    }
    return registerHttp;
}
-(id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

//检查手机是否重复                      手机号码
-(void)registerHttpCheckmyMobileAcc:(NSString *)accid{
    NSString *urlString = [NSString stringWithFormat:@"%@AccountReg/checkmobileAcc",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:accid forKey:@"accid"];
//    request.userInfo = [NSDictionary dictionaryWithObject:ReFlag forKey:@"flag"];
    request.tag = 1;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//获取图片验证码url
-(void)registerHttpGetValidateCode{
    NSString *urlString = [NSString stringWithFormat:@"%@AccountReg/GetValidateCode",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    request.tag = 2;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}


//发送手机验证码                   手机号码            图上验证码（通过获取图片验证码url显示给用户）
-(void)registerHttpSendCheckCode:(NSString *)phoneNum Code:(NSString *)vCode{
    NSString *urlString = [NSString stringWithFormat:@"%@AccountReg/SendCheckCode",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:phoneNum forKey:@"mobilenum"];
    [request addPostValue:vCode forKey:@"vCode"];
    request.tag = 3;//设置请求tag4126
    [request setDelegate:self];
    [request startAsynchronous];
}

//验证手机验证码
-(void)registerHttpRegCheckMobileVcode:(NSString *)phoneNum cCode:(NSString *)cCode vCode:(NSString *)vCode{
    NSString *urlString = [NSString stringWithFormat:@"%@AccountReg/RegCheckMobileVcode",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:phoneNum forKey:@"mobilenum"];
    [request addPostValue:cCode forKey:@"checkcode"];
    [request addPostValue:vCode forKey:@"vCode"];
    request.tag = 4;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//用户注册                      客户端版本号              客户端ID               加密后的登录JSON对象字符串             当前时间（如：2013-12-09 00:37:09        数字签名，base64(MD5(Ver+regAccIdStr+ClientKey+TimeStamp))        true,ios应用
-(void)registerHttpRegAccId:(NSString *)CliVer IAMSCID:(NSString *)IAMSCID regAccIdStr:(NSString *)regAccIdStr TimeStamp:(NSString *)TimeStamp Sign:(NSString *)Sign ios:(NSString *)ios{
    NSString *urlString = [NSString stringWithFormat:@"%@AccountReg/RegAccId",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:CliVer forKey:@"CliVer"];
    [request addPostValue:IAMSCID forKey:@"IAMSCID"];
    [request addPostValue:regAccIdStr forKey:@"regAccIdStr"];
    [request addPostValue:TimeStamp forKey:@"TimeStamp"];
    [request addPostValue:Sign forKey:@"Sign"];
    [request addPostValue:ios forKey:@"ios"];
    request.tag = 5;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//请求成功
- (void)requestFinished:(ASIHTTPRequest *)_request{
    NSData *responseData = [_request responseData];
//    NSError *error;
//    id jsonObject = [NSJSONSerialization JSONObjectWithData:responseData
//                                                    options:NSJSONReadingAllowFragments
//                                                      error:&error];
//    NSLog(@"jsonObject = %@",jsonObject);
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
    NSString* dataString = [[NSString alloc] initWithData:responseData encoding:encoding];
    NSLog(@"dataString = %@",dataString);
    D("dataString--tag=----register--------====%ld---  ",(long)_request.tag);
    NSMutableDictionary *jsonDic = [dataString objectFromJSONString];
    //先对返回值做判断，是否连接超时
    NSString *code = [jsonDic objectForKey:@"ResultCode"];
    NSLog(@"code = %@",code);
    if ([code intValue] == 8) {
        [[LoginSendHttp getInstance] hands_login];
        return;
    }
    if (_request.tag == 1) {//检查手机是否重复

        D("str00=register==1=>>>>==%@",dataString);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"tel" object:dataString];

        
    }else if (_request.tag == 2){//获取图片验证码url

        D("str00=register==2=>>>>==%@",dataString);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"urlImage" object:responseData];
        
    }else if (_request.tag == 3){//发送手机验证码
//        NSDictionary *dic = [dataString objectFromJSONString];
//        NSString *str = [dic objectForKey:@"Data"];
        D("str00=register==3=>>>>==%@",code);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"get_identi_code" object:code];
        
    }else if (_request.tag == 4){//验证手机验证码
//        NSDictionary *dic = [dataString objectFromJSONString];
//        NSString *str = [dic objectForKey:@"Data"];
        D("str00=register==4=>>>>==%@",code);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"RegCheckMobileVcode" object:code];

        
    }else if (_request.tag == 5){//用户注册
        NSDictionary *dic = [dataString objectFromJSONString];
        NSString *str = [dic objectForKey:@"Data"];
        D("str00=register==5=>>>>==%@",str);
        
    }
}
//请求失败
-(void)requestFailed:(ASIHTTPRequest *)request{
    D("dataString---register-tag=%ld,flag----  请求失败",(long)request.tag);
}


@end
