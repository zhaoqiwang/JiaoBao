//
//  UpdateUnitListModel.h
//  JiaoBao
//
//  Created by Zqw on 14-12-13.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateUnitListModel : NSObject{
    NSString *TabIDStr;//加密的单位ID
    NSString *ClassIDStr;//加密的班级ID
    NSString *UnitID;//单位ID
    NSString *UintName;//单位名称
    NSString *UnitClassID;//加密的班级ID
    NSString *ClsName;//班级名称
    NSString *pubDate;//最后发布时间
    NSString *Title;//最后发布的文章标题
    NSString *unitType;//类型
}

@property (nonatomic,strong) NSString *TabIDStr;
@property (nonatomic,strong) NSString *ClassIDStr;
@property (nonatomic,strong) NSString *UnitID;
@property (nonatomic,strong) NSString *UintName;
@property (nonatomic,strong) NSString *UnitClassID;
@property (nonatomic,strong) NSString *ClsName;
@property (nonatomic,strong) NSString *pubDate;
@property (nonatomic,strong) NSString *Title;
@property (nonatomic,strong) NSString *unitType;//类型

@end
//[{"TabIDStr":"OENFNDBBQjNBMzhCRjAwQg","ClassIDStr":"NDJENERBMDkwMDA3QzI5QQ","UnitID":997,"UintName":"金视野测试教育局","UnitClassID":0,"ClsName":null,"pubDate":"2014-12-13T17:18:46","Title":"“爸爸，我为什么要上学？”爸爸最接地气的回答！"},