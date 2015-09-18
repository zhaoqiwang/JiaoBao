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
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *code = [jsonDic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        NSArray *array = [ParserJson_knowledge parserJsonGetProvice:[jsonDic objectForKey:@"Data"]];
        NSDictionary *dic = @{@"ResultCode":code,@"ResultDesc":ResultDesc,@"array":array};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"knowledgeHttpGetProvice" object:dic];
        D("JSON--------knowledgeHttpGetProvice: %@,", result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *code = @"100";
        NSString *ResultDesc = @"服务器异常" ;
        NSDictionary *dic = @{@"ResultCode":code,@"ResultDesc":ResultDesc};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"knowledgeHttpGetProvice" object:dic];
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
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *code = [jsonDic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        NSArray *array = [ParserJson_knowledge parserJsonGetProvice:[jsonDic objectForKey:@"Data"]];
        NSDictionary *dic = @{@"ResultCode":code,@"ResultDesc":ResultDesc,@"array":array};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"knowledgeHttpGetCity" object:dic];
        D("JSON--------knowledgeHttpGetCity: %@,", result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *code = @"100";
        NSString *ResultDesc = @"服务器异常" ;
        NSDictionary *dic = @{@"ResultCode":code,@"ResultDesc":ResultDesc};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"knowledgeHttpGetCity" object:dic];
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
    [manager POST:urlString parameters:nickNames success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSMutableDictionary *jsonDic = [result objectFromJSONString];
                NSString *code = [jsonDic objectForKey:@"ResultCode"];
                NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        NSArray *array = [ParserJson_knowledge parserJsonGetJiaoBaoHao:[jsonDic objectForKey:@"Data"]];
                //NSArray *array = [ParserJson_knowledge parserJsonGetProvice:[jsonDic objectForKey:@"Data"]];
        NSDictionary *dic1 = @{@"ResultCode":code,@"ResultDesc":ResultDesc,@"array":array};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"GetAccIdbyNickname" object:dic1];
        D("JSON--------GetAccIdbyNickname: %@,", result);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------GetAccIdbyNickname: %@", error);
        NSDictionary *dic = @{@"ResultCode":@"100",@"ResultDesc":@"服务器异常"};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"GetAccIdbyNickname" object:dic];
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
        D("JSON--------SetIdflagWithAccId: %@,", result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------SetIdflagWithAccId: %@", error);
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
        D("JSON--------GetCategoryWithParentId: %@,", result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------GetCategoryWithParentId: %@", error);
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
        NSDictionary *dic1 = @{@"ResultCode":code,@"ResultDesc":ResultDesc,@"model":model};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"GetCategoryById" object:dic1];
        D("JSON--------GetCategoryById: %@,", result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------GetCategoryById: %@", error);
        NSDictionary *dic = @{@"ResultCode":@"100",@"ResultDesc":@"服务器异常"};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"GetCategoryById" object:dic];
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
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    [manager POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *code = [jsonDic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        NSArray *array = [ParserJson_knowledge parserJsonGetAllCategory:[jsonDic objectForKey:@"Data"]];
        
        D("JSON--------GetAllCategory: %@,", result);
        [tempDic setValue:code forKey:@"code"];
        [tempDic setValue:ResultDesc forKey:@"ResultDesc"];
        [tempDic setValue:array forKey:@"array"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetAllCategory" object:tempDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------GetAllCategory: %@", error);
        NSDictionary *dic = @{@"ResultCode":@"100",@"ResultDesc":@"服务器异常"};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"GetAllCategory" object:dic];
    }];
}

//发布问题 参数描述：所属话题Id-标题-问题内容-（关键字，多个以,隔开）-（QFlag）-(区域代码)-(atAccIds)
-(void)NewQuestionWithCategoryId:(NSString*)CategoryId Title:(NSString*)Title KnContent:(NSString*)KnContent TagsList:(NSString*)TagsList QFlag:(NSString*)QFlag AreaCode:(NSString*)AreaCode atAccIds:(NSString*)atAccIds
{
    NSString *urlString = [NSString stringWithFormat:@"%@/Knl/NewQuestion",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *dic = @{@"CategoryId":CategoryId,@"Title":Title,@"KnContent":KnContent,@"TagsList":TagsList,@"QFlag":QFlag,@"AreaCode":AreaCode,@"atAccIds":atAccIds};
    [manager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *code = [jsonDic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        NSDictionary *dic1 = @{@"ResultCode":code,@"ResultDesc":ResultDesc};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"NewQuestionWithCategoryId" object:dic1];
        
        D("JSON--------NewQuestionWithCategoryId: %@,", result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSDictionary *dic = @{@"ResultCode":@"100",@"ResultDesc":@"服务器异常"};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"NewQuestionWithCategoryId" object:dic];
        D("Error---------NewQuestionWithCategoryId: %@", error);
    }];

    
}

//问题内容修改
//-(void)UpdateQuestionWithTabIDStr:(NSString*)TabIDStr KnContent:(NSString*)KnContent TagsList:(NSString*)TagsList
//{
//    NSString *urlString = [NSString stringWithFormat:@"%@/Knl/UpdateQuestion",MAINURL];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.requestSerializer.timeoutInterval = TIMEOUT;
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    NSDictionary *dic = @{@"TabIDStr":TabIDStr,@"KnContent":KnContent,@"TagsList":TagsList};
//    [manager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSMutableDictionary *jsonDic = [result objectFromJSONString];
//        NSString *code = [jsonDic objectForKey:@"ResultCode"];
//        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
//        
//        
//        D("JSON--------UpdateQuestionWithTabIDStr: %@,", result);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        D("Error---------UpdateQuestionWithTabIDStr: %@", error);
//    }];
//}
//问题列表
-(void)QuestionIndexWithNumPerPage:(NSString*)numPerPage pageNum:(NSString*)pageNum CategoryId:(NSString*)CategoryId
{
    D("s;odjfl;dkjg;l-====%@,%@,%@",numPerPage,pageNum,CategoryId);
    NSString *urlString = [NSString stringWithFormat:@"%@/Knl/QuestionIndex",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *dic = @{@"numPerPage":numPerPage,@"pageNum":pageNum,@"CategoryId":CategoryId};
    [manager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *code = [jsonDic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        NSArray *array = [ParserJson_knowledge parserJsonQuestionIndex:[jsonDic objectForKey:@"Data"]];
        
        D("JSON--------QuestionIndexWithNumPerPage: %@,", result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------QuestionIndexWithNumPerPage: %@", error);
    }];
}

//问题明细
-(void)QuestionDetailWithQId:(NSString*)QId
{
    NSString *urlString = [NSString stringWithFormat:@"%@/Knl/QuestionDetail",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    NSDictionary *dic = @{@"QId":QId};
    [manager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *code = [jsonDic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        QuestionDetailModel *model = [ParserJson_knowledge parserJsonQuestionDetail:[jsonDic objectForKey:@"Data"]];
        
        D("JSON--------QuestionDetailWithQId: %@,", result);
        [tempDic setValue:code forKey:@"code"];
        [tempDic setValue:ResultDesc forKey:@"ResultDesc"];
        [tempDic setValue:model forKey:@"model"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"QuestionDetail" object:tempDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------QuestionDetailWithQId: %@", error);
        NSDictionary *dic = @{@"ResultCode":@"100",@"ResultDesc":@"服务器异常"};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"QuestionDetail" object:dic];
    }];
}

//回答问题
-(void)AddAnswerWithQId:(NSString*)QId Title:(NSString*)Title AContent:(NSString*)AContent UserName:(NSString*)UserName
{
    NSString *urlString = [NSString stringWithFormat:@"%@/Knl/AddAnswer",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    NSDictionary *dic = @{@"QId":QId,@"Title":Title,@"AContent":AContent,@"UserName":UserName};
    [manager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *code = [jsonDic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        
        D("JSON--------AddAnswerWithQId: %@,", result);
        [tempDic setValue:code forKey:@"code"];
        [tempDic setValue:ResultDesc forKey:@"ResultDesc"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AddAnswer" object:tempDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------AddAnswerWithQId: %@", error);
        NSDictionary *dic = @{@"ResultCode":@"100",@"ResultDesc":@"服务器异常"};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"AddAnswer" object:dic];
    }];
}
//修改答案 参数描述：答案id - 标题 - 回答的内容
-(void)UpdateAnswerWithTabID:(NSString*)TabID Title:(NSString*)Title AContent:(NSString*)AContent
{
    NSString *urlString = [NSString stringWithFormat:@"%@/Knl/UpdateAnswer",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *dic = @{@"TabID":TabID,@"Title":Title,@"AContent":AContent};
    [manager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *code = [jsonDic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        
        
        D("JSON--------UpdateAnswerWithTabID: %@,", result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------UpdateAnswerWithTabID: %@", error);
    }];
}

//获取问题的答案列表
-(void)GetAnswerByIdWithNumPerPage:(NSString*)numPerPage pageNum:(NSString*)pageNum QId:(NSString*)QId flag:(NSString*)flag
{
    NSString *urlString = [NSString stringWithFormat:@"%@/Knl/GetAnswerById",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    NSDictionary *dic = @{@"numPerPage":numPerPage,@"pageNum":pageNum,@"QId":QId,@"flag":flag};
    [manager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *code = [jsonDic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        NSArray *array = [ParserJson_knowledge parserJsonGetAnswerById:[jsonDic objectForKey:@"Data"]];
        
        D("JSON--------GetAnswerByIdWithNumPerPage: %@,", result);
        [tempDic setValue:code forKey:@"code"];
        [tempDic setValue:ResultDesc forKey:@"ResultDesc"];
        [tempDic setValue:array forKey:@"array"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetAnswerById" object:tempDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------GetAnswerByIdWithNumPerPage: %@", error);
        NSDictionary *dic = @{@"ResultCode":@"100",@"ResultDesc":@"服务器异常"};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"GetAnswerById" object:dic];
    }];
    
}

//举报答案 参数描述:答案id
-(void)reportanswerWithAId:(NSString*)AId
{
    NSString *urlString = [NSString stringWithFormat:@"%@/Knl/ReportAns",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *dic = @{@"ansId":AId};
    [manager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *code = [jsonDic objectForKey:@"ResultCode"];
//        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        if([code  integerValue] == 0)
        {
            [MBProgressHUD showSuccess:@"举报成功"];
        }
        else
        {
            [MBProgressHUD showError:@"举报失败"];
        }
        D("JSON--------reportanswerWithAId: %@,", result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------reportanswerWithAId: %@", error);
        [MBProgressHUD showError:@"服务器异常"];
//        NSDictionary *resultDic = @{@"ResultCode":@"100",@"ResultDesc":@"服务器异常"};
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserIndexQuestion" object:resultDic];
    }];
}

//评价答案 参数描述:答案id - (0=反对，1=支持)
-(void)SetYesNoWithAId:(NSString*)AId yesNoFlag:(NSString*)yesNoFlag
{
    NSString *urlString = [NSString stringWithFormat:@"%@/Knl/SetYesNo",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *dic = @{@"AId":AId,@"yesNoFlag":yesNoFlag};
    [manager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *code = [jsonDic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        NSString *dataStr = [jsonDic objectForKey:@"Data"];
        NSDictionary *dic = @{@"ResultCode":code,@"ResultDesc":ResultDesc,@"Data":dataStr};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"SetYesNoWithAId" object:dic];
        
        D("JSON--------SetYesNoWithAId: %@,", result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSDictionary *resultDic = @{@"ResultCode":@"100",@"ResultDesc":@"服务器异常"};
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"SetYesNoWithAId" object:resultDic ];
        D("Error---------SetYesNoWithAId: %@", error);
    }];
    
}

//添加评论 参数描述：答案Id - 评论内容 - 引用评论ID
-(void)AddCommentWithAId:(NSString*)AId comment:(NSString*)comment RefID:(NSString*)RefID
{
    NSString *urlString = [NSString stringWithFormat:@"%@/Knl/AddComment",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *dic = @{@"AId":AId,@"comment":comment,@"RefID":RefID};
    [manager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *code = [jsonDic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        NSDictionary *dic = @{@"ResultCode":code,@"ResultDesc":ResultDesc};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshComment" object:dic];
        D("JSON--------AddCommentWithAId: %@,", result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSDictionary *dic = @{@"ResultCode":@"100",@"ResultDesc":@"服务器异常"};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshComment" object:dic];
        D("Error---------AddCommentWithAId: %@", error);
    }];
    
}

//评论列表 参数描述：(取回的记录数量，默认20) - (第几页，默认为1) - 答案Id
-(void)CommentsListWithNumPerPage:(NSString*)numPerPage pageNum:(NSString*)pageNum AId:(NSString*)AId
{
    NSString *urlString = [NSString stringWithFormat:@"%@/Knl/CommentsList",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *dic = @{@"numPerPage":numPerPage,@"pageNum":pageNum,@"AId":AId};
    [manager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *code = [jsonDic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];

        AllCommentListModel *model = [ParserJson_knowledge parserJsonCommentsList:[jsonDic objectForKey:@"Data"]];
        NSDictionary *resultDic = @{@"ResultCode":code,@"ResultDesc":ResultDesc,@"model":model};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"CommentsListWithNumPerPage" object:resultDic ];
        
        D("JSON--------CommentsListWithNumPerPage: %@,", result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------CommentsListWithNumPerPage: %@", error);
        NSDictionary *resultDic = @{@"ResultCode":@"100",@"ResultDesc":@"服务器异常"};

        [[NSNotificationCenter defaultCenter]postNotificationName:@"CommentsListWithNumPerPage" object:resultDic ];
    }];
    
}

//答案明细 参数描述:答案id
-(void)AnswerDetailWithAId:(NSString*)AId
{
    NSString *urlString = [NSString stringWithFormat:@"%@/Knl/AnswerDetail",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *dic = @{@"AId":AId};
    [manager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *code = [jsonDic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        AnswerDetailModel *model = [ParserJson_knowledge parserJsonAnswerDetail:[jsonDic objectForKey:@"Data"]];
        NSDictionary *resultDic = @{@"ResultCode":code,@"ResultDesc":ResultDesc,@"model":model};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"AnswerDetailWithAId" object:resultDic ];

        
       // D("JSON--------AnswerDetailWithAId: %@,", result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------AnswerDetailWithAId: %@", error);
        NSDictionary *resultDic = @{@"ResultCode":@"100",@"ResultDesc":@"服务器异常"};
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"AnswerDetailWithAId" object:resultDic ];

    }];
    
}


//首页问题列表 参数描述：（取回的记录数量）-（第几页）-(记录数量)-(回答标志)
-(void)UserIndexQuestionWithNumPerPage:(NSString*)numPerPage pageNum:(NSString*)pageNum RowCount:(NSString*)RowCount flag:(NSString*)flag
{
    NSString *urlString = [NSString stringWithFormat:@"%@/Knl/UserIndexQuestion",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    D("srgpjpdsj'-===%@,%@,%@,%@",numPerPage,pageNum,RowCount,flag);
    NSDictionary *dic = @{@"numPerPage":numPerPage,@"pageNum":pageNum,@"RowCount":RowCount,@"flag":flag};
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    [manager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *code = [jsonDic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        NSArray *array = [ParserJson_knowledge parserJsonCategoryIndexQuestion:[jsonDic objectForKey:@"Data"]];
        
        D("JSON--------UserIndexQuestionWithNumPerPage: %@,", result);
        [tempDic setValue:code forKey:@"code"];
        [tempDic setValue:ResultDesc forKey:@"ResultDesc"];
        [tempDic setValue:array forKey:@"array"];
        [tempDic setValue:flag forKey:@"flag"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserIndexQuestion" object:tempDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------UserIndexQuestionWithNumPerPage: %@", error);
        [tempDic setValue:@"100" forKey:@"ResultCode"];
        [tempDic setValue:@"服务器异常" forKey:@"ResultDesc"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserIndexQuestion" object:tempDic];
    }];
}

//话题的问题列表 参数描述：（取回的记录数量）-（第几页）-(记录数量)-(回答标志)-(话题Id)
-(void)CategoryIndexQuestionWithNumPerPage:(NSString*)numPerPage pageNum:(NSString*)pageNum RowCount:(NSString*)RowCount flag:(NSString*)flag uid:(NSString*)uid
{
    NSString *urlString = [NSString stringWithFormat:@"%@/Knl/CategoryIndexQuestion",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    NSDictionary *dic = @{@"numPerPage":numPerPage,@"pageNum":pageNum,@"RowCount":RowCount,@"flag":flag,@"uid":uid};
    [manager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *code = [jsonDic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        NSArray *array = [ParserJson_knowledge parserJsonCategoryIndexQuestion:[jsonDic objectForKey:@"Data"]];
        
        D("JSON--------CategoryIndexQuestionWith: %@,", result);
        [tempDic setValue:code forKey:@"code"];
        [tempDic setValue:ResultDesc forKey:@"ResultDesc"];
        [tempDic setValue:array forKey:@"array"];
        [tempDic setValue:flag forKey:@"flag"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CategoryIndexQuestion" object:tempDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------CategoryIndexQuestionWith: %@", error);
        [tempDic setValue:@"100" forKey:@"ResultCode"];
        [tempDic setValue:@"服务器异常" forKey:@"ResultDesc"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CategoryIndexQuestion" object:tempDic];
    }];
}

//推荐列表 参数描述：（取回的记录数量）-（第几页）-(记录数量)
-(void)RecommentIndexWithNumPerPage:(NSString*)numPerPage pageNum:(NSString*)pageNum RowCount:(NSString*)RowCount{
    NSString *urlString = [NSString stringWithFormat:@"%@/Knl/RecommentIndex",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    NSDictionary *dic = @{@"numPerPage":numPerPage,@"pageNum":pageNum,@"RowCount":RowCount};
    [manager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *code = [jsonDic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        NSArray *array = [ParserJson_knowledge parserJsonRecommentIndex:[jsonDic objectForKey:@"Data"]];
        
        D("JSON--------RecommentIndex: %@,", result);
        [tempDic setValue:code forKey:@"ResultCode"];
        [tempDic setValue:ResultDesc forKey:@"ResultDesc"];
        [tempDic setValue:array forKey:@"array"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RecommentIndex" object:tempDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------RecommentIndex: %@", error);
        [tempDic setValue:@"100" forKey:@"ResultCode"];
        [tempDic setValue:@"服务器异常" forKey:@"ResultDesc"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RecommentIndex" object:tempDic];
    }];
}

//单个推荐明细  参数描述：（推荐ID）
-(void)ShowRecommentWithTable:(NSString*)tabid{
    NSString *urlString = [NSString stringWithFormat:@"%@/Knl/ShowRecomment",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    NSDictionary *dic = @{@"tabid":tabid};
    [manager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *code = [jsonDic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        RecommentAddAnswerModel *model = [ParserJson_knowledge parserJsonShowRecomment:[jsonDic objectForKey:@"Data"]];
        
        D("JSON--------ShowRecomment: %@,", result);
        [tempDic setValue:code forKey:@"code"];
        [tempDic setValue:ResultDesc forKey:@"ResultDesc"];
        [tempDic setValue:model forKey:@"model"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowRecomment" object:tempDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------ShowRecomment: %@", error);
        [tempDic setValue:@"100" forKey:@"ResultCode"];
        [tempDic setValue:@"服务器异常" forKey:@"ResultDesc"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowRecomment" object:tempDic];
    }];
}

//获取话题的置顶问题  参数描述：（话题Id）
-(void)GetCategoryTopQWithId:(NSString *)categoryid{
    NSString *urlString = [NSString stringWithFormat:@"%@/Knl/GetCategoryTopQ",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    NSDictionary *dic = @{@"categoryid":categoryid};
    [manager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *code = [jsonDic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        NSArray *array = [ParserJson_knowledge parserJsonCategoryIndexQuestion:[jsonDic objectForKey:@"Data"]];
        
        D("JSON--------GetCategoryTop: %@,", result);
        [tempDic setValue:code forKey:@"code"];
        [tempDic setValue:ResultDesc forKey:@"ResultDesc"];
        [tempDic setValue:array forKey:@"array"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetCategoryTop" object:tempDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------GetCategoryTop: %@", error);
        [tempDic setValue:@"100" forKey:@"ResultCode"];
        [tempDic setValue:@"服务器异常" forKey:@"ResultDesc"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetCategoryTop" object:tempDic];
    }];
}

//获取一个精选内容集 参数描述：精选集ID,为0时取最新一期精选
-(void)GetPickedByIdWithTabID:(NSString *)tabId{
    NSString *urlString = [NSString stringWithFormat:@"%@/Knl/GetPickedById",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    NSDictionary *dic = @{@"tabId":tabId};
    [manager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *code = [jsonDic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        GetPickedByIdModel *model = [ParserJson_knowledge parserJsonGetPickedById:[jsonDic objectForKey:@"Data"]];
        D("JSON--------GetPickedById: %@,", result);
        [tempDic setValue:code forKey:@"code"];
        [tempDic setValue:ResultDesc forKey:@"ResultDesc"];
        [tempDic setValue:model forKey:@"model"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetPickedById" object:tempDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------GetPickedById: %@", error);
        [tempDic setValue:@"100" forKey:@"ResultCode"];
        [tempDic setValue:@"服务器异常" forKey:@"ResultDesc"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetPickedById" object:tempDic];
    }];
}

//获取一个精选内容明细 参数描述：精选内容ID
-(void)ShowPickedWithTabID:(NSString *)tabId{
    NSString *urlString = [NSString stringWithFormat:@"%@/Knl/ShowPicked",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    NSDictionary *dic = @{@"tabId":tabId};
    [manager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *code = [jsonDic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        ShowPickedModel *model = [ParserJson_knowledge parserJsonShowPicked:[jsonDic objectForKey:@"Data"]];
        
        D("JSON--------ShowPicked: %@,", result);
        [tempDic setValue:code forKey:@"code"];
        [tempDic setValue:ResultDesc forKey:@"ResultDesc"];
        [tempDic setValue:model forKey:@"model"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowPicked" object:tempDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------ShowPicked: %@", error);
        [tempDic setValue:@"100" forKey:@"ResultCode"];
        [tempDic setValue:@"服务器异常" forKey:@"ResultDesc"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowPicked" object:tempDic];
    }];
}

//获取各期精选列表  参数描述：（取回的记录数量，默认20）- （第几页，默认为1）- (记录数量)
-(void)PickedIndexWithNumPerPage:(NSString*)numPerPage pageNum:(NSString*)pageNum RowCount:(NSString*)RowCount{
    NSString *urlString = [NSString stringWithFormat:@"%@/Knl/PickedIndex",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    NSDictionary *dic = @{@"numPerPage":numPerPage,@"pageNum":pageNum,@"RowCount":RowCount};
    [manager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *code = [jsonDic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        NSArray *array = [ParserJson_knowledge parserJsonPickedIndex:[jsonDic objectForKey:@"Data"]];
        
        D("JSON--------PickedIndex: %@,", result);
        [tempDic setValue:code forKey:@"ResultCode"];
        [tempDic setValue:ResultDesc forKey:@"ResultDesc"];
        [tempDic setValue:array forKey:@"array"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PickedIndex" object:tempDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------PickedIndex: %@", error);
        [tempDic setValue:@"100" forKey:@"ResultCode"];
        [tempDic setValue:@"服务器异常" forKey:@"ResultDesc"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PickedIndex" object:tempDic];
    }];
}

//关注某一个问题 参数描述：问题ID
-(void)AddMyAttQWithqId:(NSString*)qId
{
    NSString *urlString = [NSString stringWithFormat:@"%@/Knl/AddMyAttQ",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    NSDictionary *dic = @{@"qId":qId};
    [manager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *code = [jsonDic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        D("JSON--------AddMyAttQWithqId: %@,", result);
        [tempDic setValue:code forKey:@"ResultCode"];
        [tempDic setValue:ResultDesc forKey:@"ResultDesc"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AddMyAttQWithqId" object:tempDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------AddMyAttQWithqId: %@", error);
        [tempDic setValue:@"100" forKey:@"ResultCode"];
        [tempDic setValue:@"服务器异常" forKey:@"ResultDesc"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AddMyAttQWithqId" object:tempDic];
    }];
}

//邀请指定的用户回答问题 参数描述：被邀请的用户教宝号 - 问题ID
-(void)AtMeForAnswerWithAccId:(NSString*)accId qId:(NSString*)qId
{
    NSString *urlString = [NSString stringWithFormat:@"%@/KnUser/AtMeForAnswer",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    NSDictionary *dic = @{@"accId":accId,@"qId":qId};
    [manager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *code = [jsonDic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        D("JSON--------AtMeForAnswerWithAccId: %@,", result);
        [tempDic setValue:code forKey:@"ResultCode"];
        [tempDic setValue:ResultDesc forKey:@"ResultDesc"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AtMeForAnswerWithAccId" object:tempDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------AtMeForAnswerWithAccId: %@", error);
        [tempDic setValue:@"100" forKey:@"ResultCode"];
        [tempDic setValue:@"服务器异常" forKey:@"ResultDesc"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AtMeForAnswerWithAccId" object:tempDic];
    }];
}
//获取我关注的问题列表 参数描述：（取回的记录数量）-（第几页）-(记录数量)
-(void)MyAttQIndexWithnumPerPage:(NSString*)numPerPage pageNum:(NSString*)pageNum RowCount:(NSString*)RowCount
{
    NSString *urlString = [NSString stringWithFormat:@"%@/KnUser/MyAttQIndex",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    NSDictionary *dic = @{@"numPerPage":numPerPage,@"pageNum":pageNum,@"RowCount":RowCount};
    [manager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *code = [jsonDic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        NSArray *array = [ParserJson_knowledge parserJsonCategoryIndexQuestion:[jsonDic objectForKey:@"Data"]];
        
        D("JSON--------MyAttQIndexWithnumPerPage: %@,", result);
        [tempDic setValue:code forKey:@"ResultCode"];
        [tempDic setValue:ResultDesc forKey:@"ResultDesc"];
        [tempDic setValue:array forKey:@"array"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyAttQIndexWithnumPerPage" object:tempDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------MyAttQIndexWithnumPerPage: %@", error);
        [tempDic setValue:@"100" forKey:@"ResultCode"];
        [tempDic setValue:@"服务器异常" forKey:@"ResultDesc"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyAttQIndexWithnumPerPage" object:tempDic];
    }];
}
//邀请我回答的问题 参数描述：（取回的记录数量）-（第几页）-(记录数量)
-(void)AtMeQIndexWithnumPerPage:(NSString*)numPerPage pageNum:(NSString*)pageNum RowCount:(NSString*)RowCount
{
    NSString *urlString = [NSString stringWithFormat:@"%@/KnUser/AtMeQIndex",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    NSDictionary *dic = @{@"numPerPage":numPerPage,@"pageNum":pageNum,@"RowCount":RowCount};
    [manager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *code = [jsonDic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        NSArray *array = [ParserJson_knowledge parserJsonCategoryIndexQuestion:[jsonDic objectForKey:@"Data"]];
        
        D("JSON--------AtMeQIndexWithnumPerPage: %@,", result);
        [tempDic setValue:code forKey:@"ResultCode"];
        [tempDic setValue:ResultDesc forKey:@"ResultDesc"];
        [tempDic setValue:array forKey:@"array"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AtMeQIndexWithnumPerPage" object:tempDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------AtMeQIndexWithnumPerPage: %@", error);
        [tempDic setValue:@"100" forKey:@"ResultCode"];
        [tempDic setValue:@"服务器异常" forKey:@"ResultDesc"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AtMeQIndexWithnumPerPage" object:tempDic];
    }];
}
//获取我提出的问题列表 参数描述：（取回的记录数量）-（第几页）-(记录数量)
-(void)MyQuestionIndexWithnumPerPage:(NSString*)numPerPage pageNum:(NSString*)pageNum RowCount:(NSString*)RowCount;
{
    NSString *urlString = [NSString stringWithFormat:@"%@/KnUser/MyQuestionIndex",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    NSDictionary *dic = @{@"numPerPage":numPerPage,@"pageNum":pageNum,@"RowCount":RowCount};
    [manager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *code = [jsonDic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        NSArray *array = [ParserJson_knowledge parserJsonCategoryIndexQuestion:[jsonDic objectForKey:@"Data"]];
        
        D("JSON--------MyQuestionIndexWithnumPerPage: %@,", result);
        [tempDic setValue:code forKey:@"ResultCode"];
        [tempDic setValue:ResultDesc forKey:@"ResultDesc"];
        [tempDic setValue:array forKey:@"array"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyQuestionIndexWithnumPerPage" object:tempDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------MyQuestionIndexWithnumPerPage: %@", error);
        [tempDic setValue:@"100" forKey:@"ResultCode"];
        [tempDic setValue:@"服务器异常" forKey:@"ResultDesc"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyQuestionIndexWithnumPerPage" object:tempDic];
    }];
}
//获取我参与回答的问题列表 参数描述：（取回的记录数量）-（第几页）-(记录数量)
-(void)MyAnswerIndexWithnumPerPage:(NSString*)numPerPage pageNum:(NSString*)pageNum RowCount:(NSString*)RowCount
{
    NSString *urlString = [NSString stringWithFormat:@"%@/KnUser/MyAnswerIndex",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    NSDictionary *dic = @{@"numPerPage":numPerPage,@"pageNum":pageNum,@"RowCount":RowCount};
    [manager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *code = [jsonDic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        NSArray *array = [ParserJson_knowledge parserJsonCategoryIndexQuestion:[jsonDic objectForKey:@"Data"]];
        
        D("JSON--------MyAnswerIndexWithnumPerPage: %@,", result);
        [tempDic setValue:code forKey:@"ResultCode"];
        [tempDic setValue:ResultDesc forKey:@"ResultDesc"];
        [tempDic setValue:array forKey:@"array"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyAnswerIndexWithnumPerPage" object:tempDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------MyAnswerIndexWithnumPerPage: %@", error);
        [tempDic setValue:@"100" forKey:@"ResultCode"];
        [tempDic setValue:@"服务器异常" forKey:@"ResultDesc"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyAnswerIndexWithnumPerPage" object:tempDic];
    }];
    
}

//获取我关注的话题ID数组
-(void)GetMyattCate
{
    NSString *urlString = [NSString stringWithFormat:@"%@/KnUser/GetMyattCate",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    [manager POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *code = [jsonDic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        NSString *Data = [jsonDic objectForKey:@"Data"];
        NSString *dataStr = [Data stringByReplacingOccurrencesOfString:@"[" withString:@""];
        NSString *dataStr2 = [dataStr stringByReplacingOccurrencesOfString:@"]" withString:@""];
        NSString *dataStr3 = [dataStr2 stringByReplacingOccurrencesOfString:@"\"" withString:@""];

        NSArray *cateArr = [dataStr3 componentsSeparatedByString:@","];

        [tempDic setValue:code forKey:@"ResultCode"];
        [tempDic setValue:ResultDesc forKey:@"ResultDesc"];
        [tempDic setValue:cateArr forKey:@"array"];
        D("JSON--------GetMyattCate: %@,", result);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetMyattCate" object:tempDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------GetMyattCate: %@", error);
        [tempDic setValue:@"100" forKey:@"ResultCode"];
        [tempDic setValue:@"服务器异常" forKey:@"ResultDesc"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetMyattCate" object:tempDic];
    }];
}
//更新我关注的话题
-(void)AddMyattCateWithuid:(NSString*)uid
{
    NSString *urlString = [NSString stringWithFormat:@"%@/KnUser/AddMyattCate",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    NSDictionary *dic = @{@"uid":uid};
    [manager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *code = [jsonDic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        
        D("JSON--------AddMyattCateWithuid: %@,", result);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------AddMyattCateWithuid: %@", error);
        [tempDic setValue:@"100" forKey:@"ResultCode"];
        [tempDic setValue:@"服务器异常" forKey:@"ResultDesc"];
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"AddMyattCateWithuid" object:tempDic];
    }];
}

//邀请人回答时，获取回答该话题问题最多的用户列表（4个）参数描述：(用户账户) - （邀请人回答的问题的话题ID）
-(void)GetAtMeUsersWithuid:(NSString*)uid catid:(NSString*)catid
{
    NSString *urlString = [NSString stringWithFormat:@"%@/KnUser/GetAtMeUsers",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    NSDictionary *dic = @{@"uid":uid,@"catid":catid};
    [manager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *code = [jsonDic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        NSArray *array = [ParserJson_knowledge parserJsonInvitationUserInfo:[jsonDic objectForKey:@"Data"]];
        D("JSON--------GetAtMeUsersWithuid: %@,", result);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------GetAtMeUsersWithuid: %@", error);
        [tempDic setValue:@"100" forKey:@"ResultCode"];
        [tempDic setValue:@"服务器异常" forKey:@"ResultDesc"];
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"GetAtMeUsersWithuid" object:tempDic];
    }];
}


@end
