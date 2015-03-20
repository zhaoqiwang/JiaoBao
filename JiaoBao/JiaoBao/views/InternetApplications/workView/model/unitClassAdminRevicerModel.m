//
//  unitClassAdminRevicerModel.m
//  JiaoBao
//
//  Created by Zqw on 14-11-4.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "unitClassAdminRevicerModel.h"

@implementation unitClassAdminRevicerModel
@synthesize selitunitclassidtogen,selitunitclassidtostu,selitunitclassadmintogen,selitunitclassadmintostu;

-(id)init{
    self.selitunitclassidtogen = [[NSMutableArray alloc] init];
    self.selitunitclassidtostu = [[NSMutableArray alloc] init];
    self.selitunitclassadmintogen = [[NSMutableArray alloc] init];
    self.selitunitclassadmintostu = [[NSMutableArray alloc] init];
    return self;
}

@end
