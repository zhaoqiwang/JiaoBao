//
//  ParserJson_identity.m
//  JiaoBao
//
//  Created by Zqw on 14-10-24.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "ParserJson.h"
#import "utils.h"

@implementation ParserJson


-(id)init{
//    Identity_model *
    return self;
}
//{"RoleIdentity":5,"RoleIdName":"访客","UserUnits":[],"UserClasses":[]}]
//解析获取到的人员个人信息json
+(NSMutableArray *)parserJsonwith:(NSString *)json{
    NSArray *arrlist=[json objectFromJSONString];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=0; i<arrlist.count; i++) {
        Identity_model *identityModel = [[Identity_model alloc] init];
        NSDictionary *result = [arrlist objectAtIndex:i];
        identityModel.RoleIdentity = [result objectForKey:@"RoleIdentity"];
        identityModel.RoleIdName = [result objectForKey:@"RoleIdName"];
        NSMutableArray *arrUserUnits = [self parserJsonUserUnits:[result objectForKey:@"UserUnits"]];
        NSMutableArray *arrUserClasses = [self parserJsonUserClasses:[result objectForKey:@"UserClasses"]];
        identityModel.UserUnits = [NSMutableArray arrayWithArray:arrUserUnits];
        identityModel.UserClasses = [NSMutableArray arrayWithArray:arrUserClasses];
        identityModel.DefaultUnitId = [result objectForKey:@"DefaultUnitId"];
        [array addObject:identityModel];
    }
    return array;
}
//解析UserUnits
//{"UnitID":983,"UnitType":1,"UnitName":"测试单位下级","ShortName":"单位下级","Area":"370100","SchoolType":null,"TownShip":null,"TabIDStr":"NDNEQUNCNTRFNDNBQkNFNA"},
+(NSMutableArray *)parserJsonUserUnits:(NSArray *)arrlist{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=0; i<arrlist.count; i++) {
        Identity_UserUnits_model *userUnitsModel = [[Identity_UserUnits_model alloc] init];
        NSDictionary *result = [arrlist objectAtIndex:i];
        userUnitsModel.UnitID = [result objectForKey:@"UnitID"];
        userUnitsModel.UnitType = [result objectForKey:@"UnitType"];
        userUnitsModel.UnitName = [result objectForKey:@"UnitName"];
        userUnitsModel.ShortName = [result objectForKey:@"ShortName"];
        userUnitsModel.Area = [result objectForKey:@"Area"];
        userUnitsModel.SchoolType = [result objectForKey:@"SchoolType"];
        userUnitsModel.TownShip = [result objectForKey:@"TownShip"];
        userUnitsModel.TabIDStr = [result objectForKey:@"TabIDStr"];
        [array addObject:userUnitsModel];
    }
    return array;
}
//解析UserClasses
//{"ClassID":48,"ClassNo":"1309","ClassName":"1309班","GradeYear":2013,"GradeName":"2013级","State":1,"SchoolID":991,"SchoolIDStr":"NkFBMkNDMTg1NTI5NTdCRQ","TabIDStr":"NUJDQTc3MTVERkI5RENBQw"},
+(NSMutableArray *)parserJsonUserClasses:(NSArray *)arrlist{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=0; i<arrlist.count; i++) {
        Identity_UserClasses_model *userClassesModel = [[Identity_UserClasses_model alloc] init];
        NSDictionary *result = [arrlist objectAtIndex:i];
        userClassesModel.ClassID = [result objectForKey:@"ClassID"];
        userClassesModel.ClassNo = [result objectForKey:@"ClassNo"];
        userClassesModel.ClassName = [result objectForKey:@"ClassName"];
        userClassesModel.GradeYear = [result objectForKey:@"GradeYear"];
        userClassesModel.GradeName = [result objectForKey:@"GradeName"];
        userClassesModel.State = [result objectForKey:@"State"];
        userClassesModel.SchoolID = [result objectForKey:@"SchoolID"];
        userClassesModel.SchoolIDStr = [result objectForKey:@"SchoolIDStr"];
        userClassesModel.TabIDStr = [result objectForKey:@"TabIDStr"];
        [array addObject:userClassesModel];
    }
    return array;
}

//解析已处理未回复的信息
+(NSMutableArray *)parserJsonUnReadMsgWith:(NSString *)json{
    NSArray *arrlist=[json objectFromJSONString];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=0; i<arrlist.count; i++) {
        UnReadMsg_model *unReadMsgModel = [[UnReadMsg_model alloc] init];
        NSDictionary *result = [arrlist objectAtIndex:i];
        unReadMsgModel.TabIDStr = [result objectForKey:@"TabIDStr"];
        unReadMsgModel.UserName = [result objectForKey:@"UserName"];
        unReadMsgModel.MsgContent = [result objectForKey:@"MsgContent"];
        unReadMsgModel.MsgTabIDStr = [result objectForKey:@"MsgTabIDStr"];
        unReadMsgModel.FeeBackMsg = [result objectForKey:@"FeeBackMsg"];
//        unReadMsgModel.RecDate = [[result objectForKey:@"RecDate"]stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        NSString *str = [utils getLocalTimeDate];
        NSString *str2 = [result objectForKey:@"RecDate"];
        NSRange range = [str2 rangeOfString:str];
        if (range.length>0) {
            unReadMsgModel.RecDate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringFromIndex:10];
        }else{
            unReadMsgModel.RecDate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:10];
        }
        if ([[result objectForKey:@"JiaoBaoHao"] intValue]>0) {
            unReadMsgModel.JiaoBaoHao = [result objectForKey:@"JiaoBaoHao"];
        }else if ([[result objectForKey:@"Jiaobaohao"] intValue]>0) {
            unReadMsgModel.JiaoBaoHao = [result objectForKey:@"Jiaobaohao"];
        }else{
            unReadMsgModel.JiaoBaoHao = [dm getInstance].jiaoBaoHao;
        }
        
        [array addObject:unReadMsgModel];
    }
    
    return array;
}
//{"TabIDStr":"MjVEQ0E1RTgyNjZDNzdCQw","TabID":229654,"UnitID":0,"UnitShortName":"测试教育局4","UserID":0,"UserName":"张偿工","MsgContent":"？？？？。。","RecDate":"2014-10-24T17:59:29","ClassID":0,"UserType":0,"JiaoBaoHao":5150001,"SMSFlag":0,"destID":null,"JiaobaoID":"5150001",
//    "ReaderList":"[{\"UserID\":6,\"UserIDType\":\"6_1\",\"JiaoBaoHao\":5150001,\"TrueName\":\"石向亮\",\"SrvState\":2,\"MCState\":1,\"SMSState\":0,\"PCState\":0,\"ClassID\":0,\"UnitID\":991}]",
//    "ReadFlagList":"5150001","TrunToList":"[]","State":1,"Checker":null,"CheckDate":null,"RecGUID":null,"AttList":null,"IsAdmin":0,"CityCode":null,"FeebackList":null,"PointActionCode":0,"TrunToFlag":0,"GenReadCount":0,"GenSMSCount":0,"MsgType":0},

//解析信息详情
+(UnReadMsg_model *)parserJsonMsgDetailWithUnReadMsg:(NSString *)json{
    NSDictionary *result = [json objectFromJSONString];
    NSDictionary *model = [result objectForKey:@"Model"];
    UnReadMsg_model *unReadMsgModel = [[UnReadMsg_model alloc] init];
    unReadMsgModel.TabIDStr = [model objectForKey:@"TabIDStr"];
    unReadMsgModel.UserName = [model objectForKey:@"UserName"];
    unReadMsgModel.MsgContent = [model objectForKey:@"MsgContent"];
//    unReadMsgModel.RecDate = [[model objectForKey:@"RecDate"]stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSString *str = [utils getLocalTimeDate];
    NSString *str2 = [model objectForKey:@"RecDate"];
    NSRange range = [str2 rangeOfString:str];
    if (range.length>0) {
        unReadMsgModel.RecDate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringFromIndex:10];
    }else{
        unReadMsgModel.RecDate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:10];
    }
    if ([[model objectForKey:@"JiaoBaoHao"] intValue]>0) {
        unReadMsgModel.JiaoBaoHao = [model objectForKey:@"JiaoBaoHao"];
    }else{
        unReadMsgModel.JiaoBaoHao = [dm getInstance].jiaoBaoHao;
    }
    NSString *strAttList = [model objectForKey:@"AttList"];//解析出来是个__NSCFString，强转
    if ([strAttList isEqual:[NSNull null]]) {
        
    }else{
        NSMutableArray *attList = [self AttList:strAttList];
        unReadMsgModel.arrayAttList = [NSMutableArray arrayWithArray:attList];
    }
    
    NSString *strReadList = [model objectForKey:@"ReaderList"];//解析出来是个__NSCFString，强转
    NSMutableArray *readerList = [self ReaderList:strReadList];
    unReadMsgModel.arrayReaderList = [NSMutableArray arrayWithArray:readerList];
    
    NSString *strTrunToList = [model objectForKey:@"TrunToList"];//解析出来是个__NSCFString，强转
    NSMutableArray *trunToList = [self TrunToList:strTrunToList];//解析出来是个__NSCFString，强转
    unReadMsgModel.arrayTrunToList = [NSMutableArray arrayWithArray:trunToList];
    return unReadMsgModel;
}

//{"Model":
//    {"TabIDStr":"RjQ5OUNBQjNCMkE5MDUwOQ","TabID":217504,"UnitID":987,"UnitShortName":"测试教育局4","UserID":884,"UserName":"张偿工","MsgContent":"测试下发","RecDate":"2014-10-23T14:40:31","ClassID":0,"UserType":1,"JiaoBaoHao":5150001,"SMSFlag":2,"destID":null,"JiaobaoID":"5150001","ReaderList":"[{\"UserID\":6,\"UserIDType\":\"6_1\",\"JiaoBaoHao\":5150001,\"TrueName\":\"石向亮\",\"SrvState\":2,\"MCState\":1,\"SMSState\":3,\"PCState\":0,\"ClassID\":0,\"UnitID\":991}]","ReadFlagList":"5150001","TrunToList":"[{\"UserID\":6,\"JiaoBaoHao\":5150001,\"UnitType\":1,\"UnitID\":991,\"Who\":\"tomem\"}]","State":1,"Checker":null,"CheckDate":"0001-01-01T00:00:00","RecGUID":"c71668d8-126d-4d53-9305-383083ceade5",
//        "AttList":"[{\"dlurl\":\"http://www.jiaobao.net/jbapp/AppFiles/dlfile/QTZBQzc3MTYxOEY0NzNDOA\",\"OrgFilename\":\"fastjson.txt\",\"FileSize\":\"10.67 KB\"}]",
//        "IsAdmin":0,"CityCode":null,"FeebackList":null,"PointActionCode":10,"TrunToFlag":0,"GenReadCount":0,"GenSMSCount":0,"MsgType":0},
//    
//"FeebackList":[]}

//AttList
+(NSMutableArray *)AttList:(NSString *)str{
    str = (NSString *)str;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (str.length>0) {
        NSArray *arrlist=[str objectFromJSONString];
        for (int i=0; i<arrlist.count; i++) {
            MsgDetail_AttList *attList = [[MsgDetail_AttList alloc] init];
            NSDictionary *result = [arrlist objectAtIndex:i];
            attList.dlurl = [result objectForKey:@"dlurl"];
            attList.OrgFilename = [result objectForKey:@"OrgFilename"];
            attList.FileSize = [result objectForKey:@"FileSize"];
            [array addObject:attList];
        }
    }
    return array;
}
//ReaderList
+(NSMutableArray *)ReaderList:(NSString *)str{
    str = (NSString *)str;
    NSArray *arrlist=[str objectFromJSONString];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=0; i<arrlist.count; i++) {
        MsgDetail_ReaderList *readerList = [[MsgDetail_ReaderList alloc] init];
        NSDictionary *result = [arrlist objectAtIndex:i];
        readerList.UserID = [result objectForKey:@"UserID"];
        readerList.UserIDType = [result objectForKey:@"UserIDType"];
        readerList.JiaoBaoHao = [result objectForKey:@"JiaoBaoHao"];
        readerList.TrueName = [result objectForKey:@"TrueName"];
        readerList.SrvState = [result objectForKey:@"SrvState"];
        readerList.MCState = [result objectForKey:@"MCState"];
        readerList.SMSState = [result objectForKey:@"SMSState"];
        readerList.PCState = [result objectForKey:@"PCState"];
        readerList.ClassID = [result objectForKey:@"ClassID"];
        readerList.UnitID = [result objectForKey:@"UnitID"];
        readerList.flag = @"1";
        [array addObject:readerList];
    }
    return array;
}
//TrunToList
+(NSMutableArray *)TrunToList:(NSString *)str{
    str = (NSString *)str;
    NSArray *arrlist=[str objectFromJSONString];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=0; i<arrlist.count; i++) {
        MsgDetail_TrunToList *trunToList = [[MsgDetail_TrunToList alloc] init];
        NSDictionary *result = [arrlist objectAtIndex:i];
        trunToList.UserID = [result objectForKey:@"UserID"];
        trunToList.JiaoBaoHao = [result objectForKey:@"JiaoBaoHao"];
        trunToList.UnitType = [result objectForKey:@"UnitType"];
        trunToList.UnitID = [result objectForKey:@"UnitID"];
        trunToList.Who = [result objectForKey:@"Who"];
        [array addObject:trunToList];
    }
    return array;
}

//解析信息详情，feebackList
+(NSMutableArray *)parserJsonMsgDetailWithFeeBackList:(NSString *)json{
    NSDictionary *result = [json objectFromJSONString];
    NSMutableArray *arrlist = [result objectForKey:@"FeebackList"];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=0; i<arrlist.count; i++) {
        MsgDetail_FeebackList *feebackList = [[MsgDetail_FeebackList alloc] init];
        NSDictionary *result = [arrlist objectAtIndex:i];
        feebackList.TabIDStr = [result objectForKey:@"TabIDStr"];
        feebackList.TabID = [result objectForKey:@"TabID"];
        feebackList.Jiaobaohao = [result objectForKey:@"Jiaobaohao"];
        feebackList.MsgID = [result objectForKey:@"MsgID"];
        feebackList.FeeBackMsg = [result objectForKey:@"FeeBackMsg"];
        feebackList.RecDate = [result objectForKey:@"RecDate"];
        feebackList.FeeBackNo = [result objectForKey:@"FeeBackNo"];
        feebackList.State = [result objectForKey:@"State"];
        feebackList.ReadFlag = [result objectForKey:@"ReadFlag"];
        feebackList.UnitShortName = [result objectForKey:@"UnitShortName"];
        feebackList.UserName = [result objectForKey:@"UserName"];
        feebackList.MsgContent = [result objectForKey:@"MsgContent"];
        feebackList.MsgRecDate = [result objectForKey:@"MsgRecDate"];
        feebackList.ReaderList = [result objectForKey:@"ReaderList"];
        feebackList.MsgTabIDStr = [result objectForKey:@"MsgTabIDStr"];
        [array addObject:feebackList];
    }
    return array;
}

//{"parentUnitRevicer":[{"UnitName":"测试单位","TabIDStr":"NDNEQUNCNTRFNDNBQkNFNA","UserList":[]
//}],
//    
//    "myUnitRevicer":{"UnitName":"单位下级",
//        "TabIDStr":"NDNEQUNCNTRFNDNBQkNFNA",
//        "UserList":[{"GroupName":"基本人员",
//            "MCount":1,
//            "groupselit_selit":[{"selit":"OUU2NDUwMkY5MTY4QzhFN0JCQTU5QTdBQzcwRTFGRUI0N0RFRDhDQzg4MjJCQ0MxOTBCMjYzMjJBRTkzMjE5RkQ1OUQ3OTM5RTExMkE4MjlGMzQ2REU4RUNCNjI3NUNBQzJFMUU5RDgzQUFBNDdBMTUwMDAzMzAwOENDRjREMDRDQjUxNzVENUFDODY1NDhGQkJGMTI3MjU2QzM2Qjk4MjNDMUE2NkFCODBERTM4NjY1RkFGNjM0QTE3QUY5ODU5OEU2OTc2RTkzMTIwQkMwNQ","AccID":"5150001","isAdmin":0,"Name":"LM(123*,有)","SendFlag":1
//            }]
//        }]
//    },
//    
//    "subUnitRevicer":[],"UnitClassRevicer":null,"selitadmintomem":null,"selitadmintogen":null,"selitadmintostu":null,"unitClassAdminRevicer":null}
//解析接收人列表
+(CMRevicerModel *)parserJsonCMRevicerWith:(NSString *)json{
    NSDictionary *result = [json objectFromJSONString];
    CMRevicerModel *model = [[CMRevicerModel alloc] init];
    
    NSString *parentUnitRevicer = [result objectForKey:@"parentUnitRevicer"];//解析出来是个__NSCFString，强转
    if ([parentUnitRevicer isEqual:[NSNull null]]) {
        
    }else{
        NSMutableArray *array1 = [self parserMyUnitRevicer:[result objectForKey:@"parentUnitRevicer"]];
        model.parentUnitRevicer = [NSMutableArray arrayWithArray:array1];
    }
    
    NSString *myUnitRevicer = [result objectForKey:@"myUnitRevicer"];//解析出来是个__NSCFString，强转
    if ([myUnitRevicer isEqual:[NSNull null]]) {
        
    }else{
        model.myUnitRevicer = [self parserMyUnitRevicerModel:[result objectForKey:@"myUnitRevicer"]];
    }
    
    
    NSString *subUnitRevicer = [result objectForKey:@"subUnitRevicer"];//解析出来是个__NSCFString，强转
    if ([subUnitRevicer isEqual:[NSNull null]]) {
        
    }else{
        NSMutableArray *array2 = [self parserMyUnitRevicer:[result objectForKey:@"subUnitRevicer"]];
        model.subUnitRevicer = [NSMutableArray arrayWithArray:array2];
    }
    
    NSString *UnitClassRevicer = [result objectForKey:@"UnitClassRevicer"];//解析出来是个__NSCFString，强转
    if ([UnitClassRevicer isEqual:[NSNull null]]) {
        
    }else{
        NSMutableArray *array3 = [self parserUnitClassRevicer:[result objectForKey:@"UnitClassRevicer"]];
        model.UnitClassRevicer = [NSMutableArray arrayWithArray:array3];
    }
    
//    {"parentUnitRevicer":null,"myUnitRevicer":null,"subUnitRevicer":null,"UnitClassRevicer":null,
//    "selitadmintomem":[{"groupName":"小学","UnitType":2,"UserList":[{"selit":"OUU2NDUwMkY5MTY4QzhFN0VGMjcwQkE4NzVBMDBGQkY2QzdFQTA1RTI3Rjc3NkExMDU5NDA4MTY3RDNCRjc5MkM1NThCRjIyQ0REQzMwM0FDNkYyQTc2MDYyQTcwRDVDMjUzNEQ2MTRERTUyQkUxNUREOEFCN0Q3MTA3NjY2NTMyQkJBQTc2OUYwQkE4RjZEREY3OTRCOERBMUE2Nzg4OTJFMzRGN0I1Rjk5MEM2ODVCQTI3NDAxNDEzNDA0NTJDOUQ4NDVBQUI2MDRGQzFFMw","AccID":"5150028","isAdmin":3,"Name":"演示学校一[马文彬(139*,有)]","SendFlag":1}]}],"selitadmintogen":[{"groupName":"小学","UnitType":2,"UserList":[{"selit":"OUU2NDUwMkY5MTY4QzhFN0VGMjcwQkE4NzVBMDBGQkY2QzdFQTA1RTI3Rjc3NkExMDU5NDA4MTY3RDNCRjc5MkM1NThCRjIyQ0REQzMwM0FDNkYyQTc2MDYyQTcwRDVDMjUzNEQ2MTRERTUyQkUxNUREOEFCN0Q3MTA3NjY2NTMyQkJBQTc2OUYwQkE4RjZEREY3OTRCOERBMUE2Nzg4OTJFMzRGN0I1Rjk5MEM2ODVCQTI3NDAxNDEzNDA0NTJDOUQ4NDVBQUI2MDRGQzFFMw","AccID":"5150028","isAdmin":3,"Name":"演示学校一[马文彬(139*,有)]","SendFlag":1}]}],"selitadmintostu":null,"unitClassAdminRevicer":null}
    
    NSString *selitadmintomem = [result objectForKey:@"selitadmintomem"];//解析出来是个__NSCFString，强转
    if ([selitadmintomem isEqual:[NSNull null]]) {
        
    }else{
        NSMutableArray *array4 = [self parserSelitadmintomem:[result objectForKey:@"selitadmintomem"]];
        model.selitadmintomem = [NSMutableArray arrayWithArray:array4];
    }
    
    NSString *selitadmintogen = [result objectForKey:@"selitadmintogen"];//解析出来是个__NSCFString，强转
    if ([selitadmintogen isEqual:[NSNull null]]) {
        
    }else{
        NSMutableArray *array5 = [self parserSelitadmintomem:[result objectForKey:@"selitadmintogen"]];
        model.selitadmintogen = [NSMutableArray arrayWithArray:array5];
    }
    
    NSString *selitadmintostu = [result objectForKey:@"selitadmintostu"];//解析出来是个__NSCFString，强转
    if ([selitadmintostu isEqual:[NSNull null]]) {
        
    }else{
        NSMutableArray *array6 = [self parserSelitadmintomem:[result objectForKey:@"selitadmintostu"]];
        model.selitadmintostu = [NSMutableArray arrayWithArray:array6];
    }
    
    NSString *unitClassAdminRevicer = [result objectForKey:@"unitClassAdminRevicer"];//解析出来是个__NSCFString，强转
    if ([unitClassAdminRevicer isEqual:[NSNull null]]) {
        
    }else{
        model.unitClassAdminRevicer = [self parserunitClassAdminRevicer:[result objectForKey:@"unitClassAdminRevicer"]];
    }
    
    return model;
}
//{"groupName":"小学","UnitType":2,"UserList":[{"selit":"OUU2NDUwMkY5MTY4QzhFN0VGMjcwQkE4NzVBMDBGQkY2QzdFQTA1RTI3Rjc3NkExMDU5NDA4MTY3RDNCRjc5MkM1NThCRjIyQ0REQzMwM0FDNkYyQTc2MDYyQTcwRDVDMjUzNEQ2MTRERTUyQkUxNUREOEFCN0Q3MTA3NjY2NTMyQkJBQTc2OUYwQkE4RjZEREY3OTRCOERBMUE2Nzg4OTJFMzRGN0I1Rjk5MEM2ODVCQTI3NDAxNDEzNDA0NTJDOUQ4NDVBQUI2MDRGQzFFMw","AccID":"5150028","isAdmin":3,"Name":"演示学校一[马文彬(139*,有)]","SendFlag":1}]}
+(NSMutableArray *)parserSelitadmintomem:(NSArray *)arrlist{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=0; i<arrlist.count; i++) {
        
        NSDictionary *result = [arrlist objectAtIndex:i];
        NSMutableArray *tempArr = [result objectForKey:@"UserList"];
        if (tempArr.count>0) {
            selitadminModel *model = [[selitadminModel alloc] init];
            model.groupName = [result objectForKey:@"groupName"];
            model.UnitType = [result objectForKey:@"UnitType"];
            model.SendFlag = [result objectForKey:@"SendFlag"];
            model.UserList = [self parserGroupselit_selit:[result objectForKey:@"UserList"]];
            [array addObject:model];
        }
    }
    if (array.count==0) {
        if (arrlist.count>0) {
            UserListModel *model = [[UserListModel alloc] init];
            model.GroupName = @"本班管理员";
            model.groupselit_selit = [self parserGroupselit_selit:arrlist];
            [array addObject:model];
        }
    }
    return array;
}
+(NSMutableArray *)parserSelitadmintomem:(NSArray *)arrlist Flag:(NSString *)flag{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=0; i<arrlist.count; i++) {
        
        NSDictionary *result = [arrlist objectAtIndex:i];
        
        NSString *selitunitclassadmintogen = [result objectForKey:@"UserList"];//解析出来是个__NSCFString，强转
        if ([selitunitclassadmintogen isEqual:[NSNull null]]) {
            
        }else{
            NSMutableArray *tempArr = [result objectForKey:@"UserList"];
            if (tempArr.count>0) {
                //            selitadminModel *model = [[selitadminModel alloc] init];
                //            model.groupName = [result objectForKey:@"groupName"];
                //            model.UnitType = [result objectForKey:@"UnitType"];
                //            model.SendFlag = [result objectForKey:@"SendFlag"];
                //            model.UserList = [self parserGroupselit_selit:[result objectForKey:@"UserList"] Flag:flag];
                //            [array addObject:model];
                UserListModel *model = [[UserListModel alloc] init];
                model.GroupName = [result objectForKey:@"groupName"];
                model.groupselit_selit = [self parserGroupselit_selit:[result objectForKey:@"UserList"] Flag:flag];
                [array addObject:model];
            }
        }
        
    }
    if (array.count==0) {
        if (arrlist.count>0) {
            UserListModel *model = [[UserListModel alloc] init];
            model.GroupName = @"本班管理员";
            model.groupselit_selit = [self parserGroupselit_selit:arrlist Flag:flag];
            [array addObject:model];
        }
    }
    return array;
}
//解析myUnitRevicer-----[{"UnitName":"测试单位","TabIDStr":"NDNEQUNCNTRFNDNBQkNFNA","UserList":[]}]
+(NSMutableArray *)parserMyUnitRevicer:(NSArray *)arrlist{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=0; i<arrlist.count; i++) {
        myUnitRevicerModel *model = [[myUnitRevicerModel alloc] init];
        NSDictionary *result = [arrlist objectAtIndex:i];
        model.UnitName = [result objectForKey:@"UnitName"];
        model.TabIDStr = [result objectForKey:@"TabIDStr"];
        model.UserList = [self parserUserList:[result objectForKey:@"UserList"]];
        [array addObject:model];
    }
    return array;
}
+(NSMutableArray *)parserUnitClassRevicer:(NSArray *)arrlist{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=0; i<arrlist.count; i++) {
        UnitClassRevicerModel *model = [[UnitClassRevicerModel alloc] init];
        NSDictionary *result = [arrlist objectAtIndex:i];
        model.ClassName = [result objectForKey:@"ClassName"];
        model.teachers_selit = [result objectForKey:@"teachers_selit"];
        model.studentgens_genselit = [self parserGroupselit_selit:[result objectForKey:@"studentgens_genselit"]];
        [array addObject:model];
    }
    return array;
}

//解析myUnitRevicerModel
+(myUnitRevicerModel *)parserMyUnitRevicerModel:(NSDictionary *)dic{
    myUnitRevicerModel *model = [[myUnitRevicerModel alloc] init];
    model.UnitName = [dic objectForKey:@"UnitName"];
    model.TabIDStr = [dic objectForKey:@"TabIDStr"];
    model.UserList = [self parserUserList:[dic objectForKey:@"UserList"]];
    return model;
}

//解析UserList----[{"GroupName":"基本人员", "MCount":1, "groupselit_selit":[]}]
+(NSMutableArray *)parserUserList:(NSArray *)arrlist{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=0; i<arrlist.count; i++) {
        UserListModel *model = [[UserListModel alloc] init];
        NSDictionary *result = [arrlist objectAtIndex:i];
        model.GroupName = [result objectForKey:@"GroupName"];
        model.MCount = [result objectForKey:@"MCount"];
        model.groupselit_selit = [self parserGroupselit_selit:[result objectForKey:@"groupselit_selit"]];
        [array addObject:model];
    }
    return array;
}

//解析每个单位中的人员
+(NSMutableArray *)parserUserList_json:(NSString *)json{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSDictionary *dic = [json objectFromJSONString];
    NSMutableArray *arrlist = [dic objectForKey:@"selit"];
    for (int i=0; i<arrlist.count; i++) {
        UserListModel *model = [[UserListModel alloc] init];
        NSDictionary *result = [arrlist objectAtIndex:i];
        model.GroupName = [result objectForKey:@"GroupName"];
        model.MCount = [result objectForKey:@"MCount"];
        model.groupselit_selit = [self parserGroupselit_selit:[result objectForKey:@"groupselit_selit"] Flag:@"selit"];
        [array addObject:model];
    }
    return array;
}

//解析每个单位中的人员
+(NSMutableArray *)parserUserListClass_json:(NSString *)json{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSDictionary *dic = [json objectFromJSONString];
    
    NSMutableArray *arrlist0 = [dic objectForKey:@"selit"];
    if (arrlist0.count>0) {
        UserListModel *model = [[UserListModel alloc] init];
        model.GroupName = @"本班老师";
        model.groupselit_selit = [self parserGroupselit_selit:arrlist0 Flag:@"selit"];
        [array addObject:model];
    }
    
    NSMutableArray *arrlist = [dic objectForKey:@"genselit"];
    if (arrlist.count>0) {
        UserListModel *model = [[UserListModel alloc] init];
        model.GroupName = @"本班家长";
        model.groupselit_selit = [self parserGroupselit_selit:arrlist Flag:@"genselit"];
        [array addObject:model];
    }
    if (arrlist.count==0) {
        arrlist = [dic objectForKey:@"stuselit"];
        if (arrlist.count>0) {
            UserListModel *model = [[UserListModel alloc] init];
            model.GroupName = @"本班学生";
            model.groupselit_selit = [self parserGroupselit_selit:arrlist Flag:@"stuselit"];
            [array addObject:model];
        }
    }
    return array;
}

+(NSMutableArray *)parserGroupselit_selit:(NSArray *)arrlist Flag:(NSString *)flag{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=0; i<arrlist.count; i++) {
        groupselit_selitModel *model = [[groupselit_selitModel alloc] init];
        NSDictionary *result = [arrlist objectAtIndex:i];
        model.selit = [result objectForKey:@"selit"];
        model.AccID = [result objectForKey:@"AccID"];
        model.isAdmin = [result objectForKey:@"isAdmin"];
        model.Name = [result objectForKey:@"Name"];
        model.SendFlag = [result objectForKey:@"SendFlag"];
        model.flag = flag;
        [array addObject:model];
    }
    return array;
}
//解析groupselit_selit----[{"selit":"OUU2NDUwMkY5MTY4QzhFN0JCQTU5QTdBQzcwRTFGRUI0N0RFRDhDQzg4MjJCQ0MxOTBCMjYzMjJBRTkzMjE5RkQ1OUQ3OTM5RTExMkE4MjlGMzQ2REU4RUNCNjI3NUNBQzJFMUU5RDgzQUFBNDdBMTUwMDAzMzAwOENDRjREMDRDQjUxNzVENUFDODY1NDhGQkJGMTI3MjU2QzM2Qjk4MjNDMUE2NkFCODBERTM4NjY1RkFGNjM0QTE3QUY5ODU5OEU2OTc2RTkzMTIwQkMwNQ","AccID":"5150001","isAdmin":0,"Name":"LM(123*,有)","SendFlag":1}]
+(NSMutableArray *)parserGroupselit_selit:(NSArray *)arrlist{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=0; i<arrlist.count; i++) {
        groupselit_selitModel *model = [[groupselit_selitModel alloc] init];
        NSDictionary *result = [arrlist objectAtIndex:i];
        model.selit = [result objectForKey:@"selit"];
        model.AccID = [result objectForKey:@"AccID"];
        model.isAdmin = [result objectForKey:@"isAdmin"];
        model.Name = [result objectForKey:@"Name"];
        model.SendFlag = [result objectForKey:@"SendFlag"];
        [array addObject:model];
    }
    return array;
}
//解析parserunitClassAdminRevicer---
+(unitClassAdminRevicerModel *)parserunitClassAdminRevicer:(NSDictionary *)dic{
    unitClassAdminRevicerModel *model = [[unitClassAdminRevicerModel alloc] init];
    
    NSString *selitunitclassidtogen = [dic objectForKey:@"selitunitclassidtogen"];//解析出来是个__NSCFString，强转
    if ([selitunitclassidtogen isEqual:[NSNull null]]) {
        
    }else{
        NSMutableArray *array5 = [self parserGroupselit_selit:[dic objectForKey:@"selitunitclassidtogen"]];
        model.selitunitclassidtogen = [NSMutableArray arrayWithArray:array5];
    }
    
    NSString *selitunitclassidtostu = [dic objectForKey:@"selitunitclassidtostu"];//解析出来是个__NSCFString，强转
    if ([selitunitclassidtostu isEqual:[NSNull null]]) {
        
    }else{
        NSMutableArray *array5 = [self parserGroupselit_selit:[dic objectForKey:@"selitunitclassidtostu"]];
        model.selitunitclassidtostu = [NSMutableArray arrayWithArray:array5];
    }
    
    NSString *selitunitclassadmintogen = [dic objectForKey:@"selitunitclassadmintogen"];//解析出来是个__NSCFString，强转
    if ([selitunitclassadmintogen isEqual:[NSNull null]]) {
        
    }else{
        NSMutableArray *array5 = [self parserGroupselit_selit:[dic objectForKey:@"selitunitclassadmintogen"]];
        model.selitunitclassadmintogen = [NSMutableArray arrayWithArray:array5];
    }
    
    NSString *selitunitclassadmintostu = [dic objectForKey:@"selitunitclassadmintostu"];//解析出来是个__NSCFString，强转
    if ([selitunitclassadmintostu isEqual:[NSNull null]]) {
        
    }else{
        NSMutableArray *array5 = [self parserGroupselit_selit:[dic objectForKey:@"selitunitclassadmintostu"]];
        model.selitunitclassadmintostu = [NSMutableArray arrayWithArray:array5];
    }
    
    return model;
}
//[{"id":994,"pId":-1,"name":"战略发展部","uType":1,"TabIDStr":"ODdCRTA4NTFDMTEzQTE1QQ"}]
//解析短信直通车的人员列表
+(NSMutableArray *)parserJsonSMSUnitWith:(NSString *)json{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSArray *arrlist=[json objectFromJSONString];
    for (int i=0; i<arrlist.count; i++) {
        SMSTreeUnitModel *model = [[SMSTreeUnitModel alloc] init];
        NSDictionary *result = [arrlist objectAtIndex:i];
        model.id0 = [result objectForKey:@"id"];
        model.pId = [result objectForKey:@"pId"];
        model.name = [result objectForKey:@"name"];
        model.uType = [result objectForKey:@"uType"];
        model.TabIDStr = [result objectForKey:@"TabIDStr"];
        [array addObject:model];
    }
    return array;
}

//{"UserID":1511,"UserType":1,"UserName":"LM","UnitID":983,"isAdmin":0}
//解析个人信息
+(UserInfoModel *)parserJsonUserInfoWith:(NSString *)json{
    UserInfoModel *model = [[UserInfoModel alloc] init];
    NSDictionary *result = [json objectFromJSONString];
    model.UserID = [result objectForKey:@"UserID"];
    model.UserType = [result objectForKey:@"UserType"];
    model.UserName = [result objectForKey:@"UserName"];
    model.UnitID = [result objectForKey:@"UnitID"];
    model.isAdmin = [result objectForKey:@"isAdmin"];
    return model;
}

//{"myUnit":{"UintName":"测试教育局4","TabID":987,"TabIDStr":"MDQxNUM1MTI1OTE1NUM1OA","flag":1},"UnitParents":[{"UintName":"测试单位","TabID":1,"flag":2}],"subUnits":[{"UintName":"学校4","TabID":991,"flag":0}],"UnitClass":[{"ClsName":"总部支撑","TabID":429,"flag":13}]}
//解析获取事务信息接收单位列表，new
+(CommMsgRevicerUnitListModel *)parserJsonCommMsgRevicerUnitList:(NSString *)json{
    CommMsgRevicerUnitListModel *model = [[CommMsgRevicerUnitListModel alloc] init];
    NSDictionary *result = [json objectFromJSONString];
    
    NSString *myUnit = [result objectForKey:@"myUnit"];//解析出来是个__NSCFString，强转
    if ([myUnit isEqual:[NSNull null]]) {
        
    }else{
        model.myUnit = [self parserMyUnit:[result objectForKey:@"myUnit"]];
    }
    
    NSString *UnitParents = [result objectForKey:@"UnitParents"];//解析出来是个__NSCFString，强转
    if ([UnitParents isEqual:[NSNull null]]) {
        
    }else{
        NSMutableArray *array5 = [self ParserJsonArray:[result objectForKey:@"UnitParents"]];
        model.UnitParents = [NSMutableArray arrayWithArray:array5];
    }
    
    NSString *subUnits = [result objectForKey:@"subUnits"];//解析出来是个__NSCFString，强转
    if ([subUnits isEqual:[NSNull null]]) {
        
    }else{
        NSMutableArray *array5 = [self ParserJsonArray:[result objectForKey:@"subUnits"]];
        model.subUnits = [NSMutableArray arrayWithArray:array5];
    }
    
    NSString *UnitClass = [result objectForKey:@"UnitClass"];//解析出来是个__NSCFString，强转
    if ([UnitClass isEqual:[NSNull null]]) {
        
    }else{
        NSMutableArray *array5 = [self ParserJsonArray:[result objectForKey:@"UnitClass"]];
        model.UnitClass = [NSMutableArray arrayWithArray:array5];
    }
    
    return model;
}

+(NSMutableArray *)ParserJsonArray:(NSMutableArray *)arrlist{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=0; i<arrlist.count; i++) {
        NSDictionary *result = [arrlist objectAtIndex:i];
        myUnit *model = [self parserMyUnit:result];
        [array addObject:model];
    }
    return array;
}

+(myUnit *)parserMyUnit:(NSDictionary *)result{
    myUnit *model = [[myUnit alloc] init];
    model.UintName = [result objectForKey:@"UintName"];
    if (model.UintName.length==0) {
        model.UintName = [result objectForKey:@"ClsName"];
    }
    model.TabID = [result objectForKey:@"TabID"];
    model.TabIDStr = [result objectForKey:@"TabIDStr"];
    model.flag = [result objectForKey:@"flag"];
    return model;
}

//[{"TabIDStr":"OEQwNjQ4QzI2MjY0MTAwRA","MsgContent":"我明明有传附件啊。。。","RecDate":"2015-02-02T08:29:56","JiaoBaoHao":0,"FBCount":0,"noReadCount":0},
//获取我发送的消息列表 new
+(NSMutableArray *)parserJsonGetMySendMsgList:(NSString *)json{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSArray *arrlist=[json objectFromJSONString];
    for (int i=0; i<arrlist.count; i++) {
        CommMsgListModel *model = [[CommMsgListModel alloc] init];
        NSDictionary *result = [arrlist objectAtIndex:i];
        model.TabIDStr = [result objectForKey:@"TabIDStr"];
        model.MsgContent = [result objectForKey:@"MsgContent"];
//        model.RecDate = [result objectForKey:@"RecDate"];
        NSString *str = [utils getLocalTimeDate];
        NSString *str2 = [result objectForKey:@"RecDate"];
        NSRange range = [str2 rangeOfString:str];
        if (range.length>0) {
            model.RecDate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringFromIndex:10];
        }else{
            model.RecDate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:10];
        }
        model.UserName = [dm getInstance].name;
        model.JiaoBaoHao = [dm getInstance].jiaoBaoHao;
        model.NoReadCount = [NSString stringWithFormat:@"%@",[result objectForKey:@"noReadCount"]];
        model.NoReplyCount = [NSString stringWithFormat:@"%@",[result objectForKey:@"FBCount"]];
        model.ReadFlag = [NSString stringWithFormat:@"%@",[result objectForKey:@"ReadFlag"]];
        model.flag = @"0";
        [array addObject:model];
    }
    return array;
}

//取发给我消息的用户列表。new
+(SendToMeUserListModel *)parserJsonSendToMeUserList:(NSString *)json{
   NSDictionary *result =[json objectFromJSONString];
    SendToMeUserListModel *model = [[SendToMeUserListModel alloc] init];
    model.LastID = [result objectForKey:@"LastID"];
    model.CommMsgList = [NSMutableArray arrayWithArray:[self parserJsonCommMsgList:[result objectForKey:@"CommMsgList"]]];
    return model;
}
//{"TabIDStr":"QkJGRDk1NDVDMDAzQUI4RA","MsgContent":"2015.2.8","RecDate":"2015-02-08T14:10:18","JiaoBaoHao":5150032,"NoReadCount":1,"NoReplyCount":2},
+(NSMutableArray *)parserJsonCommMsgList:(NSArray *)arrlist{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=0; i<arrlist.count; i++) {
        CommMsgListModel *model = [[CommMsgListModel alloc] init];
        NSDictionary *result = [arrlist objectAtIndex:i];
        model.TabIDStr = [result objectForKey:@"TabIDStr"];
        model.MsgContent = [result objectForKey:@"MsgContent"];
//        model.RecDate = [result objectForKey:@"RecDate"];
        NSString *str = [utils getLocalTimeDate];
        NSString *str2 = [result objectForKey:@"RecDate"];
        NSRange range = [str2 rangeOfString:str];
        if (range.length>0) {
            model.RecDate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringFromIndex:10];
        }else{
            model.RecDate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:10];
        }
        model.UserName = [result objectForKey:@"UserName"];
        model.JiaoBaoHao = [NSString stringWithFormat:@"%@",[result objectForKey:@"JiaoBaoHao"]];
        model.NoReadCount = [NSString stringWithFormat:@"%@",[result objectForKey:@"NoReadCount"]];
        model.NoReplyCount = [NSString stringWithFormat:@"%@",[result objectForKey:@"NoReplyCount"]];
        model.ReadFlag = [NSString stringWithFormat:@"%@",[result objectForKey:@"ReadFlag"]];
        model.flag = @"1";
        [array addObject:model];
    }
    return array;
}

@end
