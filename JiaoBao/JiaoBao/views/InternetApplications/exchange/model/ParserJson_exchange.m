//
//  ParserJson_exchange.m
//  JiaoBao
//
//  Created by Zqw on 14-12-2.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "ParserJson_exchange.h"

@implementation ParserJson_exchange

//[{"GroupID":74,"GroupName":"总部支撑","HideSign":0,"UnitID":998},
//获取单位所有分组
+(NSMutableArray *)parserJsonUnitGroupsWith:(NSString *)json{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *arrList = [json objectFromJSONString];
    for (int i=0; i<arrList.count; i++) {
        ExchangeUnitGroupsModel *model = [[ExchangeUnitGroupsModel alloc] init];
        NSDictionary *dic = [arrList objectAtIndex:i];
        model.GroupName = [dic objectForKey:@"GroupName"];
        model.GroupID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"GroupID"]];
        if (model.GroupID.length==0||[model.GroupID isEqual:[NSNull null]]||[model.GroupID isEqual:@"(null)"]) {
            model.GroupID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ID"]];
        }
        model.HideSign = [NSString stringWithFormat:@"%@",[dic objectForKey:@"HideSign"]];
        model.UnitID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"UnitID"]];
        [array addObject:model];
    }
    return array;
}

//[{"isAdmin":1,"UserID":20,"UserName":"马文彬","AccID":5150028,"GroupFlag":"0,43"},
//单位内所有用户
+(NSMutableArray *)parserJsonUserInfoByUnitIDWith:(NSString *)json{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *arrList = [json objectFromJSONString];
    for (int i=0; i<arrList.count; i++) {
        UserInfoByUnitIDModel *model = [[UserInfoByUnitIDModel alloc] init];
        NSDictionary *dic = [arrList objectAtIndex:i];
        model.UserName = [dic objectForKey:@"UserName"];
        if (model.UserName.length==0) {
            model.UserName = [dic objectForKey:@"namestr"];
        }
        model.isAdmin = [NSString stringWithFormat:@"%@",[dic objectForKey:@"isAdmin"]];
        model.UserID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"UserID"]];
        model.AccID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"AccID"]];
        if (model.AccID.length == 0||[model.AccID isEqual:@"(null)"]) {
            model.AccID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"Friendjiaobaohao"]];
        }
        NSMutableArray *arr = (NSMutableArray *)[[dic objectForKey:@"GroupFlag"] componentsSeparatedByString:@","];
        //给分组去重
        NSSet *set = [NSSet setWithArray:arr];
        model.GroupFlag = [NSMutableArray arrayWithArray:[set allObjects]];
        [array addObject:model];
    }
    return array;
}

//{"code":200,"userId":"jb_5150028","token":"KZbXampHeMdkvrB7yCfLD/23Y81mtDc0PdpjyOVwFQZkdUCsLJkn/s3gY4Mny/3u1A0vHB0ewJRfFuWR8fDDa5gqRf8kheZj"}
//解析融云网络用户token
+(RongYunTokenModel *)parserJsonGetRongYunTokenWith:(NSString *)json{
    RongYunTokenModel *model = [[RongYunTokenModel alloc] init];
    NSDictionary *dic = [json objectFromJSONString];
    model.userId = [dic objectForKey:@"userId"];
    model.token = [dic objectForKey:@"token"];
    model.code = [NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
    return model;
}

//[{"ID":"0","GroupName":"我的好友"},{"ID":"1","GroupName":"同事"}]
//获取自己的好友分组
+(NSMutableArray *)parserJsonMyFriendsGroups:(NSString *)json{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *arrList = [json objectFromJSONString];
    for (int i=0; i<arrList.count; i++) {
        MyFriendsGroupsModel *model = [[MyFriendsGroupsModel alloc] init];
        NSDictionary *dic = [arrList objectAtIndex:i];
        model.ID = [dic objectForKey:@"ID"];
        model.GroupName = [dic objectForKey:@"GroupName"];
        [array addObject:model];
    }
    return array;
}

@end
