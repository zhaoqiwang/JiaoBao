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
-(void)classHttpUnitArthListIndex:(NSString *)page Num:(NSString *)num Flag:(NSString *)flag UnitID:(NSString *)UnitID order:(NSString *)order title:(NSString *)title{
    NSString *urlString = [NSString stringWithFormat:@"%@Sections/UnitArthListIndex",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:page forKey:@"pageNum"];
    [request addPostValue:@"20" forKey:@"numPerPage"];
    [request addPostValue:flag forKey:@"SectionFlag"];
    [request addPostValue:UnitID forKey:@"UnitID"];
    request.tag = 1;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//请求成功
- (void)requestFinished:(ASIHTTPRequest *)_request{
    NSData *responseData = [_request responseData];
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
    NSString* dataString = [[NSString alloc] initWithData:responseData encoding:encoding];
    D("dataString--tag=----class--------====%ld---  %@",(long)_request.tag,dataString);
    NSMutableDictionary *jsonDic = [dataString objectFromJSONString];
    //先对返回值做判断，是否连接超时
    NSString *code = [jsonDic objectForKey:@"ResultCode"];
    if ([code intValue] == 8) {
        [[LoginSendHttp getInstance] hands_login];
        return;
    }
    if (_request.tag == 1) {//客户端通过本接口获取本单位栏目文章
        NSDictionary *dic = [dataString objectFromJSONString];
        NSString *str = [dic objectForKey:@"Data"];
        D("str00=class==1=>>>>==%@",str);
        NSMutableArray *array = [ParserJson_class parserJsonUnitArthListIndex:str];
        //
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UnitArthListIndex" object:array];
    }
}
//请求失败
-(void)requestFailed:(ASIHTTPRequest *)request{
    D("dataString---theme-tag=%ld,flag----  请求失败",(long)request.tag);
}

@end
