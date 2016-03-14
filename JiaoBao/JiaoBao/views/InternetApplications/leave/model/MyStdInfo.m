//
//  MyStdInfo.m
//  JiaoBao
//
//  Created by SongYanming on 16/3/14.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "MyStdInfo.h"

@implementation MyStdInfo
-(void)dicToModel:(NSDictionary*)dic;

{
    self.TabID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"TabID"]];//学生ID
    self.GenName = [dic objectForKey:@"GenName"];//家长姓名
    self.SchoolID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"SchoolID"]];//学校ID
    self.ClassId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ClassId"]];//班级ID
    self.StdName = [dic objectForKey:@"StdName"];//学生姓名
    self.ClsName = [dic objectForKey:@"ClsName"];//班级名称
    self.GradeName = [dic objectForKey:@"GradeName"];//年级名称
    self.GradeYear = [dic objectForKey:@"GradeYear"];//入学年份
    self.GenID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"GenID"]];// 家长ID

}


@end
