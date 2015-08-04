//
//  ParserJson_knowledge.m
//  JiaoBao
//
//  Created by Zqw on 15/8/3.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "ParserJson_knowledge.h"
#import "NickNameModel.h"
#import "CategoryModel.h"

@implementation ParserJson_knowledge

//取系统中的省份信息
+(NSMutableArray *)parserJsonGetProvice:(NSString *)json{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *arrList = [json objectFromJSONString];
    for (int i=0; i<arrList.count; i++) {
        ProviceModel *model = [[ProviceModel alloc] init];
        NSDictionary *dic = [arrList objectAtIndex:i];
        model.CityCode = [dic objectForKey:@"CityCode"];
        model.CnName = [dic objectForKey:@"CnName"];
        [array addObject:model];
    }
    return array;
}

//通过昵称取用户教宝号
+(NSMutableArray *)parserJsonGetJiaoBaoHao:(NSString *)json
{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *arrList = [json objectFromJSONString];
    for(int i=0;i<arrList.count;i++)
    {
        NickNameModel *model = [[NickNameModel alloc ]init];
        NSDictionary *dic = [arrList objectAtIndex:i];
        model.NickName = [dic objectForKey:@"JiaoBaoHao"];
        model.JiaoBaoHao = [dic objectForKey:@"NickName"];
        [array addObject:model];
    }
    return array;
}

//取用户信息
+(UserInformationModel*)parserJsonGetUserInfo:(NSString *)json
{
    UserInformationModel *model = [[UserInformationModel alloc]init];
    NSDictionary *dic = [json objectFromJSONString];
    model.JiaoBaoHao = [dic objectForKey:@"JiaoBaoHao"];
    model.NickName = [dic objectForKey:@"NickName"];
    model.UserName = [dic objectForKey:@"UserName"];
    model.IdFlag = [dic objectForKey:@"IdFlag"];
    model.State = [dic objectForKey:@"State"];
    return model;
}

//取系统话题列表
+(NSMutableArray*)parserJsonGetCategory:(NSString *)json
{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *arrList = [json objectFromJSONString];
    for(int i=0;i<arrList.count;i++)
    {
        CategoryModel *model = [[CategoryModel alloc ]init];
        NSDictionary *dic = [arrList objectAtIndex:i];
        model.TabID = [dic objectForKey:@"TabID"];
        model.Subject = [dic objectForKey:@"Subject"];
        model.ParentId = [dic objectForKey:@"ParentId"];
        model.LogoPath = [dic objectForKey:@"LogoPath"];
        model.Description = [dic objectForKey:@"Description"];
        model.QCount = [dic objectForKey:@"QCount"];
        model.AttCount = [dic objectForKey:@"AttCount"];
        [array addObject:model];
    }
    return array;
}
//获取单一话题
+(CategoryModel*)parserJsonGetCategoryById:(NSString*)json
{
    NSDictionary *dic = [json objectFromJSONString];
    CategoryModel *model = [[CategoryModel alloc ]init];
    model.TabID = [dic objectForKey:@"TabID"];
    model.Subject = [dic objectForKey:@"Subject"];
    model.ParentId = [dic objectForKey:@"ParentId"];
    model.LogoPath = [dic objectForKey:@"LogoPath"];
    model.Description = [dic objectForKey:@"Description"];
    model.QCount = [dic objectForKey:@"QCount"];
    model.AttCount = [dic objectForKey:@"AttCount"];
    return model;
}


@end
