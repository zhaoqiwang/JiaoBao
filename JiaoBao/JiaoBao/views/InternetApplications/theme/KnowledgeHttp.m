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
        D("JSON--------GetCategoryById: %@,", result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------GetCategoryById: %@", error);
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

        
        D("JSON--------NewQuestionWithCategoryId: %@,", result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------NewQuestionWithCategoryId: %@", error);
    }];

    
}

//问题内容修改
-(void)UpdateQuestionWithTabIDStr:(NSString*)TabIDStr KnContent:(NSString*)KnContent TagsList:(NSString*)TagsList
{
    NSString *urlString = [NSString stringWithFormat:@"%@/Knl/UpdateQuestion",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *dic = @{@"TabIDStr":TabIDStr,@"KnContent":KnContent,@"TagsList":TagsList};
    [manager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *code = [jsonDic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        
        
        D("JSON--------UpdateQuestionWithTabIDStr: %@,", result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------UpdateQuestionWithTabIDStr: %@", error);
    }];
}
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
    NSDictionary *dic = @{@"QId":QId,@"Title":Title,@"AContent":AContent,@"UserName":UserName};
    [manager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *code = [jsonDic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];

        
        D("JSON--------AddAnswerWithQId: %@,", result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------AddAnswerWithQId: %@", error);
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
    }];
    
}

//举报答案 参数描述:答案id
-(void)reportanswerWithAId:(NSString*)AId
{
    NSString *urlString = [NSString stringWithFormat:@"%@/Knl/reportanswer",MAINURL];
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
        
        
        D("JSON--------reportanswerWithAId: %@,", result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------reportanswerWithAId: %@", error);
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
        
        
        D("JSON--------SetYesNoWithAId: %@,", result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
        
        
        D("JSON--------AddCommentWithAId: %@,", result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
        [[NSNotificationCenter defaultCenter]postNotificationName:@"CommentsListWithNumPerPage" object:model ];
        
        D("JSON--------CommentsListWithNumPerPage: %@,", result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------CommentsListWithNumPerPage: %@", error);
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

        
        D("JSON--------AnswerDetailWithAId: %@,", result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------AnswerDetailWithAId: %@", error);
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserIndexQuestion" object:tempDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------UserIndexQuestionWithNumPerPage: %@", error);
    }];
}

//话题的问题列表 参数描述：（取回的记录数量）-（第几页）-(记录数量)-(回答标志)-(话题Id)
-(void)CategoryIndexQuestionWithNumPerPage:(NSString*)numPerPage pageNum:(NSString*)pageNum RowCount:(NSString*)RowCount flag:(NSString*)flag uid:(NSString*)uid
{
    D("alughalfh-====%@,%@,%@,%@,%@",numPerPage,pageNum,RowCount,flag,uid);
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CategoryIndexQuestion" object:tempDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------CategoryIndexQuestionWith: %@", error);
    }];
}

@end
