//
//  TopArthListModel.h
//  JiaoBao
//
//  Created by Zqw on 14-11-18.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopArthListModel : NSObject{
    NSString *TabIDStr;//文章加密ID
    NSString *ClickCount;//点击数量
    NSString *Context;//内容
    NSString *JiaoBaoHao;//发布人
    NSString *LikeCount;//赞数量
    NSString *RecDate;//日期
    NSString *Source;//来源网站
    NSString *StarJson;//
    NSString *State;//
    NSString *Title;//标题
    NSString *ViewCount;//观看人数
    NSString *SectionID;//文章栏目ID
    NSString *UserName;//作者姓名
}

@property (nonatomic,strong) NSString *TabIDStr;
@property (nonatomic,strong) NSString *ClickCount;
@property (nonatomic,strong) NSString *Context;
@property (nonatomic,strong) NSString *JiaoBaoHao;
@property (nonatomic,strong) NSString *LikeCount;
@property (nonatomic,strong) NSString *RecDate;
@property (nonatomic,strong) NSString *Source;
@property (nonatomic,strong) NSString *StarJson;
@property (nonatomic,strong) NSString *State;
@property (nonatomic,strong) NSString *Title;
@property (nonatomic,strong) NSString *ViewCount;
@property (nonatomic,strong) NSString *SectionID;
@property (nonatomic,strong) NSString *UserName;

@end