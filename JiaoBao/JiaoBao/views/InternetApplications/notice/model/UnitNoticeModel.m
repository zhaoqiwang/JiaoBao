//
//  UnitNoticeModel.m
//  JiaoBao
//
//  Created by Zqw on 14-11-28.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "UnitNoticeModel.h"

@implementation UnitNoticeModel
@synthesize write,noticeInfoArray;

-(id)init{
    self.noticeInfoArray = [[NSMutableArray alloc] init];
    return self;
}

@end
