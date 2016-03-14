//
//  MyAdminClass.h
//  JiaoBao
//
//  Created by SongYanming on 16/3/14.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyAdminClass : NSObject
@property (nonatomic,strong) NSString *TabID ;//班级ID
@property (nonatomic,strong) NSString *ClsName ;//班级名称
@property (nonatomic,strong) NSString *ClsNo ;//班级代码
@property (nonatomic,strong) NSString *GradeName ;//年级名称
@property (nonatomic,strong) NSString *GradeYear ;//入学年份
@property (nonatomic,strong) NSString *SchoolId ;// 学校ID
-(void)dicToModel:(NSDictionary*)dic;

@end
