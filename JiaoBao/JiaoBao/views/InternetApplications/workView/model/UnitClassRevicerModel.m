//
//  UnitClassRevicerModel.m
//  JiaoBao
//
//  Created by Zqw on 14-11-5.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "UnitClassRevicerModel.h"

@implementation UnitClassRevicerModel
@synthesize ClassName,teachers_selit,studentgens_genselit;

-(id)init{
    self.studentgens_genselit = [[NSMutableArray alloc] init];
    return self;
}

@end
