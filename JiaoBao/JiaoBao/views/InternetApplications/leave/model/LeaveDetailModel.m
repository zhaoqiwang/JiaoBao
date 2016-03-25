//
//  LeaveDetailModel.m
//  JiaoBao
//
//  Created by SongYanming on 16/3/11.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "LeaveDetailModel.h"
#import "utils.h"
#import "SBJSON.h"
#import "JSONKit.h"


@implementation LeaveDetailModel
-(instancetype)init
{
    self = [super init];
    self.TimeList = [[NSMutableArray alloc]init];
    
    return self;
}
-(void)dicToModel:(NSDictionary*)dic{

    NSString *str = [utils getLocalTimeDate];

    self.TabID = [dic objectForKey:@"TabID"];
    self.ManName = [dic objectForKey:@"ManName"];
    self.Writer = [dic objectForKey:@"Writer"];
    NSString *str2 = [dic objectForKey:@"WriteDate"];
    NSRange range = [str2 rangeOfString:str];
    if (range.length>0) {
        self.WriteDate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringFromIndex:19];
    }else{
        self.WriteDate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:19];
    }
    self.LeaveType = [dic objectForKey:@"LeaveType"];
    self.LeaveReason = [dic objectForKey:@"LeaveReason"];
    self.StatusStr = [dic objectForKey:@"StatusStr"];
    self.ApproveStatus = [dic objectForKey:@"ApproveStatus"];
    self.Approve = [dic objectForKey:@"Approve"];
    self.ApproveDate = [dic objectForKey:@"ApproveDate"];
   str2 = [dic objectForKey:@"ApproveDate"];
   range = [str2 rangeOfString:str];
    if (range.length>0) {
        self.ApproveDate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringFromIndex:19];
    }else{
        self.ApproveDate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:19];
    }
    self.ApproveNote = [dic objectForKey:@"ApproveNote"];
    self.ApproveStatus1 = [dic objectForKey:@"ApproveStatus1"];
    self.Approve1 = [dic objectForKey:@"Approve1"];
    self.ApproveDate1 = [dic objectForKey:@"ApproveDate1"];
    str2 = [dic objectForKey:@"ApproveDate1"];
    range = [str2 rangeOfString:str];
    if (range.length>0) {
        self.ApproveDate1 = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringFromIndex:19];
    }else{
        self.ApproveDate1 = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:19];
    }
    self.ApproveNote1 = [dic objectForKey:@"ApproveNote1"];
    self.ApproveStatus2 = [dic objectForKey:@"ApproveStatus2"];
    self.Approve2 = [dic objectForKey:@"Approve2"];
    self.ApproveDate2 = [dic objectForKey:@"ApproveDate2"];
    str2 = [dic objectForKey:@"ApproveDate2"];
    range = [str2 rangeOfString:str];
    if (range.length>0) {
        self.ApproveDate2 = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringFromIndex:19];
    }else{
        self.ApproveDate2 = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:19];
    }
    self.ApproveNote2 = [dic objectForKey:@"ApproveNote2"];
    self.ApproveStatus3 = [dic objectForKey:@"ApproveStatus3"];
    self.Approve3 = [dic objectForKey:@"Approve3"];
    self.ApproveDate3 = [dic objectForKey:@"ApproveDate3"];
    str2 = [dic objectForKey:@"ApproveDate3"];
    range = [str2 rangeOfString:str];
    if (range.length>0) {
        self.ApproveDate3 = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringFromIndex:19];
    }else{
        self.ApproveDate3 = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:19];
    }
    self.ApproveNote3 = [dic objectForKey:@"ApproveNote3"];
    self.ApproveStatus4 = [dic objectForKey:@"ApproveStatus4"];
    self.Approve4 = [dic objectForKey:@"Approve4"];
    self.ApproveDate4 = [dic objectForKey:@"ApproveDate4"];
    str2 = [dic objectForKey:@"ApproveDate4"];
    range = [str2 rangeOfString:str];
    if (range.length>0) {
        self.ApproveDate4 = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringFromIndex:19];
    }else{
        self.ApproveDate4 = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:19];
    }
    self.ApproveNote4 = [dic objectForKey:@"ApproveNote4"];
    NSMutableArray *mArr = [dic objectForKey:@"TimeList"];
    for(int i=0;i<mArr.count;i++){
        NSMutableDictionary *mDic = [mArr objectAtIndex:i];
        TimeListModel *model = [[TimeListModel alloc]init];
        [model dicToModel:mDic];
        [self.TimeList addObject:model];
        
    }
    
    
}
@end
@implementation TimeListModel
-(void)dicToModel:(NSDictionary*)dic{

    NSString *str = [utils getLocalTimeDate];
    
    self.TabID = [dic objectForKey:@"TabID"];
    self.Sdate = [dic objectForKey:@"Sdate"];
    NSString *str2 = [dic objectForKey:@"Sdate"];
    NSRange range = [str2 rangeOfString:str];
    if (range.length>0) {
        self.Sdate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringFromIndex:19];
    }else{
        self.Sdate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:19];
    }
    self.Edate = [dic objectForKey:@"Edate"];
    str2 = [dic objectForKey:@"Edate"];
    range = [str2 rangeOfString:str];
    if (range.length>0) {
        self.Edate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringFromIndex:19];
    }else{
        self.Edate = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:19];
    }
    self.LeaveTime = [dic objectForKey:@"LeaveTime"];
    str2 = [dic objectForKey:@"LeaveTime"];
    range = [str2 rangeOfString:str];
    if (range.length>0) {
        self.LeaveTime = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringFromIndex:19];
    }else{
        self.LeaveTime = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:19];
    }
    self.LWriterName = [dic objectForKey:@"LWriterName"];
    self.ComeTime = [dic objectForKey:@"ComeTime"];
    str2 = [dic objectForKey:@"ComeTime"];
    range = [str2 rangeOfString:str];
    if (range.length>0) {
        self.ComeTime = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringFromIndex:19];
    }else{
        self.ComeTime = [[str2 stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:19];
    }
    self.CWriterName  = [dic objectForKey:@"CWriterName "];
    
}



@end
