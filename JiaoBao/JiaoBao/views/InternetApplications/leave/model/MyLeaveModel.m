//
//  MyLeaveModel.m
//  JiaoBao
//
//  Created by SongYanming on 16/3/11.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "MyLeaveModel.h"

@implementation MyLeaveModel
-(void)dicToModel:(NSDictionary*)dic{
    self.TabID = [dic objectForKey:@"TabID"];
    self.WriteDate = [dic objectForKey:@"WriteDate"];
    self.LeaveType = [dic objectForKey:@"LeaveType"];
    self.StatusStr = [dic objectForKey:@"StatusStr"];
    self.RowCount = [dic objectForKey:@"RowCount"];
}
@end
