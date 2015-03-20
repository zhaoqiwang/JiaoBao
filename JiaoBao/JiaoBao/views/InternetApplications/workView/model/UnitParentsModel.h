//
//  UnitParentsModel.h
//  JiaoBao
//
//  Created by Zqw on 15-1-13.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol UnitParentsModel
@end
@interface UnitParentsModel : JSONModel

@property (nonatomic,strong) NSString *UintName;
@property (nonatomic,assign) int TabID;
@property (nonatomic,assign) int flag;

@end

