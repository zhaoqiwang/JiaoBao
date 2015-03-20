//
//  UnitClassModel.h
//  JiaoBao
//
//  Created by Zqw on 15-1-13.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol UnitClassModel
@end
@interface UnitClassModel : JSONModel

@property (nonatomic,strong) NSString *ClsName;
@property (nonatomic,assign) int TabID;
@property (nonatomic,assign) int flag;

@end
//"UnitClass":[{"ClsName":"总部支撑","TabID":429,"flag":13}]}