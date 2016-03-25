//
//  CheckSelectModel.h
//  JiaoBao
//  审核筛选条件model
//  Created by Zqw on 16/3/24.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckSelectModel : NSObject

@property (nonatomic,assign) int mInt_flag;//0教职工、学生，1一审、二审等，2时间，3年级，4班级
@property (nonatomic,strong) NSString *mStr_name;//名称
@property (nonatomic,strong) NSString *mStr_value;//选择的时间、年级、班级
@property (nonatomic,assign) int mInt_id;//选择的身份，教职工0，学生1
@property (nonatomic,assign) int mInt_check;//选择的审核，0一审，1二审，等
@property (nonatomic,assign) int mInt_checkTeacher;//审核时，老师的分类，学生是全部
@property (nonatomic,assign) int mInt_allTeacher;//统计查询时，老师的分类
@property (nonatomic,assign) int mInt_allStudent;//统计查询时，学生的分类

@end
