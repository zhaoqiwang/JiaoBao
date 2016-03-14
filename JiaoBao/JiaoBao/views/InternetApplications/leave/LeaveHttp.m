//
//  LeaveHttp.m
//  JiaoBao
//
//  Created by SongYanming on 16/3/10.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "LeaveHttp.h"
#import "define_constant.h"
#import "ParserJson_leave.h"
#import "MyLeaveModel.h"
#import "LeaveDetailModel.h"
#import "ClassLeavesModel.h"
static LeaveHttp *leaveHttp = nil;

@implementation LeaveHttp
+(LeaveHttp *)getInstance{
    if (leaveHttp == nil) {
        leaveHttp = [[LeaveHttp alloc] init];
    }
    return leaveHttp;
}
-(id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}
//取指定单位的请假设置（包括当前登录用户的在该单位的审核权限，门卫权限
-(void)GetLeaveSettingWithUnitId:(NSString*)unitId{
    NSString *urlString = [NSString stringWithFormat:@"%@/Leave/GetLeaveSetting",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"unitId": unitId};

    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *data = [jsonDic objectForKey:@"Data"];
        [ParserJson_leave parserJsonGetLeaveSetting:data];
        
        D("JSON--------GetLeaveSettingWithUnitId: %@,", result);
       // [[NSNotificationCenter defaultCenter] postNotificationName:@"GetLeaveSettingWithUnitId" object:array];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------GetLeaveSettingWithUnitId: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetLeaveSettingWithUnitId" object:nil];
    }];
}
//生成一条请假条记录
-(void)NewLeaveModel:(NewLeaveModel*)model{
    NSString *urlString = [NSString stringWithFormat:@"%@/Leave/NewLeaveModel",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *parameters = [model propertiesDic];
    
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        D("JSON--------NewLeaveModel: %@,", result);
        // [[NSNotificationCenter defaultCenter] postNotificationName:@"NewLeaveModel" object:array];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------NewLeaveModel: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NewLeaveModel" object:nil];
    }];
    
}
//更新一条请假条记录
-(void)UpdateLeaveModel:(NewLeaveModel*)model{
    NSString *urlString = [NSString stringWithFormat:@"%@/Leave/UpdateLeaveModel",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *parameters = [model propertiesDic];
    
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        D("JSON--------UpdateLeaveModel: %@,", result);
        // [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateLeaveModel" object:array];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------UpdateLeaveModel: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateLeaveModel" object:nil];
    }];

    
}
//给一个假条新增加一个时间段
-(void)AddLeaveTime:(NewLeaveModel*)model{
    NSString *urlString = [NSString stringWithFormat:@"%@/Leave/AddLeaveTime",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *parameters = [model propertiesDic];
    
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        D("JSON--------AddLeaveTime: %@,", result);
        // [[NSNotificationCenter defaultCenter] postNotificationName:@"AddLeaveTime" object:array];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------AddLeaveTime: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AddLeaveTime" object:nil];
    }];
    
    
}
//更新假条的一个时间段
-(void)UpdateLeaveTime:(NewLeaveModel*)model{
    NSString *urlString = [NSString stringWithFormat:@"%@/Leave/UpdateLeaveTime",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *parameters = [model propertiesDic];
    
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        D("JSON--------UpdateLeaveTime: %@,", result);
        // [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateLeaveTime" object:array];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------UpdateLeaveTime: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateLeaveTime" object:nil];
    }];
    
    
}
//删除假条的一个时间段
-(void)DeleteLeaveTime:(NewLeaveModel*)model{
    NSString *urlString = [NSString stringWithFormat:@"%@/Leave/DeleteLeaveTime",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *parameters = [model propertiesDic];
    
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        D("JSON--------DeleteLeaveTime: %@,", result);
        // [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteLeaveTime" object:array];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------DeleteLeaveTime: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteLeaveTime" object:nil];
    }];
    
}
//删除假条
-(void)DeleteLeaveModel:(NewLeaveModel*)model{
    NSString *urlString = [NSString stringWithFormat:@"%@/Leave/DeleteLeaveModel",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *parameters = [model propertiesDic];
    
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        D("JSON--------DeleteLeaveModel: %@,", result);
        // [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteLeaveModel" object:array];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------DeleteLeaveModel: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteLeaveModel" object:nil];
    }];
    
}
//获得我提出申请的请假记录
-(void)GetMyLeaves:(leaveRecordModel*)model{
    NSString *urlString = [NSString stringWithFormat:@"%@/Leave/GetMyLeaves",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *parameters = [model propertiesDic];
    
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        D("JSON--------GetMyLeaves: %@,", result);
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *data = [jsonDic objectForKey:@"Data"];
        NSMutableArray *mArr = [ParserJson_leave parserJsonMyLeaves:data];
        // [[NSNotificationCenter defaultCenter] postNotificationName:@"GetMyLeaves" object:array];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------GetMyLeaves: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetMyLeaves" object:nil];
    }];
    
}
//取一个假条的明细信息
-(void)GetLeaveModel:(NSString*)tabId{
    NSString *urlString = [NSString stringWithFormat:@"%@/Leave/GetLeaveModel",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"tabId":tabId};
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        D("JSON--------GetLeaveModel: %@,", result);
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *data = [jsonDic objectForKey:@"Data"];
        LeaveDetailModel *model = [ParserJson_leave parserJsonleaveDetail:data];
        // [[NSNotificationCenter defaultCenter] postNotificationName:@"GetLeaveModel" object:array];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------GetLeaveModel: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetLeaveModel" object:nil];
    }];
}
//班主任身份获取本班学生请假的审批记录
-(void)GetClassLeaves:(leaveRecordModel*)model{
    NSString *urlString = [NSString stringWithFormat:@"%@/Leave/GetClassLeaves",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *parameters = [model propertiesDic];
    
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        D("JSON--------GetClassLeaves: %@,", result);
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *data = [jsonDic objectForKey:@"Data"];
        NSMutableArray *mArr = [ParserJson_leave parserJsonClassLeaves:data];
        // [[NSNotificationCenter defaultCenter] postNotificationName:@"GetClassLeaves" object:array];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------GetClassLeaves: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetClassLeaves" object:nil];
    }];
    
}
//审核人员取单位的请假记录
-(void)GetUnitLeaves:(leaveRecordModel*)model{
    NSString *urlString = [NSString stringWithFormat:@"%@/Leave/GetUnitLeaves",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *parameters = [model propertiesDic];
    
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        D("JSON--------GetUnitLeaves: %@,", result);
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *data = [jsonDic objectForKey:@"Data"];
        NSMutableArray *mArr = [ParserJson_leave parserJsonClassLeaves:data];
        // [[NSNotificationCenter defaultCenter] postNotificationName:@"GetMyLeaves" object:array];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------GetUnitLeaves: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetUnitLeaves" object:nil];
    }];
    
}
//功能： 门卫取请假记录，用于登记请假人离校和返回校的时间。查询标准有以下三条，须同时成立：
//假条审批全通过
//请假的开始时间小于当前日期时间
//当前日期时间小于请假的结束时间当天的24点
-(void)GetGateLeaves:(leaveRecordModel*)model{
    NSString *urlString = [NSString stringWithFormat:@"%@/Leave/GetGateLeaves",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *parameters = [model propertiesDic];
    
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        D("JSON--------GetGateLeaves: %@,", result);
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *data = [jsonDic objectForKey:@"Data"];
        NSMutableArray *mArr = [ParserJson_leave parserJsonClassLeaves:data];
        // [[NSNotificationCenter defaultCenter] postNotificationName:@"GetGateLeaves" object:array];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------GetGateLeaves: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetGateLeaves" object:nil];
    }];
    
}

//取得我的教宝号所关联的学生列表(家长身份）
-(void)GetMyStdInfo:(NSString *)accId{
    NSString *urlString = [NSString stringWithFormat:@"%@/Account/GetMyStdInfo",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"accId":accId};
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        D("JSON--------GetMyStdInfo: %@,", result);
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *data = [jsonDic objectForKey:@"Data"];
        NSMutableArray *mArr = [ParserJson_leave parserJsonMyStdInfo:data];
        // [[NSNotificationCenter defaultCenter] postNotificationName:@"GetMyStdInfo" object:array];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------GetMyStdInfo: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetMyStdInfo" object:nil];
    }];
    
}
//作为班主任身份,取得我所管理的班级列表
-(void)GetMyAdminClass:(NSString*)accId{
    {
        NSString *urlString = [NSString stringWithFormat:@"%@/Account/GetMyAdminClass",MAINURL];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer.timeoutInterval = TIMEOUT;
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSDictionary *parameters = @{@"accId":accId};
        [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            
            D("JSON--------GetMyAdminClass: %@,", result);
            NSMutableDictionary *jsonDic = [result objectFromJSONString];
            NSString *data = [jsonDic objectForKey:@"Data"];
            NSMutableArray *mArr = [ParserJson_leave parserJsonMyAdminClass:data];
            // [[NSNotificationCenter defaultCenter] postNotificationName:@"GetMyAdminClass" object:array];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            D("Error---------GetMyAdminClass: %@", error);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GetMyAdminClass" object:nil];
        }];
        
    }
    
}




@end
