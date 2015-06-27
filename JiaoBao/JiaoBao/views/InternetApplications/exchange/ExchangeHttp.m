//
//  ExchangeHttp.m
//  JiaoBao
//
//  Created by Zqw on 14-12-2.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "ExchangeHttp.h"

static ExchangeHttp *exchangeHttp = nil;

@implementation ExchangeHttp

+(ExchangeHttp *)getInstance{
    if (exchangeHttp == nil) {
        exchangeHttp = [[ExchangeHttp alloc] init];
    }
    return exchangeHttp;
}
-(id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

//获取单位所有分组,                         单位ID
-(void)exchangeHttpGetUnitGroupsWith:(NSString *)UID from:(NSString *)from{
    NSString *urlString = [NSString stringWithFormat:@"%@Basic/getUnitGroups",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:UID forKey:@"UID"];
    request.userInfo = [NSDictionary dictionaryWithObject:UID forKey:@"UID"];
    request.tag = 1;//设置请求tag
    request.username = from;
    [request setDelegate:self];
    [request startAsynchronous];
}

//获取单位内所有用户                             单位ID               0全部，1账户ID>0
-(void)exchangeHttpGetUserUnfoByUnitIDWith:(NSString *)UID filter:(NSString *)filter from:(NSString *)from{
    NSString *urlString = [NSString stringWithFormat:@"%@Basic/getUserInfoByUnitID",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:UID forKey:@"UID"];
    request.userInfo = [NSDictionary dictionaryWithObject:UID forKey:@"UID"];
    request.tag = 2;//设置请求tag
    request.username = from;
    [request setDelegate:self];
    [request startAsynchronous];
}

//获取头像
-(void)getFaceImg:(NSMutableArray *)array{
    NSMutableArray *tempArr = [NSMutableArray array];
    for (int i=0; i<array.count; i++) {
        UserInfoByUnitIDModel *userModel = [array objectAtIndex:i];
        [tempArr addObject:userModel.AccID];
    }
    //给数组中的教宝号去重
    NSSet *set = [NSSet setWithArray:tempArr];
    tempArr = [NSMutableArray arrayWithArray:[set allObjects]];
    D("tempArr-==== %@",[set allObjects]);
    for (int i=0; i<tempArr.count; i++) {
        [self getUserInfoFace:[tempArr objectAtIndex:i]];
    }
}

//通过用户的accid，获取头像
-(void)getUserInfoFace:(NSString *)accid{
    NSString *urlString = [NSString stringWithFormat:@"%@/ClientSrv/getfaceimg",[dm getInstance].url];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    //用户自定义数据   字典类型  （可选）
    request.userInfo = [NSDictionary dictionaryWithObject:accid forKey:@"JiaoBaoHao"];
    [request addPostValue:accid forKey:@"AccID"];
    request.tag = 3;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//获取融云网络用户token
-(void)exchangeHttpRongYunGetToken:(NSString *)accid TrueName:(NSString *)name{
    NSString *urlString = [NSString stringWithFormat:@"%@RongYun/getToken",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:accid forKey:@"AccID"];
    [request addPostValue:name forKey:@"TrueName"];
//    request.userInfo = [NSDictionary dictionaryWithObject:UID forKey:@"UID"];
    request.tag = 4;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//获取好友分组
-(void)exchangeHttpGetGetMyFriendsGroups:(NSString *)accID{
    NSString *urlString = [NSString stringWithFormat:@"%@/LGQIFriends/GetMyGroups",[dm getInstance].url];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:accID forKey:@"JiaoBaoHao"];
    request.userInfo = [NSDictionary dictionaryWithObject:accID forKey:@"ACCID"];
    request.tag = 5;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//获取该用户的这个组中所有好友
-(void)exchangeHttpGetMyFriendsByGroups:(NSString *)accID GroupID:(NSString *)groupID{
    NSString *urlString = [NSString stringWithFormat:@"%@/LGQIFriends/GetMyFriendsByGroups",[dm getInstance].url];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:accID forKey:@"JiaoBaoHao"];
    [request addPostValue:groupID forKey:@"GroupID"];
    request.userInfo = [NSDictionary dictionaryWithObject:groupID forKey:@"groupID"];
    request.tag = 6;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//请求成功
- (void)requestFinished:(ASIHTTPRequest *)_request{
    NSData *responseData = [_request responseData];
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
    NSString* dataString = [[NSString alloc] initWithData:responseData encoding:encoding];
    D("dataString--tag=---exchange---------====%ld---  %@",(long)_request.tag,dataString);
    NSMutableDictionary *jsonDic = [dataString objectFromJSONString];
    //先对返回值做判断，是否连接超时
    NSString *code = [jsonDic objectForKey:@"ResultCode"];
    NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
    if ([code intValue] == 8) {
        [[LoginSendHttp getInstance] hands_login];
        return;
    }
    if (_request.tag == 1) {//获取单位所有分组
        NSString *time = [jsonDic objectForKey:@"Data"];
        NSString *str000 = [DESTool decryptWithText:time Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        D("str00=exchange==1=>>>>==%@",str000);
        NSString *key = [_request.userInfo objectForKey:@"UID"];
        NSMutableArray *array = [ParserJson_exchange parserJsonUnitGroupsWith:str000];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:key forKey:@"UID"];
        [dic setValue:array forKey:@"array"];
        [dic setValue:code forKey:@"ResultCode"];
        [dic setValue:ResultDesc forKey:@"ResultDesc"];
        //通知到界面得到的分组
        if ([_request.username isEqual:@"1"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UnitPeopleGroupList" object:dic];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ExchangeGetUnitGroups" object:dic];
        }
    } else if (_request.tag == 2) {//获取单位内所有用户
        NSString *time = [jsonDic objectForKey:@"Data"];
        NSString *str000 = [DESTool decryptWithText:time Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        D("str00=exchange==2=>>>>==%@",str000);
        NSString *key = [_request.userInfo objectForKey:@"UID"];
        NSMutableArray *array = [ParserJson_exchange parserJsonUserInfoByUnitIDWith:str000];
        //获取头像
//        [self getFaceImg:array];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:key forKey:@"UID"];
        [dic setValue:array forKey:@"array"];
        //通知到界面得到的单位人员
        if ([_request.username isEqual:@"1"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UnitPeoplePeopleList" object:dic];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ExchangeUserInfoByUnitID" object:dic];
        }
    }else if (_request.tag == 3){//获取头像
        //获取的用户自定义内容
        NSString *hao = [_request.userInfo objectForKey:@"JiaoBaoHao"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        //文件名
        NSFileManager* fileManager=[NSFileManager defaultManager];
        NSString *imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",hao]];
        BOOL yesNo=[[NSFileManager defaultManager] fileExistsAtPath:imgPath];
        if (!yesNo) {//不存在，则直接写入后通知界面刷新
            D("no  have");
            BOOL yesNo1 = [responseData writeToFile:imgPath atomically:YES];
            if (yesNo1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"exchangeGetFaceImg" object:nil];
            }
        }else {//存在
            D(" have");
            BOOL blDele= [fileManager removeItemAtPath:imgPath error:nil];//先删除
            if (blDele) {//删除成功后，写入，通知界面
                BOOL yesNo = [responseData writeToFile:imgPath atomically:YES];
                if (yesNo) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"exchangeGetFaceImg" object:nil];
                }
            }
        }
    }else if (_request.tag == 4) {//获取单位内所有用户
        NSString *time = [jsonDic objectForKey:@"Data"];
        NSString *str000 = [DESTool decryptWithText:time Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        D("str00=exchange==4=>>>>==%@",str000);
        RongYunTokenModel *model = [ParserJson_exchange parserJsonGetRongYunTokenWith:str000];
        [dm getInstance].rongYunModel = model;
    }else if (_request.tag == 5) {//获取好友分组
        NSDictionary *dic = [dataString objectFromJSONString];
        NSString *str = [dic objectForKey:@"Data"];
        D("str00=exchange==5=>>>>==%@",str);
//        NSMutableArray *array = [ParserJson_exchange parserJsonMyFriendsGroups:str];
        NSMutableArray *array = [ParserJson_exchange parserJsonUnitGroupsWith:str];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyFriendsGroups" object:array];
    }else if (_request.tag == 6) {//获取该用户的这个组中所有好友
        NSDictionary *dic = [dataString objectFromJSONString];
        NSString *str = [dic objectForKey:@"Data"];
        D("str00=exchange==6=>>>>==%@",str);
        NSMutableArray *array = [ParserJson_exchange parserJsonUserInfoByUnitIDWith:str];
        //获取头像
//        [self getFaceImg:array];
        NSString *key = [_request.userInfo objectForKey:@"groupID"];
        NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
        [dic2 setValue:key forKey:@"groupID"];
        [dic2 setValue:array forKey:@"array"];
        //通知到界面得到的单位人员
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyFriendsGroupsMember" object:dic2];
    }
}
//请求失败
-(void)requestFailed:(ASIHTTPRequest *)request{
    D("dataString-tag----exchange-----=%ld,flag----  请求失败",(long)request.tag);
}

@end
