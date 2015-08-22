//
//  ParserJson_show.m
//  JiaoBao
//
//  Created by Zqw on 14-12-13.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "ParserJson_show.h"
#import "UpdateUnitListModel.h"

@implementation ParserJson_show

//取最新更新文章单位信息
//[{"TabIDStr":"OENFNDBBQjNBMzhCRjAwQg","ClassIDStr":"NDJENERBMDkwMDA3QzI5QQ","UnitID":997,"UintName":"金视野测试教育局","UnitClassID":0,"ClsName":null,"pubDate":"2014-12-13T17:18:46","Title":"“爸爸，我为什么要上学？”爸爸最接地气的回答！"},
//[{"TabIDStr":"NDJENERBMDkwMDA3QzI5QQ","ClassIDStr":"MTRGOTQzODVBMzc2ODYwMQ","UnitID":0,"UintName":null,"UnitClassID":45820,"ClsName":"美食","pubDate":"2014-12-16T15:27:49","Title":"传统点心——豆沙菊花酥 "},
+(NSMutableArray *)parserJsonUpdateUnitList:(NSString *)json{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *arrList = [json objectFromJSONString];
    for (int i=0; i<arrList.count; i++) {
        UpdateUnitListModel *model = [[UpdateUnitListModel alloc] init];
        NSDictionary *dic = [arrList objectAtIndex:i];
        model.TabIDStr = [dic objectForKey:@"TabIDStr"];
        model.UnitClassID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"UnitClassID"]];
        NSString *claName = [dic objectForKey:@"ClsName"];
        if ([claName isEqual:[NSNull null]]||[claName isEqual:@"<null>"]) {
            model.ClsName = @"";
        }else{
            model.ClsName = claName;
        }
        NSString *str = [utils getLocalTimeDate];
        NSString *str2 = [dic objectForKey:@"pubDate"];
        NSRange range = [str2 rangeOfString:str];
        if (range.length>0) {
            model.pubDate = [[[dic objectForKey:@"pubDate"] stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringFromIndex:10];
        }else{
            model.pubDate = [[[dic objectForKey:@"pubDate"] stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:10];
        }
        model.Title = [dic objectForKey:@"Title"];
        model.UnitID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"UnitID"]];
        if ([model.UnitID intValue]==0) {
            model.UnitID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"UnitClassID"]];
        }
        model.UintName = [dic objectForKey:@"UintName"];
        if ([model.UintName isEqual:[NSNull null]]) {
            model.UintName = [dic objectForKey:@"ClsName"];
            model.unitType = [dic objectForKey:@"UnitType"];;
        }else{
            model.unitType = [dic objectForKey:@"UnitType"];;
        }
        model.ClassIDStr = [dic objectForKey:@"ClassIDStr"];
        [array addObject:model];
    }
    return array;
}

//[{"TabID":87,"CreateByjiaobaohao":5150001,"nameStr":"单位相册","DesInfo":null,"ViewType":0,"UnitID":1070}]
//获取单位相册
+(NSMutableArray *)parserJsonGetUnitPGroup:(NSString *)json{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *arrList = [json objectFromJSONString];
    for (int i=0; i<arrList.count; i++) {
        UnitAlbumsModel *model = [[UnitAlbumsModel alloc] init];
        NSDictionary *dic = [arrList objectAtIndex:i];
        model.nameStr = [dic objectForKey:@"nameStr"];
        model.DesInfo = [dic objectForKey:@"DesInfo"];
        model.ViewType = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ViewType"]];
        model.UnitID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"UnitID"]];
        model.CreateByjiaobaohao = [NSString stringWithFormat:@"%@",[dic objectForKey:@"CreateByjiaobaohao"]];
        model.TabID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"TabID"]];
        [array addObject:model];
    }
    return array;
}

//[{"TabID":"4078","CreateByjiaobaohao":"5150001","SMPhotoPath":"http://localhost:5057//UploadPhotoOfUnit/20141125/5150001/20141125213805d417_IMG_1792.jpg","BIGPhotoPath":"http://localhost:5057//UploadPhotoOfUnitBig/20141125/5150001/20141125213805d417_IMG_1792.jpg","PhotoDescribe":""}
//获取单位相册的照片，
+(NSMutableArray *)parserJsonGetUnitPhotoByGroupID:(NSString *)json{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *arrList = [json objectFromJSONString];
    for (int i=0; i<arrList.count; i++) {
        UnitAlbumsListModel *model = [[UnitAlbumsListModel alloc] init];
        NSDictionary *dic = [arrList objectAtIndex:i];
        model.TabID = [dic objectForKey:@"TabID"];
        model.CreateByjiaobaohao = [dic objectForKey:@"CreateByjiaobaohao"];
        //对url进行编码
        model.SMPhotoPath = [[dic objectForKey:@"SMPhotoPath"] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
//        model.SMPhotoPath = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//                                                                                       (CFStringRef)[dic objectForKey:@"SMPhotoPath"],
//                                                                                       NULL,
//                                                                                       NULL,
//                                                                                       kCFStringEncodingUTF8));
        model.BIGPhotoPath = [[dic objectForKey:@"BIGPhotoPath"] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        
        model.PhotoDescribe = [dic objectForKey:@"PhotoDescribe"];
        [array addObject:model];
    }
    return array;
}

//[{"ID":"NDJENERBMDkwMDA3QzI5QQ","GroupName":"我的相册"},{"ID":"M0NFODU0RjFDRThDM0Q1Mw","GroupName":"手机相册"}]
//获取个人相册
+(NSMutableArray *)parserJsonGetPhotoList:(NSString *)json{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *arrList = [json objectFromJSONString];
    for (int i=0; i<arrList.count; i++) {
        PersonPhotoModel *model = [[PersonPhotoModel alloc] init];
        NSDictionary *dic = [arrList objectAtIndex:i];
        model.ID = [dic objectForKey:@"ID"];
        model.GroupName = [dic objectForKey:@"GroupName"];
        [array addObject:model];
    }
    return array;
}

//[{"CreateByjiaobaohao":"5182507","InterestUnitID":"3277","CreateDatetime":"2014/12/18 11:57:10","GroupID":"0","unitName":"海口市琼山第五小学","unitType":"2","isInUnit":"False","isAdmin":"False"},
//解析我关注的单位
+(NSMutableArray *)parserJsonGetMyAttUnit:(NSString *)json{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *arrList = [json objectFromJSONString];
    for (int i=0; i<arrList.count; i++) {
        MyAttUnitModel *model = [[MyAttUnitModel alloc] init];
        NSDictionary *dic = [arrList objectAtIndex:i];
//        model.CreateDatetime = [[dic objectForKey:@"CreateDatetime"] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        NSString *str = [utils getLocalTimeDate];
        NSString *str2 = [dic objectForKey:@"pubDate"];
        NSRange range = [str2 rangeOfString:str];
        if (range.length>0) {
            model.CreateDatetime = [[[dic objectForKey:@"CreateDatetime"] stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringFromIndex:10];
        }else{
            model.CreateDatetime = [[[dic objectForKey:@"CreateDatetime"] stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:10];
        }
        model.TabID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"TabID"]];
        model.CreateByjiaobaohao = [NSString stringWithFormat:@"%@",[dic objectForKey:@"CreateByjiaobaohao"]];
        model.InterestUnitID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"InterestUnitID"]];
        model.GroupID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"GroupID"]];
        model.TypeInfo = [NSString stringWithFormat:@"%@",[dic objectForKey:@"TypeInfo"]];
        NSString *name = [dic objectForKey:@"unitName"];
        if (name.length>0) {
            model.unitName = name;
        }else{
            model.unitName = @"未知";
        }
        
        model.unitType = [dic objectForKey:@"unitType"];
        model.isInUnit = [dic objectForKey:@"isInUnit"];
        model.isAdmin = [dic objectForKey:@"isAdmin"];
        [array addObject:model];
    }
    return array;
}

@end
