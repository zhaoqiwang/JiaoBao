//
//  CMRevicerModel.m
//  JiaoBao
//
//  Created by Zqw on 14-11-4.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "CMRevicerModel.h"

@implementation CMRevicerModel
@synthesize parentUnitRevicer,myUnitRevicer,subUnitRevicer,UnitClassRevicer,selitadmintomem,selitadmintogen,selitadmintostu,unitClassAdminRevicer;

-(id)init{
    self.parentUnitRevicer = [[NSMutableArray alloc] init];
    self.myUnitRevicer = [[myUnitRevicerModel alloc] init];
    self.subUnitRevicer = [[NSMutableArray alloc] init];
    self.UnitClassRevicer = [[NSMutableArray alloc] init];
    self.selitadmintomem = [[NSMutableArray alloc] init];
    self.selitadmintogen = [[NSMutableArray alloc] init];
    self.selitadmintostu = [[NSMutableArray alloc] init];
    self.unitClassAdminRevicer = [[unitClassAdminRevicerModel alloc] init];
    return self;
}

@end
