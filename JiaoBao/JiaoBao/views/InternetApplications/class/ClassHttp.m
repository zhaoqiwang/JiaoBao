//
//  ClassHttp.m
//  JiaoBao
//
//  Created by Zqw on 15-3-27.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "ClassHttp.h"

static ClassHttp *classHttp = nil;

@implementation ClassHttp

+(ClassHttp *)getInstance{
    if (classHttp == nil) {
        classHttp = [[ClassHttp alloc] init];
    }
    return classHttp;
}
-(id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

//客户端通过本接口获取本单位栏目文章。    默认第一页           默认20条           1个人发布文章，2单位发布文章     单位ID           0按最新排序，1按最热排序，默认为0  标题关键字搜索
-(void)classHttpUnitArthListIndex:(NSString *)page Num:(NSString *)num Flag:(NSString *)flag UnitID:(NSString *)UnitID order:(NSString *)order title:(NSString *)title RequestFlag:(NSString *)ReFlag{
    NSString *urlString = [NSString stringWithFormat:@"%@Sections/UnitArthListIndex",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:page forKey:@"pageNum"];
    [request addPostValue:num forKey:@"numPerPage"];
    [request addPostValue:flag forKey:@"SectionFlag"];
    [request addPostValue:UnitID forKey:@"UnitID"];
    request.userInfo = [NSDictionary dictionaryWithObject:ReFlag forKey:@"flag"];
    request.tag = 1;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//取单位空间发表的最新或推荐文章,              默认第一页   默认20条               1最新                     local本地，默认为空，取所有记录      请求flag
-(void)classHttpShowingUnitArthList:(NSString *)page Num:(NSString *)num topFlags:(NSString *)topFlags flag:(NSString *)flag RequestFlag:(NSString *)ReFlag{
    NSString *urlString = [NSString stringWithFormat:@"%@Sections/ShowingUnitArthList",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:page forKey:@"pageNum"];
    [request addPostValue:num forKey:@"numPerPage"];
    [request addPostValue:topFlags forKey:@"topFlags"];
    if (flag.length>0) {
        [request addPostValue:flag forKey:@"flag"];
    }
    
    request.userInfo = [NSDictionary dictionaryWithObject:ReFlag forKey:@"flag"];
    request.tag = 2;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//取我关注的单位栏目文章                   默认第一页           默认20条           教宝号
-(void)classHttpMyAttUnitArthListIndex:(NSString *)page Num:(NSString *)num accid:(NSString *)accid{
    NSString *urlString = [NSString stringWithFormat:@"%@Sections/MyAttUnitArthListIndex",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:page forKey:@"pageNum"];
    [request addPostValue:num forKey:@"numPerPage"];
    [request addPostValue:accid forKey:@"accId"];
    request.tag = 3;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//我的班级文章列表                          默认第一页           默认20条           1个人发布文章，2单位动态
-(void)classHttpAllMyClassArthList:(NSString *)page Num:(NSString *)num sectionFlag:(NSString *)flag RequestFlag:(NSString *)ReFlag{
    NSString *urlString = [NSString stringWithFormat:@"%@Sections/AllMyClassArthList",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:page forKey:@"pageNum"];
    [request addPostValue:num forKey:@"numPerPage"];
    [request addPostValue:flag forKey:@"sectionFlag"];
    request.userInfo = [NSDictionary dictionaryWithObject:ReFlag forKey:@"flag"];
    request.tag = 4;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//获取当前用户可以发布动态的单位列表(含班级）
-(void)classHttpGetReleaseNewsUnits{
    NSString *urlString = [NSString stringWithFormat:@"%@/Sections/GetReleaseNewsUnits",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    request.tag = 5;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//请求成功
- (void)requestFinished:(ASIHTTPRequest *)_request{
    NSData *responseData = [_request responseData];
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
    NSString* dataString = [[NSString alloc] initWithData:responseData encoding:encoding];
    D("dataString--tag=----class--------====%ld---  ",(long)_request.tag);
    NSMutableDictionary *jsonDic = [dataString objectFromJSONString];
    //先对返回值做判断，是否连接超时
    NSString *code = [jsonDic objectForKey:@"ResultCode"];
    NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
    if ([code intValue] == 8) {
        [[LoginSendHttp getInstance] hands_login];
        return;
    }
    if (_request.tag == 1) {//客户端通过本接口获取本单位栏目文章
        NSDictionary *dic = [dataString objectFromJSONString];
        
        NSString *str = [dic objectForKey:@"Data"];
        D("str00=class==1=>>>>==%@",str);
        NSMutableArray *array = [ParserJson_class parserJsonUnitArthListIndex:str];
        NSString *flag = [_request.userInfo objectForKey:@"flag"];
        NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
        [dic1 setValue:flag forKey:@"flag"];
        [dic1 setValue:array forKey:@"array"];
        [dic1 setValue:ResultDesc forKey:@"ResultDesc"];
        [dic1 setValue:code forKey:@"ResultCode"];
        if ([flag intValue]==3||[flag intValue]==4) {//获取单位专门列表界面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UnitArthListIndex3" object:dic1];
        }else{
            //通知学校界面，获取到的单位和个人数据
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UnitArthListIndex" object:dic1];
        }
    }else if (_request.tag == 2){//取单位空间发表的最新或推荐文章
        NSDictionary *dic = [dataString objectFromJSONString];
        NSString *str = [dic objectForKey:@"Data"];
        D("str00=class==2=>>>>==%@",str);
        NSMutableArray *array = [ParserJson_class parserJsonUnitArthListIndex:str];
        NSString *flag = [_request.userInfo objectForKey:@"flag"];
        NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
        [dic1 setValue:flag forKey:@"flag"];
        [dic1 setValue:array forKey:@"array"];
        [dic1 setValue:ResultDesc forKey:@"ResultDesc"];
        [dic1 setValue:code forKey:@"ResultCode"];
        //通知学校界面，获取到的本地和全部数据
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowingUnitArthList" object:dic1];
    }else if (_request.tag == 3){//取我关注的单位栏目文章
        NSDictionary *dic = [dataString objectFromJSONString];
        NSString *str = [dic objectForKey:@"Data"];
        D("str00=class==3=>>>>==%@",str);
        NSMutableArray *array = [ParserJson_class parserJsonUnitArthListIndex:str];
        NSString *flag = [_request.userInfo objectForKey:@"flag"];
        NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
        [dic1 setValue:flag forKey:@"flag"];
        [dic1 setValue:array forKey:@"array"];
        [dic1 setValue:ResultDesc forKey:@"ResultDesc"];
        [dic1 setValue:code forKey:@"ResultCode"];
        //通知学校界面，获取到的关注数据
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyAttUnitArthListIndex" object:dic1];
    }else if (_request.tag == 4){//我的班级文章列表
        NSDictionary *dic = [dataString objectFromJSONString];
        NSString *str = [dic objectForKey:@"Data"];
        D("str00=class==4=>>>>==%@",str);
        NSMutableArray *array = [ParserJson_class parserJsonUnitArthListIndex:str];
        NSString *flag = [_request.userInfo objectForKey:@"flag"];
        NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
        [dic1 setValue:flag forKey:@"flag"];
        [dic1 setValue:array forKey:@"array"];
        [dic1 setValue:ResultDesc forKey:@"ResultDesc"];
        [dic1 setValue:code forKey:@"ResultCode"];
        if ([flag intValue]==3) {//获取单位专门列表界面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AllMyClassArthList3" object:dic1];
        }else{
            //通知学校界面，获取到的关注数据
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AllMyClassArthList" object:dic1];
        }
    }else if (_request.tag == 5){//获取当前用户可以发布动态的单位列表(含班级）
        NSDictionary *dic = [dataString objectFromJSONString];
        NSString *str = [dic objectForKey:@"Data"];
        D("str00=class==5=>>>>==%@",str);
        NSMutableArray *array = [ParserJson_class parserJsonGetReleaseNewsUnits:str];
        NSMutableDictionary *mDic = [[NSMutableDictionary alloc]initWithCapacity:0];
        [mDic setValue:ResultDesc forKey:@"ResultDesc"];
        [mDic setValue:code forKey:@"ResultCode"];
        [mDic setValue:array forKey:@"array"];
        //通知主界面，获取到的单位班级数据
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetReleaseNewsUnits" object:mDic];
    }
}
//请求失败
-(void)requestFailed:(ASIHTTPRequest *)request{
    if (request.tag == 1) {//客户端通过本接口获取本单位栏目文章
        NSString *code = @"1000";
        NSString *ResultDesc = @"请求超时";
        NSString *flag = [request.userInfo objectForKey:@"flag"];
        NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];

        [dic1 setValue:ResultDesc forKey:@"ResultDesc"];
        [dic1 setValue:code forKey:@"ResultCode"];
        if ([flag intValue]==3||[flag intValue]==4) {//获取单位专门列表界面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UnitArthListIndex3" object:dic1];
        }else{
            //通知学校界面，获取到的单位和个人数据
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UnitArthListIndex" object:dic1];
        }
    }else if (request.tag == 2){//取单位空间发表的最新或推荐文章
        NSString *code = @"1000";
        NSString *ResultDesc = @"请求超时";
        NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
        [dic1 setValue:ResultDesc forKey:@"ResultDesc"];
        [dic1 setValue:code forKey:@"ResultCode"];
        //通知学校界面，获取到的本地和全部数据
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowingUnitArthList" object:dic1];
    }else if (request.tag == 3){//取我关注的单位栏目文章
        NSString *code = @"1000";
        NSString *ResultDesc = @"请求超时";
        NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
        [dic1 setValue:ResultDesc forKey:@"ResultDesc"];
        [dic1 setValue:code forKey:@"ResultCode"];
        //通知学校界面，获取到的关注数据
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyAttUnitArthListIndex" object:dic1];
    }else if (request.tag == 4){//我的班级文章列表
        NSString *code = @"1000";
        NSString *ResultDesc = @"请求超时";
        NSString *flag = [request.userInfo objectForKey:@"flag"];
        NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
        [dic1 setValue:flag forKey:@"flag"];
        [dic1 setValue:ResultDesc forKey:@"ResultDesc"];
        [dic1 setValue:code forKey:@"ResultCode"];
        if ([flag intValue]==3) {//获取单位专门列表界面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AllMyClassArthList3" object:dic1];
        }else{
            //通知学校界面，获取到的关注数据
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AllMyClassArthList" object:dic1];
        }
    }else if (request.tag == 5){//获取当前用户可以发布动态的单位列表(含班级）
        NSString *code = @"1000";
        NSString *ResultDesc = @"请求超时";
        NSMutableDictionary *mDic = [[NSMutableDictionary alloc]initWithCapacity:0];
        [mDic setValue:ResultDesc forKey:@"ResultDesc"];
        [mDic setValue:code forKey:@"ResultCode"];
        //通知主界面，获取到的单位班级数据
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetReleaseNewsUnits" object:mDic];
    }
    D("dataString---theme-tag=%ld,flag----  请求失败",(long)request.tag);
}

@end
