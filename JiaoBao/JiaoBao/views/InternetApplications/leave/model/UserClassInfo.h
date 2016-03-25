//
//  UserClassInfo.h
//  JiaoBao
//  学校所有班级
//  Created by SongYanming on 16/3/23.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserClassInfo : NSObject
@property(nonatomic,strong)NSString* ClassID;		//班级ID,惟一标识

@property(nonatomic,strong)NSString*ClassNo;		//班级代码，用户自定义的
@property(nonatomic,strong)NSString*ClassName;		//班级名称
@property(nonatomic,strong)NSString*GradeYear;		//入学年份
@property(nonatomic,strong)NSString*GradeName;		//年级名称
@property(nonatomic,strong)NSString*State;		//状态，0禁用，1正常
@property(nonatomic,strong)NSString*SchoolID;		//学校ID
@property(nonatomic,strong) NSMutableArray *mArr_class;//年级和班级的多级列表用

@end
