//
//  UnitNoticeModel.h
//  JiaoBao
//
//  Created by Zqw on 14-11-28.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnitNoticeModel : NSObject{
    NSString *write;//当前用户是否能发表通知
    NSMutableArray *noticeInfoArray;//单位通知列表
}

@property (nonatomic,strong) NSString *write;//当前用户是否能发表通知
@property (nonatomic,strong) NSMutableArray *noticeInfoArray;//单位通知列表

@end
//{"write":false,"list":
//    [{"JiaoBaoHao":5150080,"NoticMsg":"","NoticType":1,"Recdate":"2014-09-23T15:13:00","Subject":"关于2014年“国庆节”放假的通知","TabIDStr":"QUUwRDE0MDMyNzJDOEM5RA","UserName":"侯宜国"},{"JiaoBaoHao":5150692,"NoticMsg":"","NoticType":1,"Recdate":"2014-09-22T15:24:00","Subject":"关于在新平台上报日程的通知","TabIDStr":"M0UwMUZBQzZGOTdCNzNENQ","UserName":"山东行政"},]}