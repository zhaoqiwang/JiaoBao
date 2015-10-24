//
//  StuInfoModel.h
//  JiaoBao
//
//  Created by songyanming on 15/10/23.
//  Copyright © 2015年 JSY. All rights reserved.
//学生个人信息数据接口:学生信息Model

#import <Foundation/Foundation.h>

@interface StuInfoModel : NSObject
@property(nonatomic,strong)NSString *StudentID;//学生ID,惟一标识
@property(nonatomic,strong)NSString *StdName;//学生姓名
@property(nonatomic,strong)NSString *Sex;//学生性别
@property(nonatomic,strong)NSString *SchoolType;//学校类型
@property(nonatomic,strong)NSString *GradeYear;//入学年份
@property(nonatomic,strong)NSString *GradeName;//年级名称
@property(nonatomic,strong)NSString *ClassNo;//班级代码
@property(nonatomic,strong)NSString *ClassName;//班级名称
@property(nonatomic,strong)NSString *UnitClassID;//班级ID
@property(nonatomic,strong)NSString *SchoolID;//学校单位ID

//{"StudentID":3851578,"StdName":"001学生","Sex":"男","SchoolType":null,"GradeYear":0,"GradeName":"小班","ClassNo":"001","ClassName":"班级测试001","UnitClassID":72202,"SchoolID":4274,"AccID":0}


@end
