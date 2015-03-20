//
//  ShowHttp.m
//  JiaoBao
//
//  Created by Zqw on 14-12-13.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "ShowHttp.h"
#import "ShareHttp.h"
#import "InternetAppTopScrollView.h"

static ShowHttp *showHttp = nil;

@implementation ShowHttp

+(ShowHttp *)getInstance{
    if (showHttp == nil) {
        showHttp = [[ShowHttp alloc] init];
    }
    return showHttp;
}
-(id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

//获取单位logo
-(void)showHttpGetUnitLogo:(NSString *)unitID Size:(NSString *)size{
    NSString *urlString = [NSString stringWithFormat:@"%@/ClientSrv/getUnitlogo",[dm getInstance].url];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:unitID forKey:@"UnitID"];
    [request addPostValue:@"64" forKey:@"Size"];
    request.userInfo = [NSDictionary dictionaryWithObject:unitID forKey:@"unitID"];
    request.tag = 0;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//取同事、关注人、好友的分享文章
-(void)showHttpGetMyShareingArth:(NSString *)accid page:(NSString *)pageNum viewFlag:(NSString *)flag{
    NSString *urlString = [NSString stringWithFormat:@"%@Sections/myShareingArth",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:pageNum forKey:@"pageNum"];
    [request addPostValue:accid forKey:@"AccID"];
    request.userInfo = [NSDictionary dictionaryWithObject:flag forKey:@"flag"];
    request.tag = 1;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//取最新或推荐个人分享文章              1最新2推荐
-(void)showHttpGetShareingArthList:(NSString *)flag page:(NSString *)pageNum{
    NSString *urlString = [NSString stringWithFormat:@"%@Sections/ShareingArthList",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:pageNum forKey:@"pageNum"];
    [request addPostValue:flag forKey:@"topFlags"];
    request.userInfo = [NSDictionary dictionaryWithObject:flag forKey:@"flag"];
    request.tag = 2;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//取最新或推荐单位栏目文章                      1最新2推荐          是否本地
-(void)showHttpGetShowingUnitArthList:(NSString *)topFlags flag:(NSString *)flag page:(NSString *)pageNum{
    NSString *urlString = [NSString stringWithFormat:@"%@Sections/ShowingUnitArthList",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:pageNum forKey:@"pageNum"];
    [request addPostValue:topFlags forKey:@"topFlags"];
    if (flag.length>0) {
        [request addPostValue:flag forKey:@"flag"];
    }
    
//    request.userInfo = [NSDictionary dictionaryWithObject:flag forKey:@"flag"];
    request.tag = 3;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//取最新更新文章单位信息                   1最新2推荐              是否本地
-(void)showHttpGetUpdateUnitList:(NSString *)topFlag local:(NSString *)local page:(NSString *)pageNum{
    NSString *urlString = [NSString stringWithFormat:@"%@Sections/UpdateUnitList",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:pageNum forKey:@"pageNum"];
    [request addPostValue:topFlag forKey:@"topFlag"];
    [request addPostValue:local forKey:@"local"];
    [request addPostValue:@"20" forKey:@"numPerPage"];
    //    request.userInfo = [NSDictionary dictionaryWithObject:flag forKey:@"flag"];
    request.tag = 4;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//取最新更新的主题                          1最新2推荐
-(void)showHttpGetUpdatedInterestList:(NSString *)topFlag page:(NSString *)pageNum{
    NSString *urlString = [NSString stringWithFormat:@"%@Sections/UpdatedInterestList",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:pageNum forKey:@"pageNum"];
    [request addPostValue:topFlag forKey:@"topFlag"];
    //    request.userInfo = [NSDictionary dictionaryWithObject:flag forKey:@"flag"];
    request.tag = 5;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//我的主题，取我关注的和我所参与主题
-(void)showHttpGetEnjoyInterestList:(NSString *)accid{
    NSString *urlString = [NSString stringWithFormat:@"%@Sections/EnjoyInterestList",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:accid forKey:@"AccID"];
    //    request.userInfo = [NSDictionary dictionaryWithObject:flag forKey:@"flag"];
    request.tag = 6;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//获取我的关注单位
-(void)showHttpGetMyAttUnit:(NSString *)accid{
//    NSString *urlString = [NSString stringWithFormat:@"%@/LGQIFriends/GetMyAttUnit",[dm getInstance].url];
    NSString *urlString = [NSString stringWithFormat:@"%@/LGQIFriends/GetMyAttUnit",[dm getInstance].url];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:accid forKey:@"JiaoBaoHao"];
    //    request.userInfo = [NSDictionary dictionaryWithObject:flag forKey:@"flag"];
    request.tag = 7;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//获取单位头像
-(void)getUnitImg:(NSMutableArray *)array{
//    for (int i=0; i<array.count; i++) {
//        UpdateUnitListModel *model = [array objectAtIndex:i];
//        if ([model.UnitClassID intValue]>0) {
//            [self showHttpGetUnitLogo:[NSString stringWithFormat:@"-%@",model.UnitClassID] Size:@""];
//        }else{
//            [self showHttpGetUnitLogo:model.UnitID Size:@""];
//        }
//    }
}

//获取单位头像
-(void)getMyAttUnitImg:(NSMutableArray *)array{
//    for (int i=0; i<array.count; i++) {
//        MyAttUnitModel *model = [array objectAtIndex:i];
//        [self showHttpGetUnitLogo:model.InterestUnitID Size:@""];
//    }
}

//获取本单位栏目文章                               1共享2展示                单位ID                第几页
-(void)showHttpGetUnitArthLIstIndexWith:(NSString *)sectionFlag UnitID:(NSString *)unitID Page:(NSString *)page{
    NSString *urlString = [NSString stringWithFormat:@"%@Sections/ArthListIndex",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:sectionFlag forKey:@"SectionFlag"];
    [request addPostValue:unitID forKey:@"UnitID"];
    [request addPostValue:page forKey:@"pageNum"];
    request.userInfo = [NSDictionary dictionaryWithObject:sectionFlag forKey:@"sectionFlag"];
    request.tag = 8;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//获取单位简介
-(void)showHttpGetintroduce:(NSString *)unitID uTyper:(NSString *)type{
    NSString *urlString = [NSString stringWithFormat:@"%@/ClientSrv/getintroduce",[dm getInstance].url];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:unitID forKey:@"unitid"];
    [request addPostValue:type forKey:@"uType"];
    request.tag = 9;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//获取我的好友
-(void)showHttpGetMyFriends:(NSString *)accid{
    NSString *urlString = [NSString stringWithFormat:@"%@/LGQIFriends/GetMyFriends",[dm getInstance].url];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:accid forKey:@"JiaoBaoHao"];
    request.tag = 10;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//获取好友分组，提供jiaobaohao，获取该用户的所有好友分组
-(void)showHttpGetMyGroups:(NSString *)accid{
    NSString *urlString = [NSString stringWithFormat:@"%@/LGQIFriends/GetMyGroups",[dm getInstance].url];
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

//获取好友分组，提供jiaobaohao和组ID，获取该用户的这个组中所有好友
-(void)showHttpGetMyGroups:(NSString *)accid Group:(NSString *)groupID{
    NSString *urlString = [NSString stringWithFormat:@"%@/LGQIFriends/GetMyFriendsByGroups",[dm getInstance].url];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:accid forKey:@"JiaoBaoHao"];
    [request addPostValue:groupID forKey:@"GroupID"];
    request.tag = 12;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//获取我的关注,提供jiaobaohao，获取该用户关注人员
-(void)showHttpGetMyAttFriends:(NSString *)accid{
    NSString *urlString = [NSString stringWithFormat:@"%@/LGQIFriends/GetMyAttFriends",[dm getInstance].url];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:accid forKey:@"JiaoBaoHao"];
    request.tag = 13;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//请求成功
- (void)requestFinished:(ASIHTTPRequest *)_request{
    NSData *responseData = [_request responseData];
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
    NSString* dataString = [[NSString alloc] initWithData:responseData encoding:encoding];
    D("dataString--tag=----show--------====%ld---  %@",(long)_request.tag,dataString);
    NSMutableDictionary *jsonDic = [dataString objectFromJSONString];
    //先对返回值做判断，是否连接超时
    NSString *code = [jsonDic objectForKey:@"ResultCode"];
    if ([code intValue] == 8) {
        [[LoginSendHttp getInstance] hands_login];
        return;
    }
    if (_request.tag == 0) {//获取单位logo
        //获取的用户自定义内容
        NSString *unitID = [_request.userInfo objectForKey:@"unitID"];
        if ([unitID intValue]<0) {
            NSString *b = [unitID substringToIndex:1];
            if ([b isEqual:@"-"]) {
                unitID = [unitID substringFromIndex:1];
            }
        }
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        //文件名
        NSFileManager* fileManager=[NSFileManager defaultManager];
        NSString *imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",unitID]];
        BOOL yesNo=[[NSFileManager defaultManager] fileExistsAtPath:imgPath];
        if (!yesNo) {//不存在，则直接写入后通知界面刷新
            BOOL yesNo1 = [responseData writeToFile:imgPath atomically:YES];
            if (yesNo1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshShowViewNew" object:nil];
            }
        }else {//存在
            BOOL blDele= [fileManager removeItemAtPath:imgPath error:nil];//先删除
            if (blDele) {//删除成功后，写入，通知界面
                BOOL yesNo = [responseData writeToFile:imgPath atomically:YES];
                if (yesNo) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshShowViewNew" object:nil];
                }
            }
        }
    }else if (_request.tag == 1) {//取最新或推荐单位栏目文章
        NSString *flag = [_request.userInfo objectForKey:@"flag"];
        NSString *time = [jsonDic objectForKey:@"Data"];
        if ([[jsonDic objectForKey:@"ResultCode"] intValue]==0) {
            [InternetAppTopScrollView shareInstance].mInt_share = 1;
        }
        NSString *str000 = [DESTool decryptWithText:time Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        D("str00=show==1=>>>>==%@",str000);
        NSMutableArray *array = [ParserJson_share parserJsonTopArthListWith:str000];
        //获取头像
        [[ShareHttp getInstance] getFaceImg:array flag:1];
        if ([flag isEqual:@"shareNew"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TopArthListIndexNewShare" object:array];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TopArthListIndex" object:array];
        }
    }else if (_request.tag == 2) {//取最新或推荐个人分享文章
        NSString *time = [jsonDic objectForKey:@"Data"];
        NSString *str000 = [DESTool decryptWithText:time Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        D("str00=show==2=>>>>==%@",str000);
        NSMutableArray *array = [ParserJson_share parserJsonTopArthListWith:str000];
        //获取头像
//        [[ShareHttp getInstance] getFaceImg:array flag:1];
        //通知shareview界面，将得到的值，传到界面
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TopArthListIndex" object:array];
    }else if (_request.tag == 3) {//取最新或推荐单位栏目文章
//        NSString *time = [jsonDic objectForKey:@"Data"];
//        NSString *str000 = [DESTool decryptWithText:time Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        NSDictionary *dic = [dataString objectFromJSONString];
        NSString *str000 = [dic objectForKey:@"Data"];
        D("str00=show==3=>>>>==%@",str000);
        NSMutableArray *array = [ParserJson_share parserJsonTopArthListWith:str000];
        //获取头像
//        [[ShareHttp getInstance] getFaceImg:array flag:1];
       [[NSNotificationCenter defaultCenter] postNotificationName:@"TopArthListIndex" object:array];
    }else if (_request.tag == 4) {//取最新更新文章单位信息
        NSString *time = [jsonDic objectForKey:@"Data"];
        NSString *str000 = [DESTool decryptWithText:time Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        D("str00=show==4=>>>>==%@",str000);
        NSMutableArray *array = [ParserJson_show parserJsonUpdateUnitList:str000];
        //获取单位头像
        [self getUnitImg:array];
        //将获得到的单位信息，通知到界面
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateUnitList" object:array];
    }else if (_request.tag == 7){//获取我的关注单位
        if ([[jsonDic objectForKey:@"ResultCode"] intValue]==0) {
            [InternetAppTopScrollView shareInstance].mInt_show2 = 1;
        }
        NSDictionary *dic = [dataString objectFromJSONString];
        NSString *str = [dic objectForKey:@"Data"];
        D("str00=show==7=>>>>==%@",str);
        if ([[dic objectForKey:@"ResultCode"] intValue] >0) {
            D("获取我关注的单位出错");
        }else{
            NSMutableArray *array = [ParserJson_show parserJsonGetMyAttUnit:str];
            //获取单位logo
//            [self getMyAttUnitImg:array];
            //获取到我关注的单位后，通知界面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GetMyAttUnit" object:array];
        }
    }else if (_request.tag == 8) {//获取本单位栏目文章
        NSString *flag = [_request.userInfo objectForKey:@"sectionFlag"];
        NSString *time = [jsonDic objectForKey:@"Data"];
        NSString *str000 = [DESTool decryptWithText:time Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        D("str00=show==8=>>>>==%@",str000);
        if ([flag intValue] == 99) {
            NSMutableArray *array = [ParserJson_share parserJsonTopArthListWith:str000];
            //获取头像
//            [[ShareHttp getInstance] getFaceImg:array flag:1];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TopArthListIndex" object:array];
        }else{
            NSMutableArray *array = [ParserJson_share parserJsonTopArthListWith:str000];
            //获取头像
//            [[ShareHttp getInstance] getFaceImg:array flag:1];
            //通知单位展示空间界面，将得到的值，传到界面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UnitSpaceArthList" object:array];
        }
    }else if (_request.tag == 9) {//获取单位简介
        NSDictionary *dic = [dataString objectFromJSONString];
        NSString *str = [dic objectForKey:@"Data"];
        //将获取到的简介，推送到界面
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Getintroduce" object:str];
    }else if (_request.tag == 10) {//获取我的好友
        NSDictionary *dic = [dataString objectFromJSONString];
        NSString *str = [dic objectForKey:@"Data"];
        D("str00=show==10=>>>>==%@",str);
        NSMutableArray *array = [ParserJson_share parserJsonMyFriendsWith:str];
        //通知好友显示界面刷新数据
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetMyFriends" object:array];
    }else if (_request.tag == 11) {//获取好友分组，提供jiaobaohao，获取该用户的所有好友分组
//        D("str00=show==11=>>>>==%@",str000);
    }else if (_request.tag == 12) {//获取好友分组，提供jiaobaohao和组ID，获取该用户的这个组中所有好友
//        D("str00=show==12=>>>>==%@",str000);
    }else if (_request.tag == 13) {//获取我的关注,提供jiaobaohao，获取该用户关注人员
        NSDictionary *dic = [dataString objectFromJSONString];
        NSString *str = [dic objectForKey:@"Data"];
        D("str00=show==13=>>>>==%@",str);
        NSMutableArray *array = [ParserJson_share parserJsonMyFriendsWith:str];
        //通知好友显示界面刷新数据
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetMyFriends" object:array];
    }
}
//请求失败
-(void)requestFailed:(ASIHTTPRequest *)request{
    D("dataString---show-tag=%ld,flag----  请求失败",(long)request.tag);
}

@end
