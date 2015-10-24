//
//  StuHomeWorkModel.h
//  JiaoBao
//
//  Created by songyanming on 15/10/23.
//  Copyright © 2015年 JSY. All rights reserved.
//学生当前作业信息model

#import <Foundation/Foundation.h>

@interface StuHomeWorkModel : NSObject
@property(nonatomic,strong)NSString *hwid;//作业ID
@property(nonatomic,strong)NSString *hwinfoid;//作业分发ID
@property(nonatomic,strong)NSString *homeworkname;//作业名称
@property(nonatomic,strong)NSString *HWStartTime;//作业开始时间
@property(nonatomic,strong)NSString *LongTime;//作答时长
@property(nonatomic,strong)NSString *Qsc;//题数
@property(nonatomic,strong)NSString *QsIdQId;//题序号_题库ID
//{"hwid":717,"hwinfoid":344910,"homeworkname":"2015-10-23英语英语第一节（测试）作业","HWStartTime":"\/Date(1445567703000)\/","LongTime":20,"Qsc":19,"QsIdQId":"1_29|2_86|3_18|4_91|5_37|6_62|7_20|8_87|9_202|10_122|11_152|12_115|13_186|14_132|15_154|16_117|17_183|18_126|19_1571_29|2_86|3_18|4_91|5_37|6_62|7_20|8_87|9_202|10_122|11_152|12_115|13_186|14_132|15_154|16_117|17_183|18_126|19_157|"}


@end
