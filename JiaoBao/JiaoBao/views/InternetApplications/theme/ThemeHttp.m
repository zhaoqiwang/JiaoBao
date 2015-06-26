//
//  ThemeHttp.m
//  JiaoBao
//
//  Created by Zqw on 14-12-16.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "ThemeHttp.h"
#import "InternetAppTopScrollView.h"
static ThemeHttp *themeHttp = nil;

@implementation ThemeHttp

+(ThemeHttp *)getInstance{
    if (themeHttp == nil) {
        themeHttp = [[ThemeHttp alloc] init];
    }
    return themeHttp;
}
-(id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

//取最新更新的主题                              1最新2推荐
-(void)themeHttpUpdatedInterestList:(NSString *)topFlag Page:(NSString *)pageNum{
    NSString *urlString = [NSString stringWithFormat:@"%@Sections/UpdatedInterestList",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:topFlag forKey:@"topFlag"];
    [request addPostValue:pageNum forKey:@"pageNum"];
    [request addPostValue:@"20" forKey:@"numPerPage"];
    request.userInfo = [NSDictionary dictionaryWithObject:topFlag forKey:@"topFlag"];
    request.tag = 1;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//取我关注的和我所参与的主题
-(void)themeHttpEnjoyInterestList:(NSString *)accid{
    NSString *urlString = [NSString stringWithFormat:@"%@Sections/EnjoyInterestList",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:accid forKey:@"AccID"];
    request.tag = 2;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//获取单位头像
-(void)getUnitImg:(NSMutableArray *)array{
//    for (int i=0; i<array.count; i++) {
//        ThemeListModel *model = [array objectAtIndex:i];
//        D("showhttp.getunitimg-=-=%@",model.TabID);
//        [[ShowHttp getInstance] showHttpGetUnitLogo:[NSString stringWithFormat:@"-%@",model.TabID] Size:@""];
//    }
}
//获取单位头像
-(void)getUnitImg1:(NSMutableArray *)array{
//    for (int i=0; i<array.count; i++) {
//        UpdateUnitListModel *model = [array objectAtIndex:i];
//        D("showhttp.getunitimg-=-=%@",model.UnitClassID);
//        [[ShowHttp getInstance] showHttpGetUnitLogo:[NSString stringWithFormat:@"-%@",model.UnitClassID] Size:@""];
//    }
}

//获取单位相册,功能：获取某单位中的相册
-(void)themeHttpGetUnitPGroup:(NSString *)unitID{
    NSString *urlString = [NSString stringWithFormat:@"%@/LGQIPhotoInfo/GetUnitPGroup",[dm getInstance].url];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:unitID forKey:@"UnitID"];
    request.tag = 3;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//获取在单位中我创建的相册
-(void)themeHttpGetUnitMyGroup:(NSString *)unitID AccID:(NSString *)accid{
    NSString *urlString = [NSString stringWithFormat:@"%@/LGQIPhotoInfo/GetUnitMyGroup",[dm getInstance].url];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:unitID forKey:@"UnitID"];
    [request addPostValue:accid forKey:@"JiaoBaoHao"];
    request.tag = 4;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//获取单位相册的照片
-(void)themeHttpGetUnitPhotoByGroupIDs:(NSString *)unitID GroupID:(NSString *)groupID{
    NSString *urlString = [NSString stringWithFormat:@"%@/LGQIPhotoInfo/GetUnitPhotoByGroupID",[dm getInstance].url];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:unitID forKey:@"UnitID"];
    [request addPostValue:groupID forKey:@"GroupID"];
    request.tag = 5;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//创建单位相册                                                相册名称                 相册创建人：jiaobaohao    相册描述，目前没有用描述,这里写“来自手机”  0无限制，1单位内可见
-(void)themeHttpCreateUnitPhotoGroup:(NSString *)unitID PhotoName:(NSString *)name CreatBy:(NSString *)creatID DesInfo:(NSString *)desInfo ViewType:(NSString *)viewType{
    NSString *urlString = [NSString stringWithFormat:@"%@/LGQIPhotoInfo/CreateUnitPhotoGroup",[dm getInstance].url];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:unitID forKey:@"UnitID"];
    [request addPostValue:name forKey:@"nameStr"];
    [request addPostValue:creatID forKey:@"CreateBy"];
    [request addPostValue:@"来自手机" forKey:@"DesInfo"];
    [request addPostValue:viewType forKey:@"ViewType"];;
    request.tag = 6;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//单位相册上传照片
-(void)themeHttpUpLoadPhotoUnit:(NSString *)unitID GroupID:(NSString *)groupID Creatby:(NSString *)creatID Fiel:(NSString *)file{
    NSString *urlString = [NSString stringWithFormat:@"%@/LGQIPhotoInfo/UpLoadPhotoUnit",[dm getInstance].url];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:unitID forKey:@"UnitID"];
    [request addPostValue:groupID forKey:@"GroupID"];
    [request addPostValue:creatID forKey:@"CreateBy"];
    
    [request setFile:file forKey:@"file"];
    request.tag = 7;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//获取单位相册的第一张照片
-(void)themeHttpGetUnitFristPhotoByGroup:(NSString *)unitID GroupID:(NSString *)groupID{
    NSString *urlString = [NSString stringWithFormat:@"%@/LGQIPhotoInfo/GetUnitFristPhotoByGroupID",[dm getInstance].url];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:unitID forKey:@"UnitID"];
    [request addPostValue:groupID forKey:@"GroupID"];
    request.userInfo = [NSDictionary dictionaryWithObject:groupID forKey:@"groupID"];
    request.tag = 8;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//获取单位中最新的N张照片
-(void)themeHttpGetUnitNewPhoto:(NSString *)unitID count:(NSString *)count{
    NSString *urlString = [NSString stringWithFormat:@"%@/LGQIPhotoInfo/GetUnitNewPhoto",[dm getInstance].url];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:unitID forKey:@"UnitID"];
    [request addPostValue:count forKey:@"count"];
    request.tag = 15;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//个人空间相册上传照片                上传 人jiaobaohao      文件名称 带后缀                        照片描述                    相册ID ，加密后的ID
-(void)themeHttpUpLoadPhotoFromAPP:(NSString *)accid FileName:(NSString *)fileName Describe:(NSString *)describe GroupID:(NSString *)group FIle:(NSString *)file{
    NSString *urlString = [NSString stringWithFormat:@"%@/LGQIPhoto/UpLoadPhotoFromAPP",[dm getInstance].url];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:accid forKey:@"JiaoBaoHao"];
    [request addPostValue:fileName forKey:@"FileName"];
    [request addPostValue:describe forKey:@"PhotoDescribe"];
    [request addPostValue:group forKey:@"GroupID"];
    [request setFile:file forKey:@"file"];
    request.tag = 9;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//个人空间添加相册                                          type:相册访问权限:0:私有；1：好友可访问；2：关注可访问；3：游客可访问
-(void)themeHttpAddPhotoGroup:(NSString *)accid PhotoName:(NSString *)name viewType:(NSString *)type{
    NSString *urlString = [NSString stringWithFormat:@"%@/LGQIPhoto/AddPhotoGroup",[dm getInstance].url];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:accid forKey:@"JiaoBaoHao"];
    [request addPostValue:name forKey:@"PhotoGroupName"];
    [request addPostValue:type forKey:@"viewType"];
    request.tag = 10;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//要获取属于jiaobaohao下的相册
-(void)themeHttpGetPhotoList:(NSString *)accid{
    NSString *urlString = [NSString stringWithFormat:@"%@/LGQIPhoto/GetPhotoList",[dm getInstance].url];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:accid forKey:@"JiaoBaoHao"];
    request.tag = 11;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//个人某个相册中的照片
-(void)themeHttpGetPhotoByGroup:(NSString *)accid GroupInfo:(NSString *)groupID{
    NSString *urlString = [NSString stringWithFormat:@"%@/LGQIPhoto/GetPhotoByGroup",[dm getInstance].url];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:accid forKey:@"JiaoBaoHao"];
    [request addPostValue:groupID forKey:@"GroupInfo"];
    request.tag = 5;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//个人最新前N张照片
-(void)themeHttpGetNewPhoto:(NSString *)accid Count:(NSString *)count{
    NSString *urlString = [NSString stringWithFormat:@"%@/LGQIPhoto/GetNewPhoto",[dm getInstance].url];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:accid forKey:@"JiaoBaoHao"];
    [request addPostValue:count forKey:@"Count"];
    request.tag = 13;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//个人相册中第一张照片
-(void)themeHttpGetFristPhotoByGroup:(NSString *)accid GroupInfo:(NSString *)groupID{
    NSString *urlString = [NSString stringWithFormat:@"%@/LGQIPhoto/GetFristPhotoByGroup",[dm getInstance].url];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:accid forKey:@"JiaoBaoHao"];
    [request addPostValue:groupID forKey:@"GroupInfo"];
    request.userInfo = [NSDictionary dictionaryWithObject:groupID forKey:@"groupID"];
    request.tag = 14;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//是否关注主题                主题加密id
-(void)themeHttpExistAtt:(NSString *)uid{
    NSString *urlString = [NSString stringWithFormat:@"%@Interest/ExistAtt",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:uid forKey:@"uid"];
    request.tag = 16;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//加主题关注
-(void)themeHttpAddAtt:(NSString *)uid{
    NSString *urlString = [NSString stringWithFormat:@"%@Interest/AddAtt",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:uid forKey:@"uid"];
    request.tag = 17;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//取消主题关注
-(void)themeHttpRemoveAtt:(NSString *)uid{
    NSString *urlString = [NSString stringWithFormat:@"%@Interest/RemoveAtt",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:uid forKey:@"uid"];
    request.tag = 18;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//所有照片
-(void)themeHttpGetPhotoAll:(NSString *)accid{
    
}

//请求成功
- (void)requestFinished:(ASIHTTPRequest *)_request{
    NSData *responseData = [_request responseData];
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
    NSString* dataString = [[NSString alloc] initWithData:responseData encoding:encoding];
    D("dataString--tag=----theme--------====%ld---  %@",(long)_request.tag,dataString);
    NSMutableDictionary *jsonDic = [dataString objectFromJSONString];
    //先对返回值做判断，是否连接超时
    NSString *code = [jsonDic objectForKey:@"ResultCode"];
    NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];

    if ([code intValue] == 8) {
        [[LoginSendHttp getInstance] hands_login];
        return;
    }
    if (_request.tag == 1) {//取最新更新的主题
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];

        if([code integerValue]==0)
        {
        NSString *time = [jsonDic objectForKey:@"Data"];
        NSString *str000 = [DESTool decryptWithText:time Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        D("str00=theme==1=>>>>==%@",str000);
        NSMutableArray *array = [ParserJson_show parserJsonUpdateUnitList:str000];
            [dic setValue:code forKey:@"ResultCode"];
            [dic setValue:ResultDesc forKey:@"ResultDesc"];
            [dic setValue:array forKey:@"array"];

        //获取单位头像
//        [self getUnitImg1:array];
        //将获得到的单位信息，通知到界面
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateUnitList" object:dic];
        }
        else
        {
            [dic setValue:code forKey:@"ResultCode"];
            [dic setValue:ResultDesc forKey:@"ResultDesc"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateUnitList" object:dic];

        }
    }else if (_request.tag == 2) {//取我关注的和我所参与的主题
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];

        if ([code intValue]==0) {
            [InternetAppTopScrollView shareInstance].mInt_theme = 1;
            NSString *time = [jsonDic objectForKey:@"Data"];
            NSString *str000 = [DESTool decryptWithText:time Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
            D("str00=theme==2=>>>>==%@",str000);
            NSMutableArray *array = [ParserJson_theme parserJsonEnjoyInterestList:str000];
            [dic setValue:code forKey:@"ResultCode"];
            [dic setValue:ResultDesc forKey:@"ResultDesc"];
            [dic setValue:array forKey:@"array"];
            //获取单位头像
            //        [self getUnitImg:array];
            //将我的主题通知界面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"EnjoyInterestList" object:dic];
        }
        else
        {
            [dic setValue:code forKey:@"ResultCode"];
            [dic setValue:ResultDesc forKey:@"ResultDesc"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"EnjoyInterestList" object:dic];

        }

    }else if (_request.tag == 3) {//获取单位相册,功能：获取某单位中的相册
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];

        if ([code intValue]>0) {
            [dic setValue:code forKey:@"ResultCode"];
            [dic setValue:ResultDesc forKey:@"ResultDesc"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GetUnitPGroup" object:dic];
            D("数据错误或没有相册");
        }else{
            NSDictionary *dic1 = [dataString objectFromJSONString];
            NSString *str = [dic1 objectForKey:@"Data"];
            D("str00=theme==3=>>>>==%@",str);
            NSMutableArray *array = [ParserJson_show parserJsonGetUnitPGroup:str];
            [dic setValue:code forKey:@"ResultCode"];
            [dic setValue:ResultDesc forKey:@"ResultDesc"];
            [dic setValue:array forKey:@"array"];

            //获取单位相册后，通知界面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GetUnitPGroup" object:dic];
        }
        
    }else if (_request.tag == 5) {//获取单位相册的照片
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:code forKey:@"ResultCode"];
        [dic setValue:ResultDesc forKey:@"ResultDesc"];
        if ([code intValue]>0) {
            D("数据错误或没有相册");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GetUnitPhotoByGroupID" object:dic];
        }else{
            NSDictionary *dic1 = [dataString objectFromJSONString];
            NSString *str = [dic1 objectForKey:@"Data"];
            D("str00=theme==5=>>>>==%@",str);
            NSMutableArray *array = [ParserJson_show parserJsonGetUnitPhotoByGroupID:str];
            [dic setValue:array forKey:@"array"];

            //获取单位相册照片后，通知界面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GetUnitPhotoByGroupID" object:dic];
        }
    }else if (_request.tag == 6) {//创建单位相册
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:code forKey:@"ResultCode"];
        [dic setValue:ResultDesc forKey:@"ResultDesc"];
        if ([code intValue]==0) {
            D("单位相册创建成功");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CreateUnitPhotoGroup" object:@"0"];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CreateUnitPhotoGroup" object:@"1"];
        }
    }else if (_request.tag == 7) {//单位相册上传照片
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:code forKey:@"ResultCode"];
        [dic setValue:ResultDesc forKey:@"ResultDesc"];
        if ([code intValue]==0) {
            D("单位上传照片成功");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpLoadPhotoUnit" object:@"0"];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpLoadPhotoUnit" object:@"1"];
        }
    }else if (_request.tag == 8) {//获取单位相册的第一张照片
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:code forKey:@"ResultCode"];
        [dic setValue:ResultDesc forKey:@"ResultDesc"];
        if ([code intValue]>0) {
            D("数据错误或没有相册");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetUnitFristPhotoByGroup" object:dic];

        }else{
            NSDictionary *dic1 = [dataString objectFromJSONString];
            NSString *str = [dic1 objectForKey:@"Data"];
            str = [str stringByReplacingOccurrencesOfString:@"[{{" withString:@"[{"];
            D("str00=theme==8=>>>>==%@",str);
            NSMutableArray *array = [ParserJson_show parserJsonGetUnitPhotoByGroupID:str];
            D("str00=theme==8=>>>>%lu",(unsigned long)array.count);
            NSString *group = [_request.userInfo objectForKey:@"groupID"];
            //NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
            [dic setValue:group forKey:@"groupID"];
            [dic setValue:array forKey:@"array"];
            //获取单位相册的第一张照片后，通知界面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GetUnitFristPhotoByGroup" object:dic];
        }
    }else if (_request.tag == 9) {//个人空间相册上传照片
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:code forKey:@"ResultCode"];
        [dic setValue:ResultDesc forKey:@"ResultDesc"];
        if ([code intValue]==0) {
            D("个人空间上传照片成功");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpLoadPhotoUnit" object:@"0"];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpLoadPhotoUnit" object:@"1"];
        }
    }else if (_request.tag == 10) {//个人空间添加相册
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:code forKey:@"ResultCode"];
        [dic setValue:ResultDesc forKey:@"ResultDesc"];
        if ([code intValue]==0) {
            D("个人空间相册创建成功");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CreateUnitPhotoGroup" object:@"0"];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CreateUnitPhotoGroup" object:@"1"];
        }
    }else if (_request.tag == 11) {//要获取属于jiaobaohao下的相册
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:code forKey:@"ResultCode"];
        [dic setValue:ResultDesc forKey:@"ResultDesc"];
        if ([code intValue]>0) {
            D("数据错误或没有相册");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GetPhotoList" object:dic];
        }else{
            NSDictionary *dic1 = [dataString objectFromJSONString];
            NSString *str = [dic1 objectForKey:@"Data"];
            D("str00=theme==11=>>>>==%@",str);
            NSMutableArray *array = [ParserJson_show parserJsonGetPhotoList:str];
            [dic setValue:array forKey:@"array"];
            //获取单位相册照片后，通知界面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GetPhotoList" object:dic];
        }
    }else if (_request.tag == 12) {//个人某个相册中的照片
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:code forKey:@"ResultCode"];
        [dic setValue:ResultDesc forKey:@"ResultDesc"];
        if ([code intValue]>0) {
            D("数据错误或没有相册");
        }else{
            NSDictionary *dic1 = [dataString objectFromJSONString];
            NSString *str = [dic1 objectForKey:@"Data"];
            D("str00=theme==12=>>>>==%@",str);
//            NSMutableArray *array = [ParserJson_show parserJsonGetPhotoList:str];
//            //获取单位相册照片后，通知界面
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"GetUnitPGroup" object:array];
        }
    }else if (_request.tag == 13) {//个人最新前N张照片
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:code forKey:@"ResultCode"];
        [dic setValue:ResultDesc forKey:@"ResultDesc"];
        if ([code intValue]>0) {
            D("数据错误或没有相册");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GetNewPhoto" object:dic];
        }else{
            NSDictionary *dic1 = [dataString objectFromJSONString];
            NSString *str = [dic1 objectForKey:@"Data"];
            D("str00=theme==13=>>>>==%@",str);
            NSMutableArray *array = [ParserJson_show parserJsonGetUnitPhotoByGroupID:str];
            [dic setValue:array forKey:@"array"];
            //个人最新前N张照片后，通知界面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GetNewPhoto" object:dic];
        }
    }else if (_request.tag == 14) {//个人相册中第一张照片
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:code forKey:@"ResultCode"];
        [dic setValue:ResultDesc forKey:@"ResultDesc"];
        if ([code intValue]>0) {
            D("数据错误或没有相册");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GetFristPhotoByGroup" object:dic];

        }else{
            NSDictionary *dic1 = [dataString objectFromJSONString];
            NSString *str = [dic1 objectForKey:@"Data"];
//            str = [str stringByReplacingOccurrencesOfString:@"[{{" withString:@"[{"];
            D("str00=theme==14=>>>>==%@",str);
            NSMutableArray *array = [ParserJson_show parserJsonGetUnitPhotoByGroupID:str];
            D("str00=theme==14=>>>>%lu",(unsigned long)array.count);
            NSString *group = [_request.userInfo objectForKey:@"groupID"];
            //NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
            [dic setValue:group forKey:@"groupID"];
            [dic setValue:array forKey:@"array"];
            //获取个人相册的第一张照片后，通知界面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GetFristPhotoByGroup" object:dic];
        }
    }else if (_request.tag == 15) {//获取单位中最新的N张照片
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:code forKey:@"ResultCode"];
        [dic setValue:ResultDesc forKey:@"ResultDesc"];
        if ([code intValue]>0) {
            D("数据错误或没有相册");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GetUnitNewPhoto" object:dic];
        }else{
            NSDictionary *dic1 = [dataString objectFromJSONString];
            NSString *str = [dic1 objectForKey:@"Data"];
            D("str00=theme==15=>>>>==%@",str);
            NSMutableArray *array = [ParserJson_show parserJsonGetUnitPhotoByGroupID:str];
            [dic setValue:array forKey:@"array"];

            //个人最新前N张照片后，通知界面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GetUnitNewPhoto" object:dic];
        }
    }else if (_request.tag == 16) {//是否关注主题
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:code forKey:@"ResultCode"];
        [dic setValue:ResultDesc forKey:@"ResultDesc"];
        if ([code intValue]==0) {
            NSString *str = [jsonDic objectForKey:@"Data"];
            [dic setValue:str forKey:@"str"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ExistAtt" object:dic];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ExistAtt" object:dic];
            
        }
    }else if (_request.tag == 17) {//加主题关注
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:code forKey:@"ResultCode"];
        [dic setValue:ResultDesc forKey:@"ResultDesc"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AddAtt" object:nil];
    }else if (_request.tag == 18) {//取消主题关注
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:code forKey:@"ResultCode"];
        [dic setValue:ResultDesc forKey:@"ResultDesc"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveAtt" object:nil];
    }
}
//请求失败
-(void)requestFailed:(ASIHTTPRequest *)request{
    [MBProgressHUD hideHUDForView:nil];
    D("dataString---theme-tag=%ld,flag----  请求失败",(long)request.tag);
}

@end
