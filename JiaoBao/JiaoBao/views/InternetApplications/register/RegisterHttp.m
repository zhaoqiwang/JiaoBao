//
//  RegisterHttp.m
//  JiaoBao
//
//  Created by 赵启旺 on 15/6/2.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "RegisterHttp.h"
#import "unitModel.h"

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
    //对json串加密
    NSData *dataRSA = [RSATool encrypt:regAccIdStr error:nil];
    NSString *registerRSA = [dataRSA base64EncodedString];
    [request addPostValue:registerRSA forKey:@"regAccIdStr"];
    [request addPostValue:TimeStamp forKey:@"TimeStamp"];
    //生成签名字符串
    NSString *ClientKey = [[NSUserDefaults standardUserDefaults]objectForKey:@"ClientKey"];
    NSString *sign = [NSString stringWithFormat:@"%@%@%@%@",CLIVER,registerRSA,ClientKey,TimeStamp];
    NSData * md5Data=[[sign dataUsingEncoding:NSUTF8StringEncoding] MD5Sum];
    NSString *strSign =[NSString base64StringFromData:md5Data length:(int)md5Data.length];
    [request addPostValue:strSign forKey:@"Sign"];
    [request addPostValue:ios forKey:@"ios"];
    request.tag = 5;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//检查昵称是否重复      昵称不能全是数字，不能包含@
-(void)registerHttpCheckAccN:(NSString *)nickname{
    NSString *urlString = [NSString stringWithFormat:@"%@AccountReg/checkAccN",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:nickname forKey:@"nickname"];
    request.tag = 6;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//修改帐户信息的昵称和姓名          用户教宝号           昵称不能全是数字，不能包含@          姓名，20字以内
-(void)registerHttpUpateRecAcc:(NSString *)accid NickName:(NSString *)nickname TrueName:(NSString *)trueName{
    NSString *urlString = [NSString stringWithFormat:@"%@AccountReg/UpateRecAcc",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:accid forKey:@"accId"];
    [request addPostValue:nickname forKey:@"nickname"];
    [request addPostValue:trueName forKey:@"trueName"];
    request.tag = 7;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//验证旧密码后修改帐户密码      加密后的json密码对象的base64字符串  true,ios应用
-(void)registerHttpChangePW:(NSString *)pwobjstr iOS:(NSString *)ios{
    NSString *urlString = [NSString stringWithFormat:@"%@AccountReg/ChangePW",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    //对json串加密
    NSData *dataRSA = [RSATool encrypt:pwobjstr error:nil];
    NSString *registerRSA = [dataRSA base64EncodedString];
    [request addPostValue:registerRSA forKey:@"pwobjstr"];
    [request addPostValue:ios forKey:@"ios"];
    request.tag = 8;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//获取根据手机号码匹配的单位数据           教宝号
-(void)registerHttpGetMyMobileUnitList:(NSString *)accid{
    NSString *urlString = [NSString stringWithFormat:@"%@AccountReg/GetMyMobileUnitList",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:accid forKey:@"accId"];
    request.tag = 9;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//加入单位操作                  教宝号         0=加入单位，1=不加入单位，-2下次恢复提示    加密Id，GetMyMobileUnitList中获对象的TabIdStr
-(void)registerHttpJoinUnitOP:(NSString *)accid option:(NSString *)option tableStr:(NSString *)tabIdStr{
    NSString *urlString = [NSString stringWithFormat:@"%@AccountReg/JoinUnitOP",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:accid forKey:@"accId"];
    [request addPostValue:option forKey:@"op"];
    [request addPostValue:tabIdStr forKey:@"tabIdStr"];
    request.tag = 10;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//在重置密码时验证用户手机                  手机号码            收到的手机验证码        图片验证码
-(void)registerHttpCheckMobileVcode:(NSString *)phoneNum cCode:(NSString *)cCode vCode:(NSString *)vCode{
    NSString *urlString = [NSString stringWithFormat:@"%@AccountReg/CheckMobileVcode",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:phoneNum forKey:@"mobilenum"];
    [request addPostValue:cCode forKey:@"checkcode"];
    [request addPostValue:vCode forKey:@"vCode"];
    request.tag = 11;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//重置用户密码                  加密后的json密码对象的base64字符串   true,ios应用
-(void)registerHttpResetAccPw:(NSString *)resetobjstr iOS:(NSString *)ios{
    NSString *urlString = [NSString stringWithFormat:@"%@AccountReg/ResetAccPw",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    //对json串加密
    NSData *dataRSA = [RSATool encrypt:resetobjstr error:nil];
    NSString *registerRSA = [dataRSA base64EncodedString];
    [request addPostValue:registerRSA forKey:@"resetobjstr"];
    [request addPostValue:ios forKey:@"ios"];
    request.tag = 12;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//重置用户密码时发送手机验证码
-(void)registerHttpReSendCheckCode:(NSString *)phone vCode:(NSString *)vCode{
    NSString *urlString = [NSString stringWithFormat:@"%@AccountReg/ReSendCheckCode",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:phone forKey:@"mobilenum"];
    [request addPostValue:vCode forKey:@"vCode"];
    request.tag = 13;//设置请求tag
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
    D("dataString--tag=----register--------====%ld---  ",(long)_request.tag);
    NSMutableDictionary *jsonDic = [dataString objectFromJSONString];
    //先对返回值做判断，是否连接超时
    NSString *code = [jsonDic objectForKey:@"ResultCode"];
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
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"get_identi_code" object:@{code:ResultDesc}];
        
    }else if (_request.tag == 4){//验证手机验证码
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];

        D("str00=register==4=>>>>==%@",code);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"RegCheckMobileVcode" object:@{code:ResultDesc}];

        
    }else if (_request.tag == 5){//用户注册

        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];

        [[NSNotificationCenter defaultCenter]postNotificationName:@"registerPW" object:@{code:ResultDesc}];
        
    }else if (_request.tag == 6){//检查昵称是否重复
        NSDictionary *dic = [dataString objectFromJSONString];
        NSString *str = [dic objectForKey:@"ResultDesc"];
        D("str00=register==6=>>>>==%@",str);
        NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
        [dic2 setValue:code forKey:@"code"];
        [dic2 setValue:str forKey:@"str"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"registerHttpCheckAccN" object:dic2];
        
    }else if (_request.tag == 7){//修改帐户信息的昵称和姓名
        NSDictionary *dic = [dataString objectFromJSONString];
        NSString *str = [dic objectForKey:@"ResultDesc"];
        D("str00=register==7=>>>>==%@",str);
        NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
        [dic2 setValue:code forKey:@"code"];
        [dic2 setValue:str forKey:@"str"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"registerHttpUpateRecAcc" object:dic2];
    }else if (_request.tag == 8){//验证旧密码后修改帐户密码
        NSDictionary *dic = [dataString objectFromJSONString];
        NSString *str = [dic objectForKey:@"ResultDesc"];
        D("str00=register==8=>>>>==%@",str);
        NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
        [dic2 setValue:code forKey:@"code"];
        [dic2 setValue:str forKey:@"str"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"registerHttpChangePW" object:dic2];
    }else if (_request.tag == 9){//获取根据手机号码匹配的单位数据
        NSDictionary *dic = [dataString objectFromJSONString];
        NSString *str = [dic objectForKey:@"Data"];
        
        NSArray *unitArr = [ParserJson parserUnitList:str];

        D("str00=register==9=>>>>==%@",str);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"GetMyMobileUnitList" object:unitArr];
        
    }else if (_request.tag == 10){//加入单位操作
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];


        [[NSNotificationCenter defaultCenter]postNotificationName:@"JoinUnitOP" object:@{code:ResultDesc}];
        
    }else if (_request.tag == 11){//在重置密码时验证用户手机
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];

        [[NSNotificationCenter defaultCenter]postNotificationName:@"RegCheckMobileVcode" object:@{code:ResultDesc}];


        
    }else if (_request.tag == 12){//重置用户密码 
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];

        [[NSNotificationCenter defaultCenter]postNotificationName:@"registerPW" object:@{code:ResultDesc}];

        
    }else if (_request.tag == 13){//重置用户密码时发送手机验证码
        NSDictionary *dic = [dataString objectFromJSONString];
        NSString *str = [dic objectForKey:@"Data"];
        D("str00=register==12=>>>>==%@",str);
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];

        [[NSNotificationCenter defaultCenter]postNotificationName:@"get_identi_code" object:@{code:ResultDesc}];

        
    }
}
//请求失败
-(void)requestFailed:(ASIHTTPRequest *)request{
    if (request.tag == 1) {//检查手机是否重复
        NSString *dataString = @"请求超时";
        [[NSNotificationCenter defaultCenter]postNotificationName:@"tel" object:dataString];
        
        
    }else if (request.tag == 2){//获取图片验证码url
        NSString *dataString = @"请求超时";

        [[NSNotificationCenter defaultCenter]postNotificationName:@"urlImage" object:dataString];
        
    }else if (request.tag == 3){//发送手机验证码
        NSString *code = @"1000";
        NSString *ResultDesc = @"请求超时";
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"get_identi_code" object:@{code:ResultDesc}];
        
    }else if (request.tag == 4){//验证手机验证码
        NSString *code = @"1000";
        NSString *ResultDesc = @"请求超时";
        [[NSNotificationCenter defaultCenter]postNotificationName:@"RegCheckMobileVcode" object:@{code:ResultDesc}];
        
        
    }else if (request.tag == 5){//用户注册
        
        NSString *code = @"1000";
        NSString *ResultDesc = @"请求超时";
        [[NSNotificationCenter defaultCenter]postNotificationName:@"registerPW" object:@{code:ResultDesc}];
        
    }else if (request.tag == 6){//检查昵称是否重复
        NSString *code = @"1000";
        NSString *ResultDesc = @"请求超时";

        NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
        [dic2 setValue:code forKey:@"code"];
        [dic2 setValue:ResultDesc forKey:@"str"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"registerHttpCheckAccN" object:dic2];
        
    }else if (request.tag == 7){//修改帐户信息的昵称和姓名
        NSString *code = @"1000";
        NSString *ResultDesc = @"请求超时";
        NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
        [dic2 setValue:code forKey:@"code"];
        [dic2 setValue:ResultDesc forKey:@"str"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"registerHttpUpateRecAcc" object:dic2];
    }else if (request.tag == 8){//验证旧密码后修改帐户密码
        NSString *code = @"1000";
        NSString *ResultDesc = @"请求超时";
        NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
        [dic2 setValue:code forKey:@"code"];
        [dic2 setValue:ResultDesc forKey:@"str"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"registerHttpChangePW" object:dic2];
    }else if (request.tag == 9){//获取根据手机号码匹配的单位数据
        
        NSString *ResultDesc = @"请求超时";
        [[NSNotificationCenter defaultCenter]postNotificationName:@"GetMyMobileUnitList" object:ResultDesc];
        
    }else if (request.tag == 10){//加入单位操作
        NSString *code = @"1000";
        NSString *ResultDesc = @"请求超时";
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"JoinUnitOP" object:@{code:ResultDesc}];
        
    }else if (request.tag == 11){//在重置密码时验证用户手机
        NSString *code = @"1000";
        NSString *ResultDesc = @"请求超时";
        [[NSNotificationCenter defaultCenter]postNotificationName:@"RegCheckMobileVcode" object:@{code:ResultDesc}];
        
        
        
    }else if (request.tag == 12){//重置用户密码
        NSString *code = @"1000";
        NSString *ResultDesc = @"请求超时";
        [[NSNotificationCenter defaultCenter]postNotificationName:@"registerPW" object:@{code:ResultDesc}];
        
        
    }else if (request.tag == 13){//重置用户密码时发送手机验证码
        NSString *code = @"1000";
        NSString *ResultDesc = @"请求超时";
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"get_identi_code" object:@{code:ResultDesc}];
        
        
    }

    D("dataString---register-tag=%ld,flag----  请求失败",(long)request.tag);
}


@end
