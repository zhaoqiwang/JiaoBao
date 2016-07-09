//
//  MyStdInfo.h
//  JiaoBao
//  取得我的教宝号所关联的学生列表(家长身份）model
//  Created by SongYanming on 16/3/14.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyStdInfo : NSObject
@property (nonatomic,strong) NSString *TabID ;// 学生ID
@property (nonatomic,strong) NSString *GenName ;//家长姓名
@property (nonatomic,strong) NSString *SchoolID; //学校ID
@property (nonatomic,strong) NSString *ClassId; //班级ID
@property (nonatomic,strong) NSString *StdName; //学生姓名
@property (nonatomic,strong) NSString *ClsName; //班级名称
@property (nonatomic,strong) NSString *GradeName; //年级名称
@property (nonatomic,strong) NSString *GradeYear; //入学年份
@property (nonatomic,strong) NSString *GenID; // 家长ID
-(void)dicToModel:(NSDictionary*)dic;

@end
