//
//  PublishJobModel.m
//  JiaoBao
//
//  Created by songyanming on 15/10/19.
//  Copyright © 2015年 JSY. All rights reserved.
//

#import "PublishJobModel.h"
#import <objc/runtime.h>
@implementation PublishJobModel
-(instancetype)init
{
    self = [super init];
    self.classIDArr = [[NSMutableArray alloc]initWithCapacity:0];
    return self;
}
/* 获取对象的所有属性 以及属性值 */
- (NSDictionary *)propertiesDic
{
    self.classIDArr = [NSMutableArray array];
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

@end
