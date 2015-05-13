//
//  GetmyUserClassModel.h
//  JiaoBao
//
//  Created by Zqw on 15/5/13.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetmyUserClassModel : NSObject{
    NSString *ClassID;
    NSString *ClassNo;
    NSString *ClassName;
    NSString *GradeYear;
    NSString *GradeName;
    NSString *State;
    NSString *SchoolID;
    NSString *SchoolIDStr;
    NSString *TabIDStr;
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
//[{"ClassID":48529,"ClassNo":"ls","ClassName":"1201","GradeYear":2008,"GradeName":"二年级","State":1,"SchoolID":3467,"SchoolIDStr":null,"TabIDStr":null},{"ClassID":61762,"ClassNo":"1301","ClassName":"1301","GradeYear":2009,"GradeName":"小班","State":1,"SchoolID":3467,"SchoolIDStr":null,"TabIDStr":null}]