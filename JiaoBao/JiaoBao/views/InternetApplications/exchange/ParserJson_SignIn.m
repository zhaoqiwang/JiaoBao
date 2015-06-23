//
//  ParserJson_SignIn.m
//  JiaoBao
//
//  Created by songyanming on 15/3/6.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "ParserJson_SignIn.h"
#import "utils.h"

@implementation ParserJson_SignIn
+(NSMutableArray *)parserJsonSignIn:(NSString *)json
{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *arrList = [json objectFromJSONString];
    for (int i=0; i<arrList.count; i++) {
        ThemeListModel *model = [[ThemeListModel alloc] init];
        NSDictionary *dic = [arrList objectAtIndex:i];
        model.TabIDStr = [dic objectForKey:@"TabIDStr"];
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
        [array addObject:model];
    }
    return array;

    
}


@end
