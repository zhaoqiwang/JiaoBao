//
//  MyLeaveModel.m
//  JiaoBao
//
//  Created by SongYanming on 16/3/11.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "MyLeaveModel.h"
#import "utils.h"
#import "SBJSON.h"
#import "JSONKit.h"

@implementation MyLeaveModel
-(void)dicToModel:(NSDictionary*)dic{

    self.TabID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"TabID"]];
    NSString *str = [utils getLocalTimeDate];
    NSString *str2 = [dic objectForKey:@"WriteDate"];
    NSRange range = [str2 rangeOfString:str];
    if (range.length>0) {
        self.WriteDate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:10];
    }else{
        self.WriteDate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:10];
    }
    self.LeaveType = [dic objectForKey:@"LeaveType"];
    self.StatusStr = [dic objectForKey:@"StatusStr"];
    if ([self.StatusStr isEqualToString:@"审批拒绝"]) {
        self.StatusStr = @"拒绝";
    }
    self.RowCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"RowCount"]];
}
@end
