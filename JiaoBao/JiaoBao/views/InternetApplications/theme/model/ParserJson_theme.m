//
//  ParserJson_theme.m
//  JiaoBao
//
//  Created by Zqw on 14-12-16.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "ParserJson_theme.h"
#import "utils.h"

@implementation ParserJson_theme

//[{"TabIDStr":"RDREOEU5RjFGN0RFMDAzOQ","TabID":47672,"InterestName":"舞文弄墨","UpdateTime":"2014-12-16T09:32:00","FunsCount":226,"ArtCount":241,"ArtUpdate":1},
//取我关注的和我所参与的主题
+(NSMutableArray *)parserJsonEnjoyInterestList:(NSString *)json{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *arrList = [json objectFromJSONString];
    for (int i=0; i<arrList.count; i++) {
        ThemeListModel *model = [[ThemeListModel alloc] init];
        NSDictionary *dic = [arrList objectAtIndex:i];
        model.TabIDStr = [dic objectForKey:@"TabIDStr"];
//        model.InterestName = [dic objectForKey:@"InterestName"];
        NSString *name = [dic objectForKey:@"InterestName"];
        if ([name isKindOfClass:[NSNull class]]||[name isEqual:@"null"]) {
            
        }else{
            model.InterestName = name;
        }
        model.TabID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"TabID"]];
        model.FunsCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"FunsCount"]];
        model.ArtCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ArtCount"]];
//        model.UpdateTime = [[dic objectForKey:@"UpdateTime"] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        NSString *str = [utils getLocalTimeDate];
        NSString *str2 = [dic objectForKey:@"UpdateTime"];
        NSRange range = [str2 rangeOfString:str];
        if (range.length>0) {
            model.UpdateTime = [[[dic objectForKey:@"UpdateTime"] stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringFromIndex:10];
        }else{
            model.UpdateTime = [[[dic objectForKey:@"UpdateTime"] stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:10];
        }
        model.ArtUpdate = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ArtUpdate"]];
        //歌词版权问题，先屏蔽
        if ([model.TabID intValue]==57197) {
            
        }else{
            [array addObject:model];
        }
    }
    return array;
}

@end
