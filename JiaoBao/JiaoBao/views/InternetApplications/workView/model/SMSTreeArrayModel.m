//
//  SMSTreeArrayModel.m
//  JiaoBao
//
//  Created by Zqw on 14-11-12.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "SMSTreeArrayModel.h"

@implementation SMSTreeArrayModel
@synthesize name,smsTree;

-(id)init{
    self.smsTree = [[NSMutableArray alloc] init];
    return self;
}

@end
