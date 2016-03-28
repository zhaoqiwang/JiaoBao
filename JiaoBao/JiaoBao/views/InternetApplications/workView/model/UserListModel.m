//
//  UserListModel.m
//  JiaoBao
//
//  Created by Zqw on 14-11-4.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "UserListModel.h"

@implementation UserListModel
@synthesize GroupName,MCount,groupselit_selit;

-(id)init{
    self = [super init];
    self.groupselit_selit = [[NSMutableArray alloc] init];
    self.sectionSelSymbol = 0;
    self.cellSelNum = 0;
    return self;
}

@end
