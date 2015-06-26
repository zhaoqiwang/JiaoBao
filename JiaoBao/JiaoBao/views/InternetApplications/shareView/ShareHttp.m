//
//  ShareHttp.m
//  JiaoBao
//
//  Created by Zqw on 14-11-15.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "ShareHttp.h"
#import "InternetAppTopScrollView.h"

static ShareHttp *shareHttp = nil;

@implementation ShareHttp

+(ShareHttp *)getInstance{
    if (shareHttp == nil) {
        shareHttp = [[ShareHttp alloc] init];
    }
    return shareHttp;
}
-(id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

//获取我所在的单位                  new                1共享2展示          账户ID
-(void)shareHttpGetUnitSectionMessagesWith:(NSString *)sectionID AcdID:(NSString *)accID{
    NSString *urlString = [NSString stringWithFormat:@"%@Sections/getUnitSectionMessages",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:sectionID forKey:@"SectionID"];
    [request addPostValue:accID forKey:@"AccID"];
    request.userInfo = [NSDictionary dictionaryWithObject:sectionID forKey:@"sectionID"];
    request.tag = 5;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//获取最新和推荐文章                             1共享2展示                  1最新2推荐              第几页
-(void)shareHttpGetTopArthListIndexWith:(NSString *)sectionFlag TopFlag:(NSString *)topFlag Page:(NSString *)page{
    NSString *urlString = [NSString stringWithFormat:@"%@Sections/TopArthListIndex",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:sectionFlag forKey:@"SectionFlag"];
    [request addPostValue:topFlag forKey:@"TopFlags"];
    [request addPostValue:page forKey:@"pageNum"];
    request.userInfo = [NSDictionary dictionaryWithObject:sectionFlag forKey:@"sectionFlag"];
    request.tag = 3;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//获取头像                                  1普通2内务通知3评论列表
-(void)getFaceImg:(NSMutableArray *)array flag:(int)flag{
    NSMutableArray *tempArr = [NSMutableArray array];
    if (flag == 1) {
        for (int i=0; i<array.count; i++) {
            TopArthListModel *topArthListModel = [array objectAtIndex:i];
            [tempArr addObject:topArthListModel.JiaoBaoHao];
        }
    }else if (flag == 2){
        for (int i=0; i<array.count; i++) {
            NoticeInfoModel *noticeInfoModel = [array objectAtIndex:i];
            [tempArr addObject:noticeInfoModel.JiaoBaoHao];
        }
    }else if (flag == 3){
        for (int i=0; i<array.count; i++) {
            commentsListModel *commentModel = [array objectAtIndex:i];
            [tempArr addObject:commentModel.JiaoBaoHao];
        }
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
        request.tag = 4;//设置请求tag
        [request setDelegate:self];
        [request startAsynchronous];
    }
}

//获取本单位栏目文章                               1共享2展示                单位ID                第几页
-(void)shareHttpGetUnitArthLIstIndexWith:(NSString *)sectionFlag UnitID:(NSString *)unitID Page:(NSString *)page{
    NSString *urlString = [NSString stringWithFormat:@"%@Sections/ArthListIndex",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    if ([sectionFlag isEqual:@"99"]) {//单位主题
        [request addPostValue:@"1" forKey:@"SectionFlag"];
    }else{
        [request addPostValue:sectionFlag forKey:@"SectionFlag"];
    }
    
    [request addPostValue:unitID forKey:@"UnitID"];
    [request addPostValue:page forKey:@"pageNum"];
    request.userInfo = [NSDictionary dictionaryWithObject:sectionFlag forKey:@"sectionFlag"];
    request.tag = 3;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//获取关联的班级                       用户账号                用户单位ID              1共享2展示
-(void)shareHttpGetMyUserClassWith:(NSString *)accID UID:(NSString *)UID Section:(NSString *)flag{
    NSString *urlString = [NSString stringWithFormat:@"%@Account/getmyUserClass",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:accID forKey:@"AccID"];
    [request addPostValue:UID forKey:@"UID"];
    request.userInfo = [NSDictionary dictionaryWithObject:flag forKey:@"flag"];
    request.tag = 1;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//获取所有班级                        用户单位ID              1共享2展示
-(void)shareHttpGetUnitClassWith:(NSString *)UID Section:(NSString *)flag{
    NSString *urlString = [NSString stringWithFormat:@"%@Basic/getSchoolClassInfo",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:UID forKey:@"UID"];
    request.userInfo = [NSDictionary dictionaryWithObject:flag forKey:@"flag"];
    request.tag = 2;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//显示文章详细内容
-(void)shareHttpGetShowArthDetailWith:(NSString *)tableID SectionID:(NSString *)sid{
    NSString *urlString = [NSString stringWithFormat:@"%@Sections/ShowArthDetail",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:tableID forKey:@"aid"];
    [request addPostValue:sid forKey:@"sid"];
    request.tag = 6;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//获取本单位的所有下级单位基础信息
-(void)shareHttpGetMySubUnitInfoWith:(NSString *)UID{
    NSString *urlString = [NSString stringWithFormat:@"%@Basic/getMySubUnitInfo",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:UID forKey:@"UID"];
    request.tag = 7;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}
//上传图片
-(void)shareHttpUploadSectionImgWith:(NSString *)imgPath Name:(NSString *)name{
   // NSData *data = UIImagePNGRepresentation(img);//获取图片数据
//    NSString *urlString = [NSString stringWithFormat:@"%@AppFiles/uploadSectionImg",MAINURL];
    NSString *urlString = [NSString stringWithFormat:@"%@ClientUpLoadFile/uploadSectionImg",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    request.tag = 8;//设置请求tag
    [request setDelegate:self];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//    NSFileManager* fileManager=[NSFileManager defaultManager];
//    
//    NSString *imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",name]];
//    NSLog(@"imgPath = %@",imgPath);
//    BOOL yesNo=[[NSFileManager defaultManager] fileExistsAtPath:imgPath];
//    if (!yesNo) {//不存在，则直接写入后通知界面刷新
//        D("no  have");
//        BOOL yesNo1 = [data writeToFile:imgPath atomically:YES];
//        if (yesNo1) {
            [request setFile:imgPath forKey:@"file"];
            [request startAsynchronous];
//        }
//    }else {//存在
//        D(" have");
//        BOOL blDele= [fileManager removeItemAtPath:imgPath error:nil];//先删除
//        if (blDele) {//删除成功后，写入，通知界面
//            BOOL yesNo = [data writeToFile:imgPath atomically:YES];
//            if (yesNo) {
//                [request setFile:imgPath forKey:@"file"];
//                [request startAsynchronous];
//            }
//        }
//    }
}

//发表文章                                  标题                      内容                  单位类型                单位ID                    来自分享1、展示2
-(void)shareHttpSavePublishArticleWith:(NSString *)title Content:(NSString *)content uType:(NSString *)utype UnitID:(NSString *)unitID SectionFlag:(NSString *)flag{
    NSString *urlString = [NSString stringWithFormat:@"%@Sections/savepublishArticle",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:title forKey:@"Title"];
    [request addPostValue:content forKey:@"Context"];
    [request addPostValue:utype forKey:@"uType"];
    [request addPostValue:unitID forKey:@"UnitID"];
    [request addPostValue:flag forKey:@"SectionFlag"];
    request.userInfo = [NSDictionary dictionaryWithObject:flag forKey:@"SectionFlag"];
    request.tag = 9;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//获取栏目最新和推荐文章的未读数量             _1展示_2共享           1最新2推荐                      账户ID
-(void)shareHttpGetSectionMessageWith:(NSString *)sectionID TopFlags:(NSString *)topFlag AccID:(NSString *)accid{
    NSString *urlString = [NSString stringWithFormat:@"%@Sections/getSectionMessage",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:sectionID forKey:@"SectionID"];
    [request addPostValue:topFlag forKey:@"TopFlags"];
    [request addPostValue:accid forKey:@"AccID"];
//    request.userInfo = [NSDictionary dictionaryWithObject:topFlag forKey:@"topFlag"];
    request.userInfo = [NSDictionary dictionaryWithObject:sectionID forKey:@"sectionID"];
    request.username = topFlag;
    request.tag = 10;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//获得单位通知，内务                     1教育局2学校3班级          单位ID                    第几页
-(void)NoticeHttpGetUnitNoticesWith:(NSString *)uType UnitID:(NSString *)unitID pageNum:(NSString *)pageNum{
    NSString *urlString = [NSString stringWithFormat:@"%@Sections/getUnitNotics",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:uType forKey:@"uType"];
    [request addPostValue:unitID forKey:@"UnitID"];
    [request addPostValue:pageNum forKey:@"pageNum"];
    [request addPostValue:@"20" forKey:@"numPerPage"];
    request.tag = 11;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//获取通知详细内容
-(void)NoticeHttpGetShowNoticeDetailWith:(NSString *)talbeID{
    NSString *urlString = [NSString stringWithFormat:@"%@Sections/ShowNoticDetail",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:talbeID forKey:@"uid"];
    request.tag = 12;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//获取单位头像
-(void)getUnitImg:(NSMutableArray *)array{
//    for (int i=0; i<array.count; i++) {
//        UnitSectionMessageModel *model = [array objectAtIndex:i];
//        D("showhttp.getunitimg-=-=%@",model.UnitID);
//        if ([model.UnitType intValue] == 2) {
//            [[ShowHttp getInstance] showHttpGetUnitLogo:[NSString stringWithFormat:@"-%@",model.UnitID] Size:@""];
//        }else{
//            [[ShowHttp getInstance] showHttpGetUnitLogo:model.UnitID Size:@""];
//        }
//    }
}

//获取下级单位logo
-(void)getDownUnitImg:(NSMutableArray *)array{
//    for (int i=0; i<array.count; i++) {
//        UnitInfoModel *model = [array objectAtIndex:i];
//        D("showhttp.getunitimg-=-=%@",model.TabID);
//        [[ShowHttp getInstance] showHttpGetUnitLogo:model.TabID Size:@""];
//    }
}

//文章点赞
-(void)shareHttpAirthLikeIt:(NSString *)aid Flag:(NSString *)flag{
    NSString *urlString = [NSString stringWithFormat:@"%@Sections/LikeIt",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:aid forKey:@"aid"];
    [request addPostValue:flag forKey:@"goflag"];
    request.userInfo = [NSDictionary dictionaryWithObject:aid forKey:@"aid"];
    request.tag = 13;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//获取文章评论列表              文章加密id                                                      来自哪个页面的请求
-(void)shareHttpAirthCommentsList:(NSString *)aid Page:(NSString *)page Num:(NSString *)num Flag:(NSString *)flag{
    NSString *urlString = [NSString stringWithFormat:@"%@Sections/CommentsList",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:num forKey:@"numPerPage"];
    [request addPostValue:page forKey:@"pageNum"];
    [request addPostValue:aid forKey:@"aid"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:aid,@"tableID",flag,@"flag", nil];
    request.userInfo = dic;
    request.tag = 14;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//发表评论                  文章加密id                                              加密的引用评语ID
-(void)shareHttpAirthAddComment:(NSString *)aid content:(NSString *)comment refid:(NSString *)refid{
    NSString *urlString = [NSString stringWithFormat:@"%@Sections/addComment",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:aid forKey:@"aid"];
    [request addPostValue:comment forKey:@"comment"];
    if (refid.length>0) {
        [request addPostValue:refid forKey:@"refid"];
    }
    request.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:aid,@"tableID",comment,@"comment", nil];
    request.tag = 15;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//评论顶和踩                     加密评论ID             顶=1，踩=0
-(void)shareHttpAirthAddScore:(NSString *)uid tp:(NSString *)tp{
    NSString *urlString = [NSString stringWithFormat:@"%@Sections/AddScore",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:uid forKey:@"uid"];
    [request addPostValue:tp forKey:@"tp"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",tp,@"tp", nil];
    request.userInfo = dic;
    request.tag = 16;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//取文章附加信息                   文章加密id          文章栏目id
-(void)shareHttpAirthGetArthInfo:(NSString *)aid sid:(NSString *)sid{
    NSString *urlString = [NSString stringWithFormat:@"%@Sections/GetArthInfo",MAINURL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.timeOutSeconds = TIMEOUT;
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    [request addRequestHeader:@"charset" value:@"UTF8"];
    [request setRequestMethod:@"POST"];
    [request addPostValue:aid forKey:@"aid"];
    [request addPostValue:sid forKey:@"sid"];
    request.userInfo = [NSDictionary dictionaryWithObject:aid forKey:@"tableID"];
    request.tag = 17;//设置请求tag
    [request setDelegate:self];
    [request startAsynchronous];
}

//请求成功
- (void)requestFinished:(ASIHTTPRequest *)_request{
    NSData *responseData = [_request responseData];
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
    NSString* dataString = [[NSString alloc] initWithData:responseData encoding:encoding];
    D("dataString--tag=---share---------====%ld---  %@",(long)_request.tag,dataString);
    NSMutableDictionary *jsonDic = [dataString objectFromJSONString];
    //先对返回值做判断，是否连接超时
    NSString *code = [jsonDic objectForKey:@"ResultCode"];
    if ([code intValue] == 8) {
        [[LoginSendHttp getInstance] hands_login];
        return;
    }
    if (_request.tag == 3) {//获取本单位栏目文章
        NSString *time = [jsonDic objectForKey:@"Data"];
        NSString *str000 = [DESTool decryptWithText:time Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        D("str00===3=>>>>==%@",str000);
        NSMutableArray *array = [ParserJson_share parserJsonTopArthListWith:str000];
        //获取头像
        [self getFaceImg:array flag:1];
        //通知shareview界面，将得到的值，传到界面
        NSString *flag = [_request.userInfo objectForKey:@"sectionFlag"];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"0" forKey:@"flag"];
        [dic setValue:@"array" forKey:@"array"];
        if ([flag isEqual:@"1"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TopArthListIndex" object:dic];
        }else if ([flag isEqual:@"2"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TopArthListIndexShow" object:dic];
        }else if ([flag isEqual:@"99"]) {//单位主题
            [[NSNotificationCenter defaultCenter] postNotificationName:@"themeSpace" object:dic];
        }
    }else if (_request.tag == 4){//获取头像
        //获取的用户自定义内容
        NSString *hao = [_request.userInfo objectForKey:@"JiaoBaoHao"];
        D("jiaobaohao-====%@",hao);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        //文件名
        NSFileManager* fileManager=[NSFileManager defaultManager];
        NSString *imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",hao]];
        BOOL yesNo=[[NSFileManager defaultManager] fileExistsAtPath:imgPath];
        if (!yesNo) {//不存在，则直接写入后通知界面刷新
            BOOL yesNo1 = [responseData writeToFile:imgPath atomically:YES];
            if (yesNo1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TopArthListIndexImg" object:nil];
            }
        }else {//存在
            BOOL blDele= [fileManager removeItemAtPath:imgPath error:nil];//先删除
            if (blDele) {//删除成功后，写入，通知界面
                BOOL yesNo = [responseData writeToFile:imgPath atomically:YES];
                if (yesNo) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"TopArthListIndexImg" object:nil];
                }
            }
        }
    }else if (_request.tag == 5) {//获取我所在的单位
        if ([[jsonDic objectForKey:@"ResultCode"] intValue]==0) {
            [InternetAppTopScrollView shareInstance].mInt_show = 1;
        }
        NSString *time = [jsonDic objectForKey:@"Data"];
        NSString *str000 = [DESTool decryptWithText:time Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        D("str00===5=>>>>==%@",str000);
        NSMutableArray *array = [ParserJson_share parserJsonSectionMessage:str000];
        //获取单位头像
        [self getUnitImg:array];
        //通知shareview界面，将得到的值，传到界面
        NSString *flag = [_request.userInfo objectForKey:@"sectionID"];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"0" forKey:@"flag"];
        [dic setValue:@"array" forKey:@"array"];
        if ([flag isEqual:@"1"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getUnitInfo" object:dic];
        }else if ([flag isEqual:@"2"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getUnitInfoShow" object:dic];
        }
    }else if (_request.tag == 1) {//获取关联的班级
        NSString *time = [jsonDic objectForKey:@"Data"];
        NSString *str000 = [DESTool decryptWithText:time Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        D("str00===1=>>>>==%@",str000);
        NSMutableArray *array = [ParserJson_share parserJsonUnitClassWith:str000];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"1" forKey:@"index"];
        [dic setValue:array forKey:@"array"];
        [dic setValue:@"0" forKey:@"flag"];
        //将值传到界面
        NSString *flag = [_request.userInfo objectForKey:@"flag"];
        if ([flag isEqual:@"1"]) {//分享
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getUnitClass" object:dic];
        }else if ([flag isEqual:@"2"]) {//展示
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getUnitClassShow" object:dic];
        }else if ([flag isEqual:@"3"]) {//内务
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getUnitClassNotice" object:dic];
        }
    }else if (_request.tag == 2) {//获取所有班级
        NSString *time = [jsonDic objectForKey:@"Data"];
        NSString *str000 = [DESTool decryptWithText:time Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        D("str00===2=>>>>==%@",str000);
        NSMutableArray *array = [ParserJson_share parserJsonSumClassWith:str000];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"2" forKey:@"index"];
        [dic setValue:array forKey:@"array"];
        [dic setValue:@"0" forKey:@"flag"];
        //将值传到界面
        NSString *flag = [_request.userInfo objectForKey:@"flag"];
        if ([flag isEqual:@"1"]) {//分享
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getUnitClass" object:dic];
        }else if ([flag isEqual:@"2"]) {//展示
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getUnitClassShow" object:dic];
        }
    }else if (_request.tag == 6) {//显示文章详细内容
        NSString *time = [jsonDic objectForKey:@"Data"];
        NSString *str000 = [DESTool decryptWithText:time Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        D("str00===6=>>>>==%@",str000);
        ArthDetailModel *model = [ParserJson_share parserJsonArthDetailWith:str000];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:model forKey:@"model"];
        [dic setValue:@"0" forKey:@"flag"];
        //通知文章详情界面刷新
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ArthDetai" object:dic];
    }else if (_request.tag == 7) {//获取本单位的所有下级单位基础信息
        NSString *time = [jsonDic objectForKey:@"Data"];
        NSString *str000 = [DESTool decryptWithText:time Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        D("str00===7=>>>>==%@",str000);
        NSMutableArray *array = [ParserJson_share parserJsonMySubUnitInfoWith:str000];
        //获取下级单位logo
        [self getDownUnitImg:array];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"0" forKey:@"flag"];
        [dic setValue:@"array" forKey:@"array"];
        //将值传到界面
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MySubUnitInfo" object:dic];
    }else if (_request.tag == 8) {//上传图片
        NSString *time = [jsonDic objectForKey:@"Data"];
        NSString *str000 = [DESTool decryptWithText:time Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        D("str00===8=>>>>==%@",str000);
        UploadImgModel *model = [ParserJson_share parserJsonUploadImgWith:str000];
        //通知界面
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"0" forKey:@"flag"];
        [dic setValue:model forKey:@"model"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UploadImg" object:dic];
    }else if (_request.tag == 9) {//发表文章
        NSString *time = [jsonDic objectForKey:@"Data"];
        NSString *str000 = [DESTool decryptWithText:time Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        D("str00===9=>>>>==%@",str000);
        if ([[jsonDic objectForKey:@"ResultCode"] intValue] == 0) {
            //通知界面发表文章成功
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SavePublishArticle" object:@"成功"];
        }else{
            NSString *time1 = [jsonDic objectForKey:@"ResultDesc"];
            NSString *str0002 = [DESTool decryptWithText:time1 Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SavePublishArticle" object:str0002];
        }
    }else if (_request.tag == 10) {//获取栏目最新和推荐文章的未读数量
        NSString *time = [jsonDic objectForKey:@"Data"];
        NSString *str000 = [DESTool decryptWithText:time Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        D("str00===10=>>>>==%@",str000);
//        NSString *flag = [_request.userInfo objectForKey:@"topFlag"];
        NSString *flag = _request.username;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:str000 forKey:@"count"];
        [dic setValue:flag forKey:@"flag"];
        //将获取到的值，传到界面
        NSString *section = [_request.userInfo objectForKey:@"sectionID"];
        D("flag---10-===%@,%@,%@",flag,section,_request.username);
        if ([section isEqual:@"_1"]) {//展示
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GetSectionMessageShow" object:dic];
            //记录未读数量
            [dm getInstance].mImt_showUnRead = [dm getInstance].mImt_showUnRead + [str000 intValue];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showUnReadMSG" object:nil];
        }else if ([section isEqual:@"_2"]) {//分享
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GetSectionMessage" object:dic];
            //记录未读数量
            [dm getInstance].mImt_shareUnRead = [dm getInstance].mImt_shareUnRead + [str000 intValue];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shareUnReadMSG" object:nil];
        }
    }else if (_request.tag == 11) {//获得单位通知，内务
        NSString *time = [jsonDic objectForKey:@"Data"];
        NSString *str000 = [DESTool decryptWithText:time Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        D("str00===11=>>>>==%@",str000);
        UnitNoticeModel *model = [ParserJson_share parserJsonUnitNoticesWith:str000];
        //获取头像
        [self getFaceImg:model.noticeInfoArray flag:2];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"0" forKey:@"flag"];
        [dic setValue:model forKey:@"model"];
        //通知到内务获取到的单位通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetUnitNotices" object:dic];
    }else if (_request.tag == 12) {//获取通知详细内容
        NSString *time = [jsonDic objectForKey:@"Data"];
        NSString *str000 = [DESTool decryptWithText:time Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        D("str00===12=>>>>==%@",str000);
        NoticeInfoModel *model = [ParserJson_share parserJsonNoticeDetailWith:str000];
        //通知文章详情界面刷新
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"0" forKey:@"flag"];
        [dic setValue:model forKey:@"model"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ArthDetai" object:dic];
    }else if (_request.tag == 13) {//文章点赞
        NSString *time = [jsonDic objectForKey:@"ResultCode"];
        NSString *str;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        if ([time intValue] ==0) {
            str = @"点赞成功";
            [dic setValue:@"0" forKey:@"flag"];
        }else{
            str = @"点赞失败";
            [dic setValue:@"1" forKey:@"flag"];
        }
        NSString *aid = [_request.userInfo objectForKey:@"aid"];
        [dic setValue:aid forKey:@"aid"];
        [dic setValue:str forKey:@"str"];
        
        //通知文章详情界面刷新点赞
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AirthLikeIt" object:dic];
    }else if (_request.tag == 14) {//获取文章评论列表
        NSString *time = [jsonDic objectForKey:@"Data"];
        NSString *str000 = [DESTool decryptWithText:time Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        D("str00===14=>>>>==%@",str000);
        CommentsListObjModel *model = [ParserJson_share parserJsonCommentsListWith:str000];
        NSString *flag = [_request.userInfo objectForKey:@"flag"];
        NSString *tableID = [_request.userInfo objectForKey:@"tableID"];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"0" forKey:@"flag"];
        if ([flag intValue]==2) {//学校圈总界面
            [dic setValue:model forKey:@"model"];
            [dic setValue:tableID forKey:@"tableID"];
            //将获取到的评论列表传到界面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AirthCommentsList2" object:dic];
        }else{//详情界面
            //获取头像
            [self getFaceImg:model.commentsList flag:3];
            //将获取到的评论列表传到界面
            [dic setValue:model forKey:@"model"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AirthCommentsList" object:dic];
        }
    }else if (_request.tag == 15) {//文章评论
        NSString *time = [jsonDic objectForKey:@"ResultCode"];
        NSString *str;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        if ([time intValue] ==0) {
            str = @"评论成功";
            [dic setValue:@"0" forKey:@"flag"];
        }else{
            str = @"评论失败";
            [dic setValue:@"1" forKey:@"flag"];
        }
        NSString *tableID = [_request.userInfo objectForKey:@"tableID"];
        NSString *comment = [_request.userInfo objectForKey:@"comment"];
        
        [dic setValue:str forKey:@"str"];
        [dic setValue:tableID forKey:@"tableID"];
        [dic setValue:comment forKey:@"comment"];
        //文章评论
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AirthAddComment" object:dic];
    }else if (_request.tag == 16) {//评论顶和踩
        NSString *time = [jsonDic objectForKey:@"ResultCode"];
        NSString *str;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        if ([time intValue] ==0) {
            str = @"成功";
            [dic setValue:@"0" forKey:@"flag"];
        }else{
            str = @"失败";
            [dic setValue:@"1" forKey:@"flag"];
        }
        NSString *temp1 = [_request.userInfo objectForKey:@"uid"];
        NSString *temp2 = [_request.userInfo objectForKey:@"tp"];
        
        [dic setValue:temp1 forKey:@"uid"];
        [dic setValue:temp2 forKey:@"tp"];
        [dic setValue:str forKey:@"name"];
        //将踩、顶回复返回界面
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AirthAddScore" object:dic];
    }else if (_request.tag == 17) {//文章附加评论
        NSString *time = [jsonDic objectForKey:@"Data"];
        NSString *str000 = [DESTool decryptWithText:time Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        D("str00===17=>>>>==%@",str000);
        GetArthInfoModel *model = [ParserJson_share parserJsonGetArthInfo:str000];
        NSString *tableID = [_request.userInfo objectForKey:@"tableID"];
        model.TabIDStr = tableID;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"0" forKey:@"flag"];
        [dic setValue:model forKey:@"model"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetArthInfo" object:dic];
    }
}
//请求失败
-(void)requestFailed:(ASIHTTPRequest *)_request{
    D("dataString---share-tag=%ld,flag----  请求失败",(long)_request.tag);
    if (_request.tag == 3) {//获取本单位栏目文章
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"1" forKey:@"flag"];
        //通知shareview界面，将得到的值，传到界面
        NSString *flag = [_request.userInfo objectForKey:@"sectionFlag"];
        if ([flag isEqual:@"1"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TopArthListIndex" object:dic];
        }else if ([flag isEqual:@"2"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TopArthListIndexShow" object:dic];
        }else if ([flag isEqual:@"99"]) {//单位主题
            [[NSNotificationCenter defaultCenter] postNotificationName:@"themeSpace" object:dic];
        }
    }else if (_request.tag == 4){//获取头像
        
    }else if (_request.tag == 5) {//获取我所在的单位
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"1" forKey:@"flag"];
        //通知shareview界面，将得到的值，传到界面
        NSString *flag = [_request.userInfo objectForKey:@"sectionID"];
        if ([flag isEqual:@"1"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getUnitInfo" object:dic];
        }else if ([flag isEqual:@"2"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getUnitInfoShow" object:dic];
        }
    }else if (_request.tag == 1) {//获取关联的班级
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"1" forKey:@"flag"];
        //将值传到界面
        NSString *flag = [_request.userInfo objectForKey:@"flag"];
        if ([flag isEqual:@"1"]) {//分享
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getUnitClass" object:dic];
        }else if ([flag isEqual:@"2"]) {//展示
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getUnitClassShow" object:dic];
        }else if ([flag isEqual:@"3"]) {//内务
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getUnitClassNotice" object:dic];
        }
    }else if (_request.tag == 2) {//获取所有班级
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"1" forKey:@"flag"];
        //将值传到界面
        NSString *flag = [_request.userInfo objectForKey:@"flag"];
        if ([flag isEqual:@"1"]) {//分享
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getUnitClass" object:dic];
        }else if ([flag isEqual:@"2"]) {//展示
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getUnitClassShow" object:dic];
        }
    }else if (_request.tag == 6) {//显示文章详细内容
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"1" forKey:@"flag"];
        //通知文章详情界面刷新
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ArthDetai" object:dic];
    }else if (_request.tag == 7) {//获取本单位的所有下级单位基础信息
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"1" forKey:@"flag"];
        //将值传到界面
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MySubUnitInfo" object:dic];
    }else if (_request.tag == 8) {//上传图片
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"1" forKey:@"flag"];
        //通知界面
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UploadImg" object:dic];
    }else if (_request.tag == 9) {//发表文章
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SavePublishArticle" object:@"超时"];
    }else if (_request.tag == 10) {//获取栏目最新和推荐文章的未读数量
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"3" forKey:@"flag"];
        //将获取到的值，传到界面
        NSString *section = [_request.userInfo objectForKey:@"sectionID"];
        if ([section isEqual:@"_1"]) {//展示
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GetSectionMessageShow" object:dic];
        }else if ([section isEqual:@"_2"]) {//分享
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GetSectionMessage" object:dic];
        }
    }else if (_request.tag == 11) {//获得单位通知，内务
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"1" forKey:@"flag"];
        //通知到内务获取到的单位通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetUnitNotices" object:dic];
    }else if (_request.tag == 12) {//获取通知详细内容
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"1" forKey:@"flag"];
        //通知文章详情界面刷新
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ArthDetai" object:dic];
    }else if (_request.tag == 13) {//文章点赞
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"1" forKey:@"flag"];
        [dic setValue:@"超时" forKey:@"str"];
        //通知文章详情界面刷新点赞
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AirthLikeIt" object:dic];
    }else if (_request.tag == 14) {//获取文章评论列表
        NSString *flag = [_request.userInfo objectForKey:@"flag"];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"1" forKey:@"flag"];
        if ([flag intValue]==2) {//学校圈总界面
            //将获取到的评论列表传到界面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AirthCommentsList2" object:dic];
        }else{//详情界面
            //获取头像
            //将获取到的评论列表传到界面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AirthCommentsList" object:dic];
        }
    }else if (_request.tag == 15) {//文章评论
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"超时" forKey:@"str"];
        [dic setValue:@"1" forKey:@"flag"];
        //文章评论
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AirthAddComment" object:dic];
    }else if (_request.tag == 16) {//评论顶和踩
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"1" forKey:@"flag"];
        [dic setValue:@"超时" forKey:@"name"];
        //将踩、顶回复返回界面
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AirthAddScore" object:dic];
    }else if (_request.tag == 17) {//文章附加评论
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"1" forKey:@"flag"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetArthInfo" object:dic];
    }
}

@end
