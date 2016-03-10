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

@interface LeaveHttp : NSObject<ASIHTTPRequestDelegate>
+(LeaveHttp *)getInstance;
//取指定单位的请假设置（包括当前登录用户的在该单位的审核权限，门卫权限
-(void)GetLeaveSettingWithUnitId:(NSString*)unitId;
//保存一条新增加的请假记录
-(void)NewLeaveModel:(NewLeaveModel*)model;
//更新一条请假条记录
-(void)UpdateLeaveModel:(NewLeaveModel*)model;
@end
