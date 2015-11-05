//
//  SaveJobModel.m
//  JiaoBao
//
//  Created by Zqw on 15/10/22.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "SaveJobModel.h"
#import "SaveClassModel.h"
#import <objc/runtime.h>



@implementation SaveJobModel

@dynamic additional;
@dynamic additionalDes;
@dynamic allNum;
@dynamic chapterID;
@dynamic chapterName;
@dynamic classID;
@dynamic classNam;
@dynamic desId;
@dynamic distribution;
@dynamic doLv;
@dynamic expTime;
@dynamic gradeCode;
@dynamic gradeName;
@dynamic homeworkName;
@dynamic hwType;
@dynamic inpNum;
@dynamic isAnSms;
@dynamic isQsSms;
@dynamic isRep;
@dynamic longTime;
@dynamic modeSlection;
@dynamic schoolName;
@dynamic selNum;
@dynamic subjectID;
@dynamic subjectName;
@dynamic teacherJiaobaohao;
@dynamic tecName;
@dynamic versionID;
@dynamic versionName;
@dynamic saveClass;
/* 获取对象的所有属性 以及属性值 */
- (NSMutableDictionary *)propertiesDic
{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return props;
}
-(void)addSaveClassObject:(SaveClassModel *)value
{
    NSMutableOrderedSet *saveClass = [self.saveClass mutableCopy];
    [saveClass addObject:value];
    self.saveClass = [saveClass copy];
    
    
}

@end
