//
//  SMSTreeUnitModel.h
//  JiaoBao
//
//  Created by Zqw on 14-11-12.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMSTreeUnitModel : NSObject{
    NSString *id0;//单位ID
    NSString *pId;//父级单位
    NSString *name;//单位名称
    NSString *uType;//单位类型，1教育局，2学校
    NSString *TabIDStr;
    int mInt_select;//是否被选中，默认0，选中为1
}
@property (nonatomic,strong) NSString *id0;
@property (nonatomic,strong) NSString *pId;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *uType;
@property (nonatomic,strong) NSString *TabIDStr;
@property (nonatomic,assign) int mInt_select;//是否被选中，默认0，选中为1

@end
//{"id":994,"pId":-1,"name":"战略发展部","uType":1,"TabIDStr":"ODdCRTA4NTFDMTEzQTE1QQ"}
