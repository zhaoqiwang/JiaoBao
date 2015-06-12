//
//  CommMsgRevicerUnitListModel.m
//  JiaoBao
//
//  Created by Zqw on 15-1-10.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "CommMsgRevicerUnitListModel.h"

@implementation CommMsgRevicerUnitListModel
@synthesize myUnit,UnitParents,subUnits,UnitClass;

-(id)init{
    self = [super init];
    self.myUnit = [[myUnit alloc] init];
    self.UnitParents = [[NSMutableArray alloc] init];
    self.subUnits = [[NSMutableArray alloc] init];
    self.UnitClass = [[NSMutableArray alloc] init];
    return self;
}

@end

@implementation myUnit
@synthesize UintName,TabID,TabIDStr,flag,list;

-(id)init{
    self.list = [NSMutableArray array];
    return self;
}

@end

@implementation UnitParents
@synthesize UnitParents_array;

-(id)init{
    self.UnitParents_array = [NSMutableArray array];
    return self;
}

@end

@implementation subUnits
@synthesize subUnits_array;

-(id)init{
    self.subUnits_array = [NSMutableArray array];
    return self;
}

@end

@implementation UnitClass
@synthesize UnitClass_array;

-(id)init{
    self.UnitClass_array = [NSMutableArray array];
    return self;
}

@end