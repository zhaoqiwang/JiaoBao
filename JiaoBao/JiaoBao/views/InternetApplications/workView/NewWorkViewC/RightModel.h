//
//  RightModel.h
//  JiaoBao
//
//  Created by songyanming on 15/6/13.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RightModel : NSObject
@property(nonatomic,assign)NSString *ParentCommRight;//对上级发送事务的权限
@property(nonatomic,assign)NSString *UnitCommRight;//对同单位事务的权限
@property(nonatomic,assign)NSString *SubUnitCommRight;//对下级发送事务的权限



@end
