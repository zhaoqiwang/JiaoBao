//
//  LoginSendHttp.m
//  JiaoBao
//
//  Created by Zqw on 14-10-20.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "LoginSendHttp.h"
#import "InternetAppTopScrollView.h"
#import "RegisterHttp.h"

static LoginSendHttp *loginSendHttp = nil;

@implementation LoginSendHttp
@synthesize mStr_hands,mStr_Register,flag_request,delegate,flag_skip,mStr_passwd,mStr_userName,flag_unReadMsg,mInt_forwardAll,mInt_forwardFlag;

+(LoginSendHttp *)getInstance{
    if (loginSendHttp == nil) {
        loginSendHttp = [[LoginSendHttp alloc] init];
    }
    return loginSendHttp;
}
-(id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

//向服务器获取当前时间
-(void)getTime:(NSString *)flag{
    NSString *urlString = [NSString stringWithFormat:@"%@Account/getcurTime",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    request.userInfo = [NSDictionary dictionaryWithObject:flag forKey:@"flag"];
    flag_request = 4;
    [request startAsynchronous];
}

//客户端开始注册接口
-(void)reg:(NSString *)time{
    NSString *ClientKey = [dm getInstance].uuid;
    NSDictionary *user = [[NSDictionary alloc] initWithObjectsAndKeys:APPID,@"AppID",[[NSUserDefaults standardUserDefaults] valueForKey:@"UUID"], @"ID",ClientKey,@"Key",time,@"TimeStamp", nil];
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    NSString *additionStr = [writer stringWithObject:user];
    NSData *dataRSA = [RSATool encrypt:additionStr error:nil];
    NSString *encodedPassword = [dataRSA base64EncodedString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@Account/Reg",MAINURL]];
    flag_request = 2;
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"pplication/json; encoding=utf-8"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:CLIVER forKey:@"CliVer"];
    [request addPostValue:encodedPassword forKey:@"regstr"];
    [request addPostValue:@"true" forKey:@"ios"];
    [request setDelegate:self];
    [request startAsynchronous];
}

//登录，先握手，再发送登录
-(void)hands_login{
    NSString *tempUUID = [[NSUserDefaults standardUserDefaults] valueForKey:@"UUID"];
    self.mStr_hands = [[utils uuid] substringWithRange:NSMakeRange(3,8)];
    D("self.hello = %@",self.mStr_hands);
    //生成签名字符串
    NSString *ClientKey = [[NSUserDefaults standardUserDefaults]objectForKey:@"ClientKey"];
    NSString *sign = [NSString stringWithFormat:@"%@%@%@%@",CLIVER,tempUUID,self.mStr_hands,ClientKey];
    NSData * md5Data=[[sign dataUsingEncoding:NSUTF8StringEncoding] MD5Sum];
    NSString *strSign =[NSString base64StringFromData:md5Data length:(int)md5Data.length];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@Account/hello",MAINURL]];
    flag_request = 3;
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:CLIVER forKey:@"CliVer"];
    [request addPostValue:tempUUID forKey:@"IAMSCID"];
    [request addPostValue:self.mStr_hands forKey:@"hellostr"];
    [request addPostValue:strSign forKey:@"Sign"];
    D("shdkl-== %@",self.mStr_hands);
    [request setDelegate:self];
    [request startAsynchronous];
}

//发送登录请求
-(void)login:(NSString *)time{
    NSString *ClientKey = [[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"];
    //登录字符串
    NSDictionary *loginStr;
    if (self.flag_skip == 1) {
        loginStr = [[NSDictionary alloc] initWithObjectsAndKeys:self.mStr_userName,@"UserName",self.mStr_passwd, @"UserPW",time,@"TimeStamp", nil];
    } else {
        loginStr = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults]objectForKey:@"UserName"],@"UserName",[[NSUserDefaults standardUserDefaults]objectForKey:@"PassWD"], @"UserPW",time,@"TimeStamp", nil];
    }
    D("loginstr-======%@",loginStr);
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    NSString *loginJSon = [writer stringWithObject:loginStr];
    //加密
    NSData *dataRSA = [RSATool encrypt:loginJSon error:nil];
    NSString *loginRSA = [dataRSA base64EncodedString];
    //生成签名字符串
    NSString *sign = [NSString stringWithFormat:@"%@%@%@%@",CLIVER,loginRSA,ClientKey,time];
    //加密
    NSData * md5Data=[[sign dataUsingEncoding:NSUTF8StringEncoding] MD5Sum];
    NSString *strSign =[NSString base64StringFromData:md5Data length:(int)md5Data.length];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@Account/login",MAINURL]];
    flag_request = 5;
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"pplication/json; encoding=utf-8"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:CLIVER forKey:@"CliVer"];
    [request addPostValue:loginRSA forKey:@"Loginstr"];
    [request addPostValue:time forKey:@"TimeStamp"];
    [request addPostValue:strSign forKey:@"Sign"];
    [request addPostValue:@"true" forKey:@"ios"];
    [request setDelegate:self];
    [request startAsynchronous];
}

//请求Token
-(void)getToken{
    self.flag_request = 7;
    NSString *urlString = [NSString stringWithFormat:@"%@Account/getToken",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request startAsynchronous];
}

//验证Token
-(void)validateToken:(NSString *)token{
    self.flag_request = 8;
    NSString *urlString = [NSString stringWithFormat:@"%@/Account/checkToken",[dm getInstance].url];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    request.userInfo = [NSDictionary dictionaryWithObject:token forKey:@"token"];
    [request addPostValue:token forKey:@"cliToken"];
    [request setDelegate:self];
    [request startAsynchronous];
}

//请求系统应用的URL
-(void)getSRVUrl{
    self.flag_request = 6;
    NSString *urlString = [NSString stringWithFormat:@"%@Account/getSRVUrl",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request startAsynchronous];
}

//获取自己的身份信息
-(void)getIdentityInformation{
    NSString *urlString = [NSString stringWithFormat:@"%@Account/getRoleIdentity",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    request.tag = 2;//设置请求tag
    self.flag_request = 0;
    [request setDelegate:self];
    [request startAsynchronous];
}
//获取未读消息数量
-(void)getUnreadMessages1{
    NSString *urlString = [NSString stringWithFormat:@"%@CommMsg/getNoReadeCount",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    request.tag = 3;//设置请求tag
    self.flag_request = 0;
    [request setDelegate:self];
    [request startAsynchronous];
}
//获取未读回复数量
-(void)getUnreadMessages2{
    NSString *urlString = [NSString stringWithFormat:@"%@CommMsg/getfbtomecount",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    request.tag = 4;//设置请求tag
    self.flag_request = 0;
    [request setDelegate:self];
    [request startAsynchronous];
}

//获取发给我的待处理信息6,已处理未回复的8，已处理已回复的9,转发上级通知4,回复我的7
-(void)wait_unReadMsgWithTag:(int)tag page:(NSString *)page{
    NSString *urlString;
    if (tag == 7) {
        urlString = [NSString stringWithFormat:@"%@CommMsg/FeebackToMe",MAINURL];
    }else{
        urlString = [NSString stringWithFormat:@"%@CommMsg/CommListToMe",MAINURL];
    }
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:page forKey:@"pageNum"];
    [request addPostValue:@"20" forKey:@"numPerPage"];
    if (tag == 6) {
        [request addPostValue:@"1" forKey:@"readflag"];
        request.userInfo = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d",tag] forKey:@"tag"];
        request.tag = 5;//设置请求tag
    } else if(tag == 8){
        [request addPostValue:@"2" forKey:@"readflag"];
        request.tag = 6;//设置请求tag
    }else if(tag == 9){
        [request addPostValue:@"3" forKey:@"readflag"];
        request.tag = 7;//设置请求tag
    }else if (tag == 4){
        [request addPostValue:@"true" forKey:@"trun"];
        request.tag = 9;//设置请求tag
    }else if (tag == 7){
        request.tag = 11;//设置请求tag
    }else if(tag == 0){//全部
        [request addPostValue:@"null" forKey:@"readflag"];
        request.userInfo = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d",tag] forKey:@"tag"];
        request.tag = 5;//设置请求tag
    }
    self.flag_request = 0;
    [request setDelegate:self];
    [request startAsynchronous];
}

//获取自己发出的信息
-(void)getMyselfSendMsgWithPage:(NSString *)page{
    NSString *urlString = [NSString stringWithFormat:@"%@CommMsg/MySend",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:@"20" forKey:@"numPerPage"];
    [request addPostValue:page forKey:@"pageNum"];
    request.tag = 8;//设置请求tag
    self.flag_request = 0;
    [request setDelegate:self];
    [request startAsynchronous];
}

//获取头像
-(void)getFaceImg:(NSMutableArray *)array{
    NSMutableArray *tempArr = [NSMutableArray array];
    for (int i=0; i<array.count; i++) {
        UnReadMsg_model *unReadMsgModel = [array objectAtIndex:i];
        [tempArr addObject:unReadMsgModel.JiaoBaoHao];
    }
    //给数组中的教宝号去重
    NSSet *set = [NSSet setWithArray:tempArr];
    tempArr = [NSMutableArray arrayWithArray:[set allObjects]];
    D("tempArr-==== %@",[set allObjects]);
    for (int i=0; i<tempArr.count; i++) {
        NSString *urlString = [NSString stringWithFormat:@"%@/ClientSrv/getfaceimg",[dm getInstance].url];
        NSURL *url = [NSURL URLWithString:urlString];
        ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
        request.timeOutSeconds = TIMEOUT;
        [request addRequestHeader:@"Content-Type" value:@"text/xml"];
        [request addRequestHeader:@"charset" value:@"UTF8"];
        [request setRequestMethod:@"POST"];
        //用户自定义数据   字典类型  （可选）
        request.userInfo = [NSDictionary dictionaryWithObject:[tempArr objectAtIndex:i] forKey:@"JiaoBaoHao"];
        [request addPostValue:[tempArr objectAtIndex:i] forKey:@"AccID"];
        request.tag = 10;//设置请求tag
        self.flag_request = 0;
        [request setDelegate:self];
        [request startAsynchronous];
    }
}

//显示交流信息明细
-(void)msgDetailwithUID:(NSString *)uid page:(int)page feeBack:(NSString *)feeBack ReadFlag:(NSString *)flag{
    NSString *urlString = [NSString stringWithFormat:@"%@CommMsg/ShowDetail2",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:@"true" forKey:@"getfb"];
    [request addPostValue:@"20" forKey:@"numPerPage"];
    [request addPostValue:[NSString stringWithFormat:@"%d",page] forKey:@"pageNum"];
    if (feeBack.length>0) {
        [request addPostValue:uid forKey:@"rid"];
        [request addPostValue:feeBack forKey:@"uid"];
    }else{
        [request addPostValue:uid forKey:@"uid"];
    }
    [request addPostValue:flag forKey:@"ReadFlag"];
    request.tag = 12;//设置请求tag
    self.flag_request = 0;
    [request setDelegate:self];
    [request startAsynchronous];
}

//回复交流信息
-(void)addFeeBackWithUID:(NSString *)uid content:(NSString *)content{
    NSString *urlString = [NSString stringWithFormat:@"%@CommMsg/addfeeback",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:uid forKey:@"uid"];
    [request addPostValue:content forKey:@"feebacktalkcontent"];
    NSString *time = [utils getLocalTime];
    D("当前的时间是：%@",time);
    [request addPostValue:time forKey:@"MsgRecDate"];
    request.tag = 13;//设置请求tag
    self.flag_request = 0;
    [request setDelegate:self];
    [request startAsynchronous];
}

//在信息详情页，点击下载文件
-(void)msgDetailDownLoadFileWithURL:(NSString *)Fileurl fileName:(NSString *)fileName{
    NSURL *url = [NSURL URLWithString:Fileurl];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    request.tag = 14;//设置请求tag
    
//    [request setUploadProgressDelegate:self];
//    别忘记showAccurateProgress也要设置为YES (默认为NO,则只显示0%和100%):
    request.showAccurateProgress=YES;//
    [request setDownloadProgressDelegate:self];
//    request.userInfo = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@%@",Fileurl,fileName] forKey:@"fileName"];
    request.userInfo = [NSDictionary dictionaryWithObject:fileName forKey:@"fileName"];
    self.flag_request = 0;
    [request setDelegate:self];
    [request startAsynchronous];
}

-(void)setProgress:(float)newProgress{
//    [self.pv setProgress:newProgress];
//    self.lbPercent.text=[NSString stringWithFormat:@"%0.f%%",newProgress*100];
    D("进度是：%@",[NSString stringWithFormat:@"%0.f",newProgress*100]);
    NSString *temp = [NSString stringWithFormat:@"%.0f",newProgress*100];
    //通知信息详情界面，更新下载文件的进度条
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadingProgress" object:temp];
}

-(void)request:(ASIHTTPRequest *)request incrementDownloadSizeBy:(long long)newLength{
    D("请求过程中.... %lld",newLength);
}

//获取接收人列表或单位列表,flag是短信还是普通请求，all是否群发
-(void)ReceiveListWithFlag:(int)flag all:(int)all{
    NSString *urlString;
    if (flag == 1) {
        urlString = [NSString stringWithFormat:@"%@CommMsg/CommMsgRevicerList",MAINURL];
    } else {
        urlString = [NSString stringWithFormat:@"%@CommMsg/SMSCommIndex",MAINURL];
    }
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    if (all == 1) {
        [request addPostValue:@"true" forKey:@"msgall"];
    }
    if (flag == 1) {//普通请求
        request.tag = 15;//设置请求tag
    }else{//短信直通车
        request.tag = 18;//设置请求tag
    }
    
    self.flag_request = 0;
    [request setDelegate:self];
    [request startAsynchronous];
}
//切换所在单位，切换身份
-(void)changeCurUnit{
    NSString *urlString = [NSString stringWithFormat:@"%@Account/changeCurUnit",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:@([dm getInstance].UID) forKey:@"UID"];
    [request addPostValue:@([dm getInstance].uType) forKey:@"uType"];
    request.tag = 16;//设置请求tag
    self.flag_request = 0;
    [request setDelegate:self];
    [request startAsynchronous];
}

//获取自己的个人信息
-(void)getUserInfoWith:(NSString *)accID UID:(NSString *)uid{
    NSString *urlString = [NSString stringWithFormat:@"%@Account/getUserInfo",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:[dm getInstance].jiaoBaoHao forKey:@"AccID"];
    [request addPostValue:uid forKey:@"UID"];
    request.tag = 19;//设置请求tag
    self.flag_request = 0;
    [request setDelegate:self];
    [request startAsynchronous];
}

//发表交流信息,内容                                 是否发生短信      单位加密ID                  接收班级总人数         是否短信直通车     接收者数组
-(void)creatCommMsgWith:(NSString *)content SMSFlag:(int)sms unitid:(NSString *)unit classCount:(int)count grsms:(int)grsms array:(NSMutableArray *)array forwardMsgID:(NSString *)msgid access:(NSMutableArray *)arrayAccess{
    NSString *urlString = [NSString stringWithFormat:@"%@CommMsg/CreateCommMsg",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:content forKey:@"talkcontent"];
    if (sms == 1) {
        [request addPostValue:@"0" forKey:@"SMSFlag"];//false
    } else {
        [request addPostValue:@"1" forKey:@"SMSFlag"];
    }
    [request addPostValue:unit forKey:@"curunitid"];
    if (grsms == 1) {
        [request addPostValue:@"false" forKey:@"grsms"];
        for (int i=0; i<array.count; i++) {
            NSMutableDictionary *dic = [array objectAtIndex:i];
            D("[dic objectForKey:-===%@,%@",[dic objectForKey:@"selit"],[dic objectForKey:@"flag"]);

            [request addPostValue:[dic objectForKey:@"selit"] forKey:[dic objectForKey:@"flag"]];
        }
    }else{
        [request addPostValue:@"true" forKey:@"grsms"];
        for (int i=0; i<array.count; i++) {
            NSString *str = [array objectAtIndex:i];
            [request addPostValue:str forKey:@"selit"];
           
        }
    }
    //判断是否有附件
    if (arrayAccess.count>0) {
        //文件名
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *tempPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"file-%@",[dm getInstance].jiaoBaoHao]];
        for (int i=0; i<arrayAccess.count; i++) {
            NSString *imgPath=[tempPath stringByAppendingPathComponent:[arrayAccess objectAtIndex:i]];
            [request setFile:imgPath forKey:[NSString stringWithFormat:@"ATTfileList%d",i]];
            D("imgegpaht-===%@",imgPath);
        }
    }
    
    [request addPostValue:@(count) forKey:@"unitclassgenCount"];
    
    if (msgid.length>0) {
        [request addPostValue:msgid forKey:@"tomsgid"];
    }
    request.tag = 17;//设置请求tag
    self.flag_request = 0;
    [request setDelegate:self];
    [request startAsynchronous];
}

//发表下发通知,内容                                是否发生短信      单位加密ID                  接收班级总人数         是否短信直通车     单位人员数组,家长，学生
-(void)creatCommMsgWith:(NSString *)content SMSFlag:(int)sms unitid:(NSString *)unit classCount:(int)count grsms:(int)grsms arrMem:(NSMutableArray *)memArr arrGen:(NSMutableArray *)genArr forwardMsgID:(NSString *)msgid{
    NSString *urlString = [NSString stringWithFormat:@"%@CommMsg/CreateCommMsg",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:content forKey:@"talkcontent"];
    if (sms == 1) {
        [request addPostValue:@"0" forKey:@"SMSFlag"];//false
    } else {
        [request addPostValue:@"1" forKey:@"SMSFlag"];
    }
    [request addPostValue:unit forKey:@"curunitid"];
    
    [request addPostValue:@"false" forKey:@"grsms"];
    [request addPostValue:@(count) forKey:@"unitclassgenCount"];
    for (int i=0; i<memArr.count; i++) {
//        NSString *str = [memArr objectAtIndex:i];
//        [request addPostValue:str forKey:@"selitadmintomem"];
        NSMutableDictionary *dic = [memArr objectAtIndex:i];
        D("[dic objectForKey:-===%@,%@",[dic objectForKey:@"selit"],[dic objectForKey:@"flag"]);
        [request addPostValue:[dic objectForKey:@"selit"] forKey:[dic objectForKey:@"flag"]];
    }
    for (int i=0; i<genArr.count; i++) {
//        NSString *str = [genArr objectAtIndex:i];
//        [request addPostValue:str forKey:@"selitadmintogen"];
        NSMutableDictionary *dic = [genArr objectAtIndex:i];
        [request addPostValue:[dic objectForKey:@"selit"] forKey:[dic objectForKey:@"flag"]];
    }
    if (msgid.length>0) {
        [request addPostValue:msgid forKey:@"tomsgid"];
    }
    request.tag = 17;//设置请求tag
    self.flag_request = 0;
    [request setDelegate:self];
    [request startAsynchronous];
}

//发表短信直通车,内容                                是否发生短信      单位加密ID                  接收班级总人数         是否短信直通车     单位人员数组,家长，学生
-(void)creatCommMsgWith:(NSString *)content SMSFlag:(int)sms unitid:(NSString *)unit classCount:(int)count grsms:(int)grsms arrMem:(NSMutableArray *)memArr arrGen:(NSMutableArray *)genArr arrStu:(NSMutableArray *)stuArr access:(NSMutableArray *)arrayAccess{
    NSString *urlString = [NSString stringWithFormat:@"%@CommMsg/CreateCommMsg",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:content forKey:@"talkcontent"];
    if (sms == 1) {
        [request addPostValue:@"0" forKey:@"SMSFlag"];//false
    } else {
        [request addPostValue:@"1" forKey:@"SMSFlag"];
    }
    [request addPostValue:unit forKey:@"curunitid"];
    
    [request addPostValue:@"true" forKey:@"grsms"];
//    [request addPostValue:@(count) forKey:@"unitclassgenCount"];
    for (int i=0; i<memArr.count; i++) {
        NSString *str = [memArr objectAtIndex:i];
        [request addPostValue:str forKey:@"MemUnit"];
    }
    for (int i=0; i<genArr.count; i++) {
        NSString *str = [genArr objectAtIndex:i];
        NSLog(@"str999999 = %@",str);
        [request addPostValue:str forKey:@"GenUnit"];
    }
    for (int i=0; i<stuArr.count; i++) {
        NSString *str = [stuArr objectAtIndex:i];
        [request addPostValue:str forKey:@"StuUnit"];
    }
    //判断是否有附件
    if (arrayAccess.count>0) {
        //文件名
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *tempPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"file-%@",[dm getInstance].jiaoBaoHao]];
        for (int i=0; i<arrayAccess.count; i++) {
            NSString *imgPath=[tempPath stringByAppendingPathComponent:[arrayAccess objectAtIndex:i]];
            [request setFile:imgPath forKey:[NSString stringWithFormat:@"ATTfileList%d",i]];
            D("imgegpaht-===%@",imgPath);
        }
    }
    request.tag = 17;//设置请求tag
    self.flag_request = 0;
    [request setDelegate:self];
    [request startAsynchronous];
}

//获取事务信息接收单位列表
-(void)login_CommMsgRevicerUnitList{
    NSString *urlString = [NSString stringWithFormat:@"%@CommMsg/CommMsgRevicerUnitList",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    request.tag = 20;//设置请求tag
    self.flag_request = 0;
    [request setDelegate:self];
    [request startAsynchronous];
}

//获取单位接收人
-(void)login_GetUnitRevicer:(NSString *)unitID Flag:(NSString *)flag{
    NSString *urlString = [NSString stringWithFormat:@"%@CommMsg/GetUnitRevicer",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:unitID forKey:@"unitId"];
    [request addPostValue:flag forKey:@"flag"];
    request.tag = 21;//设置请求tag
    if ([unitID intValue]>0) {
        request.userInfo = [NSDictionary dictionaryWithObject:unitID forKey:@"unitID"];
    }
    self.flag_request = 0;
    [request setDelegate:self];
    [request startAsynchronous];
}

//获取班级接收人
-(void)login_GetUnitClassRevicer:(NSString *)classID Flag:(NSString *)flag{
    NSString *urlString = [NSString stringWithFormat:@"%@CommMsg/GetUnitClassRevicer",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:classID forKey:@"unitclassId"];
    [request addPostValue:flag forKey:@"flag"];
    if ([classID intValue]>0) {
        request.userInfo = [NSDictionary dictionaryWithObject:classID forKey:@"unitID"];
    }
    request.tag = 22;//设置请求tag
    self.flag_request = 0;
    [request setDelegate:self];
    [request startAsynchronous];
}
//-(void)getUnitClassRevicer:(NSString *)classID Flag:(NSString *)flag
//{
//    NSString *urlString = [NSString stringWithFormat:@"%@CommMsg/GetUnitClassRevicer",MAINURL];
//    NSURL *url = [NSURL URLWithString:urlString];
//    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
//    request.timeOutSeconds = TIMEOUT;
//    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
//    [request addRequestHeader:@"charset" value:@"UTF8"];
//    [request setRequestMethod:@"POST"];
//    [request addPostValue:classID forKey:@"unitclassId"];
//    [request addPostValue:flag forKey:@"flag"];
//    if ([classID intValue]>0) {
//        request.userInfo = [NSDictionary dictionaryWithObject:classID forKey:@"unitID"];
//    }
//    request.tag = 1000;//设置请求tag
//    self.flag_request = 0;
//    [request setDelegate:self];
//    [request startAsynchronous];
//    
//}


//获取群发权限
-(void)login_GetMsgAllReviceUnitList{
    NSString *urlString = [NSString stringWithFormat:@"%@CommMsg/GetMsgAllReviceUnitList",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    request.tag = 23;//设置请求tag
    self.flag_request = 0;
    [request setDelegate:self];
    [request startAsynchronous];
}

//获取群发下属单位接收对象
-(void)login_GetMsgAllRevicer_toSubUnit{
    NSString *urlString = [NSString stringWithFormat:@"%@CommMsg/GetMsgAllRevicer_toSubUnit",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    request.tag = 24;//设置请求tag
    self.flag_request = 0;
    [request setDelegate:self];
    [request startAsynchronous];
}

//获取群发家长的接收对象
-(void)login_GetMsgAllRevicer_toSchoolGen{
    NSString *urlString = [NSString stringWithFormat:@"%@CommMsg/GetMsgAllRevicer_toSchoolGen",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    request.tag = 25;//设置请求tag
    self.flag_request = 0;
    [request setDelegate:self];
    [request startAsynchronous];
}

//检查版本更新
-(void)login_itunesUpdataCheck{
    NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/lookup?id=958950234"];
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = 150;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"GET"];
    request.tag = 26;//设置请求tag
    self.flag_request = 0;
    [request setDelegate:self];
    [request startAsynchronous];
}

//获取我发送的消息列表，new        返回数量            第几页                 检索条件                    开始日期                    结束日期
-(void)login_GetMySendMsgList:(NSString *)num Page:(NSString *)page SendName:(NSString *)sendName sDate:(NSString *)sDate eDate:(NSString *)eDate{
    NSString *urlString = [NSString stringWithFormat:@"%@CommMsg/GetMySendMsgList",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:num forKey:@"numPerPage"];
    [request addPostValue:page forKey:@"pageNum"];
    request.tag = 27;//设置请求tag
    self.flag_request = 0;
    [request setDelegate:self];
    [request startAsynchronous];
}

//取发给我消息的用户列表，new        返回数量            第几页                 检索条件                    开始日期                    结束日期           阅读标志检索：不提供该参数：查全部，1：未读，2：已读未回复，3：已回复    分页标志值
-(void)login_SendToMeUserList:(NSString *)num Page:(NSString *)page SendName:(NSString *)sendName sDate:(NSString *)sDate eDate:(NSString *)eDate readFlag:(NSString *)readFlag lastId:(NSString *)lastId{
    NSString *urlString = [NSString stringWithFormat:@"%@CommMsg/SendToMeUserList",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:num forKey:@"numPerPage"];
    [request addPostValue:page forKey:@"pageNum"];
    if (lastId.length>0) {
        [request addPostValue:lastId forKey:@"lastId"];
    }
    request.userInfo = [NSDictionary dictionaryWithObject:readFlag forKey:@"readFlag"];
    request.tag = 28;//设置请求tag
    self.flag_request = 0;
    [request setDelegate:self];
    [request startAsynchronous];
}

//取单个用户发给我消息列表 new       返回数量            第几页                 发送者教宝号                    开始日期                    结束日期           阅读标志检索：不提供该参数：查全部，1：未读，2：已读未回复，3：已回复    分页标志值
-(void)login_SendToMeMsgList:(NSString *)num Page:(NSString *)page senderAccId:(NSString *)accid sDate:(NSString *)sDate eDate:(NSString *)eDate readFlag:(NSString *)readFlag lastId:(NSString *)lastId{
    NSString *urlString = [NSString stringWithFormat:@"%@CommMsg/SendToMeMsgList",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:num forKey:@"numPerPage"];
    [request addPostValue:page forKey:@"pageNum"];
    [request addPostValue:accid forKey:@"senderAccId"];
    if (lastId.length>0) {
        [request addPostValue:lastId forKey:@"lastId"];
    }
    request.tag = 29;//设置请求tag
    self.flag_request = 0;
    [request setDelegate:self];
    [request startAsynchronous];
}

//获取老师的关联班级
-(void)login_GetmyUserClass:(NSString *)uid Accid:(NSString *)accid{
    NSString *urlString = [NSString stringWithFormat:@"%@Account/getmyUserClass",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:uid forKey:@"UID"];
    [request addPostValue:accid forKey:@"AccID"];
    request.tag = 30;//设置请求tag
    self.flag_request = 0;
    [request setDelegate:self];
    [request startAsynchronous];
}
-(void)GetCommPerm
{
    NSString *urlString = [NSString stringWithFormat:@"%@CommMsg/GetCommPerm",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    request.tag = 31;//设置请求tag
    self.flag_request = 0;
    [request setDelegate:self];
    [request startAsynchronous];
}

//请求成功
- (void)requestFinished:(ASIHTTPRequest *)_request{
    NSData *responseData = [_request responseData];
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
    NSString* dataString = [[NSString alloc] initWithData:responseData encoding:encoding];
    D("dataString--tag=%ld--flag=%d-  %@",(long)_request.tag,flag_request,dataString);
    SBJsonParser * parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDic = [parser objectWithString:dataString];
    //先对返回值做判断，是否连接超时
    NSString *code = [jsonDic objectForKey:@"ResultCode"];
    if ([code intValue] == 8) {
        [[LoginSendHttp getInstance] hands_login];
        return;
    }
    if (flag_request == 1) {//注册获取到时间回调
        //记录注册时，向服务器请求的时间，与flag_request做对比
        self.mStr_Register = [jsonDic objectForKey:@"Data"];
        //客户端开始注册接口
        [self reg:self.mStr_Register];
    }else if (flag_request == 2){//注册回调
        NSString *time = [jsonDic objectForKey:@"Data"];
        NSString *ClientKey = [dm getInstance].uuid;
        NSString *str000 = [DESTool decryptWithText:time Key:ClientKey];
        if ([self.mStr_Register isEqual:str000]) {
            [[NSUserDefaults standardUserDefaults] setValue:ClientKey forKey:@"ClientKey"];
            D("注册成功");
        }
        D("str-==  %@",str000);
    }else if (flag_request == 3){//握手回调
        NSString *time = [jsonDic objectForKey:@"Data"];
        NSString *str000 = [DESTool decryptWithText:time Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        if ([str000 isEqual:self.mStr_hands]) {
            D("握手成功");
            //登录获取时间
            if([dm getInstance].RegisterSymbol == NO)
               {
                   [self getTime:@"1"];
               }
            else
            {
//                [[RegisterHttp getInstance]registerHttpSendCheckCode:[dm getInstance].tel Code:[dm getInstance].urlNum];
            }
        }
    }else if (flag_request == 4){//登录获取时间回调
        NSString *time = [jsonDic objectForKey:@"Data"];
        NSString *flag = [_request.userInfo objectForKey:@"flag"];
        if ([flag intValue]==1) {
            //发送登录请求
            [self login:time];
        }else{
            //发送注册请求
            [[NSNotificationCenter defaultCenter] postNotificationName:@"registerGetTime" object:time];
        }
    }else if (flag_request == 5){//发送登录请求回调
        NSString *str = [jsonDic objectForKey:@"ResultDesc"];
        if ([str isEqual:@"成功!"]) {
            NSString *time = [jsonDic objectForKey:@"Data"];
            D("flag_request==5 == %@",time);
            NSString *str000 = [DESTool decryptWithText:time Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
            //通知登录界面，是否记住密码
            [self.delegate LoginSendHttpMember:@"1"];
            D("str-=flag_request5== %@",str000);
            NSDictionary *dic = [str000 objectFromJSONString];
            [dm getInstance].jiaoBaoHao = [dic objectForKey:@"JiaoBaoHao"];
            NSString *name = [dic objectForKey:@"Nickname"];
            if ([name isKindOfClass:[NSNull class]]||[name isEqual:@"null"]) {
                [dm getInstance].NickName = [dic objectForKey:@"TrueName"];
            }else{
                [dm getInstance].NickName = [dic objectForKey:@"Nickname"];
            }
            [dm getInstance].TrueName = [dic objectForKey:@"TrueName"];
            //请求融云用户token
//            if (SHOWRONGYUN == 1) {
//                [[ExchangeHttp getInstance] exchangeHttpRongYunGetToken:[dm getInstance].jiaoBaoHao TrueName:[dm getInstance].TrueName];
//            }
            //跳转到主界面
            if (self.flag_skip == 1) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"registeredSuccessfully" object:nil];//切换界面
            }
            //获取系统应用URL
            [self getSRVUrl];
            //通知界面，是否登录成功
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:@"登录成功"];
        } else {
            D("失败---- %@",str);
            //通知登录界面，是否记住密码
            [self.delegate LoginSendHttpMember:@"2"];
            //通知界面，是否登录成功
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:str];
        }
    }else if (flag_request == 6){//获取系统应用URL的回调
        NSString *time = [jsonDic objectForKey:@"Data"];
        D("flag_request==6 == %@",time);
        NSString *str000 = [DESTool decryptWithText:time Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        D("str-=flag_request6== %@",str000);
        NSArray *arrlist=[str000 objectFromJSONString];
        D("%lu",(unsigned long)[arrlist count]);
        for (int i=0; i<[arrlist count]; i++) {
            NSDictionary *item=[arrlist objectAtIndex:i];
            NSString *url=[item objectForKey:@"Value"];
            D("url-==  %@",url);
            [dm getInstance].url = url;
            //请求Token
            [self getToken];
        }
    }else if (flag_request == 7){//获取Token回调
        NSString *time = [jsonDic objectForKey:@"Data"];
        D("flag_request==7 == %@",time);
        NSString *str000 = [DESTool decryptWithText:time Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        D("str-=flag_request7== %@",str000);
        //验证Token
        [self validateToken:str000];
    }else if (flag_request == 8){//验证Token回调
        int ResultCode = [[jsonDic objectForKey:@"ResultCode"] intValue];
        D("ResultCode-== %d",ResultCode);
        if (ResultCode == 0) {
            //获取自己的身份信息
            [self getIdentityInformation];
            //获取未读消息数量
            self.flag_unReadMsg = 0;
            [self getUnreadMessages1];
            //获取未读回复数量
            [self getUnreadMessages2];
        }else{
            D("验证Token失败");
            NSString *token = [_request.userInfo objectForKey:@"token"];
            //验证Token
            [self validateToken:token];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:@"验证失败，重新验证中"];
        }
    }
    if (_request.tag == 2) {//获取自己的身份信息
        NSString *time = [jsonDic objectForKey:@"Data"];
        NSString *str000 = [DESTool decryptWithText:time Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        D("tag-=login== 2=== %@",str000);
        //解析成model数组
        NSMutableArray *array = [ParserJson parserJsonwith:str000];
        //将得到的个人信息，通知界面
        [dm getInstance].identity = array;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"getIdentity" object:array];
    }else if (_request.tag == 3){//未读消息数量
        NSString *time = [jsonDic objectForKey:@"Data"];
        NSString *str000 = [DESTool decryptWithText:time Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        D("tag-=== 3=== %@",str000);
        [dm getInstance].unReadMsg1 = str000;
        ++self.flag_unReadMsg;
//        if (self.flag_unReadMsg == 2) {
            //通知界面更新未读消息数量
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UnReadMsg" object:nil];
//        }
    }else if (_request.tag == 4){//未读回复数量
        NSString *time = [jsonDic objectForKey:@"Data"];
        NSString *str000 = [DESTool decryptWithText:time Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        D("tag-=== 4=== %@",str000);
        [dm getInstance].unReadMsg2 = str000;
        ++self.flag_unReadMsg;
        if (self.flag_unReadMsg == 2) {
            //通知界面更新未读消息数量
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UnReadMsg" object:nil];
        }
    }else if (_request.tag == 5){//发给我的待处理信息
        NSString *time = [jsonDic objectForKey:@"Data"];
        NSString *str000 = [DESTool decryptWithText:time Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        D("tag-=== 5=== %@",str000);
        //解析成model数组
        NSMutableArray *array = [ParserJson parserJsonUnReadMsgWith:str000];
        D("array.count-===== %lu",(unsigned long)array.count);
        //获取头像
//        [self getFaceImg:array];
        //通知界面刷新待处理未读消息
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSString *tag =  [_request.userInfo objectForKey:@"tag"];
        if ([tag intValue] == 0) {
            [dic setValue:@"0" forKey:@"tag"];
        }else{
            [dic setValue:@"6" forKey:@"tag"];
        }
        [dic setValue:array forKey:@"array"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UnReadMsgCell" object:dic];
        //通知界面更新未读消息数量
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"UnReadMsg" object:nil];
    }else if (_request.tag == 6){//已处理未回复的
        NSString *time = [jsonDic objectForKey:@"Data"];
        NSString *str000 = [DESTool decryptWithText:time Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        D("tag-=== 6=== %@",str000);
        //解析成model数组
        NSMutableArray *array = [ParserJson parserJsonUnReadMsgWith:str000];
        //获取头像
//        [self getFaceImg:array];
        //通知界面刷新已处理未回复消息
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"8" forKey:@"tag"];
        [dic setValue:array forKey:@"array"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UnReadMsgCell" object:dic];
    }else if (_request.tag == 7){//已处理已回复的
        NSString *time = [jsonDic objectForKey:@"Data"];
        NSString *str000 = [DESTool decryptWithText:time Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        D("tag-=== 7=== %@",str000);
        //解析成model数组
        NSMutableArray *array = [ParserJson parserJsonUnReadMsgWith:str000];
        //获取头像
//        [self getFaceImg:array];
        //通知界面刷新已处理已回复消息
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"9" forKey:@"tag"];
        [dic setValue:array forKey:@"array"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UnReadMsgCell" object:dic];
    }else if (_request.tag == 8){//获取自己发出的信息
        NSString *time = [jsonDic objectForKey:@"Data"];
        NSString *str000 = [DESTool decryptWithText:time Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        D("str000=--8-=== %@",str000);
        //解析成model数组
        NSMutableArray *array = [ParserJson parserJsonUnReadMsgWith:str000];
        D("array.count-= %lu",(unsigned long)array.count);
        //获取头像
//        [self getFaceImg:array];
        //通知界面刷新已处理已回复消息
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"2" forKey:@"tag"];
        [dic setValue:array forKey:@"array"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UnReadMsgCell" object:dic];
    }else if (_request.tag == 9){//转发上级通知
        NSString *time = [jsonDic objectForKey:@"Data"];
        NSString *str000 = [DESTool decryptWithText:time Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        if (time.length==0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:[jsonDic objectForKey:@"ResultDesc"]];
        }
        
        //解析成model数组
        NSMutableArray *array = [ParserJson parserJsonUnReadMsgWith:str000];
        //获取头像
//        [self getFaceImg:array];
        //通知界面刷新已处理已回复消息
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"4" forKey:@"tag"];
        [dic setValue:array forKey:@"array"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UnReadMsgCell" object:dic];
    }else if (_request.tag == 10){//获取头像
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
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UnReadMsgCellImg" object:nil];
            }
        }else {//存在
            D(" have");
            BOOL blDele= [fileManager removeItemAtPath:imgPath error:nil];//先删除
            if (blDele) {//删除成功后，写入，通知界面
                BOOL yesNo = [responseData writeToFile:imgPath atomically:YES];
                if (yesNo) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UnReadMsgCellImg" object:nil];
                }
            }
        }
    }else if (_request.tag == 11){//回复我的
        NSString *time = [jsonDic objectForKey:@"Data"];
        NSString *str000 = [DESTool decryptWithText:time Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        D("tag-=== 11=== %@",str000);
        //解析成model数组
        NSMutableArray *array = [ParserJson parserJsonUnReadMsgWith:str000];
        //获取头像
//        [self getFaceImg:array];
        //通知界面刷新回复我的信息
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"7" forKey:@"tag"];
        [dic setValue:array forKey:@"array"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UnReadMsgCell" object:dic];
        //通知界面更新未读消息数量
        [dm getInstance].unReadMsg2 = [NSString stringWithFormat:@"%lu",(unsigned long)array.count];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UnReadMsg" object:nil];
    }else if (_request.tag == 12){//显示交流信息明细
//        NSString *time = [jsonDic objectForKey:@"Data"];
//        NSString *str000 = [DESTool decryptWithText:time Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        NSString *str000 = [jsonDic objectForKey:@"Data"];
        D("tag-=== 12=== %@",str000);
        //解析成model数组
        UnReadMsg_model *model = [ParserJson parserJsonMsgDetailWithUnReadMsg:str000];
        NSMutableArray *array= [ParserJson parserJsonMsgDetailWithFeeBackList:str000];
        D("arrary-== %lu",(unsigned long)array.count);
        //通知界面刷新信息详情
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:model forKey:@"model"];
        [dic setValue:array forKey:@"array"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MsgDetail" object:dic];
    }else if (_request.tag == 13){//回复交流信息
        NSString *time = [jsonDic objectForKey:@"ResultDesc"];
        //通知信息详情界面回复是否成功
        if ([time isEqual:@"成功!"]) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:@"发送成功" forKey:@"msg"];
            [dic setValue:@"1" forKey:@"flag"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"addFeeBack" object:dic];
        } else {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:@"发送失败" forKey:@"msg"];
            [dic setValue:@"2" forKey:@"flag"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"addFeeBack" object:dic];
        }
    }else if (_request.tag == 14){//在信息详情页，点击下载文件
        //获取的用户自定义内容
        NSString *fileName = [_request.userInfo objectForKey:@"fileName"];
        fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@""];
        D("tag.14-=== %@",responseData);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        //文件名
        NSFileManager* fileManager=[NSFileManager defaultManager];
        
        NSString *tempPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"file-%@",[dm getInstance].jiaoBaoHao]];
        //判断文件夹是否存在
        if(![fileManager fileExistsAtPath:tempPath]) {//如果不存在
            [fileManager createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        D("filename-===%@",fileName);
        NSString *imgPath=[tempPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
        D("imgPath-2222== %@",imgPath);
        BOOL yesNo=[[NSFileManager defaultManager] fileExistsAtPath:imgPath];
        if (!yesNo) {//不存在，则直接写入后通知界面刷新
            [responseData writeToFile:imgPath atomically:YES];
        }else {//存在
            BOOL blDele= [fileManager removeItemAtPath:imgPath error:nil];//先删除
            if (blDele) {//删除成功后，写入，通知界面
                [responseData writeToFile:imgPath atomically:YES];
            }
        }
    }else if (_request.tag == 15){//获取接收人列表或单位列表，普通请求
        NSString *time = [jsonDic objectForKey:@"Data"];
        NSString *str000 = [DESTool decryptWithText:time Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        D("tag-=== 15=== %@",str000);
        CMRevicerModel *model = [ParserJson parserJsonCMRevicerWith:str000];
        D("model-==== %@",model);
        //向转发界面传递得到的人员单位列表
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CMRevicer" object:model];
    }else if (_request.tag == 16){//切换身份
        NSString *time = [jsonDic objectForKey:@"ResultCode"];
        if ([time intValue] == 0) {
             D("tag-=== 16=== 切换身份成功");
            //发送获取接收人列表请求

            if (self.mInt_forwardFlag == 1) {//普通请求
                [[LoginSendHttp getInstance] login_CommMsgRevicerUnitList];
            }else if (self.mInt_forwardFlag ==2){//获取个人信息
                [[LoginSendHttp getInstance] getUserInfoWith:[dm getInstance].jiaoBaoHao UID:[NSString stringWithFormat:@"%d",[dm getInstance].UID]];
            }else{//短信直通车
                [self ReceiveListWithFlag:self.mInt_forwardFlag all:self.mInt_forwardAll];
            }
            
            //通知内务界面，切换成功
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCurUnit" object:nil];
        }
    }else if (_request.tag == 17){//发表交流信息,内容
        NSString *time = [jsonDic objectForKey:@"ResultCode"];
        if ([time intValue] == 0) {
            D("tag-=== 17=== 成功");
            //发表消息成功推送
            [[NSNotificationCenter defaultCenter] postNotificationName:@"creatCommMsg" object:[jsonDic objectForKey:@"ResultDesc"]];
        }else{
            NSString *time = [jsonDic objectForKey:@"ResultDesc"];
            //发表消息失败推送
            [[NSNotificationCenter defaultCenter] postNotificationName:@"creatCommMsg" object:time];
        }
    }else if (_request.tag == 18){//获取接收人列表或单位列表，普通请求
        NSString *time = [jsonDic objectForKey:@"Data"];
        NSString *str000 = [DESTool decryptWithText:time Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        D("tag-=== 18=== %@",str000);
        NSMutableArray *array = [NSMutableArray array];
        for (int i=0; i<3; i++) {
            SMSTreeArrayModel *model = [[SMSTreeArrayModel alloc] init];
            if (i == 0) {
                model.name = @"单位人员(老师)";
            }else if (i == 1){
                model.name = @"家长";
            }else if (i == 2){
                model.name = @"学生";
            }
            model.smsTree = [NSMutableArray arrayWithArray:[ParserJson parserJsonSMSUnitWith:str000]];
            [array addObject:model];
        }
        //向转发界面传递得到的人员单位列表
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CMRevicer" object:array];
    }else if (_request.tag == 19){//获取个人信息
        NSString *time = [jsonDic objectForKey:@"Data"];
        NSString *str000 = [DESTool decryptWithText:time Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        D("tag-=== 19=== %@",str000);
        UserInfoModel *model = [ParserJson parserJsonUserInfoWith:str000];
        [dm getInstance].userInfo = model;
        //判断当前单位显示
        if ([[dm getInstance].mStr_unit isKindOfClass:[NSNull class]]||[[dm getInstance].mStr_unit isEqual:@"null"]||[[dm getInstance].mStr_unit isEqual:@"nil"]||[dm getInstance].mStr_unit == Nil||[dm getInstance].mStr_unit.length==0) {
            for (Identity_model *model in [dm getInstance].identity) {
                if ([model.RoleIdentity intValue] == 3||[model.RoleIdentity intValue]==4) {
                    if (model.UserClasses.count>0) {
                        Identity_UserClasses_model *temp = [model.UserClasses objectAtIndex:0];
                        [dm getInstance].mStr_unit = temp.ClassName;
                        [dm getInstance].uType = [model.RoleIdentity intValue];
                        [dm getInstance].UID = [temp.SchoolID intValue];
                        break;
                    }
                }
            }
        }
        NSString *name;
        if ([str000 isKindOfClass:[NSNull class]]||[str000 isEqual:@"null"]) {
            [dm getInstance].name = [dm getInstance].TrueName;
            name = [NSString stringWithFormat:@"%@:%@",[dm getInstance].mStr_unit,[dm getInstance].name];
        }else{
            [dm getInstance].name = model.UserName;
            name = [NSString stringWithFormat:@"%@:%@",[dm getInstance].mStr_unit,model.UserName];
        }
        CGSize newSize = [name sizeWithFont:[UIFont systemFontOfSize:16]];
        [Nav_internetAppView getInstance].mLab_name.text = name;
        [Nav_internetAppView getInstance].mScrollV_name.contentSize = CGSizeMake(newSize.width, 49);
        
        //通知internetApp界面，获取成功
        [[NSNotificationCenter defaultCenter] postNotificationName:@"internetAppGetUserInfo" object:nil];
    }else if (_request.tag == 20){//获取事务信息接收单位列表
        NSDictionary *dic = [dataString objectFromJSONString];
        NSString *str = [dic objectForKey:@"Data"];
        D("str00=login==20=>>>>==%@",str);     
        CommMsgRevicerUnitListModel *model = [ParserJson parserJsonCommMsgRevicerUnitList:str];
//        id data2 = [str objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
//        UnitListJsonModel* model = [[UnitListJsonModel alloc] initWithString:str error:nil];
        //通知界面更新，获取事务信息接收单位列表
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CommMsgRevicerUnitList" object:model];
    }else if (_request.tag == 21){//获取单位接收人
        NSDictionary *dic = [dataString objectFromJSONString];
        NSString *str = [dic objectForKey:@"Data"];
        D("str00=login==21=>>>>==%@",str);
        NSString *unitID = [_request.userInfo objectForKey:@"unitID"];
        NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
        [dic2 setValue:unitID forKey:@"unitID"];
        NSMutableArray *array = [ParserJson parserUserList_json:str];
        [dic2 setValue:array forKey:@"array"];
//        id data2 = [str objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
//        D("data2-====%@",data2);
//        CommMsgRevicerUnitListModel *model = [ParserJson parserJsonCommMsgRevicerUnitList:str];
        //通知界面更新，获取事务信息接收单位列表
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetUnitRevicer" object:dic2];
    }else if (_request.tag == 22){//获取班级接收人
        NSDictionary *dic = [dataString objectFromJSONString];
        NSString *str = [dic objectForKey:@"Data"];
        D("str00=login==22=>>>>==%@",str);
        NSString *unitID = [_request.userInfo objectForKey:@"unitID"];
        NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
        [dic2 setValue:unitID forKey:@"unitID"];
        NSMutableArray *array = [ParserJson parserUserListClass_json:str];
        NSLog(@"rselut = %@",array);
        [dic2 setValue:array forKey:@"array"];
//        CommMsgRevicerUnitListModel *model = [ParserJson parserJsonCommMsgRevicerUnitList:str];
//        //通知界面更新，获取事务信息接收单位列表
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetUnitRevicer" object:dic2];
    }
    //else if (_request.tag == 1000){//获取班级接收人
//        NSData *responseData = [_request responseData];
//        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
//        NSString* dataString = [[NSString alloc] initWithData:responseData encoding:encoding];
//        NSLog(@"UpLoadResult1111111 = %@",dataString);
//        NSDictionary *dic = [dataString objectFromJSONString];
//        NSDictionary *dic2 = [dic objectForKey:@"Data"];
//        NSString *genselit = [dic2 objectForKey:@"genselit"];
//        NSArray *selitArr = [genselit objectFromJSONString];
//        NSLog(@"selitArr = %@",selitArr);
//
//
//        
//        //NSArray *dataList = [dicList  objectForKey:@"Data"];
////        D("str00=login==22=>>>>==%@",str);
////        NSString *unitID = [_request.userInfo objectForKey:@"unitID"];
////        NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
////        [dic2 setValue:unitID forKey:@"unitID"];
////        NSMutableArray *array = [ParserJson parserUserListClass_json:str];
////        [dic2 setValue:array forKey:@"array"];
////        //        CommMsgRevicerUnitListModel *model = [ParserJson parserJsonCommMsgRevicerUnitList:str];
////        //        //通知界面更新，获取事务信息接收单位列表
//        //[[NSNotificationCenter defaultCenter] postNotificationName:@"GetUnitRevicer" object:dic2];
//    }
    else if (_request.tag == 23){//获取群发权限
        NSDictionary *dic = [dataString objectFromJSONString];
        NSString *str = [dic objectForKey:@"Data"];
        D("str00=login==23=>>>>==%@",str);
        NSDictionary *dic2 = [str objectFromJSONString];
        NSMutableArray *array = [NSMutableArray array];
        CommMsgUnitNotice *notice0 = [[CommMsgUnitNotice alloc] init];
        notice0.msgAll = [NSString stringWithFormat:@"%@",[dic2 objectForKey:@"MsgAll_ToSubUnitMem"]];
        [array addObject:notice0];
        CommMsgUnitNotice *notice1 = [[CommMsgUnitNotice alloc] init];
        notice1.msgAll = [NSString stringWithFormat:@"%@",[dic2 objectForKey:@"MsgAll_ToGen"]];
        [array addObject:notice1];
        if ([[dic2 objectForKey:@"MsgAll_ToSubUnitMem"] intValue] ==1) {
            [self login_GetMsgAllRevicer_toSubUnit];
        }
        if ([[dic2 objectForKey:@"MsgAll_ToGen"] intValue] ==1) {
            [self login_GetMsgAllRevicer_toSchoolGen];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetMsgAllReviceUnitList" object:array];
    }else if (_request.tag == 24){//获取群发下属单位接收对象
        NSDictionary *dic = [dataString objectFromJSONString];
        NSString *str = [dic objectForKey:@"Data"];
        D("str00=login==24=>>>>==%@",str);
        NSDictionary *tempDic = [str objectFromJSONString];
        NSMutableArray *arrlist = [tempDic objectForKey:@"selitadmintomem"];
        NSMutableArray *array = [ParserJson parserSelitadmintomem:arrlist Flag:@"selitadmintomem"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetMsgAllRevicer_toSubUnit" object:array];
    }else if (_request.tag == 25){//获取事务信息接收单位列表
        NSDictionary *dic = [dataString objectFromJSONString];
        NSString *str = [dic objectForKey:@"Data"];
        D("str00=login==25=>>>>==%@",str);
        NSDictionary *tempDic = [str objectFromJSONString];
        NSMutableArray *arrlist = [NSMutableArray array];
        NSMutableArray *array = [NSMutableArray array];
        
        NSString *selitadmintostu = [tempDic objectForKey:@"selitunitclassadmintogen"];
        if ([selitadmintostu isEqual:[NSNull null]]) {
            
        }else{
            arrlist = [tempDic objectForKey:@"selitunitclassadmintogen"];
            array = [ParserJson parserSelitadmintomem:arrlist Flag:@"selitunitclassadmintogen"];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetMsgAllRevicer_toSchoolGe" object:array];
    }else if (_request.tag == 26){//检查版本更新
        NSString *version = @"";
        int versionNumber = 0;
        int versionNumber2 = 0;
        NSString* jsonResponseString = [_request responseString];
        SBJsonParser * parser = [[SBJsonParser alloc] init];
        NSMutableDictionary *jsonDic = [parser objectWithString:jsonResponseString];
        NSArray *configData = [jsonDic valueForKey:@"results"];
        for (id config in configData)
        {
            version = [config valueForKey:@"version"];
        }
        D("version = %@",version);
        if ([version isEqual:@""]) {
            
        }else{
            NSArray *array = [version componentsSeparatedByString:@"."];
            for (int i=0; i<[array count]; i++) {
                versionNumber = [[NSString stringWithFormat:@"%@%@%@",[array objectAtIndex:0],[array objectAtIndex:1],[array objectAtIndex:2]]intValue];
            }
            D("versionNumber = %d",versionNumber);
            NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
            NSString* versionNum =[infoDict objectForKey:@"CFBundleVersion"];
            NSArray *array2 = [versionNum componentsSeparatedByString:@"."];
            for (int i=0; i<[array2 count]; i++) {
                versionNumber2 = [[NSString stringWithFormat:@"%@%@%@",[array2 objectAtIndex:0],[array2 objectAtIndex:1],[array2 objectAtIndex:2]]intValue];
            }
            D("versionNumber2-===%d,%d",versionNumber,versionNumber2);
            if (versionNumber>versionNumber2)
            {
                //通知界面，有更新
                [[NSNotificationCenter defaultCenter] postNotificationName:@"itunesUpdataCheck" object:nil];
            }else{
//                [self.view makeToast:@"您使用的已经是最新版本" duration:2 position:@"bottom"];
            }
        }
    }else if (_request.tag == 27){//获取我发送的消息列表
        if ([[jsonDic objectForKey:@"ResultCode"] intValue]==0) {
            [InternetAppTopScrollView shareInstance].mInt_work_mysend = 1;
            NSString *str = [jsonDic objectForKey:@"Data"];
            D("str00=login==27=>>>>==%@",str);
            NSMutableArray *array = [ParserJson parserJsonGetMySendMsgList:str];
            //传到事务界面显示
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GetMySendMsgList" object:array];
        }
    }else if (_request.tag == 28){//取发给我消息的用户列表，new
        if ([[jsonDic objectForKey:@"ResultCode"] intValue]==0) {
            [InternetAppTopScrollView shareInstance].mInt_work_sendToMe = 1;
            NSString *str = [jsonDic objectForKey:@"Data"];
            NSString *readFlag = [_request.userInfo objectForKey:@"readFlag"];
            D("str00=login==28=>>>>=%@=%@",readFlag,str);
            SendToMeUserListModel *model = [ParserJson parserJsonSendToMeUserList:str];
            NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
            [dic2 setValue:readFlag forKey:@"readFlag"];
            [dic2 setValue:model forKey:@"model"];
            //传到事务界面显示
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SendToMeUserList" object:dic2];
        }
    }else if (_request.tag == 29){//取单个用户发给我消息列表 new
        if ([[jsonDic objectForKey:@"ResultCode"] intValue]==0) {
            NSString *str = [jsonDic objectForKey:@"Data"];
            D("str00=login==29=>>>>==%@",str);
            SendToMeUserListModel *model = [ParserJson parserJsonSendToMeUserList:str];
            //传到事务界面显示
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SendToMeMsgList" object:model];
        }
    }else if (_request.tag == 30){//获取老师的关联班级
        if ([[jsonDic objectForKey:@"ResultCode"] intValue]==0) {
            NSString *str = [jsonDic objectForKey:@"Data"];
            NSString *str000 = [DESTool decryptWithText:str Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
            D("str00=login==30=>>>>==%@",str000);
            NSMutableArray *array = [ParserJson parserJsonGetmyUserClass:str000];
            //传到事务界面显示
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GetmyUserClass" object:array];
        }
    }else if (_request.tag == 31)
    {
        if ([[jsonDic objectForKey:@"ResultCode"] intValue]==0) {
            NSString *str = [jsonDic objectForKey:@"Data"];
            D("str00=login==31=>>>>==%@",str);
            NSArray *dic = [str objectFromJSONString];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"GetCommPerm" object:dic];
        }
        

    }
}

//请求失败
-(void)requestFailed:(ASIHTTPRequest *)request{
    NSData *responseData = [request responseData];
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
    NSString* dataString = [[NSString alloc] initWithData:responseData encoding:encoding];
    D("dataString--login==-tag=%ld,flag=%d----  请求失败--%@",(long)request.tag,flag_request,dataString);
    if (self.flag_request == 8) {
        NSString *token = [request.userInfo objectForKey:@"token"];
        //验证Token
        [self validateToken:token];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:@"验证失败，重新验证中"];
    }
}

@end
