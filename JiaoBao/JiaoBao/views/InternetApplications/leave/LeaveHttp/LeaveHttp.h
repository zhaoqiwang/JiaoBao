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
#import "CheckLeaveModel.h"


@interface LeaveHttp: NSObject<ASIHTTPRequestDelegate>
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
//取得我的教宝号所关联的学生列表(家长身份）
-(void)GetMyStdInfo:(NSString *)accId;

//作为班主任身份,取得我所管理的班级列表
-(void)GetMyAdminClass:(NSString*)accId;

//班主任身份获取本班学生请假的审批记录
-(void)GetClassLeaves:(leaveRecordModel*)model;

//审核人员取单位的请假记录
-(void)GetUnitLeaves:(leaveRecordModel*)model;

//功能： 门卫取请假记录，用于登记请假人离校和返回校的时间。查询标准有以下三条，须同时成立：
//假条审批全通过
//请假的开始时间小于当前日期时间
//当前日期时间小于请假的结束时间当天的24点
-(void)GetGateLeaves:(leaveRecordModel*)model;

//审批人审批假条，并做批注。
-(void)CheckLeaveModel:(CheckLeaveModel*)model;

//门卫登记离校返校时间 参数：请假时间记录ID - 登记人姓名 - 0离校，1返校
-(void)UpdateGateInfo:(NSString*)tabid userName:(NSString*)userName flag:(NSString*)flag;

//获取指定班级的所有学生数据列表
-(void)getClassStdInfoWithUID:(NSString*)UID;
//应用系统通过单位ID，获取学校所有班级
-(void)getunitclassWithUID:(NSString*)UID;


@end
