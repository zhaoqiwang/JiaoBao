//
//  ThemeListModel.h
//  JiaoBao
//
//  Created by Zqw on 14-12-16.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThemeListModel : NSObject{
    NSString *TabIDStr;//加密ID
    NSString *TabID;//
    NSString *InterestName;//主题名称
    NSString *UpdateTime;//最后更新时间
    NSString *FunsCount;//关注人数
    NSString *ArtCount;//文章数量
    NSString *ArtUpdate;//今日更新
}

@property (nonatomic,strong) NSString *TabIDStr;
@property (nonatomic,strong) NSString *TabID;
@property (nonatomic,strong) NSString *InterestName;
@property (nonatomic,strong) NSString *UpdateTime;
@property (nonatomic,strong) NSString *FunsCount;
@property (nonatomic,strong) NSString *ArtCount;
@property (nonatomic,strong) NSString *ArtUpdate;

@end
//[{"TabIDStr":"RDREOEU5RjFGN0RFMDAzOQ","TabID":47672,"InterestName":"舞文弄墨","UpdateTime":"2014-12-16T09:32:00","FunsCount":226,"ArtCount":241,"ArtUpdate":1},