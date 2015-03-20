//
//  Identity_UserClasses_model.h
//  JiaoBao
//
//  Created by Zqw on 14-10-24.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Identity_UserClasses_model : NSObject{
    NSString *ClassID;//班级ID
    NSString *ClassNo;//
    NSString *ClassName;//班级名称
    NSString *GradeYear;//
    NSString *GradeName;//
    NSString *State;//
    NSString *SchoolID;//学校ID
    NSString *SchoolIDStr;//
    NSString *TabIDStr;//班级加密ID
}
@property (strong,nonatomic) NSString *ClassID;
@property (strong,nonatomic) NSString *ClassNo;
@property (strong,nonatomic) NSString *ClassName;
@property (strong,nonatomic) NSString *GradeYear;
@property (strong,nonatomic) NSString *GradeName;
@property (strong,nonatomic) NSString *State;
@property (strong,nonatomic) NSString *SchoolID;
@property (strong,nonatomic) NSString *SchoolIDStr;
@property (strong,nonatomic) NSString *TabIDStr;


@end
