//
//  UnitClassRevicerModel.h
//  JiaoBao
//
//  Created by Zqw on 14-11-5.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnitClassRevicerModel : NSObject{
    NSString *ClassName;
    NSString *teachers_selit;
    NSMutableArray *studentgens_genselit;
}

@property (nonatomic,strong) NSString *ClassName;
@property (nonatomic,strong) NSString *teachers_selit;
@property (nonatomic,strong) NSMutableArray *studentgens_genselit;

@end
//[{"ClassName":"调班临时数据","teachers_selit":null,"studentgens_genselit":[]},{"ClassName":"1310班","teachers_selit":null,"studentgens_genselit":[{"selit":"OUU2NDUwMkY5MTY4QzhFNzBCQUY2MTdDNzQ2QkZBQTREM0VDREFFMDkwREIyMTBDQTgxMEU3M0RCOUREQjNCOTlBNUU4RjEyMjcyNzI5N0M4QjlFRkQ4ODUyNDg0RDY2OUFDOTc3OTMwMzQ3QkNCN0M2NjZENjg5NTc5NUJENTBGN0MwRjg1Q0NFNTJGN0VCNUUwQTJDNzQ4QjU3RkQ0MTlERURCNjYyQ0I4OUNFQzE5Nzk4QUJEN0ZERUU1RkFEM0I1MEJDQjVGNEQ2MTU2MQ","AccID":"0","isAdmin":0,"Name":"陈雪峰的家长(151*,无,取消)","SendFlag":1},