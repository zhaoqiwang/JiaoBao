//
//  OnlineJobHttp.m
//  JiaoBao
//
//  Created by songyanming on 15/10/15.
//  Copyright © 2015年 JSY. All rights reserved.
//

#import "OnlineJobHttp.h"
#import "ParserJson_OnlineJob.h"
#import "StuHWQsModel.h"
#import "StuHomeWorkModel.h"
#import "StuSubModel.h"
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
//获取年纪列表 - 0普通，1手动加全部
-(void)GetGradeList:(int)flag;
{
    NSString *urlString = [NSString stringWithFormat:@"%@/GetGradeList",ONLINEJOBURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];

        NSArray *array = [ParserJson_OnlineJob parserJsonGradeList:result flag:flag];
        
        D("JSON--------GetGradeList: %@,", result);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetGradeList" object:array];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------GetGradeList: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetGradeList" object:nil];
    }];
}
//获取联动列表 //（年级代码）- （科目代码）- （教版联动代码）- （0： 根据年级获取科目，1：根据科目获取教版，2： 根据教版获取章节 - 0普通，1手动加全部
-(void)GetUnionChapterListWithgCode:(NSString*)gCode subCode:(NSString*)subCode uId:(NSString*)uId flag:(NSString*)flag sumFlag:(int)sumFlag
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
        NSString *code = [dic objectForKey:@"statusCode"];
        //长时间不操作，握手通讯失败后，进行登录操作
        Login
        if( [code integerValue] == 200)
        {
//            if([flag integerValue]== 0)//获取科目列表
//            {
                NSArray *array1 = [ParserJson_OnlineJob parserJsonSubjectList:[dic objectForKey:@"args1"] sumFlag:sumFlag];
                
//            }
//            else if ([flag integerValue]== 1)//获取教版列表
//            {
                NSArray *array2 = [ParserJson_OnlineJob parserJsonVersionList:[dic objectForKey:@"args2"] sumFlag:sumFlag];
//            }
//            else if ([flag integerValue]== 2)//获取章节列表
//            {
                NSArray *array3 = [ParserJson_OnlineJob parserJsonChapterList:[dic objectForKey:@"args3"] sumFlag:sumFlag];
//            }
            D("alirjglkgj-=====%@",array3);
//            [self nslogarray3:array3 aaa:0];
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
//-(void)nslogarray3:(NSArray *)array aaa:(int)a{
//    for (ChapterModel *model in array) {
//        D("model-=====%d,%@",model.mInt_flag,model.chapterName);
//        if (model.array.count>0) {
//            a++;
//            [self nslogarray3:model.array aaa:a];
//        }
//    }
//}
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
    D("%@",publishJobModel.className);

    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *HTTPBody = [[NSString alloc]initWithData:operation.request.HTTPBody encoding:NSUTF8StringEncoding];
        NSDictionary * httpObject = [HTTPBody objectFromJSONString];
        NSString *className = [httpObject objectForKey:@"className"];
        D("JSON--------TecMakeHWWithPublishJobModel: %@, %@", result,HTTPBody);
        
        if([result isEqualToString:@"true"]){
            [[NSNotificationCenter defaultCenter]postNotificationName:@"TecMakeHWWithPublishJobModel" object:@"成功" userInfo:httpObject];

        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"TecMakeHWWithPublishJobModel" object:@"失败" userInfo:httpObject];

        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *HTTPBody = [[NSString alloc]initWithData:operation.request.HTTPBody encoding:NSUTF8StringEncoding];
        NSDictionary * httpObject = [HTTPBody objectFromJSONString];
        NSString *className = [httpObject objectForKey:@"className"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"TecMakeHWWithPublishJobModel" object:@"失败" userInfo:httpObject];

        
        D("Error---------TecMakeHWWithPublishJobModel: %@", error);
        //[MBProgressHUD showError:@"发布作业失败"];
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
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        D("JSON--------getStuInfoWithAccID: %@,", result);
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *code = [jsonDic objectForKey:@"ResultCode"];
        //长时间不操作，握手通讯失败后，进行登录操作
        Login
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        NSString *data = [jsonDic objectForKey:@"Data"];
        NSString *dataStr = [DESTool decryptWithText:data Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        D("JSON--------getStuInfoWithAccID111111: %@,", dataStr);
        StuInfoModel *model = [ParserJson_OnlineJob parserJsonStuInfo:dataStr];
        [tempDic setValue:code forKey:@"ResultCode"];
        [tempDic setValue:ResultDesc forKey:@"ResultDesc"];
        [tempDic setValue:model forKey:@"model"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getStuInfo" object:tempDic];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [tempDic setValue:@"100" forKey:@"ResultCode"];
        [tempDic setValue:@"服务器异常" forKey:@"ResultDesc"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getStuInfo" object:tempDic];
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
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        D("JSON--------getGenInfoWithAccID: %@,", result);
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *code = [jsonDic objectForKey:@"ResultCode"];
        //长时间不操作，握手通讯失败后，进行登录操作
        Login
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        NSString *data = [jsonDic objectForKey:@"Data"];
        NSString *dataStr = [DESTool decryptWithText:data Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        GenInfo *model = [ParserJson_OnlineJob parserJsonGenInfo:dataStr];
        [tempDic setValue:code forKey:@"ResultCode"];
        [tempDic setValue:ResultDesc forKey:@"ResultDesc"];
        [tempDic setValue:model forKey:@"model"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getGenInfoWithAccID" object:tempDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [tempDic setValue:@"100" forKey:@"ResultCode"];
        [tempDic setValue:@"服务器异常" forKey:@"ResultDesc"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getGenInfoWithAccID" object:tempDic];
        D("Error---------getGenInfoWithAccID: %@", error);
    }];
    
}
//单位信息获取接口      参数：用户单位ID
-(void)getUnitInfoWithUID:(NSString *)UID{
    NSString *urlString = [NSString stringWithFormat:@"%@/Basic/GetUnitInfo",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"UID":UID};
    //    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
//        NSString *code = [jsonDic objectForKey:@"ResultCode"];
//        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        NSString *data = [jsonDic objectForKey:@"Data"];
        NSString *dataStr = [DESTool decryptWithText:data Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        GetUnitInfoModel *model = [ParserJson_OnlineJob parserJsonGetUnitInfoModel:dataStr];
        D("JSON--------getUnitInfoWithUID: %@,", dataStr);
        //        NSArray *arr =[ParserJson_OnlineJob parserJsonStuHWList:result];
        //        [tempDic setValue:@"0" forKey:@"ResultCode"];
        //        [tempDic setValue:arr forKey:@"array"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"getUnitInfoWithUID" object:model];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------getUnitInfoWithUID: %@", error);
    }];
}

//学生获取当前作业列表 参数：学生ID
//学生获取当前作业列表 参数：学生ID                =0为作业，=1为练习
-(void)GetStuHWListWithStuId:(NSString*)StuId IsSelf:(NSString *)IsSelf
{
    NSString *urlString = [NSString stringWithFormat:@"%@GetStuHWList",ONLINEJOBURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    if ([StuId intValue]>0) {
        
    }else{
        NSMutableDictionary *tempDic0 = [NSMutableDictionary dictionary];
        [tempDic0 setValue:@"100" forKey:@"ResultCode"];
        [tempDic0 setValue:@"学生信息错误" forKey:@"ResultDesc"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetStuHWList" object:tempDic0];
        return;
    }
    NSDictionary *parameters = @{@"StuId":StuId,@"IsSelf":IsSelf};
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        D("JSON--------GetStuHWListWithStuId: %@,", result);
        NSArray *arr =[ParserJson_OnlineJob parserJsonStuHWList:result];
        [tempDic setValue:@"0" forKey:@"ResultCode"];
        [tempDic setValue:arr forKey:@"array"];
        [tempDic setValue:IsSelf forKey:@"IsSelf"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetStuHWList" object:tempDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [tempDic setValue:@"100" forKey:@"ResultCode"];
        [tempDic setValue:@"服务器异常" forKey:@"ResultDesc"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetStuHWList" object:tempDic];
        D("Error---------GetStuHWListWithStuId: %@", error);
    }];
}

//获取单题,作业名称,作业题量,作业开始时间,作业时长,作业上交时间 参数：作业ID
-(void)GetStuHWWithHwInfoId:(NSString*)HwInfoId isStu:(NSString*)isStu
{
    NSString *urlString = [NSString stringWithFormat:@"%@GetStuHW",ONLINEJOBURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"HwInfoId":HwInfoId, @"isStu":isStu};
    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        D("JSON--------GetStuHWWithHwInfoId: %@,", result);
        StuHomeWorkModel *model = [ParserJson_OnlineJob parserJsonStuHW:result];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetStuHWWithHwInfoId" object:model];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        D("Error---------GetStuHWWithHwInfoId: %@", error);
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
        NSString *str1 = [result stringByReplacingOccurrencesOfString:@"\\u003c" withString:@"<"];
        NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@"\\u003e" withString:@">"];
        
        D("JSON--------GetStuHWQsWithHwInfoId: %@,", str2);
        StuHWQsModel *model = [ParserJson_OnlineJob parserJsonStuHWQs:result];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"GetStuHWQsWithHwInfoId" object:model];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        D("Error---------GetStuHWQsWithHwInfoId: %@", error);
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
        D("JSON--------StuSubQsWithHwInfoId: %@,", result);
        StuSubModel *model = [ParserJson_OnlineJob parserJsonStuSubModel:result];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"StuSubQsWithHwInfoId" object:model];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------StuSubQsWithHwInfoId: %@", error);
        StuSubModel *model;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"StuSubQsWithHwInfoId" object:model];

    }];
}

//学生发布练习                学生id                    班级id                    班级名称                        联合id                    章节id                        作业名称                            学校名称
-(void)StuMakeSelfWithStuId:(NSString *)StuId classID:(NSString *)classID className:(NSString *)className Unid:(NSString *)Unid chapterID:(NSString *)chapterID homeworkName:(NSString *)homeworkName schoolName:(NSString *)schoolName{
    NSString *urlString = [NSString stringWithFormat:@"%@StuMakeSelf",ONLINEJOBURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"UserJBH":[dm getInstance].jiaoBaoHao,@"StuId":StuId,@"classID":classID,@"className":className,@"Unid":Unid,@"chapterID":chapterID,@"homeworkName":homeworkName,@"schoolName":schoolName,@"IsSys":@"2"};
    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        D("JSON--------StuMakeSelf: %@,",result);
//        {"ok":true,"stateCode":200,"stateMessage":"发送成功"},
        //异常牛逼的给值方式，32个👍
        NSDictionary *dic = [result objectFromJSONString];
        if ([[dic objectForKey:@"stateCode"] intValue] ==200) {
            if ([[dic objectForKey:@"ok"] intValue]==1) {
                [tempDic setValue:@"0" forKey:@"ResultCode"];
                [tempDic setValue:[dic objectForKey:@"stateMessage"] forKey:@"ResultDesc"];
            }else{
                [tempDic setValue:@"100" forKey:@"ResultCode"];
                [tempDic setValue:@"根据您的当前学力值未抽选到合适的题目,无法生成试卷" forKey:@"ResultDesc"];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"StuMakeSelf" object:tempDic];
        }else{
            [tempDic setValue:@"100" forKey:@"ResultCode"];
            [tempDic setValue:[dic objectForKey:@"stateMessage"] forKey:@"ResultDesc"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"StuMakeSelf" object:tempDic];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [tempDic setValue:@"100" forKey:@"ResultCode"];
        [tempDic setValue:@"服务器异常" forKey:@"ResultDesc"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"StuMakeSelf" object:tempDic];
        D("Error---------StuMakeSelf: %@", error);
    }];
}

//获取某学生学力值 参数：学生ID - 教版科目ID - 章节ID - 0学生id取值1教版取值2章取值
-(void)GetStuEduLevelWithStuId:(NSString*)StuId uId:(NSString*)uId chapterid:(NSString*)chapterid flag:(NSString *)flag
{
    D("sdfgjlksgjkl-=====%@,%@,%@,%@",StuId,uId,chapterid,flag);
    NSString *urlString = [NSString stringWithFormat:@"%@GetStuEduLevel",ONLINEJOBURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"StuId":StuId,@"uId":uId,@"chapterid":chapterid};
    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        D("JSON--------GetStuEduLevelWithStuId: %@,", result);
        NSArray *levelArr = [ParserJson_OnlineJob parserJsonStuEduLevel:result];
        [tempDic setValue:@"0" forKey:@"ResultCode"];
        [tempDic setValue:levelArr forKey:@"array"];
        [tempDic setValue:uId forKey:@"uId"];
        [tempDic setValue:chapterid forKey:@"chapterid"];
        [tempDic setValue:StuId forKey:@"StuId"];
        [tempDic setValue:flag forKey:@"flag"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetStuEduLevel" object:tempDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [tempDic setValue:@"100" forKey:@"ResultCode"];
        [tempDic setValue:@"服务器异常" forKey:@"ResultDesc"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetStuEduLevel" object:tempDic];
        D("Error---------GetStuEduLevelWithStuId: %@", error);
    }];
}

//获取某学生各科作业完成情况 参数：学生ID
-(void)GetCompleteStatusHWWithStuId:(NSString*)StuId
{
    NSString *urlString = [NSString stringWithFormat:@"%@GetCompleteStatusHW",ONLINEJOBURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"StuId":StuId};
    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        D("JSON--------GetCompleteStatusHWWithStuId: %@,", result);
        NSArray *CompleteStatusArr = [ParserJson_OnlineJob parserJsonCompleteStatusHWWith:result];
        [tempDic setValue:@"0" forKey:@"ResultCode"];
        [tempDic setValue:CompleteStatusArr forKey:@"array"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetCompleteStatusHW" object:tempDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [tempDic setValue:@"100" forKey:@"ResultCode"];
        [tempDic setValue:@"服务器异常" forKey:@"ResultDesc"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetCompleteStatusHW" object:tempDic];
        D("Error---------GetCompleteStatusHWWithStuId: %@", error);
    }];
}

//根据章节id判断题库中是否有数据      章节id
-(void)TecQswithchapterid:(NSString*)chapterid
{
    NSString *urlString = [NSString stringWithFormat:@"%@TecQs",ONLINEJOBURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"chapterid":chapterid};
    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        D("JSON--------TecQswithchapterid: %@,", result);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"TecQswithchapterid" object:result];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"TecQswithchapterid" object:error.localizedDescription];
        D("Error---------TecQswithchapterid: %@", error);
    }];
}
-(void)GetSQLDateTime{
    NSString *urlString = [NSString stringWithFormat:@"%@GetSQLDateTime",ONLINEJOBURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetSQLDateTime" object:result];
        
        D("JSON--------GetSQLDateTime: %@,", result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
}
// 错题表
-(void)GetStuErr:(StuErrModel*)model{
    NSString *urlString = [NSString stringWithFormat:@"%@GetStuErr",ONLINEJOBURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *parameters = [model propertiesDic];
    
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        D("JSON--------GetStuErr: %@,", result);
        NSMutableArray *mArr = [ParserJson_OnlineJob parserJsonStuErr:result];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"GetStuErr" object:mArr];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------GetStuErr: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetStuErr" object:nil];
    }];
    
}
// 根据学生ID分页获取作业或练习列表 参数：学生ID - （0作业,1练习）- 页码 - 页记录数
-(void)GetStuHWListPageWithStuId:(NSString*)StuId IsSelf:(NSString*)IsSelf PageIndex:(NSString*)PageIndex PageSize:(NSString*)PageSize{

    
        NSString *urlString = [NSString stringWithFormat:@"%@GetStuHWListPage",ONLINEJOBURL];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer.timeoutInterval = TIMEOUT;
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        if ([StuId intValue]>0) {
            
        }else{
            NSMutableDictionary *tempDic0 = [NSMutableDictionary dictionary];
            [tempDic0 setValue:@"100" forKey:@"ResultCode"];
            [tempDic0 setValue:@"学生信息错误" forKey:@"ResultDesc"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GetStuHWListPageWithStuId" object:tempDic0];
            return;
        }
        NSDictionary *parameters = @{@"StuId":StuId,@"IsSelf":IsSelf,@"PageIndex":PageIndex,@"PageSize":PageSize,};
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            D("JSON--------GetStuHWListPageWithStuId: %@,", result);
            NSArray *arr =[ParserJson_OnlineJob parserJsonStuHWList:result];
            [tempDic setValue:@"0" forKey:@"ResultCode"];
            [tempDic setValue:arr forKey:@"array"];
            [tempDic setValue:IsSelf forKey:@"IsSelf"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GetStuHWListPageWithStuId" object:tempDic];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [tempDic setValue:@"100" forKey:@"ResultCode"];
            [tempDic setValue:@"服务器异常" forKey:@"ResultDesc"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GetStuHWListPageWithStuId" object:tempDic];
            D("Error---------GetStuHWListPageWithStuId: %@", error);
        }];
    
}


@end
