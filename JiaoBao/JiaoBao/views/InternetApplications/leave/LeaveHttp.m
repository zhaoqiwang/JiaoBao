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


@end
