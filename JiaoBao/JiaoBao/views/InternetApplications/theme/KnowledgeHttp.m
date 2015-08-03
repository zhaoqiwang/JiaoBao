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

@end
