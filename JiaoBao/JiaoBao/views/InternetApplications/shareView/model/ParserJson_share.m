//
//  ParserJson_share.m
//  JiaoBao
//
//  Created by Zqw on 14-11-17.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "ParserJson_share.h"
#import "utils.h"

@implementation ParserJson_share


//[{"TabIDStr":"NEVERjZCRUQ2OTFFNEZGMg","ClickCount":9,"Context":null,"JiaoBaoHao":5184862,"LikeCount":3,"RecDate":"2014-11-18T10:52:01.2728326+08:00","Source":0,"StarJson":null,"State":1,"Title":"招聘信息","ViewCount":8,"SectionID":"1850_2","UserName":"许传吉"},
//解析最新更新、推荐
+(NSMutableArray *)parserJsonTopArthListWith:(NSString *)json{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *arrList = [json objectFromJSONString];
    for (int i=0; i<arrList.count; i++) {
        TopArthListModel *model = [[TopArthListModel alloc] init];
        NSDictionary *dic = [arrList objectAtIndex:i];
        model.TabIDStr = [dic objectForKey:@"TabIDStr"];
        model.ClickCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ClickCount"]];
        model.Context = [dic objectForKey:@"Context"];
        model.JiaoBaoHao = [dic objectForKey:@"JiaoBaoHao"];
        model.LikeCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"LikeCount"]];
//        model.RecDate = [[dic objectForKey:@"RecDate"] substringToIndex:10];
        NSString *str = [utils getLocalTimeDate];
        NSString *str2 = [[dic objectForKey:@"RecDate"] substringToIndex:19];
        NSRange range = [str2 rangeOfString:str];
        if (range.length>0) {
            model.RecDate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringFromIndex:10];
        }else{
            model.RecDate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:10];
        }
        model.Source = [dic objectForKey:@"Source"];
        model.StarJson = [dic objectForKey:@"StarJson"];
        model.State = [dic objectForKey:@"State"];
        model.Title = [dic objectForKey:@"Title"];
        model.ViewCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ViewCount"]];
        model.SectionID = [dic objectForKey:@"SectionID"];
        model.UserName = [dic objectForKey:@"UserName"];
        [array addObject:model];
    }
    return array;
}

//[{"UnitID":1,"UnitName":"测试单位","IsMyUnit":2,"MessageCount":0,"UnitType":1}
//解析获取到得单位，本级和上级，new
+(NSMutableArray *)parserJsonSectionMessage:(NSString *)json{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *arrList = [json objectFromJSONString];
    for (int i=0; i<arrList.count; i++) {
        UnitSectionMessageModel *model = [[UnitSectionMessageModel alloc] init];
        NSDictionary *dic = [arrList objectAtIndex:i];
        model.UnitID = [dic objectForKey:@"UnitID"];
        model.UnitName = [dic objectForKey:@"UnitName"];
        model.IsMyUnit = [NSString stringWithFormat:@"%@",[dic objectForKey:@"IsMyUnit"]];
        model.MessageCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"MessageCount"]];
        model.UnitType = [NSString stringWithFormat:@"%@",[dic objectForKey:@"UnitType"]];
        if ([model.UnitType isEqual:@"1"]) {
            model.imgName = @"share_education";
        }else if ([model.UnitType isEqual:@"2"]){
            model.imgName = @"share_school";
        }
        [array addObject:model];
    }
    return array;
}

//[{"ClassID":19,"ClassNo":"9805","ClassName":"调班临时数据","GradeYear":2013,"GradeName":"一年级","State":1,"SchoolID":991,"SchoolIDStr":null,"TabIDStr":null},
//解析班级信息
+(NSMutableArray *)parserJsonUnitClassWith:(NSString *)json{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *arrList = [json objectFromJSONString];
    for (int i=0; i<arrList.count; i++) {
        UserClassModel *model = [[UserClassModel alloc] init];
        NSDictionary *dic = [arrList objectAtIndex:i];
        model.ClassNo = [dic objectForKey:@"ClassNo"];
        model.ClassName = [dic objectForKey:@"ClassName"];
        model.ClassID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ClassID"]];
        model.GradeYear = [NSString stringWithFormat:@"%@",[dic objectForKey:@"GradeYear"]];
        model.State = [NSString stringWithFormat:@"%@",[dic objectForKey:@"State"]];
        model.GradeName = [dic objectForKey:@"GradeName"];
        model.SchoolID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"SchoolID"]];
        model.SchoolIDStr = [dic objectForKey:@"SchoolIDStr"];
        model.TabIDStr = [dic objectForKey:@"TabIDStr"];
        [array addObject:model];
    }
    return array;
}

//[{"AccountID":0,"ArtUpdate":0,"ClsName":"调班临时数据","ClsNo":"9805","GradeName":"一年级","GradeYear":2013,"ParentID":991,"SchoolType":null,"TabID":19},
//解析所有班级信息
+(NSMutableArray *)parserJsonSumClassWith:(NSString *)json{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *arrList = [json objectFromJSONString];
    for (int i=0; i<arrList.count; i++) {
        UserSumClassModel *model = [[UserSumClassModel alloc] init];
        NSDictionary *dic = [arrList objectAtIndex:i];
        model.ClsNo = [dic objectForKey:@"ClsNo"];
        model.ClsName = [dic objectForKey:@"ClsName"];
        model.AccountID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"AccountID"]];
        model.ArtUpdate = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ArtUpdate"]];
        model.GradeYear = [NSString stringWithFormat:@"%@",[dic objectForKey:@"GradeYear"]];
        model.GradeName = [dic objectForKey:@"GradeName"];
        model.ParentID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ParentID"]];
        model.SchoolType = [dic objectForKey:@"SchoolType"];
        model.TabID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"TabID"]];
        [array addObject:model];
    }
    return array;
}

//解析文章详情
+(ArthDetailModel *)parserJsonArthDetailWith:(NSString *)json{
    ArthDetailModel *model = [[ArthDetailModel alloc] init];
    NSDictionary *dic = [json objectFromJSONString];
    model.TabIDStr = [dic objectForKey:@"TabIDStr"];
    model.Context = [dic objectForKey:@"Context"];
    model.ClickCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ClickCount"]];
    model.JiaoBaoHao = [NSString stringWithFormat:@"%@",[dic objectForKey:@"JiaoBaoHao"]];
    model.LikeCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"LikeCount"]];
    model.RecDate = [dic objectForKey:@"RecDate"];
//    model.RecDate = [[[dic objectForKey:@"RecDate"] stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:19];
    NSString *str = [utils getLocalTimeDate];
    NSString *str2 = [[dic objectForKey:@"RecDate"] substringToIndex:19];
    NSRange range = [str2 rangeOfString:str];
    if (range.length>0) {
        model.RecDate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringFromIndex:10];
    }else{
        model.RecDate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:10];
    }
    model.Source = [NSString stringWithFormat:@"%@",[dic objectForKey:@"Source"]];
    model.StarJson = [dic objectForKey:@"StarJson"];
    model.State = [NSString stringWithFormat:@"%@",[dic objectForKey:@"State"]];
    model.Title = [dic objectForKey:@"Title"];
    model.SectionID = [dic objectForKey:@"SectionID"];
    model.ViewCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ViewCount"]];
    model.UserName = [dic objectForKey:@"UserName"];
    model.FeeBackCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"FeeBackCount"]];
    model.Likeflag = [NSString stringWithFormat:@"%@",[dic objectForKey:@"Likeflag"]];
    return model;
}

//[{"AccountID":0,"ArtCount":513,"ArtUpdate":556,"CityCode":"370103","EduParentID":-1,"ParentID":"997","ShortName":null,"State":1,"TabID":998,"TownShip":null,"UintName":"金视野山东大区","UnitCode":null,"UnitNo":0,"UnitType":1}
//解析所有下级单位基础信息
+(NSMutableArray *)parserJsonMySubUnitInfoWith:(NSString *)json{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *arrList = [json objectFromJSONString];
    for (int i=0; i<arrList.count; i++) {
        UnitInfoModel *model = [[UnitInfoModel alloc] init];
        NSDictionary *dic = [arrList objectAtIndex:i];
        model.CityCode = [dic objectForKey:@"CityCode"];
        model.ParentID = [dic objectForKey:@"ParentID"];
        model.AccountID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"AccountID"]];
        model.ArtCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ArtCount"]];
        model.ArtUpdate = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ArtUpdate"]];
        model.ShortName = [dic objectForKey:@"ShortName"];
        model.EduParentID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"EduParentID"]];
        model.TownShip = [dic objectForKey:@"TownShip"];
        model.TabID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"TabID"]];
        model.UintName = [dic objectForKey:@"UintName"];
        model.UnitCode = [dic objectForKey:@"UnitCode"];
        model.State = [NSString stringWithFormat:@"%@",[dic objectForKey:@"State"]];
        model.UnitNo = [NSString stringWithFormat:@"%@",[dic objectForKey:@"UnitNo"]];
        model.UnitType = [NSString stringWithFormat:@"%@",[dic objectForKey:@"UnitType"]];
        [array addObject:model];
    }
    return array;
}

//{"originalName":"111.png","url":"http://www.jsyoa.edu8800.com/JBClient/AppFiles/getSectionFiletmp?fn=Igk9iyhkIXk-SO1PKKtwm2okVzWqFDHHlYj2p7jmiXDi4iQvGJSvyt6-SQITdEQCQXPnJwGnSpIC0","size":221682,"type":".png"}
//解析上传图片成功后的数据
+(UploadImgModel *)parserJsonUploadImgWith:(NSString *)json{
    UploadImgModel *model = [[UploadImgModel alloc] init];
    NSDictionary *dic = [json objectFromJSONString];
    NSString *name= [dic objectForKey:@"originalName"];
    model.originalName = [name substringToIndex:name.length-4];
    NSString *str = [dic objectForKey:@"url"];
    model.url = [NSString stringWithFormat:@"<img src=\"%@\" />",str];
    model.size = [NSString stringWithFormat:@"%@",[dic objectForKey:@"size"]];
    model.type = [dic objectForKey:@"type"];
    return model;
}

//解析内务通知列表
+(UnitNoticeModel *)parserJsonUnitNoticesWith:(NSString *)json{
    UnitNoticeModel *model = [[UnitNoticeModel alloc] init];
    NSDictionary *dic = [json objectFromJSONString];
    model.write = [dic objectForKey:@"write"];
    NSMutableArray *arrlist = [dic objectForKey:@"list"];
    for (int i=0; i<arrlist.count; i++) {
        NoticeInfoModel *noticeModel = [[NoticeInfoModel alloc] init];
        NSDictionary *result = [arrlist objectAtIndex:i];
        noticeModel.JiaoBaoHao = [NSString stringWithFormat:@"%@",[result objectForKey:@"JiaoBaoHao"]];
        noticeModel.NoticMsg = [result objectForKey:@"NoticMsg"];
        noticeModel.NoticType = [NSString stringWithFormat:@"%@",[result objectForKey:@"NoticType"]];
//        noticeModel.Recdate = [[result objectForKey:@"Recdate"] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        NSString *str = [utils getLocalTimeDate];
        NSString *str2 = [dic objectForKey:@"Recdate"];
        NSRange range = [str2 rangeOfString:str];
        if (range.length>0) {
            noticeModel.Recdate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringFromIndex:10];
        }else{
            noticeModel.Recdate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:10];
        }
        noticeModel.Subject = [result objectForKey:@"Subject"];
        noticeModel.TabIDStr = [result objectForKey:@"TabIDStr"];
        noticeModel.UserName = [result objectForKey:@"UserName"];
        [model.noticeInfoArray addObject:noticeModel];
    }
    return model;
}

//解析通知详情
+(NoticeInfoModel *)parserJsonNoticeDetailWith:(NSString *)json{
    NoticeInfoModel *noticeModel = [[NoticeInfoModel alloc] init];
    NSDictionary *dic = [json objectFromJSONString];
    noticeModel.JiaoBaoHao = [NSString stringWithFormat:@"%@",[dic objectForKey:@"JiaoBaoHao"]];
    noticeModel.NoticMsg = [dic objectForKey:@"NoticMsg"];
    noticeModel.NoticType = [NSString stringWithFormat:@"%@",[dic objectForKey:@"NoticType"]];
//    noticeModel.Recdate = [[dic objectForKey:@"Recdate"] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSString *str = [utils getLocalTimeDate];
    NSString *str2 = [dic objectForKey:@"Recdate"];
    NSRange range = [str2 rangeOfString:str];
    if (range.length>0) {
        noticeModel.Recdate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringFromIndex:10];
    }else{
        noticeModel.Recdate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:10];
    }
    noticeModel.Subject = [dic objectForKey:@"Subject"];
    noticeModel.TabIDStr = [dic objectForKey:@"TabIDStr"];
    noticeModel.UserName = [dic objectForKey:@"UserName"];
    return noticeModel;
}

//好友
//[{"TabID":1310,"Actjiaobaohao":5150028,"Friendjiaobaohao":5150114,"GroupID":0,"Remark":null,"NickName":null,"LinkFirendsTabID":655,"LastLogDatetime":"0001-01-01T00:00:00"},
//关注人
//[{"TabID":389,"CreateByjiaobaohao":5150028,"InterestFirendsjiaobaohao":5150030,"CreateDatetime":"2014-11-23T18:22:39","GroupID":0}]
//解析该用户的所有好友
+(NSMutableArray *)parserJsonMyFriendsWith:(NSString *)json{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *arrList = [json objectFromJSONString];
    for (int i=0; i<arrList.count; i++) {
        FriendSpaceModel *model = [[FriendSpaceModel alloc] init];
        NSDictionary *dic = [arrList objectAtIndex:i];
        model.NickName = [dic objectForKey:@"NickName"];
        model.Remark = [dic objectForKey:@"Remark"];
        model.Actjiaobaohao = [NSString stringWithFormat:@"%@",[dic objectForKey:@"Actjiaobaohao"]];
        if (model.Actjiaobaohao.length==0) {
            model.Actjiaobaohao = [NSString stringWithFormat:@"%@",[dic objectForKey:@"CreateByjiaobaohao"]];
        }
        model.Friendjiaobaohao = [NSString stringWithFormat:@"%@",[dic objectForKey:@"Friendjiaobaohao"]];
        if ([model.Friendjiaobaohao intValue]>0) {
            
        }else{
            model.Friendjiaobaohao = [NSString stringWithFormat:@"%@",[dic objectForKey:@"InterestFirendsjiaobaohao"]];
        }
        model.GroupID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"GroupID"]];
        NSString *time = [dic objectForKey:@"LastLogDatetime"];
        if (time.length==0) {
            NSString *str = [utils getLocalTimeDate];
            NSString *str2 = [dic objectForKey:@"CreateDatetime"];
            NSRange range = [str2 rangeOfString:str];
            if (range.length>0) {
                model.LastLogDatetime = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringFromIndex:10];
            }else{
                model.LastLogDatetime = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:10];
            }
        }else{
            NSString *str = [utils getLocalTimeDate];
            NSString *str2 = [dic objectForKey:@"LastLogDatetime"];
            NSRange range = [str2 rangeOfString:str];
            if (range.length>0) {
                model.LastLogDatetime = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringFromIndex:10];
            }else{
                model.LastLogDatetime = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:10];
            }
        }
        model.LinkFirendsTabID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"LinkFirendsTabID"]];
        model.TabID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"TabID"]];
        [array addObject:model];
    }
    return array;
}

//解析文章的评论
+(CommentsListObjModel *)parserJsonCommentsListWith:(NSString *)json{
    CommentsListObjModel *model = [[CommentsListObjModel alloc] init];
    NSDictionary *dic = [json objectFromJSONString];
    model.commentsList = [self parserJsonCommentsList:[dic objectForKey:@"commentsList"]];
    model.refcomments = [self parserJsonRefcomments:[dic objectForKey:@"refcomments"]];
    return model;
}

+(NSMutableArray *)parserJsonCommentsList:(NSMutableArray *)arrlist{
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i<arrlist.count; i++) {
        commentsListModel *model = [[commentsListModel alloc] init];
        NSDictionary *result = [arrlist objectAtIndex:i];
        model.JiaoBaoHao = [NSString stringWithFormat:@"%@",[result objectForKey:@"JiaoBaoHao"]];
        model.TabIDStr = [result objectForKey:@"TabIDStr"];
        model.TabID = [NSString stringWithFormat:@"%@",[result objectForKey:@"TabID"]];
        model.CaiCount = [NSString stringWithFormat:@"%@",[result objectForKey:@"CaiCount"]];
        model.Number = [result objectForKey:@"Number"];
        model.LikeCount = [NSString stringWithFormat:@"%@",[result objectForKey:@"LikeCount"]];
        model.Commnets = [result objectForKey:@"Commnets"];
        NSString *str = [utils getLocalTimeDate];
        NSString *str2 = [result objectForKey:@"Recdate"];
        NSRange range = [str2 rangeOfString:str];
        if (range.length>0) {
            model.RecDate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringFromIndex:10];
        }else{
            model.RecDate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:10];
        }
        model.UnitShortname = [result objectForKey:@"UnitShortname"];
        NSString *temp = [result objectForKey:@"RefID"];//解析出来是个__NSCFString，强转
        if ([temp isEqual:[NSNull null]]) {
            
        }else{
            NSArray *array0 = [[result objectForKey:@"RefID"] componentsSeparatedByString:@","];
            for (int i=0; i<array0.count; i++) {
                if ([[array0 objectAtIndex:i] intValue]>0) {
                    [model.RefID addObject:[array0 objectAtIndex:i]];
                }
            }
        }
        
        model.UserName = [result objectForKey:@"UserName"];
        [array addObject:model];
    }
    return array;
    //"TabIDStr": "MzFBRkIzNjI3QURDRjE1RQ",
    //"TabID": 1454640,
    //"Number": "8楼",
    //"JiaoBaoHao": 5150001,
    //"CaiCount": 0,
    //"LikeCount": 0,
    //"Commnets": "444",
    //"UnitShortname": "支撑学校",
    //"RecDate": "2015-01-16T14:53:00",
    //"RefID": "1434519,1454460,",
    //"UserName": "测试5150001"
}
+(NSMutableArray *)parserJsonRefcomments:(NSMutableArray *)arrlist{
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i<arrlist.count; i++) {
        refcommentsModel *model = [[refcommentsModel alloc] init];
        NSDictionary *result = [arrlist objectAtIndex:i];
        model.JiaoBaoHao = [NSString stringWithFormat:@"%@",[result objectForKey:@"JiaoBaoHao"]];
        model.TabIDStr = [result objectForKey:@"TabIDStr"];
        model.TabID = [NSString stringWithFormat:@"%@",[result objectForKey:@"TabID"]];
        model.CaiCount = [NSString stringWithFormat:@"%@",[result objectForKey:@"CaiCount"]];
        model.LikeCount = [NSString stringWithFormat:@"%@",[result objectForKey:@"LikeCount"]];
        model.Commnets = [result objectForKey:@"Commnets"];
        NSString *str = [utils getLocalTimeDate];
        NSString *str2 = [result objectForKey:@"Recdate"];
        NSRange range = [str2 rangeOfString:str];
        if (range.length>0) {
            model.RecDate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringFromIndex:10];
        }else{
            model.RecDate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:10];
        }
        model.UnitShortname = [result objectForKey:@"UnitShortname"];
        model.UserName = [result objectForKey:@"UserName"];
        [array addObject:model];
    }
    return array;
    
    //"TabIDStr": "Q0IxMzA0RjZGODRDODBCNw",
    //"TabID": 1454515,
    //"JiaoBaoHao": 5150001,
    //"CaiCount": 0,
    //"LikeCount": 0,
    //"Commnets": "222",
    //"UnitShortname": "支撑学校",
    //"RecDate": "2015-01-16T14:52:00",
    //"UserName": "测试5150001"
}

//{"TabID":368263,"ClickCount":27,"LikeCount":7,"StarJson":null,"State":1,"ViewCount":16,"FeeBackCount":4,"Likeflag":0}
//解析文件附加信息
+(GetArthInfoModel *)parserJsonGetArthInfo:(NSString *)json{
    NSDictionary *result = [json objectFromJSONString];
    GetArthInfoModel *model = [[GetArthInfoModel alloc] init];
    model.TabID = [[result objectForKey:@"TabID"] intValue];
    model.ClickCount = [[result objectForKey:@"ClickCount"] intValue];
    model.LikeCount = [[result objectForKey:@"LikeCount"] intValue];
    NSString *str = [result objectForKey:@"StarJson"];
    if ([str isKindOfClass:[NSNull class]]||[str isEqual:@"null"]) {
        
    }else{
        model.StarJson = [[result objectForKey:@"StarJson"] intValue];
    }
    
    model.State = [[result objectForKey:@"State"] intValue];
    model.ViewCount = [[result objectForKey:@"ViewCount"] intValue];
    model.FeeBackCount = [[result objectForKey:@"FeeBackCount"] intValue];
    model.Likeflag = [[result objectForKey:@"Likeflag"] intValue];
    return model;
}

@end
