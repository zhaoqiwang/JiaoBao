//
//  OnlineJobHttp.m
//  JiaoBao
//
//  Created by songyanming on 15/10/15.
//  Copyright © 2015年 JSY. All rights reserved.
//

#import "OnlineJobHttp.h"
#import "ParserJson_OnlineJob.h"
static OnlineJobHttp *onlineJobHttp = nil;

@implementation OnlineJobHttp
+(OnlineJobHttp *)getInstance{
    if (onlineJobHttp == nil) {
        onlineJobHttp = [[OnlineJobHttp alloc] init];
    }
    return onlineJobHttp;
}
-(id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}
//获取年级列表
-(void)GetGradeList
{
    NSString *urlString = [NSString stringWithFormat:@"%@/GetGradeList",ONLINEJOBURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];

        NSArray *array = [ParserJson_OnlineJob parserJsonGradeList:result];
        
        D("JSON--------GetGradeList: %@,", result);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetGradeList" object:array];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------GetGradeList: %@", error);

    }];
}
//获取联动列表 //（年级代码）- （科目代码）- （教版联动代码）- （0： 根据年级获取科目，1：根据科目获取教版，2： 根据教版获取章节）
-(void)GetUnionChapterListWithgCode:(NSString*)gCode subCode:(NSString*)subCode uId:(NSString*)uId flag:(NSString*)flag
{
    NSString *urlString = [NSString stringWithFormat:@"%@/GetUnionChapterList",ONLINEJOBURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *parameters = @{@"gCode": gCode,@"subCode": subCode,@"uId":uId,@"flag":flag};
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [result objectFromJSONString];
        NSString *statusCode = [dic objectForKey:@"statusCode"];
        if( [statusCode integerValue] == 200)
        {
//            if([flag integerValue]== 0)//获取科目列表
//            {
                NSArray *array1 = [ParserJson_OnlineJob parserJsonSubjectList:[dic objectForKey:@"args1"]];
                
//            }
//            else if ([flag integerValue]== 1)//获取教版列表
//            {
                NSArray *array2 = [ParserJson_OnlineJob parserJsonVersionList:[dic objectForKey:@"args2"]];
//            }
//            else if ([flag integerValue]== 2)//获取章节列表
//            {
                NSArray *array3 = [ParserJson_OnlineJob parserJsonChapterList:[dic objectForKey:@"args3"]];
//            }
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:flag forKey:@"flag"];
            [dic setValue:array1 forKey:@"args1"];
            [dic setValue:array2 forKey:@"args2"];
            [dic setValue:array3 forKey:@"args3"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GetUnionChapterList" object:dic];
        }

        D("JSON--------GetUnionChaterListWithgCode: %@,", result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        D("Error---------GetUnionChaterListWithgCode: %@", error);
    }];
    
}
//获取老师的自定义作业列表
-(void)GetDesHWListWithChapterID:(NSString*)ChapterID teacherJiaobaohao:(NSString*)teacherJiaobaohao
{
    NSString *urlString = [NSString stringWithFormat:@"%@GetDesHWList",ONLINEJOBURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *parameters = @{@"ChapterID": ChapterID,@"teacherJiaobaohao": teacherJiaobaohao};
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSArray *array = [ParserJson_OnlineJob parserJsonHomeworkList:result];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetDesHWList" object:array];
        D("JSON--------GetDestHWListWithChapterID: %@,", result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------GetDestHWListWithChapterID: %@", error);
    }];
    
}

//老师发布作业接口
//发布作业的参数在PublishJobModel里
-(void)TecMakeHWWithPublishJobModel:(PublishJobModel*)publishJobModel
{
    NSString *urlString = [NSString stringWithFormat:@"%@TecMakeHW",ONLINEJOBURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSMutableDictionary *parameters = [publishJobModel propertiesDic];
    [parameters removeObjectForKey:@"classIDArr"];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        D("JSON--------TecMakeHWWithPublishJobModel: %@,", result);
        [MBProgressHUD showSuccess:@"发布成功"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        D("Error---------TecMakeHWWithPublishJobModel: %@", error);
        [MBProgressHUD showError:@"发布失败"];
    }];
    
}
//学生个人信息数据接口 参数：用户账号ID - 班级ID
-(void)getStuInfoWithAccID:(NSString*)AccID UID:(NSString*)UID
{
    NSString *urlString = [NSString stringWithFormat:@"%@/Account/getStuInfo",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"AccID":AccID,@"UID":UID};
    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        D("JSON--------getStuInfoWithAccID: %@,", result);
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *code = [jsonDic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        NSString *data = [jsonDic objectForKey:@"Data"];
        NSString *dataStr = [DESTool decryptWithText:data Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        NSDictionary *dic = [ParserJson_OnlineJob parserJsonStuInfo:dataStr];
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        D("Error---------getStuInfoWithAccID: %@", error);
    }];
    
}
//家长数据接口 参数：用户账号ID - 班级ID
-(void)getGenInfoWithAccID:(NSString*)AccID UID:(NSString*)UID
{
    NSString *urlString = [NSString stringWithFormat:@"%@/Account/getGenInfo",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"AccID":AccID,@"UID":UID};
    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        D("JSON--------getGenInfoWithAccID: %@,", result);
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *code = [jsonDic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        NSString *data = [jsonDic objectForKey:@"Data"];
        NSString *dataStr = [DESTool decryptWithText:data Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        NSDictionary *dic = [ParserJson_OnlineJob parserJsonStuInfo:dataStr];
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        D("Error---------getGenInfoWithAccID: %@", error);
    }];
    
}
//学生获取当前作业列表 参数：学生ID
-(void)GetStuHWListWithStuId:(NSString*)StuId
{
    NSString *urlString = [NSString stringWithFormat:@"%@GetStuHWList",ONLINEJOBURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"StuId":StuId};
    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        D("JSON--------GetStuHWListWithStuId: %@,", result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        D("Error---------GetStuHWListWithStuId: %@", error);
    }];
    
}

//获取单题,作业名称,作业题量,作业开始时间,作业时长,作业上交时间 参数：作业ID
-(void)GetStuHWWithHwInfoId:(NSString*)HwInfoId
{
    NSString *urlString = [NSString stringWithFormat:@"%@HwInfoId",ONLINEJOBURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"HwInfoId":HwInfoId};
    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        D("JSON--------GetStuHWListWithStuId: %@,", result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        D("Error---------GetStuHWListWithStuId: %@", error);
    }];
    
}

//获取某作业下某题的作业题及答案 参数：作业ID - 试题ID
-(void)GetStuHWQsWithHwInfoId:(NSString*)HwInfoId QsId:(NSString*)QsId
{
    NSString *urlString = [NSString stringWithFormat:@"%@GetStuHWQs",ONLINEJOBURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"HwInfoId":HwInfoId,@"QsId":QsId};
    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        D("JSON--------GetStuHWListWithStuId: %@,", result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        D("Error---------GetStuHWListWithStuId: %@", error);
    }];
}
//学生递交作业 参数：作业ID - 试题ID - 学生作答该题的答案
-(void)StuSubQsWithHwInfoId:(NSString*)HwInfoId QsId:(NSString*)QsId Answer:(NSString*)Answer
{
    NSString *urlString = [NSString stringWithFormat:@"%@StuSubQs",ONLINEJOBURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"HwInfoId":HwInfoId,@"QsId":QsId,@"Answer":Answer};
    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        D("JSON--------GetStuHWListWithStuId: %@,", result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        D("Error---------GetStuHWListWithStuId: %@", error);
    }];
}
@end
