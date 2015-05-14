//
//  ParserJson_identity.h
//  JiaoBao
//
//  Created by Zqw on 14-10-24.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Identity_model.h"
#import "Identity_UserClasses_model.h"
#import "Identity_UserUnits_model.h"
#import "JSONKit.h"
#import "UnReadMsg_model.h"
#import "dm.h"
#import "MsgDetail_FeebackList.h"
#import "MsgDetail_AttList.h"
#import "MsgDetail_ReaderList.h"
#import "MsgDetail_TrunToList.h"
#import "CMRevicerModel.h"
#import "UserListModel.h"
#import "groupselit_selitModel.h"
#import "UnitClassRevicerModel.h"
#import "selitadminModel.h"
#import "SMSTreeUnitModel.h"
#import "UserInfoModel.h"
#import "CommMsgRevicerUnitListModel.h"
#import "SendToMeUserListModel.h"
#import "GetmyUserClassModel.h"

@interface ParserJson : NSObject


//解析获取到的人员个人信息json
+(NSMutableArray *)parserJsonwith:(NSString *)json;

//解析已处理未回复的信息
+(NSMutableArray *)parserJsonUnReadMsgWith:(NSString *)json;

//解析信息详情
+(UnReadMsg_model *)parserJsonMsgDetailWithUnReadMsg:(NSString *)json;

//解析信息详情，feebackList
+(NSMutableArray *)parserJsonMsgDetailWithFeeBackList:(NSString *)json;

//解析接收人列表
+(CMRevicerModel *)parserJsonCMRevicerWith:(NSString *)json;

//解析短信直通车的人员列表
+(NSMutableArray *)parserJsonSMSUnitWith:(NSString *)json;

//解析个人信息
+(UserInfoModel *)parserJsonUserInfoWith:(NSString *)json;

//解析获取事务信息接收单位列表，new
+(CommMsgRevicerUnitListModel *)parserJsonCommMsgRevicerUnitList:(NSString *)json;

//解析每个单位中的人员
+(NSMutableArray *)parserUserList_json:(NSString *)json;

//解析每个单位中的人员
+(NSMutableArray *)parserUserListClass_json:(NSString *)json;

//解析下发通知的群发
+(NSMutableArray *)parserSelitadmintomem:(NSArray *)arrlist;
+(NSMutableArray *)parserSelitadmintomem:(NSArray *)arrlist Flag:(NSString *)flag;

//获取我发送的消息列表 new
+(NSMutableArray *)parserJsonGetMySendMsgList:(NSString *)json;

//取发给我消息的用户列表。new
+(SendToMeUserListModel *)parserJsonSendToMeUserList:(NSString *)json;

//获取到关联的班级
+(NSMutableArray *)parserJsonGetmyUserClass:(NSString *)json;

@end
