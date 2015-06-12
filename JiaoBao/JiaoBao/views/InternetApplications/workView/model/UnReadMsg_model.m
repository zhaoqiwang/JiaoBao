//
//  UnReadMsg_model.m
//  JiaoBao
//
//  Created by Zqw on 14-10-25.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "UnReadMsg_model.h"

@implementation UnReadMsg_model
@synthesize TabIDStr,UserName,MsgContent,RecDate,JiaoBaoHao,arrayAttList,arrayReaderList,arrayTrunToList,MsgTabIDStr,FeeBackMsg;

-(id)init{
    self = [super init];
    self.arrayAttList = [[NSMutableArray alloc] init];
    self.arrayReaderList = [[NSMutableArray alloc] init];
    self.arrayTrunToList = [[NSMutableArray alloc] init];
    return self;
}

@end
