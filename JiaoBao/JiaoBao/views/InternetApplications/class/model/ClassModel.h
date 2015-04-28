//
//  ClassModel.h
//  JiaoBao
//
//  Created by Zqw on 15-3-27.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassModel : NSObject{
    NSString *TabIDStr;//加密ID
    NSString *ClickCount;//点击数量
    NSString *Context;//
    NSString *JiaoBaoHao;//教宝号
    NSString *LikeCount;//赞数
    NSString *RecDate;//发布日期
    NSString *Source;//来源网站
    NSString *StarJson;//
    NSString *State;//
    NSString *Title;//标题
    NSString *Abstracts;//摘要
    NSMutableArray *Thumbnail;//图片url(string[]数组
    NSString *ViewCount;//观看人数
    NSString *SectionID;//文章栏目ID，997_2，最后一位，1是展示，2是分享
    NSString *FeeBackCount;//回复数量
    NSString *UserName;//发表者姓名
    NSString *UnitName;//发布单位
    NSString *flag;//来自展示1，还是分享2
    NSString *className;//班级名称
    NSString *classID;//班级号
    NSString *UnitType;//类型
    NSString *unitId;//单位号
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
@property (nonatomic,strong) NSString *Abstracts;
@property (nonatomic,strong) NSMutableArray *Thumbnail;
@property (nonatomic,strong) NSString *ViewCount;
@property (nonatomic,strong) NSString *SectionID;
@property (nonatomic,strong) NSString *FeeBackCount;
@property (nonatomic,strong) NSString *UserName;
@property (nonatomic,strong) NSString *UnitName;
@property (nonatomic,strong) NSString *flag;//来自展示1，还是分享2
@property (nonatomic,strong) NSString *className;//班级名称
@property (nonatomic,strong) NSString *classID;//班级号
@property (nonatomic,strong) NSString *UnitType;//类型
@property (nonatomic,strong) NSString *unitId;//单位号

@end

//[{"TabIDStr":"QjgzMzg3NTZGM0Y4QjQ5Nw","ClickCount":32,"Context":null,"JiaoBaoHao":5160786,"LikeCount":20,"RecDate":"2015-03-27T09:00:46.4082611+08:00","Source":0,"StarJson":null,"State":1,"Title":"孩子们总会给我们的课堂带来出乎意料的东西","Abstracts":"今天上园地，本园地中有一篇可爱的小诗《小鸟》，文章共有三小节，要求 学生 读一读，背一背。在和学生们一起朗读，对内容进行了讲解后。我按照文中的要求让学试背。于是我 指导 学生背诵：“文章共有……","Thumbnail":null,"ViewCount":27,"SectionID":"997_2","FeeBackCount":0,"UserName":"龚驰","UnitName":"恩施办","UnitType":1,"unitId":997},

//{"TabIDStr":"NDY2OTJCMjA4RDFFNUM0Ng","ClickCount":22,"Abstracts":"好记忆不如烂笔头”，就是说边学习边动笔的好处。笔记不仅是学习新知识的方法，也是复习旧知识的依据，同时我们还可以从笔记中发现新的问题，我们要培养孩子养成写读书笔记的习惯，这有可能是影响孩子一辈……","JiaoBaoHao":5220059,"LikeCount":7,"RecDate":"2015-03-30T12:58:43","Source":0,"StarJson":null,"State":1,"Title":"好记忆不如烂笔头","ViewCount":20,"Thumbnail":null,"SectionID":"1655_2","UserName":"刘俊玲","UnitName":"中册徐李小学"}]