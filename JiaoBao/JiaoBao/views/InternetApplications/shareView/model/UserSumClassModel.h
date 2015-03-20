//
//  UserSumClassModel.h
//  JiaoBao
//
//  Created by Zqw on 14-11-21.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserSumClassModel : NSObject{
    NSString *AccountID;//创建者ID
    NSString *ArtUpdate;//今日更新
    NSString *ClsName;//班级名称
    NSString *ClsNo;//班级代码
    NSString *GradeName;//年级名称
    NSString *GradeYear;//入学年份
    NSString *ParentID;//学校ID
    NSString *SchoolType;//学校类型
    NSString *TabID;//班级ID
}

@property (nonatomic,strong) NSString *AccountID;
@property (nonatomic,strong) NSString *ArtUpdate;
@property (nonatomic,strong) NSString *ClsName;
@property (nonatomic,strong) NSString *ClsNo;
@property (nonatomic,strong) NSString *GradeName;
@property (nonatomic,strong) NSString *GradeYear;
@property (nonatomic,strong) NSString *ParentID;
@property (nonatomic,strong) NSString *SchoolType;
@property (nonatomic,strong) NSString *TabID;

@end
//[{"AccountID":0,"ArtUpdate":0,"ClsName":"调班临时数据","ClsNo":"9805","GradeName":"一年级","GradeYear":2013,"ParentID":991,"SchoolType":null,"TabID":19},