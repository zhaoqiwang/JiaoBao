//
//  LeaveHttp.h
//  JiaoBao
//
//  Created by SongYanming on 16/3/10.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "dm.h"
#import "ASIFormDataRequest.h"
#import "RSATool.h"
#import "NSString+Base64.h"
#import "NSData+Base64.h"
#import "NSData+CommonCrypto.h"
#import "DESTool.h"
#import "JSONKit.h"
#import "define_constant.h"
#import "ParserJson_share.h"
#import "LoginSendHttp.h"
#import "VlorNetWorkAPI.h"
#import "NewLeaveModel.h"
#import "ParserJson_knowledge.h"
#import "leaveRecordModel.h"

@interface LeaveHttp : NSObject<ASIHTTPRequestDelegate>
+(LeaveHttp *)getInstance;
//取指定单位的请假设置（包括当前登录用户的在该单位的审核权限，门卫权限
-(void)GetLeaveSettingWithUnitId:(NSString*)unitId;
//生成一条请假条记录
-(void)NewLeaveModel:(NewLeaveModel*)model;
//更新一条请假条记录
-(void)UpdateLeaveModel:(NewLeaveModel*)model;
//给一个假条新增加一个时间段
-(void)AddLeaveTime:(NewLeaveModel*)model;
//更新假条的一个时间段
-(void)UpdateLeaveTime:(NewLeaveModel*)model;
//删除假条的一个时间段
-(void)DeleteLeaveTime:(NewLeaveModel*)model;
//删除假条
-(void)DeleteLeaveModel:(NewLeaveModel*)model;
//获得我提出申请的请假记录
-(void)GetMyLeaves:(leaveRecordModel*)model;
//取一个假条的明细信息
-(void)GetLeaveModel:(NSString*)tabId;
//班主任身份获取本班学生请假的审批记录
-(void)GetClassLeaves;



@end
