//
//  GenInfo.h
//  JiaoBao
//
//  Created by songyanming on 15/10/23.
//  Copyright © 2015年 JSY. All rights reserved.
//家长信息model

#import <Foundation/Foundation.h>

@interface GenInfo : NSObject
@property(nonatomic,strong)NSString *AccID;
@property(nonatomic,strong)NSString *GenID;//家长ID,惟一标识
@property(nonatomic,strong)NSString *StudentID;//学生ID,惟一标识
@property(nonatomic,strong)NSString *StdName;//学生姓名
@property(nonatomic,strong)NSString *UnitClassID;//班级ID
@property(nonatomic,strong)NSString *ClassName;//班级名称
@property(nonatomic,strong)NSString *SchoolID;//学校ID
@property(nonatomic,strong)NSString *SrvFlag;//服务状态0未开通1正式2试用3免费

//{
//    AccID = 0;
//    ClassName = "\U73ed\U7ea7\U6d4b\U8bd5001";
//    GenID = 3511791;
//    SchoolID = 4274;
//    SrvFlag = 2;
//    StdName = "001\U5b66\U751f";
//    StudentID = 3851578;
//    UnitClassID = 72202;
//}
@end
