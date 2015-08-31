//
//  AllCategoryModel.m
//  JiaoBao
//
//  Created by songyanming on 15/8/5.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "AllCategoryModel.h"

@implementation AllCategoryModel
-(instancetype)init
{
    self = [super init];
    self.item = [[ItemModel alloc]init];
    self.subitem = [[ItemModel alloc]init];
    self.item_now = [[ItemModel alloc]init];
    self.mArr_subItem = [[NSMutableArray alloc]initWithCapacity:0];
    self.mArr_all = [NSMutableArray array];
    self.mArr_evidence = [NSMutableArray array];
    self.mArr_discuss = [NSMutableArray array];
    self.mArr_top = [NSMutableArray array];
    self.mArr_sum = [NSMutableArray array];
    return self;
}

@end
