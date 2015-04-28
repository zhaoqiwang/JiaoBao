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

//[{"RoleIdentity":1,"RoleIdName":"教育局人员","UserUnits":[{"UnitID":994,"UnitType":1,"UnitName":"战略发展部","ShortName":"战略发展","Area":"370102","SchoolType":null,"TownShip":"金视野","TabIDStr":"ODdCRTA4NTFDMTEzQTE1QQ"},{"UnitID":997,"UnitType":1,"UnitName":"金视野测试教育局","ShortName":"金视野","Area":"370000","SchoolType":null,"TownShip":null,"TabIDStr":"OENFNDBBQjNBMzhCRjAwQg"},{"UnitID":998,"UnitType":1,"UnitName":"山东测试教育局","ShortName":"山东测试教育局","Area":"370103","SchoolType":null,"TownShip":null,"TabIDStr":"NUVBNDA2NzcxRERGOTQzRg"},{"UnitID":999,"UnitType":1,"UnitName":"湖北测试教育局","ShortName":"金视野湖北大区","Area":"420000","SchoolType":null,"TownShip":null,"TabIDStr":"RUI4ODM0RjJDN0UyRDZEOQ"},{"UnitID":1000,"UnitType":1,"UnitName":"海南测试教育局","ShortName":"海南测试教育局","Area":"460101","SchoolType":null,"TownShip":"海口","TabIDStr":"MzIwRUJCQzVFNTNDRkUxRA"}],"UserClasses":[],"DefaultUnitId":997},{"RoleIdentity":2,"RoleIdName":"老师","UserUnits":[{"UnitID":1001,"UnitType":2,"UnitName":"演示学校一","ShortName":"演示学校","Area":"370102","SchoolType":"小学","TownShip":null,"TabIDStr":"MzUxMDU1MDQ3QzZCODgyQw"},{"UnitID":1070,"UnitType":2,"UnitName":"支撑学校","ShortName":"支撑","Area":"370000","SchoolType":"小学","TownShip":null,"TabIDStr":"M0M5MzcyODA1NjQyQzg2Rg"},{"UnitID":3659,"UnitType":2,"UnitName":"金视野开发部","ShortName":"金视野开发部","Area":"370105","SchoolType":"幼儿园","TownShip":null,"TabIDStr":"QkNGOTExMTE2RUM2QTI1Mw"}],"UserClasses":[],"DefaultUnitId":997},{"RoleIdentity":3,"RoleIdName":"家长","UserUnits":[],"UserClasses":[{"ClassID":243,"ClassNo":"213123","ClassName":"新增测试班级","GradeYear":2011,"GradeName":"四年级","State":1,"SchoolID":1001,"SchoolIDStr":"MzUxMDU1MDQ3QzZCODgyQw","TabIDStr":"OTEzQ0M2OTc1QUU4MzFBQw"}],"DefaultUnitId":997},{"RoleIdentity":4,"RoleIdName":"学生","UserUnits":[],"UserClasses":[{"ClassID":51,"ClassNo":"20130101","ClassName":"一年级（1）班","GradeYear":2013,"GradeName":"一年级","State":1,"SchoolID":1001,"SchoolIDStr":"MzUxMDU1MDQ3QzZCODgyQw","TabIDStr":"NjhBMUJGMjIzNEM3ODA0QQ"}],"DefaultUnitId":0},{"RoleIdentity":5,"RoleIdName":"访客","UserUnits":[],"UserClasses":[],"DefaultUnitId":997}]