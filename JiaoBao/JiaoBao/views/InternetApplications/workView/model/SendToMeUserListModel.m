//
//  SendToMeUserListModel.m
//  JiaoBao
//
//  Created by Zqw on 15-2-9.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "SendToMeUserListModel.h"

@implementation SendToMeUserListModel
@synthesize LastID,CommMsgList;

-(id)init{
    self.CommMsgList = [NSMutableArray array];
    return self;
}

@end

@implementation CommMsgListModel
@synthesize TabIDStr,MsgContent,RecDate,JiaoBaoHao,NoReadCount,NoReplyCount,UserName,flag,ReadFlag;

@end