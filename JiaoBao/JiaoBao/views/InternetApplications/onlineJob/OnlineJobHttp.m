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
//获取年纪列表
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
//获取联动列表
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
                NSLog(@"diofgoidshgoi-===000=%@",array1);
                
//            }
//            else if ([flag integerValue]== 1)//获取教版列表
//            {
                NSArray *array2 = [ParserJson_OnlineJob parserJsonVersionList:[dic objectForKey:@"args2"]];
                NSLog(@"diofgoidshgoi-===111=%@",array2);
//            }
//            else if ([flag integerValue]== 2)//获取章节列表
//            {
                NSArray *array3 = [ParserJson_OnlineJob parserJsonChapterList:[dic objectForKey:@"args3"]];
                NSLog(@"diofgoidshgoi-===222=%@",array3);
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
//获取自定义作业列表
-(void)GetDesHWListWithChapterID:(NSString*)ChapterID teacherJiaobaohao:(NSString*)teacherJiaobaohao
{
    NSString *urlString = [NSString stringWithFormat:@"%@GetDesHWList",ONLINEJOBURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    //[manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *parameters = @{@"ChapterID": ChapterID,@"teacherJiaobaohao": teacherJiaobaohao};
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        D("JSON--------GetDestHWListWithChapterID: %@,", result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        D("Error---------GetDestHWListWithChapterID: %@", error);
    }];
    
}
//
-(void)GetStuHWListWithStuId:(NSString*)StuId
{
    
}
//获取单题，作业名称作业题量，作业开始时间，作业时长，作业上交时间
-(void)GetStuHWWithHwInfoId:(NSString*)HwInfoId
{
    
}


@end
