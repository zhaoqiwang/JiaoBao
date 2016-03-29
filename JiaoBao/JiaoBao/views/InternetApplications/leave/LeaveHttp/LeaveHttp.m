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
#import "StuInfoModel.h"
#import "ParserJson_OnlineJob.h"
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
        LeaveSettingModel *model = [ParserJson_leave parserJsonGetLeaveSetting:data];
        [dm getInstance].leaveModel = model;
        D("JSON--------GetLeaveSettingWithUnitId: %@,", result);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetLeaveSettingWithUnitId" object:nil];
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
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *ResultCode = [jsonDic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        NSDictionary *dic = @{@"ResultCode":ResultCode,@"ResultDesc":ResultDesc};
        
         [[NSNotificationCenter defaultCenter] postNotificationName:@"NewLeaveModel" object:dic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------NewLeaveModel: %@", error);
        NSString *ResultCode= @"100";
        NSString *ResultDesc= error.localizedDescription;
        NSDictionary *dic = @{@"ResultCode":ResultCode,@"ResultDesc":ResultDesc};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NewLeaveModel" object:dic];
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
//删除假条的一个时间段 参数：时间段记录Id
-(void)DeleteLeaveTime:(NSString*)tabId{
    NSString *urlString = [NSString stringWithFormat:@"%@/Leave/DeleteLeaveTime",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"tabId":tabId};
    
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        D("JSON--------DeleteLeaveTime: %@,", result);
        // [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteLeaveTime" object:array];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------DeleteLeaveTime: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteLeaveTime" object:nil];
    }];
    
}
//删除假条 参数：请假记录Id
-(void)DeleteLeaveModel:(NSString*)tabId{
    NSString *urlString = [NSString stringWithFormat:@"%@/Leave/DeleteLeaveModel",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"tabId":tabId};
    
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
        NSString *HTTPBody = [[NSString alloc]initWithData:operation.request.HTTPBody encoding:NSUTF8StringEncoding];
        NSDictionary * httpObject = [HTTPBody objectFromJSONString];
        NSString *manType = [httpObject objectForKey:@"manType"];
        D("JSON--------GetMyLeaves: %@,", result);
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *data = [jsonDic objectForKey:@"Data"];
        NSString *ResultCode = [jsonDic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];

        NSMutableArray *mArr = [ParserJson_leave parserJsonClassLeaves:data];
        NSDictionary *dic = @{@"data":mArr,@"ResultCode":ResultCode,@"ResultDesc":ResultDesc,@"manType":manType};
         [[NSNotificationCenter defaultCenter] postNotificationName:@"GetMyLeaves" object:dic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *ResultCode= @"100";
        NSString *ResultDesc= error.localizedDescription;
        NSDictionary *dic = @{@"ResultCode":ResultCode,@"ResultDesc":ResultDesc};

        D("Error---------GetMyLeaves: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetMyLeaves" object:dic];
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
        NSString *ResultCode = [jsonDic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        NSDictionary *dic = @{@"model":model,@"ResultCode":ResultCode,@"ResultDesc":ResultDesc};
         [[NSNotificationCenter defaultCenter] postNotificationName:@"GetLeaveModel" object:dic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------GetLeaveModel: %@", error);
        NSString *ResultCode= @"100";
        NSString *ResultDesc= error.localizedDescription;
        NSDictionary *dic = @{@"ResultCode":ResultCode,@"ResultDesc":ResultDesc};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetLeaveModel" object:dic];
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
        NSString *ResultCode = [jsonDic objectForKey:@"ResultCode"];
        NSString *ResultDesc = [jsonDic objectForKey:@"ResultDesc"];
        
        NSMutableArray *mArr = [ParserJson_leave parserJsonClassLeaves:data];
        NSDictionary *dic = @{@"data":mArr,@"ResultCode":ResultCode,@"ResultDesc":ResultDesc};

         [[NSNotificationCenter defaultCenter] postNotificationName:@"GetClassLeaves" object:dic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *ResultCode= @"100";
        NSString *ResultDesc= error.localizedDescription;
        NSDictionary *dic = @{@"ResultCode":ResultCode,@"ResultDesc":ResultDesc};
        D("Error---------GetClassLeaves: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetClassLeaves" object:dic];
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
         [[NSNotificationCenter defaultCenter] postNotificationName:@"GetUnitLeaves" object:mArr];
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
        NSMutableArray *mArr = [ParserJson_leave parserJsonGateLeaves:data];
        // [[NSNotificationCenter defaultCenter] postNotificationName:@"GetGateLeaves" object:array];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------GetGateLeaves: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetGateLeaves" object:nil];
    }];
    
}
//审批人审批假条，并做批注。
-(void)CheckLeaveModel:(CheckLeaveModel*)model{
    NSString *urlString = [NSString stringWithFormat:@"%@/Leave/CheckLeaveModel",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *parameters = [model propertiesDic];
    
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSMutableDictionary *jsonDic = [result objectFromJSONString];

        D("JSON--------CheckLeaveModel: %@,", result);
        NSString *ResultCode = [jsonDic objectForKey:@"ResultCode"];

         [[NSNotificationCenter defaultCenter] postNotificationName:@"CheckLeaveModel" object:ResultCode];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------CheckLeaveModel: %@", error);
        NSString *ResultCode = @"100";

        [[NSNotificationCenter defaultCenter] postNotificationName:@"CheckLeaveModel" object:ResultCode];
    }];
    
}
//门卫登记离校返校时间 参数：请假时间记录ID - 登记人姓名 - 0离校，1返校
-(void)UpdateGateInfo:(NSString*)tabid userName:(NSString*)userName
                 flag:(NSString*)flag{
    NSString *urlString = [NSString stringWithFormat:@"%@/Leave/UpdateGateInfo",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"tabid":tabid,@"userName":userName,@"flag":flag,};
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        D("JSON--------UpdateGateInfo: %@,", result);
        
        // [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateGateInfo" object:array];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------UpdateGateInfo: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateGateInfo" object:nil];
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
        [dm getInstance].mArr_leaveStudent = mArr;
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
            [dm getInstance].mArr_leaveClass = mArr;
            // [[NSNotificationCenter defaultCenter] postNotificationName:@"GetMyAdminClass" object:array];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            D("Error---------GetMyAdminClass: %@", error);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GetMyAdminClass" object:nil];
        }];
        
    }
    
}

//获取指定班级的所有学生数据列表
-(void)getClassStdInfoWithUID:(NSString*)UID{
    NSString *urlString = [NSString stringWithFormat:@"%@/basic/getClassStdInfo",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"UID":UID};
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *data = [jsonDic objectForKey:@"Data"];
        NSString *str000 = [DESTool decryptWithText:data Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        D("JSON--------getClassStdInfoWithUID: %@,", str000);
        NSMutableArray *mArr = [ParserJson_leave parserJsonStuInfoArr:str000];
        
//        NSMutableArray *mArr = [ParserJson_leave parserJsonMyAdminClass:data];
//        [dm getInstance].mArr_leaveClass = mArr;
         [[NSNotificationCenter defaultCenter] postNotificationName:@"getClassStdInfoWithUID" object:mArr];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------getClassStdInfoWithUID: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getClassStdInfoWithUID" object:nil];
    }];
    
}
//应用系统通过单位ID，获取学校所有班级
-(void)getunitclassWithUID:(NSString*)UID{
    NSString *urlString = [NSString stringWithFormat:@"%@/basic/getunitclass",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"UID":UID};
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *data = [jsonDic objectForKey:@"Data"];
        NSString *str000 = [DESTool decryptWithText:data Key:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientKey"]];
        D("JSON--------getunitclassWithUID: %@,", str000);
        NSMutableArray *mArr = [ParserJson_leave parserJsonUserClassInfoArr:str000];
        
        //        NSMutableArray *mArr = [ParserJson_leave parserJsonMyAdminClass:data];
        //        [dm getInstance].mArr_leaveClass = mArr;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getunitclassWithUID" object:mArr];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------getunitclassWithUID: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getunitclassWithUID" object:nil];
    }];
    
}
//学校班级请假查询统计
-(void)GetClassSumLeavesWithUnitId:(NSString*)unitId sDateTime:(NSString*)sDateTime gradeStr:(NSString*)gradeStr{
    NSString *urlString = [NSString stringWithFormat:@"%@/Leave/GetClassSumLeaves",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"unitId":unitId,@"sDateTime":sDateTime,@"gradeStr":gradeStr};
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *data = [jsonDic objectForKey:@"Data"];
        D("JSON--------GetClassSumLeaves: %@,", result);
        NSMutableArray *mArr = [ParserJson_leave parserJsonGetClassSumLeaves:data ];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetClassSumLeaves" object:mArr];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------GetClassSumLeaves: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetClassSumLeaves" object:nil];
    }];
}
//班级学生查询统计
-(void)GetStudentSumLeavesWithUnitId:(NSString*)unitClassId sDateTime:(NSString*)sDateTime{
    NSString *urlString = [NSString stringWithFormat:@"%@/Leave/GetStudentSumLeaves",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"unitClassId":unitClassId,@"sDateTime":sDateTime};
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *data = [jsonDic objectForKey:@"Data"];
        NSMutableArray *mArr = [ParserJson_leave parserJsonGetClassSumLeaves:data ];
        D("JSON--------GetStudentSumLeaves: %@,", result);
        
        
         [[NSNotificationCenter defaultCenter] postNotificationName:@"GetStudentSumLeaves" object:mArr];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------GetStudentSumLeaves: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetStudentSumLeaves" object:nil];
    }];
}

//教职工请假查询统计
-(void)GetManSumLeavesWithUnitId:(NSString*)unitId sDateTime:(NSString*)sDateTime{
    NSString *urlString = [NSString stringWithFormat:@"%@/Leave/GetManSumLeaves",MAINURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"unitId":unitId,@"sDateTime":sDateTime};
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSMutableDictionary *jsonDic = [result objectFromJSONString];
        NSString *data = [jsonDic objectForKey:@"Data"];
        D("JSON--------GetManSumLeaves: %@,", result);
        NSMutableArray *mArr = [ParserJson_leave parserJsonGetClassSumLeaves:data ];
        
         [[NSNotificationCenter defaultCenter] postNotificationName:@"GetManSumLeaves" object:mArr];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D("Error---------GetManSumLeaves: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetManSumLeaves" object:nil];
    }];
    
}


@end
