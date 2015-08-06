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
#import "QuestionModel.h"
#import "AnswerModel.h"
#import "AllCategoryModel.h"
#import "SubItemModel.h"
#import "ItemModel.h"
#import "QuestionIndexModel.h"
#import "AnswerByIdModel.h"

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

//取所有话题
+(NSMutableArray*)parserJsonGetAllCategory:(NSString*)json
{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *arrList = [json objectFromJSONString];
    for(int i=0;i<arrList.count;i++)
    {
        
        NSDictionary *dic = [arrList objectAtIndex:i];
        AllCategoryModel *allCategoryModel = [[AllCategoryModel alloc]init];
        //item
        allCategoryModel.item = [[ItemModel alloc]init];
        allCategoryModel.item.TabID = [dic objectForKey:@"TabID"];
        allCategoryModel.item.Subject = [dic objectForKey:@"Subject"];
        allCategoryModel.item.QCount = [dic objectForKey:@"QCount"];
        allCategoryModel.item.AttCount = [dic objectForKey:@"AttCount"];
        allCategoryModel.item.ParentId = [dic objectForKey:@"ParentId"];
        //subItem
        NSArray *arr = [dic objectForKey:@"subitem"];
        for(int i=0;i<arr.count;i++)
        {
            NSDictionary *subDic = [arr objectAtIndex:i];
            allCategoryModel.subitem = [[ItemModel alloc]init];
            allCategoryModel.subitem.TabID = [subDic objectForKey:@"TabID"];
            allCategoryModel.subitem.Subject = [subDic objectForKey:@"Subject"];
            allCategoryModel.subitem.QCount = [subDic objectForKey:@"QCount"];
            allCategoryModel.subitem.AttCount = [subDic objectForKey:@"AttCount"];
            allCategoryModel.subitem.ParentId = [subDic objectForKey:@"ParentId"];
            [allCategoryModel.mArr_subItem addObject:allCategoryModel.subitem];
            
        }

        [array addObject:allCategoryModel];
    }
    return array;
    
}
//问题列表
+(NSMutableArray*)parserJsonQuestionIndex:(NSString*)json
{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *arrList = [json objectFromJSONString];
    for(int i=0;i<arrList.count;i++)
    {
        QuestionIndexModel *model = [[QuestionIndexModel alloc ]init];
        NSDictionary *dic = [arrList objectAtIndex:i];
        model.TabID = [dic objectForKey:@"TabID"];
        model.Title = [dic objectForKey:@"Title"];
        model.Abstracts = [dic objectForKey:@"Abstracts"];
        model.ViewCount = [dic objectForKey:@"ViewCount"];
        model.LastUpdate = [dic objectForKey:@"LastUpdate"];
        model.AnswersCount = [dic objectForKey:@"AnswersCount"];
        model.Thumbnail = [dic objectForKey:@"Thumbnail"];
        [array addObject:model];
    }
    return array;
}

//问题明细
+(QuestionDetailModel*)parserJsonQuestionDetail:(NSString*)json
{
    NSDictionary *dic = [json objectFromJSONString];
    QuestionDetailModel *model = [[QuestionDetailModel alloc ]init];
    model.TabID = [dic objectForKey:@"TabID"];
    model.Title = [dic objectForKey:@"Title"];
    model.Abstracts = [dic objectForKey:@"Abstracts"];
    model.ViewCount = [dic objectForKey:@"ViewCount"];
    model.LastUpdate = [dic objectForKey:@"LastUpdate"];
    model.AnswersCount = [dic objectForKey:@"AnswersCount"];
    model.Thumbnail = [dic objectForKey:@"Thumbnail"];
    model.KnContent = [dic objectForKey:@"KnContent"];
    model.AreaCode = [dic objectForKey:@"AreaCode"];
    model.AtAccIds = [dic objectForKey:@"AtAccIds"];
    return model;
}

//获取问题的答案列表
+(NSMutableArray*)parserJsonGetAnswerById:(NSString*)json
{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *arrList = [json objectFromJSONString];
    for(int i=0;i<arrList.count;i++)
    {
        AnswerByIdModel *model = [[AnswerByIdModel alloc ]init];
        NSDictionary *dic = [arrList objectAtIndex:i];
        model.TabID = [dic objectForKey:@"TabID"];
        model.JiaoBaoHao = [dic objectForKey:@"JiaoBaoHao"];
        model.QId = [dic objectForKey:@"QId"];
        model.RecDate = [dic objectForKey:@"RecDate"];
        model.ATitle = [dic objectForKey:@"ATitle"];
        model.CCount = [dic objectForKey:@"CCount"];
        model.LikeCount = [dic objectForKey:@"LikeCount"];
        model.CCount = [dic objectForKey:@"CCount"];
        model.Flag = [dic objectForKey:@"Flag"];
        model.Abstracts = [dic objectForKey:@"Abstracts"];
        model.Thumbnail = [dic objectForKey:@"Thumbnail"];
        model.IdFlag = [dic objectForKey:@"IdFlag"];
        [array addObject:model];
    }
    return array;
}






//首页问题列表和话题的问题列表
+(NSMutableArray*)parserJsonCategoryIndexQuestion:(NSString*)json
{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *arrList = [json objectFromJSONString];
    for(int i=0;i<arrList.count;i++)
    {
        QuestionModel *model = [[QuestionModel alloc ]init];
        NSDictionary *dic = [arrList objectAtIndex:i];
        model.TabID = [dic objectForKey:@"TabID"];
        model.Title = [dic objectForKey:@"Title"];
        model.AnswersCount = [dic objectForKey:@"AnswersCount"];
        model.AttCount = [dic objectForKey:@"AttCount"];
        model.ViewCount = [dic objectForKey:@"ViewCount"];
        model.CategorySuject = [dic objectForKey:@"CategorySuject"];
        model.CategoryId = [dic objectForKey:@"CategoryId"];
        model.LastUpdate = [dic objectForKey:@"LastUpdate"];
        model.AreaCode = [dic objectForKey:@"AreaCode"];
        model.JiaoBaoHao = [dic objectForKey:@"JiaoBaoHao"];
        model.rowCount = [dic objectForKey:@"rowCount"];
        
        NSDictionary *answerDic =  [dic objectForKey:@"answer"];
        model.answerModel = [[AnswerModel alloc]init];
        model.answerModel.ATitle = [answerDic objectForKey:@"ATitle"];
        model.answerModel.Abstracts = [answerDic objectForKey:@"Abstracts"];
        model.answerModel.AFlag = [answerDic objectForKey:@"AFlag"];
        model.answerModel.TabID = [answerDic objectForKey:@"TabID"];
        model.answerModel.RecDate = [answerDic objectForKey:@"RecDate"];
        model.answerModel.LikeCount = [answerDic objectForKey:@"LikeCount"];
        model.answerModel.CaiCount = [answerDic objectForKey:@"CaiCount"];
        model.answerModel.JiaoBaoHao = [answerDic objectForKey:@"JiaoBaoHao"];
        model.answerModel.IdFlag = [answerDic objectForKey:@"IdFlag"];
        if([answerDic objectForKey:@"Thumbnail"])
        {
            model.answerModel.Thumbnail = [answerDic objectForKey:@"Thumbnail"];

            
        }

        [array addObject:model];
    }
    
    return array;
    
}


@end
