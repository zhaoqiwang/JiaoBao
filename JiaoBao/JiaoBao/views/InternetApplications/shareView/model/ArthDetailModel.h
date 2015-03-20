//
//  ArthDetailModel.h
//  JiaoBao
//
//  Created by Zqw on 14-11-21.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArthDetailModel : NSObject{
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
    NSString *FeeBackCount;
    NSString *Likeflag;//0未赞，1已赞
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
@property (nonatomic,strong) NSString *FeeBackCount;
@property (nonatomic,strong) NSString *Likeflag;

@end
//{"TabIDStr":"NDBBRTRCRkFFQjA1RkQyRQ","ClickCount":1,"Context":"<></p>","JiaoBaoHao":5176588,"LikeCount":2,"RecDate":"2014-11-21T11:07:08.5534359+08:00","Source":1,"StarJson":null,"State":1,"Title":"冬季养生饮食小常识","ViewCount":1,"SectionID":"2170_2","UserName":"张金荣","FeeBackCount":7,"Likeflag":1}