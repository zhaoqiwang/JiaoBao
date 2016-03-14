//
//  MyAdminClass.m
//  JiaoBao
//
//  Created by SongYanming on 16/3/14.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "MyAdminClass.h"

@implementation MyAdminClass

-(void)dicToModel:(NSDictionary*)dic{
    self.TabID = [dic objectForKey:@"TabID"];//班级ID
    self.ClsName = [dic objectForKey:@"ClsName"];//班级名称
    self.ClsNo = [dic objectForKey:@"ClsNo"];//班级代码
    self.GradeName = [dic objectForKey:@"GradeName"];//年级名称
    self.GradeYear = [dic objectForKey:@"GradeYear"];//入学年份
    self.SchoolId = [dic objectForKey:@"SchoolId"];// 学校ID

    
    
}

@end
