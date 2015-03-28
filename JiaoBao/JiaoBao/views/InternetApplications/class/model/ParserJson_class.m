//
//  ParserJson_class.m
//  JiaoBao
//
//  Created by Zqw on 15-3-27.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "ParserJson_class.h"
#import "utils.h"

@implementation ParserJson_class

//[{"TabIDStr":"NDk4MkIxMTBCNDA4NEQxMw","ClickCount":58,"Context":null,"JiaoBaoHao":5194726,"LikeCount":39,"RecDate":"2014-12-26T14:12:47.1452449+08:00","Source":0,"StarJson":null,"State":1,"Title":"【润博教育】慢养——给孩子一个好性格","Abstracts":"孩子，你慢慢来。你独一无二，与众不同，你有 权以自己的思想主宰成长。 孩子，你慢慢来。春天开花，秋天结果，成熟需 要时间。小神童和小超人的人生，并不样样领先。 人生不是短跑，也不是中长跑，是……","Thumbnail":null,"ViewCount":51,"SectionID":"997_1","FeeBackCount":0,"UserName":"杜延昌","UnitName":"金视野"}]
//客户端通过本接口获取本单位栏目文章
+(NSMutableArray *)parserJsonUnitArthListIndex:(NSString *)json{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *arrList = [json objectFromJSONString];
    for (int i=0; i<arrList.count; i++) {
        ClassModel *model = [[ClassModel alloc] init];
        NSDictionary *dic = [arrList objectAtIndex:i];
        model.TabIDStr = [dic objectForKey:@"TabIDStr"];
        model.Context = [dic objectForKey:@"Context"];
        model.ClickCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ClickCount"]];
        model.JiaoBaoHao = [NSString stringWithFormat:@"%@",[dic objectForKey:@"JiaoBaoHao"]];
        model.LikeCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"LikeCount"]];
        model.Source = [NSString stringWithFormat:@"%@",[dic objectForKey:@"Source"]];
        model.State = [NSString stringWithFormat:@"%@",[dic objectForKey:@"State"]];
        model.ViewCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ViewCount"]];
        model.FeeBackCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"FeeBackCount"]];
        model.StarJson = [dic objectForKey:@"StarJson"];
        model.Title = [dic objectForKey:@"Title"];
        model.Abstracts = [dic objectForKey:@"Abstracts"];
        model.Thumbnail = [dic objectForKey:@"Thumbnail"];
        model.SectionID = [dic objectForKey:@"SectionID"];
        model.UserName = [dic objectForKey:@"UserName"];
        model.UnitName = [dic objectForKey:@"UnitName"];
        NSString *str = [utils getLocalTimeDate];
        NSString *str2 = [dic objectForKey:@"RecDate"];
        NSRange range = [str2 rangeOfString:str];
        if (range.length>0) {
            model.RecDate = [[[dic objectForKey:@"UpdateTime"] stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringFromIndex:10];
        }else{
            model.RecDate = [[[dic objectForKey:@"UpdateTime"] stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:10];
        }
        [array addObject:model];
        
        
    }
    return array;
}

@end
