//
//  KnowledgeHttp.m
//  JiaoBao
//
//  Created by Zqw on 15/8/3.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "KnowledgeHttp.h"

static KnowledgeHttp *knowledgeHttp = nil;

@implementation KnowledgeHttp

+(KnowledgeHttp *)getInstance{
    if (knowledgeHttp == nil) {
        knowledgeHttp = [[KnowledgeHttp alloc] init];
    }
    return knowledgeHttp;
}
-(id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

//取系统中的省份信息
-(void)knowledgeHttpGetProvice{
    NSString *urlString = [NSString stringWithFormat:@"%@Basic/GetProvice",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSMutableDictionary *jsonDic = [result objectFromJSONString];
//        NSString *code = [jsonDic objectForKey:@"ResultCode"];
//        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
//        NSArray *array = [ParserJson_knowledge parserJsonGetProvice:[jsonDic objectForKey:@"Data"]];
        D("JSON--------knowledgeHttpGetProvice: %@,", result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------knowledgeHttpGetProvice: %@", error);
    }];
}

//取指定省份的地市数据或取指定地市的区县数据
-(void)knowledgeHttpGetCity:(NSString *)cityCode level:(NSString *)level{
    NSString *urlString = [NSString stringWithFormat:@"%@Basic/GetCity",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"cityCode": cityCode,@"level": level};
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSMutableDictionary *jsonDic = [result objectFromJSONString];
//        NSString *code = [jsonDic objectForKey:@"ResultCode"];
//        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
//        NSArray *array = [ParserJson_knowledge parserJsonGetProvice:[jsonDic objectForKey:@"Data"]];
        D("JSON--------knowledgeHttpGetCity: %@,", result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------knowledgeHttpGetCity: %@", error);
    }];
}

//通过昵称取用户教宝号
-(void)GetAccIdbyNickname:(NSArray*)nickNames;
{
    NSString *urlString = [NSString stringWithFormat:@"%@Knl/GetAccIdbyNickname",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //NSDictionary *parameters = @{@"cityCode": cityCode,@"level": level};
    NSArray *parameters = [NSArray arrayWithObjects:@"nickname1",@"nickname2", nil];
    nickNames = parameters;
    [manager POST:urlString parameters:nickNames success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSMutableDictionary *jsonDic = [result objectFromJSONString];
                NSString *code = [jsonDic objectForKey:@"ResultCode"];
                NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        NSArray *array = [ParserJson_knowledge parserJsonGetJiaoBaoHao:[jsonDic objectForKey:@"Data"]];
                //NSArray *array = [ParserJson_knowledge parserJsonGetProvice:[jsonDic objectForKey:@"Data"]];
        D("JSON--------GetAccIdbyNickname: %@,", result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------GetAccIdbyNickname: %@", error);
    }];
}
-(void)GetUserInfo//取用户信息
{
    NSString *urlString = [NSString stringWithFormat:@"%@Knl/GetUserInfo",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *code = [jsonDic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        UserInformationModel *model = [ParserJson_knowledge parserJsonGetUserInfo:[jsonDic objectForKey:@"Data"]];
        D("JSON--------GetUserInfo: %@,", result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------GetUserInfo: %@", error);
    }];
}

//设置用户称号和姓名(暂不用)  参数描述：教宝号——称号——姓名
-(void)SetIdflagWithAccId:(NSString *)accId idFlag:(NSString*)idFlag userName:(NSString*)userName
{
    NSString *urlString = [NSString stringWithFormat:@"%@Knl/SetIdflag",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *code = [jsonDic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        D("JSON--------GetUserInfo: %@,", result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------GetUserInfo: %@", error);
    }];
}

//取系统话题列表
-(void)GetCategoryWithParentId:(NSString*)parentId subject:(NSString*)subject
{
    NSString *urlString = [NSString stringWithFormat:@"%@Knl/GetCategory",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
   // NSDictionary *dic = @{@"parentId":parentId, @"subject":subject};
    [manager POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *code = [jsonDic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        NSArray *array = [ParserJson_knowledge parserJsonGetCategory:[jsonDic objectForKey:@"Data"]];
        D("JSON--------GetUserInfo: %@,", result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------GetUserInfo: %@", error);
    }];
}

//获取单一话题
-(void)GetCategoryById:(NSString*)uId
{
    NSString *urlString = [NSString stringWithFormat:@"%@Knl/GetCategoryById",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
     NSDictionary *dic = @{@"uId":uId};
    [manager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *code = [jsonDic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        CategoryModel *model = [ParserJson_knowledge parserJsonGetCategoryById:[jsonDic objectForKey:@"Data"]];
        D("JSON--------GetUserInfo: %@,", result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------GetUserInfo: %@", error);
    }];
}

//取所有话题
-(void)GetAllCategory
{
    NSString *urlString = [NSString stringWithFormat:@"%@Knl/GetAllCategory",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *code = [jsonDic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        NSArray *arr = [jsonDic objectForKey:@"Data"];
        
        
        D("JSON--------GetUserInfo: %@,", result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------GetUserInfo: %@", error);
    }];
}

@end
