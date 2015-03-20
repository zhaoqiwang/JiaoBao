//
//  UserClassModel.h
//  JiaoBao
//
//  Created by Zqw on 14-11-20.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserClassModel : NSObject{
    NSString *ClassID;//班级ID
    NSString *ClassNo;//班级代码
    NSString *ClassName;//班级名称
    NSString *GradeYear;//入学年份
    NSString *GradeName;//年级名称
    NSString *State;//状态，禁用0，正常1
    NSString *SchoolID;//学校ID
    NSString *SchoolIDStr;//
    NSString *TabIDStr;//
}

@property (nonatomic,strong) NSString *ClassID;
@property (nonatomic,strong) NSString *ClassNo;
@property (nonatomic,strong) NSString *ClassName;
@property (nonatomic,strong) NSString *GradeYear;
@property (nonatomic,strong) NSString *GradeName;
@property (nonatomic,strong) NSString *State;
@property (nonatomic,strong) NSString *SchoolID;
@property (nonatomic,strong) NSString *SchoolIDStr;
@property (nonatomic,strong) NSString *TabIDStr;

@end
//[{"ClassID":19,"ClassNo":"9805","ClassName":"调班临时数据","GradeYear":2013,"GradeName":"一年级","State":1,"SchoolID":991,"SchoolIDStr":null,"TabIDStr":null},{"ClassID":49,"ClassNo":"1310","ClassName":"1310班","GradeYear":2013,"GradeName":"2013级","State":1,"SchoolID":991,"SchoolIDStr":null,"TabIDStr":null}]