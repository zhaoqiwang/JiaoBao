//
//  LeaveDetailModel.m
//  JiaoBao
//
//  Created by SongYanming on 16/3/11.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "LeaveDetailModel.h"


@implementation LeaveDetailModel
-(instancetype)init
{
    self = [super init];
    self.TimeList = [[NSMutableArray alloc]init];
    
    return self;
}
-(void)dicToModel:(NSDictionary*)dic{
    self.TabID = [dic objectForKey:@"TabID"];
    self.ManName = [dic objectForKey:@"ManName"];
    self.Writer = [dic objectForKey:@"Writer"];
    self.WriteDate = [dic objectForKey:@"WriteDate"];
    self.LeaveType = [dic objectForKey:@"LeaveType"];
    self.LeaveReason = [dic objectForKey:@"LeaveReason"];
    self.StatusStr = [dic objectForKey:@"StatusStr"];
    self.ApproveStatus = [dic objectForKey:@"ApproveStatus"];
    self.Approve = [dic objectForKey:@"Approve"];
    self.ApproveDate = [dic objectForKey:@"ApproveDate"];
    self.ApproveNote = [dic objectForKey:@"ApproveNote"];
    self.ApproveStatus1 = [dic objectForKey:@"ApproveStatus1"];
    self.Approve1 = [dic objectForKey:@"Approve1"];
    self.ApproveDate1 = [dic objectForKey:@"ApproveDate1"];
    self.ApproveNote1 = [dic objectForKey:@"ApproveNote1"];
    self.ApproveStatus2 = [dic objectForKey:@"ApproveStatus2"];
    self.Approve2 = [dic objectForKey:@"Approve2"];
    self.ApproveDate2 = [dic objectForKey:@"ApproveDate2"];
    self.ApproveNote2 = [dic objectForKey:@"ApproveNote2"];
    self.ApproveStatus3 = [dic objectForKey:@"ApproveStatus3"];
    self.Approve3 = [dic objectForKey:@"Approve3"];
    self.ApproveDate3 = [dic objectForKey:@"ApproveDate3"];
    self.ApproveNote3 = [dic objectForKey:@"ApproveNote3"];
    self.ApproveStatus4 = [dic objectForKey:@"ApproveStatus4"];
    self.Approve4 = [dic objectForKey:@"Approve4"];
    self.ApproveDate4 = [dic objectForKey:@"ApproveDate4"];
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
self.TabID = [dic objectForKey:@"TabID"];
self.Sdate = [dic objectForKey:@"Sdate"];
self.Edate = [dic objectForKey:@"Edate"];
self.LeaveTime = [dic objectForKey:@"LeaveTime"];
self.LWriterName = [dic objectForKey:@"LWriterName"];
self.ComeTime = [dic objectForKey:@"ComeTime"];
self.CWriterName  = [dic objectForKey:@"CWriterName "];
    
}



@end
