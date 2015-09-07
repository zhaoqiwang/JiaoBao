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
#import "Loger.h"
#import "AnswerDetailModel.h"
#import "commentListModel.h"
#import "utils.h"

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
        model.NickName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"NickName"]];
        model.JiaoBaoHao = [dic objectForKey:@"JiaoBaoHao"];
        [array addObject:model];
    }
    return array;
}

//取用户信息
+(UserInformationModel*)parserJsonGetUserInfo:(NSString *)json
{
    UserInformationModel *model = [[UserInformationModel alloc]init];
    NSDictionary *dic = [json objectFromJSONString];
    model.JiaoBaoHao = [NSString stringWithFormat:@"%@",[dic objectForKey:@"JiaoBaoHao"]];
    model.NickName = [dic objectForKey:@"NickName"];
    model.UserName = [dic objectForKey:@"UserName"];
    model.IdFlag = [dic objectForKey:@"IdFlag"];
    if (model.IdFlag.length==0) {
        model.IdFlag = @"匿名回答";
        model.JiaoBaoHao = @"";
    }
    model.State = [NSString stringWithFormat:@"%@",[dic objectForKey:@"State"]];
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
        model.TabID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"TabID"]];
                model.Subject = [dic objectForKey:@"Subject"];
        model.ParentId = [dic objectForKey:@"ParentId"];
        model.LogoPath = [dic objectForKey:@"LogoPath"];
        model.Description = [dic objectForKey:@"Description"];
        model.QCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"QCount"]];
        model.AttCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"AttCount"]];
        [array addObject:model];
    }
    return array;
}
//获取单一话题
+(CategoryModel*)parserJsonGetCategoryById:(NSString*)json
{
    NSDictionary *dic = [json objectFromJSONString];
    CategoryModel *model = [[CategoryModel alloc ]init];
    model.TabID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"TabID"]];
    model.Subject = [dic objectForKey:@"Subject"];
    model.ParentId = [dic objectForKey:@"ParentId"];
    model.LogoPath = [dic objectForKey:@"LogoPath"];
    model.Description = [dic objectForKey:@"Description"];
    model.QCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"QCount"]];
    model.AttCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"AttCount"]];
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
        NSDictionary *tempDic = [dic objectForKey:@"item"];
        //item
        allCategoryModel.item.TabID = [NSString stringWithFormat:@"%@",[tempDic objectForKey:@"TabID"]];
        allCategoryModel.item.Subject = [tempDic objectForKey:@"Subject"];
        allCategoryModel.item.QCount = [NSString stringWithFormat:@"%@",[tempDic objectForKey:@"QCount"]];
        allCategoryModel.item.AttCount = [NSString stringWithFormat:@"%@",[tempDic objectForKey:@"AttCount"]];
        allCategoryModel.item.ParentId = [NSString stringWithFormat:@"%@",[tempDic objectForKey:@"ParentId"]];
        //subItem
        NSArray *arr = [dic objectForKey:@"subitem"];
        for(int i=0;i<arr.count;i++)
        {
            NSDictionary *subDic = [arr objectAtIndex:i];
            ItemModel*  subitem = [[ItemModel alloc]init];

            subitem.TabID = [NSString stringWithFormat:@"%@",[subDic objectForKey:@"TabID"]];
            subitem.Subject = [subDic objectForKey:@"Subject"];
            subitem.QCount = [NSString stringWithFormat:@"%@",[subDic objectForKey:@"QCount"]];
            subitem.AttCount = [NSString stringWithFormat:@"%@",[subDic objectForKey:@"AttCount"]];
            subitem.ParentId = [NSString stringWithFormat:@"%@",[subDic objectForKey:@"ParentId"]];
            [allCategoryModel.mArr_subItem addObject:subitem];
            
        }

        [array addObject:allCategoryModel];
    }
    return array;
    
}
//问题列表
+(NSMutableArray*)parserJsonQuestionIndex:(NSString*)json
{
    D("sdfiughldol-====%@",json);
    NSMutableArray *array = [NSMutableArray array];
    NSArray *arrList = [json objectFromJSONString];
    for(int i=0;i<arrList.count;i++)
    {
        QuestionIndexModel *model = [[QuestionIndexModel alloc ]init];
        NSDictionary *dic = [arrList objectAtIndex:i];
        model.TabID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"TabID"]];
        model.Title = [dic objectForKey:@"Title"];
        model.Abstracts = [dic objectForKey:@"Abstracts"];
        model.ViewCount = [dic objectForKey:@"ViewCount"];
        model.LastUpdate = [dic objectForKey:@"LastUpdate"];
        NSString *str = [utils getLocalTimeDate];
        NSString *str2 = [dic objectForKey:@"LastUpdate"];
        NSRange range = [str2 rangeOfString:str];
        if (range.length>0) {
            model.LastUpdate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringFromIndex:10];
        }else{
            model.LastUpdate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:10];
        }
        model.AnswersCount = [dic objectForKey:@"AnswersCount"];
        NSString *Thumbnail = [dic objectForKey:@"Thumbnail"];
        if ([Thumbnail isKindOfClass:[NSNull class]]||[Thumbnail isEqual:@"null"]) {
            
        }else{
            NSArray *temp = [Thumbnail objectFromJSONString];
            model.Thumbnail = [NSMutableArray arrayWithArray:temp];
        }
        [array addObject:model];
    }
    return array;
}

//{"Tag":0,"NickName":"mo5150022","TabID":342,"JiaoBaoHao":5150022,"Title":"哪些知识、技能、能力是一定要掌握的","KnContent":"<h2 class=\"zm-item-title zm-editable-content\">哪些知识、技能、能力是一定要掌握的</h2><p><br/></p>","QFlag":1,"RecDate":"2015-09-05T21:41:03","CategoryId":15,"TagsList":null,"State":1,"ViewCount":81,"AnswersCount":1,"LastUpdate":"2015-09-07T09:43:59","Abstracts":"哪些知识、技能、能力是一定要掌握的","Thumbnail":null,"AreaCode":"","AtAccIds":"","AttCount":1,"FactSign":1}
//问题明细
+(QuestionDetailModel*)parserJsonQuestionDetail:(NSString*)json
{
    D("soiudhgousdh-====%@",json);
    NSDictionary *dic = [json objectFromJSONString];
    QuestionDetailModel *model = [[QuestionDetailModel alloc ]init];
    model.TabID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"TabID"]];
    model.Title = [dic objectForKey:@"Title"];
    model.Abstracts = [dic objectForKey:@"Abstracts"];
    model.ViewCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ViewCount"]];
    model.LastUpdate = [dic objectForKey:@"LastUpdate"];
    NSString *str = [utils getLocalTimeDate];
    NSString *str2 = [dic objectForKey:@"LastUpdate"];
    NSRange range = [str2 rangeOfString:str];
    if (range.length>0) {
        model.LastUpdate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringFromIndex:10];
    }else{
        model.LastUpdate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:10];
    }
    model.AnswersCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"AnswersCount"]];
    NSString *Thumbnail = [dic objectForKey:@"Thumbnail"];
    if ([Thumbnail isKindOfClass:[NSNull class]]||[Thumbnail isEqual:@"null"]) {
        
    }else{
        NSArray *temp = [Thumbnail objectFromJSONString];
        model.Thumbnail = [NSMutableArray arrayWithArray:temp];
    }
    model.KnContent = [dic objectForKey:@"KnContent"];
    model.AreaCode = [dic objectForKey:@"AreaCode"];
    model.AtAccIds = [dic objectForKey:@"AtAccIds"];
    
    model.Tag = [NSString stringWithFormat:@"%@",[dic objectForKey:@"Tag"]];
    model.NickName = [dic objectForKey:@"NickName"];
    model.JiaoBaoHao = [NSString stringWithFormat:@"%@",[dic objectForKey:@"JiaoBaoHao"]];
    model.QFlag = [NSString stringWithFormat:@"%@",[dic objectForKey:@"QFlag"]];
    NSString *str3 = [dic objectForKey:@"RecDate"];
    NSRange range3 = [str3 rangeOfString:str];
    if (range3.length>0) {
        model.RecDate = [[str3 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringFromIndex:10];
    }else{
        model.RecDate = [[str3 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:10];
    }
    model.CategoryId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"CategoryId"]];
    model.TagsList = [[dic objectForKey:@"TagsList"] objectFromJSONString];
    model.State = [NSString stringWithFormat:@"%@",[dic objectForKey:@"State"]];
    model.AttCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"AttCount"]];
    model.FactSign = [NSString stringWithFormat:@"%@",[dic objectForKey:@"FactSign"]];
    
    return model;
}

//获取问题的答案列表
+(NSMutableArray*)parserJsonGetAnswerById:(NSString*)json
{
    D("sldhghgrhjlksjd-=====%@",json);
    NSMutableArray *array = [NSMutableArray array];
    NSArray *arrList = [json objectFromJSONString];
    for(int i=0;i<arrList.count;i++)
    {
        AnswerByIdModel *model = [[AnswerByIdModel alloc ]init];
        NSDictionary *dic = [arrList objectAtIndex:i];
        model.TabID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"TabID"]];
        model.JiaoBaoHao = [NSString stringWithFormat:@"%@",[dic objectForKey:@"JiaoBaoHao"]];
        model.QId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"QId"]];
        model.RecDate = [dic objectForKey:@"RecDate"];
        NSString *str = [utils getLocalTimeDate];
        NSString *str2 = [dic objectForKey:@"RecDate"];
        NSRange range = [str2 rangeOfString:str];
        if (range.length>0) {
            model.RecDate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringFromIndex:10];
        }else{
            model.RecDate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:10];
        }
        model.ATitle = [dic objectForKey:@"ATitle"];
        model.CCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"CCount"]];
        model.LikeCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"LikeCount"]];
        model.CaiCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"CaiCount"]];
        model.Flag = [NSString stringWithFormat:@"%@",[dic objectForKey:@"Flag"]];
        model.Abstracts = [dic objectForKey:@"Abstracts"];
//        model.Thumbnail = [dic objectForKey:@"Thumbnail"];
        NSString *Thumbnail = [dic objectForKey:@"Thumbnail"];
        if ([Thumbnail isKindOfClass:[NSNull class]]||[Thumbnail isEqual:@"null"]) {
            
        }else{
            NSArray *temp = [Thumbnail objectFromJSONString];
            model.Thumbnail = [NSMutableArray arrayWithArray:temp];
        }
        model.IdFlag = [dic objectForKey:@"IdFlag"];
        if (model.IdFlag.length==0) {
            model.IdFlag = @"匿名回答";
            model.JiaoBaoHao = @"";
        }
        [array addObject:model];
    }
    return array;
}

//答案明细
+(AnswerDetailModel*)parserJsonAnswerDetail:(NSString*)json
{
    D("fd;'osgjr;a'sdgj';a-====%@",json);
    AnswerDetailModel *model = [[AnswerDetailModel alloc ]init];
    NSDictionary *dic = [json objectFromJSONString];
    model.TabID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"TabID"]];
    model.JiaoBaoHao = [NSString stringWithFormat:@"%@",[dic objectForKey:@"JiaoBaoHao"]];
    model.QId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"QId"]];
    model.RecDate = [dic objectForKey:@"RecDate"];
    NSString *str = [utils getLocalTimeDate];
    NSString *str2 = [dic objectForKey:@"RecDate"];
    NSRange range = [str2 rangeOfString:str];
    if (range.length>0) {
        model.RecDate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringFromIndex:10];
    }else{
        model.RecDate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:10];
    }
    model.ATitle = [dic objectForKey:@"ATitle"];
    model.CCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"CCount"]];
    model.LikeCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"LikeCount"]];
    model.CaiCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"CaiCount"]];
    model.LikeList = [NSString stringWithFormat:@"%@",[dic objectForKey:@"LikeList"]];
    model.Flag = [NSString stringWithFormat:@"%@",[dic objectForKey:@"Flag"]];
    model.Abstracts = [dic objectForKey:@"Abstracts"];
    NSString *Thumbnail = [dic objectForKey:@"Thumbnail"];
    if ([Thumbnail isKindOfClass:[NSNull class]]||[Thumbnail isEqual:@"null"]) {
        
    }else{
        NSArray *temp = [Thumbnail objectFromJSONString];
        model.Thumbnail = [NSMutableArray arrayWithArray:temp];
    }
    model.IdFlag = [dic objectForKey:@"IdFlag"];
    if (model.IdFlag.length==0) {
        model.IdFlag = @"匿名回答";
        model.JiaoBaoHao = @"";
    }
    model.AContent = [dic objectForKey:@"AContent"];
    return model;
}
//评论列表
+(AllCommentListModel *)parserJsonCommentsList:(NSString*)json
{
    D("json_____ = %@",json);
    AllCommentListModel *model = [[AllCommentListModel alloc ]init];
    NSDictionary *dic = [json objectFromJSONString];
    
    NSMutableArray *mArr_commentsList = [dic objectForKey:@"commentsList"];
    for(int i=0;i<mArr_commentsList.count;i++)
    {
        commentListModel*subModel = [[commentListModel alloc]init];
        NSDictionary *subDic = [mArr_commentsList objectAtIndex:i];
        subModel.TabID = [NSString stringWithFormat:@"%@",[subDic objectForKey:@"TabID"]];
        subModel.JiaoBaoHao = [NSString stringWithFormat:@"%@",[subDic objectForKey:@"JiaoBaoHao"]];
        subModel.Number = [subDic objectForKey:@"Number"];
        subModel.RefIds = [subDic objectForKey:@"RefIds"];
        subModel.RecDate = [subDic objectForKey:@"RecDate"];
        subModel.TabIDStr = [subDic objectForKey:@"TabIDStr"];
        NSString *str = [utils getLocalTimeDate];
        NSString *str2 = [subDic objectForKey:@"RecDate"];
        NSRange range = [str2 rangeOfString:str];
        if (range.length>0) {
            subModel.RecDate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringFromIndex:10];
        }else{
            subModel.RecDate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:10];
        }
        subModel.CaiCount = [NSString stringWithFormat:@"%@",[subDic objectForKey:@"CaiCount"]];
        subModel.LikeCount = [NSString stringWithFormat:@"%@",[subDic objectForKey:@"LikeCount"]];
        subModel.WContent = [subDic objectForKey:@"WContent"];
        NSString *userName = [subDic objectForKey:@"UserName"];
        if( [userName isKindOfClass:[NSNull class]]||[userName isEqual:@"null"])
        {
            subModel.UserName = @"";

        }
        else
        {
            subModel.UserName = [subDic objectForKey:@"UserName"];

        }
        [model.mArr_CommentList addObject:subModel];
    }
    
    NSMutableArray *mArr_refcomments = [dic objectForKey:@"refcomments"];
    for(int i=0;i<mArr_refcomments.count;i++)
    {
        commentListModel *subModel = [[commentListModel alloc]init];
        NSDictionary *subDic = [mArr_refcomments objectAtIndex:i];
        subModel.TabID = [NSString stringWithFormat:@"%@",[subDic objectForKey:@"TabID"]];
        subModel.JiaoBaoHao = [NSString stringWithFormat:@"%@",[subDic objectForKey:@"JiaoBaoHao"]];
        subModel.RecDate = [subDic objectForKey:@"RecDate"];
        NSString *str = [utils getLocalTimeDate];
        NSString *str2 = [dic objectForKey:@"RecDate"];
        NSRange range = [str2 rangeOfString:str];
        if (range.length>0) {
            subModel.RecDate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringFromIndex:10];
        }else{
            subModel.RecDate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:10];
        }
        subModel.CaiCount = [NSString stringWithFormat:@"%@",[subDic objectForKey:@"CaiCount"]];
        subModel.LikeCount = [NSString stringWithFormat:@"%@",[subDic objectForKey:@"LikeCount"]];
        subModel.WContent = [subDic objectForKey:@"WContent"];
        subModel.UserName = [subDic objectForKey:@"UserName"];
        subModel.TabIDStr = [subDic objectForKey:@"TabIDStr"];

        [model.mArr_refcomments addObject:subModel];
    }
    return model;


    
}
//{"TabID":133,"Title":"小于９０度的角都是锐角吗？","AnswersCount":1,"AttCount":0,"ViewCount":4,"CategorySuject":"小学数学","CategoryId":16,"LastUpdate":"2015-08-14T08:59:15","AreaCode":null,"JiaoBaoHao":5200750,"rowCount":109,"answer":{"ATitle":"在小学阶段，小于９０度的角都是锐角","Abstracts":"根据课标教材定义：小于９０度的角叫做锐角。答案似乎是肯定的，但由此又产生一个新的问题：０度的角是什么角，也是锐角吗？ 事实是，锐角定义有一个隐含的前提，就是小学数学中所讨论的角都是正角。习惯……","AFlag":0,"TabID":137,"RecDate":"2015-08-13T10:51:50","LikeCount":0,"CaiCount":0,"CCount":1,"JiaoBaoHao":5200750,"IdFlag":"郑召欣","Thumbnail":"[\"file:///C:/Users/ADMINI~1/AppData/Local/Temp/msohtml1/01/clip_image002.jpg\",\"http://www.jiaobao.net/JBApp3/AppFiles/getSectionFile?fn=7lui-ApUpS43Ck4kDlnxWomHYAnfD-AYyhxGY4e3Bcj-Ar82GGYeMuhZB9iO1BYG3FKPnJwGnSpIC0\"]"}},
//首页问题列表和话题的问题列表
+(NSMutableArray*)parserJsonCategoryIndexQuestion:(NSString*)json
{
    D("sdoighjdofk-====%@",json);
    NSMutableArray *array = [NSMutableArray array];
    NSArray *arrList = [json objectFromJSONString];
    for(int i=0;i<arrList.count;i++)
    {
        QuestionModel *model = [[QuestionModel alloc ]init];
        NSDictionary *dic = [arrList objectAtIndex:i];
        model.TabID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"TabID"]];
        model.Title = [dic objectForKey:@"Title"];
        model.AnswersCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"AnswersCount"]];
        model.AttCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"AttCount"]];
        model.ViewCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ViewCount"]];
        model.CategorySuject = [dic objectForKey:@"CategorySuject"];
        model.CategoryId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"CategoryId"]];
        NSString *str = [utils getLocalTimeDate];
        NSString *str0 = [dic objectForKey:@"LastUpdate"];
        NSRange range0 = [str0 rangeOfString:str];
        if (range0.length>0) {
            model.LastUpdate = [[str0 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringFromIndex:10];
        }else{
            model.LastUpdate = [[str0 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:10];
        }
        NSString *AreaCode = [dic objectForKey:@"AreaCode"];
        if ([AreaCode isKindOfClass:[NSNull class]]||[AreaCode isEqual:@"null"]) {
            model.AreaCode = @"";
        }else{
            model.AreaCode = [dic objectForKey:@"AreaCode"];
        }
        
        model.JiaoBaoHao = [NSString stringWithFormat:@"%@",[dic objectForKey:@"JiaoBaoHao"]];
        NSArray *temp0 = [[dic objectForKey:@"Thumbnail"] objectFromJSONString];
        model.Thumbnail = [NSMutableArray arrayWithArray:temp0];
        model.rowCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"rowCount"]];
        
        NSDictionary *answerDic =  [dic objectForKey:@"answer"];
        model.answerModel.ATitle = [answerDic objectForKey:@"ATitle"];
        model.answerModel.Abstracts = [answerDic objectForKey:@"Abstracts"];
        model.answerModel.AFlag = [NSString stringWithFormat:@"%@",[answerDic objectForKey:@"AFlag"]];
        model.answerModel.TabID = [NSString stringWithFormat:@"%@",[answerDic objectForKey:@"TabID"]];
        
        NSString *str2 = [answerDic objectForKey:@"RecDate"];
        NSRange range = [str2 rangeOfString:str];
        if (range.length>0) {
            model.answerModel.RecDate = [[[answerDic objectForKey:@"RecDate"] stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringFromIndex:10];
        }else{
            model.answerModel.RecDate = [[[answerDic objectForKey:@"RecDate"] stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:10];
        }
        model.answerModel.LikeCount = [NSString stringWithFormat:@"%@",[answerDic objectForKey:@"LikeCount"]];
        model.answerModel.Flag = [NSString stringWithFormat:@"%@",[answerDic objectForKey:@"Flag"]];
        model.answerModel.CaiCount = [NSString stringWithFormat:@"%@",[answerDic objectForKey:@"CaiCount"]];
        model.answerModel.JiaoBaoHao = [NSString stringWithFormat:@"%@",[answerDic objectForKey:@"JiaoBaoHao"]];
        model.answerModel.IdFlag = [answerDic objectForKey:@"IdFlag"];
        if (model.answerModel.IdFlag.length==0) {
             model.answerModel.IdFlag = @"匿名回答";
            model.answerModel.JiaoBaoHao = @"";
        }
        model.answerModel.CCount = [NSString stringWithFormat:@"%@",[answerDic objectForKey:@"CCount"]];
        NSString *Thumbnail = [answerDic objectForKey:@"Thumbnail"];
        if ([Thumbnail isKindOfClass:[NSNull class]]||[Thumbnail isEqual:@"null"]) {
            
        }else{
            NSArray *temp = [Thumbnail objectFromJSONString];
            model.answerModel.Thumbnail = [NSMutableArray arrayWithArray:temp];
        }

        [array addObject:model];
    }
    
    return array;
    
}

//[{"tabid":5,"question":{"TabID":98,"Title":"为什么人有时会出现「更容易向陌生人展示真实想法」的情况","AnswersCount":2,"AttCount":1,"ViewCount":36,"CategorySuject":"艺术","CategoryId":47,"LastUpdate":"2015-08-10T10:35:35","AreaCode":null,"Thumbnail":null,"JiaoBaoHao":5150022},"answer":{"ATitle":"因为熟人间的关系越来越工具化了。","Abstracts":"因为熟人间的关系越来越工具化了。 工具化的意思，就是具有明确的目的，关系为了特定的功能而存在。「他是什么角色？」「我为什么需要发展或维护这段关系？」「跟他交往可能给我带来哪些好处？」我们翻手……","AFlag":0,"TabID":89,"RecDate":"2015-08-10T10:35:35","LikeCount":0,"CaiCount":1,"JiaoBaoHao":5150001,"Thumbnail":null,"CCount":0,"IdFlag":"momo"},"rowCount":3},
//推荐列表
+(NSMutableArray *)parserJsonRecommentIndex:(NSString *)json{
    D("sdoighjdofk-====%@",json);
    NSMutableArray *array = [NSMutableArray array];
    NSArray *arrList = [json objectFromJSONString];
    for(int i=0;i<arrList.count;i++){
        QuestionModel *model = [[QuestionModel alloc ]init];
        NSDictionary *dic0 = [arrList objectAtIndex:i];
        model.tabid = [NSString stringWithFormat:@"%@",[dic0 objectForKey:@"tabid"]];
        NSDictionary *dic =  [dic0 objectForKey:@"question"];
        model.TabID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"TabID"]];
        model.Title = [dic objectForKey:@"Title"];
        model.AnswersCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"AnswersCount"]];
        model.AttCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"AttCount"]];
        model.ViewCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ViewCount"]];
        model.CategorySuject = [dic objectForKey:@"CategorySuject"];
        model.CategoryId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"CategoryId"]];
        NSString *str = [utils getLocalTimeDate];
        NSString *str0 = [dic objectForKey:@"LastUpdate"];
        NSRange range0 = [str0 rangeOfString:str];
        if (range0.length>0) {
            model.LastUpdate = [[str0 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringFromIndex:10];
        }else{
            model.LastUpdate = [[str0 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:10];
        }
        NSString *AreaCode = [dic objectForKey:@"AreaCode"];
        if ([AreaCode isKindOfClass:[NSNull class]]||[AreaCode isEqual:@"null"]) {
            model.AreaCode = @"";
        }else{
            model.AreaCode = [dic objectForKey:@"AreaCode"];
        }
        
        model.JiaoBaoHao = [NSString stringWithFormat:@"%@",[dic objectForKey:@"JiaoBaoHao"]];
        NSArray *temp0 = [[dic objectForKey:@"Thumbnail"] objectFromJSONString];
        model.Thumbnail = [NSMutableArray arrayWithArray:temp0];
        model.rowCount = [NSString stringWithFormat:@"%@",[dic0 objectForKey:@"rowCount"]];
        
        NSDictionary *answerDic =  [dic0 objectForKey:@"answer"];
        model.answerModel.ATitle = [answerDic objectForKey:@"ATitle"];
        model.answerModel.Abstracts = [answerDic objectForKey:@"Abstracts"];
        model.answerModel.AFlag = [NSString stringWithFormat:@"%@",[answerDic objectForKey:@"AFlag"]];
        model.answerModel.TabID = [NSString stringWithFormat:@"%@",[answerDic objectForKey:@"TabID"]];
        model.answerModel.Flag = [NSString stringWithFormat:@"%@",[answerDic objectForKey:@"Flag"]];
        NSString *str2 = [answerDic objectForKey:@"RecDate"];
        NSRange range = [str2 rangeOfString:str];
        if (range.length>0) {
            model.answerModel.RecDate = [[[answerDic objectForKey:@"RecDate"] stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringFromIndex:10];
        }else{
            model.answerModel.RecDate = [[[answerDic objectForKey:@"RecDate"] stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:10];
        }
        model.answerModel.LikeCount = [NSString stringWithFormat:@"%@",[answerDic objectForKey:@"LikeCount"]];
        model.answerModel.CaiCount = [NSString stringWithFormat:@"%@",[answerDic objectForKey:@"CaiCount"]];
        model.answerModel.JiaoBaoHao = [NSString stringWithFormat:@"%@",[answerDic objectForKey:@"JiaoBaoHao"]];
        model.answerModel.IdFlag = [answerDic objectForKey:@"IdFlag"];
        if (model.answerModel.IdFlag.length==0) {
            model.answerModel.IdFlag = @"匿名回答";
            model.answerModel.JiaoBaoHao = @"";
        }
        model.answerModel.CCount = [NSString stringWithFormat:@"%@",[answerDic objectForKey:@"CCount"]];
        NSString *Thumbnail = [answerDic objectForKey:@"Thumbnail"];
        if ([Thumbnail isKindOfClass:[NSNull class]]||[Thumbnail isEqual:@"null"]) {
            
        }else{
            NSArray *temp = [Thumbnail objectFromJSONString];
            model.answerModel.Thumbnail = [NSMutableArray arrayWithArray:temp];
        }
        
        [array addObject:model];
    }
    
    return array;
    
}

//推荐明细
+(RecommentAddAnswerModel *)parserJsonShowRecomment:(NSString *)json{
    RecommentAddAnswerModel *model = [[RecommentAddAnswerModel alloc]init];
    model.questionModel = [[RecommentQuestionModel alloc] init];
    NSDictionary *dic0 = [json objectFromJSONString];
    
    model.tabid = [NSString stringWithFormat:@"%@",[dic0 objectForKey:@"tabid"]];
    
    NSDictionary *dic =  [dic0 objectForKey:@"question"];
    model.questionModel.TabID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"TabID"]];
    model.questionModel.Title = [dic objectForKey:@"Title"];
    model.questionModel.AnswersCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"AnswersCount"]];
    model.questionModel.AttCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"TabID"]];
    model.questionModel.ViewCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ViewCount"]];
    model.questionModel.CategorySuject = [dic objectForKey:@"CategorySuject"];
    model.questionModel.KnContent = [dic objectForKey:@"KnContent"];
    model.questionModel.CategoryId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"CategoryId"]];
    NSString *str = [utils getLocalTimeDate];
    NSString *str0 = [dic objectForKey:@"LastUpdate"];
    NSRange range0 = [str0 rangeOfString:str];
    if (range0.length>0) {
        model.questionModel.LastUpdate = [[str0 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringFromIndex:10];
    }else{
        model.questionModel.LastUpdate = [[str0 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:10];
    }
    model.questionModel.AreaCode = [dic objectForKey:@"AreaCode"];
    model.questionModel.JiaoBaoHao = [NSString stringWithFormat:@"%@",[dic objectForKey:@"JiaoBaoHao"]];
    
    NSMutableArray *mArr_answer = [dic0 objectForKey:@"answers"];
    for(int i=0;i<mArr_answer.count;i++)
    {
        AnswerModel *answerModel = [[AnswerModel alloc]init];
        NSDictionary *answerDic =  [mArr_answer objectAtIndex:i];
        answerModel.ATitle = [answerDic objectForKey:@"ATitle"];
        answerModel.Abstracts = [answerDic objectForKey:@"AContent"];
        answerModel.AFlag = [NSString stringWithFormat:@"%@",[answerDic objectForKey:@"AFlag"]];
        answerModel.TabID = [NSString stringWithFormat:@"%@",[answerDic objectForKey:@"TabID"]];
        
        NSString *str2 = [answerDic objectForKey:@"RecDate"];
        NSRange range = [str2 rangeOfString:str];
        if (range.length>0) {
            answerModel.RecDate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringFromIndex:10];
        }else{
            answerModel.RecDate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:10];
        }
        answerModel.LikeCount = [NSString stringWithFormat:@"%@",[answerDic objectForKey:@"LikeCount"]];
        answerModel.CaiCount = [NSString stringWithFormat:@"%@",[answerDic objectForKey:@"CaiCount"]];
        answerModel.JiaoBaoHao = [NSString stringWithFormat:@"%@",[answerDic objectForKey:@"JiaoBaoHao"]];
        answerModel.IdFlag = [answerDic objectForKey:@"IdFlag"];
        if (answerModel.IdFlag.length==0) {
            answerModel.IdFlag = @"匿名回答";
            answerModel.JiaoBaoHao = @"";
        }
        answerModel.CCount = [NSString stringWithFormat:@"%@",[answerDic objectForKey:@"CCount"]];
        [model.answerArray addObject:answerModel];
    }
    return model;
}

//获取一个精选内容集
+(GetPickedByIdModel *)parserJsonGetPickedById:(NSString *)json{
    D("dgoahdlk-===%@",json);
    GetPickedByIdModel *model = [[GetPickedByIdModel alloc] init];
    NSDictionary *dic0 = [json objectFromJSONString];
    model.TabID = [NSString stringWithFormat:@"%@",[dic0 objectForKey:@"TabID"]];
    model.PTitle = [NSString stringWithFormat:@"%@",[dic0 objectForKey:@"PTitle"]];
    model.PickDescipt = [NSString stringWithFormat:@"%@",[dic0 objectForKey:@"PickDescipt"]];
    model.VedioConntent = [NSString stringWithFormat:@"%@",[dic0 objectForKey:@"VedioConntent"]];
    model.baseImgUrl = [NSString stringWithFormat:@"%@",[dic0 objectForKey:@"baseImgUrl"]];
    model.RecDate = [NSString stringWithFormat:@"%@",[dic0 objectForKey:@"RecDate"]];
    NSString *str = [utils getLocalTimeDate];
    NSString *str2 = [dic0 objectForKey:@"RecDate"];
    NSRange range = [str2 rangeOfString:str];
    if (range.length>0) {
        model.RecDate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringFromIndex:10];
    }else{
        model.RecDate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:10];
    }
    model.ImgContent = [[dic0 objectForKey:@"ImgContent"] objectFromJSONString];
    NSMutableArray *mArr_answer = [dic0 objectForKey:@"PickContent"];
    for(int i=0;i<mArr_answer.count;i++)
    {
        PickContentModel *pickModel = [[PickContentModel alloc]init];
        NSDictionary *answerDic =  [mArr_answer objectAtIndex:i];
        pickModel.Title = [answerDic objectForKey:@"Title"];
        pickModel.Abstracts = [answerDic objectForKey:@"Abstracts"];
        pickModel.Thumbnail = [[answerDic objectForKey:@"Thumbnail"] objectFromJSONString];
        pickModel.TabID = [NSString stringWithFormat:@"%@",[answerDic objectForKey:@"TabID"]];
        [model.PickContent addObject:pickModel];
    }
    
    return model;
}

//获取一个精选内容明细
+(ShowPickedModel *)parserJsonShowPicked:(NSString *)json{
    ShowPickedModel *model = [[ShowPickedModel alloc] init];
    NSDictionary *dic0 = [json objectFromJSONString];
    model.TabID = [NSString stringWithFormat:@"%@",[dic0 objectForKey:@"TabID"]];
    model.Title = [NSString stringWithFormat:@"%@",[dic0 objectForKey:@"Title"]];
    model.PContent = [NSString stringWithFormat:@"%@",[dic0 objectForKey:@"PContent"]];
    model.QID = [NSString stringWithFormat:@"%@",[dic0 objectForKey:@"QID"]];
    return model;
}

//获取各期精选列表
+(NSMutableArray *)parserJsonPickedIndex:(NSString *)json{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *arrList = [json objectFromJSONString];
    for(int i=0;i<arrList.count;i++){
        PickedIndexModel *model = [[PickedIndexModel alloc ]init];
        NSDictionary *dic = [arrList objectAtIndex:i];
        model.TabID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"TabID"]];
        model.PTitle = [dic objectForKey:@"PTitle"];
        model.baseImgUrl = [NSString stringWithFormat:@"%@",[dic objectForKey:@"baseImgUrl"]];
        model.RowCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"RowCount"]];
        model.ImgContent = [dic objectForKey:@"ImgContent"];
        model.PickDescipt = [dic objectForKey:@"PickDescipt"];
        NSString *str = [utils getLocalTimeDate];
        NSString *str0 = [dic objectForKey:@"RecDate"];
        NSRange range0 = [str0 rangeOfString:str];
        if (range0.length>0) {
            model.RecDate = [[str0 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringFromIndex:10];
        }else{
            model.RecDate = [[str0 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:10];
        }
        [array addObject:model];
    }
    
    return array;
}


@end
