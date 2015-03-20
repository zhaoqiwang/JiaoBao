//
//  UserInfoByUnitIDModel.m
//  JiaoBao
//
//  Created by Zqw on 14-12-3.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "UserInfoByUnitIDModel.h"

@implementation UserInfoByUnitIDModel
@synthesize isAdmin,UserID,UserName,AccID,GroupFlag;

-(id)init{
    self.GroupFlag = [[NSMutableArray alloc] init];
    self.isAdmin = @"";
    self.UserID = @"";
    self.UserName = @"";
    self.AccID = @"";
    return self;
}

@end
