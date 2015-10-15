//
//  TreeJob_node.m
//  JiaoBao
//
//  Created by Zqw on 15/10/14.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "TreeJob_node.h"

@implementation TreeJob_node

-(instancetype)init
{
    self = [super init];
    self.sonNodes = [NSMutableArray array];
    self.flag = -1;
    return self;
}

@end
