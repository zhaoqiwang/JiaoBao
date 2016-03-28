//
//  ClassLeavesModel.m
//  JiaoBao
//
//  Created by SongYanming on 16/3/14.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "ClassLeavesModel.h"
#import "utils.h"

@implementation ClassLeavesModel
-(void)dicToModel:(NSDictionary*)dic{
    self.TabID = [dic objectForKey:@"TabID"];//假条记录ID
    self.ManName = [dic objectForKey:@"ManName"];//请假人姓名
    NSString *str = [utils getLocalTimeDate];
    NSString *str2 = [dic objectForKey:@"WriteDate"];
    NSRange range = [str2 rangeOfString:str];
    if (range.length>0) {
        self.WriteDate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:10];
    }else{
        self.WriteDate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:10];
    }
    self.LeaveType = [dic objectForKey:@"LeaveType"];//请假类型
    self.StatusStr = [dic objectForKey:@"StatusStr"];//状态
    self.RowCount = [dic objectForKey:@"RowCount"];// 记录数量
    self.ManName = [dic objectForKey:@"ManName"];
    


}
-(void)dicToGateModel:(NSDictionary*)dic{
    self.TabID = [dic objectForKey:@"TabID"];//假条记录ID
    self.ManName = [dic objectForKey:@"ManName"];//请假人姓名
    self.WriteDate = [dic objectForKey:@"WriteDate"];//发起日期
    self.LeaveType = [dic objectForKey:@"LeaveType"];//请假类型
    self.RowCount = [dic objectForKey:@"RowCount"];// 记录数量
    self.Sdate = [dic objectForKey:@"Sdate"];//请假开始时间
    self.Edate = [dic objectForKey:@"Edate"];//请假结束时间
    self.LWriterName = [dic objectForKey:@"LWriterName"];//离校登记人（门卫）
    self.LeaveTime = [dic objectForKey:@"LeaveTime"];//离校时间
    self.CWriterName = [dic objectForKey:@"CWriterName"];//返校登记人(门卫）
    self.ComeTime = [dic objectForKey:@"ComeTime"];// 返校时间
    
}


@end
