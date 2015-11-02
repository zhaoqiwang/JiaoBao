//
//  LevelModel.h
//  JiaoBao
//
//  Created by songyanming on 15/11/2.
//  Copyright © 2015年 JSY. All rights reserved.
//学力model

#import <Foundation/Foundation.h>

@interface LevelModel : NSObject
@property(nonatomic,strong)NSString *Level;//学力值
@property(nonatomic,strong)NSString *Name;//学科或章节名称
@property(nonatomic,strong)NSString *ID;//学科或章节ID
//调用实例：
//1、
//获取学生（3851578）各科目学力值
//请求：
//http://localhost:5057/AtHWPort/GetStuEduLevel?StuId=3851578
//返回结果：
//[{"Level":6095,"Name":"英语(人教新课标)","ID":418},{"Level":7759,"Name":"语文(人教新课标)","ID":419},{"Level":0,"Name":"英语(五四制-鲁教版)","ID":502},{"Level":1811,"Name":"数学(北京版)","ID":832},{"Level":0,"Name":"英语(外研新课标)","ID":620}]
//2、
//获取学生（3851578）“英语(人教新课标)（ID:418）”科目学力值
//请求：
//http://localhost:5057/AtHWPort/GetStuEduLevel?StuId=3851578&uid=418
//返回结果：
//[{"Level":6095,"Name":"英语第一节（测试）","ID":1},{"Level":0,"Name":"第一章  测试xxxx","ID":2261}]
//3、
//获取学生（3851578）“英语第一节（测试）（ID:2261）”章学力值
//请求：
//http://localhost:5057/AtHWPort/GetStuEduLevel?StuId=3851578&uid=418&chapterid=2261
//返回结果：
//[{"Level":0,"Name":"第一单元 测试XXX","ID":2262}]

@end
