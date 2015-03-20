//
//  NoticeInfoModel.h
//  JiaoBao
//
//  Created by Zqw on 14-11-28.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticeInfoModel : NSObject{
    NSString *JiaoBaoHao;//发表人教宝ID
    NSString *NoticMsg;//通知正文，列表时不包含
    NSString *NoticType;//类型
    NSString *Recdate;//日期
    NSString *Subject;//标题
    NSString *TabIDStr;//加密ID
    NSString *UserName;//发表用户
}

@property (nonatomic,strong) NSString *JiaoBaoHao;
@property (nonatomic,strong) NSString *NoticMsg;
@property (nonatomic,strong) NSString *NoticType;
@property (nonatomic,strong) NSString *Recdate;
@property (nonatomic,strong) NSString *Subject;
@property (nonatomic,strong) NSString *TabIDStr;
@property (nonatomic,strong) NSString *UserName;

@end
//[{"JiaoBaoHao":5150080,"NoticMsg":"","NoticType":1,"Recdate":"2014-09-23T15:13:00","Subject":"关于2014年“国庆节”放假的通知","TabIDStr":"QUUwRDE0MDMyNzJDOEM5RA","UserName":"侯宜国"},{"JiaoBaoHao":5150692,"NoticMsg":"","NoticType":1,"Recdate":"2014-09-22T15:24:00","Subject":"关于在新平台上报日程的通知","TabIDStr":"M0UwMUZBQzZGOTdCNzNENQ","UserName":"山东行政"},