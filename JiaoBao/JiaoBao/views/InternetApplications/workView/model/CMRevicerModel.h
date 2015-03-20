//
//  CMRevicerModel.h
//  JiaoBao
//
//  Created by Zqw on 14-11-4.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "myUnitRevicerModel.h"
#import "unitClassAdminRevicerModel.h"

@interface CMRevicerModel : NSObject{
    NSMutableArray *parentUnitRevicer;//上级单位接收人
    myUnitRevicerModel *myUnitRevicer;//本单位接收人
    NSMutableArray *subUnitRevicer;//下级单位接收人
    NSMutableArray *UnitClassRevicer;//班级接收人（家长或老师）
    NSMutableArray *selitadmintomem; //单位管理员，转发给本单位人员
    NSMutableArray *selitadmintogen;//学校管理员,转发给学校家长
    NSMutableArray *selitadmintostu;//学校管理员，转发给本交学生
    unitClassAdminRevicerModel *unitClassAdminRevicer;//群发（下发通知）时班级接收者
}

@property (nonatomic,strong) NSMutableArray *parentUnitRevicer;
@property (nonatomic,strong) NSMutableArray *subUnitRevicer;
@property (nonatomic,strong) NSMutableArray *UnitClassRevicer;
@property (nonatomic,strong) NSMutableArray *selitadmintomem;
@property (nonatomic,strong) NSMutableArray *selitadmintogen;
@property (nonatomic,strong) NSMutableArray *selitadmintostu;
@property (nonatomic,strong) myUnitRevicerModel *myUnitRevicer;
@property (nonatomic,strong) unitClassAdminRevicerModel *unitClassAdminRevicer;

@end
//{"parentUnitRevicer":[{"UnitName":"测试单位","TabIDStr":"NDNEQUNCNTRFNDNBQkNFNA","UserList":[]
//}],
//    
//    "myUnitRevicer":{"UnitName":"单位下级",
//        "TabIDStr":"NDNEQUNCNTRFNDNBQkNFNA",
//        "UserList":[{"GroupName":"基本人员",
//            "MCount":1,
//            "groupselit_selit":[{"selit":"OUU2NDUwMkY5MTY4QzhFN0JCQTU5QTdBQzcwRTFGRUI0N0RFRDhDQzg4MjJCQ0MxOTBCMjYzMjJBRTkzMjE5RkQ1OUQ3OTM5RTExMkE4MjlGMzQ2REU4RUNCNjI3NUNBQzJFMUU5RDgzQUFBNDdBMTUwMDAzMzAwOENDRjREMDRDQjUxNzVENUFDODY1NDhGQkJGMTI3MjU2QzM2Qjk4MjNDMUE2NkFCODBERTM4NjY1RkFGNjM0QTE3QUY5ODU5OEU2OTc2RTkzMTIwQkMwNQ","AccID":"5150001","isAdmin":0,"Name":"LM(123*,有)","SendFlag":1
//            }]
//        }]
//    },
//
//    "subUnitRevicer":[],"UnitClassRevicer":null,"selitadmintomem":null,"selitadmintogen":null,"selitadmintostu":null,"unitClassAdminRevicer":null}