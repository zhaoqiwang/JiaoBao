//
//  ClassSumLeaves.h
//  JiaoBao
//
//  Created by SongYanming on 16/3/28.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassSumLeaves : NSObject
@property (nonatomic,strong) NSString *UnitClassId;//班级ID用来做为取该班学生的请假统计的输入参数。
@property (nonatomic,strong) NSString *ClassStr;//班级名称
@property (nonatomic,strong) NSString *GradeStr;//年级名称
@property (nonatomic,strong) NSString *Amount;//补课假次数
@property (nonatomic,strong) NSString *Amount2;// 其他假次数

@end
