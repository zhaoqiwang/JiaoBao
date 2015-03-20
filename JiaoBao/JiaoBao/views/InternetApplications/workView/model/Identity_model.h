//
//  Identity_model.h
//  JiaoBao
//
//  Created by Zqw on 14-10-24.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Identity_model : NSObject{
    NSString *RoleIdentity;
    NSString *RoleIdName;
    NSMutableArray *UserUnits;
    NSMutableArray *UserClasses;
    NSString *DefaultUnitId;
}
@property (strong,nonatomic) NSString *RoleIdentity;
@property (strong,nonatomic) NSString *RoleIdName;
@property (strong,nonatomic) NSMutableArray *UserUnits;
@property (strong,nonatomic) NSMutableArray *UserClasses;
@property (strong,nonatomic) NSString *DefaultUnitId;


@end
