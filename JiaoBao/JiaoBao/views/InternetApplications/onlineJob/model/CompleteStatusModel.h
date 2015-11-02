//
//  CompleteStatusModel.h
//  JiaoBao
//
//  Created by songyanming on 15/11/2.
//  Copyright © 2015年 JSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompleteStatusModel : NSObject
@property(nonatomic,strong)NSString *UnId;//科目教版ID
@property(nonatomic,strong)NSString *Name;//学科教版名称
@property(nonatomic,strong)NSString *Total;//作业总数
@property(nonatomic,strong)NSString *IsF;//已完成作业数
@property(nonatomic,strong)NSString *UnF;//未完成作业数


//调用实例：
//请求：
//获取学生（3851578）作业完成情况
//http://localhost:5057/AtHWPort/GetCompleteStatusHW?StuId=3851578
//返回结果：
//[{"UnId":418,"Name":"英语(人教新课标)","Total":222,"IsF":112,"UnF":110},{"UnId":419,"Name":"语文(人教新课标)","Total":28,"IsF":21,"UnF":7},{"UnId":502,"Name":"英语(五四制-鲁教版)","Total":0,"IsF":0,"UnF":0},{"UnId":832,"Name":"数学(北京版)","Total":19,"IsF":10,"UnF":9},{"UnId":620,"Name":"英语(外研新课标)","Total":0,"IsF":0,"UnF":0}]


@end
