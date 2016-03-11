//
//  ParserJson_leave.h
//  JiaoBao
//
//  Created by SongYanming on 16/3/10.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"
#import "LeaveSettingModel.h"
#import "LevelNoteModel.h"
#import "MyLeaveModel.h"
#import "LeaveDetailModel.h"


@interface ParserJson_leave : NSObject

//取指定单位的请假设置
+(LeaveSettingModel *)parserJsonGetLeaveSetting:(NSString *)json;
//获得我提出申请的请假记录
+(NSMutableArray*)parserJsonMyLeaves:(NSString*)json;
//取一个假条的明细信息
+(LeaveDetailModel*)parserJsonleaveDetail:(NSString*)json;
@end
