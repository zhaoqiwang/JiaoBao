//
//  dm.m
//  JiaoBao
//
//  Created by Zqw on 14-10-18.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "dm.h"
static dm* dmone = nil;

@implementation dm
@synthesize width,height,url,statusBar,jiaoBaoHao,identity,name,UID,uType,unReadMsg1,unReadMsg2,mStr_unit,mStr_tableID,userInfo,mImt_shareUnRead,mImt_showUnRead,TrueName,rongYunModel,mArr_rongYunGroup,mArr_rongYunUser,mArr_unit_member,mArr_myFriends,uuid,MainUrl,RiCUrl,KaoQUrl,NickName,tableSymbol;

+(dm*) getInstance {
    if(dmone == nil) {
        dmone = [[dm alloc] init];
    }
    return dmone;
}

-(id) init {
    self = [super init];
    if (self) {
        self.identity = [[NSMutableArray alloc] init];
        self.mArr_rongYunUser = [[NSMutableArray alloc] init];
        self.mArr_rongYunGroup = [[NSMutableArray alloc] init];
        self.mArr_unit_member = [[NSMutableArray alloc] init];
        self.mArr_myFriends = [[NSMutableArray alloc] init];
        self.mStr_unit = @"";
    }
    return self;
}

@end
